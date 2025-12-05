import { promises as fs } from 'fs';
import path from 'path';

const API_BASE_URL = 'https://lmaobox.net/lua/';
const SITEMAP_URL = 'https://lmaobox.net/lua/sitemap.xml';
const WORKSPACE_ROOT = process.cwd();
const TYPES_DIR = path.join(WORKSPACE_ROOT, 'types');
const SESSION_FILE = path.join(TYPES_DIR, '.session');
const CACHE_DIR = path.join(WORKSPACE_ROOT, '.cache', 'docs');

// Rate limiting
async function shouldFetch() {
	try {
		const sessionData = await fs.readFile(SESSION_FILE, 'utf8');
		const session = JSON.parse(sessionData);
		const now = Date.now();
		const oneHour = 60 * 60 * 1000;

		if (session.lastFetch && (now - session.lastFetch) < oneHour) {
			const timeSince = Math.floor((now - session.lastFetch) / 1000 / 60);
			console.log(`[CrawlDocs] Rate limited (${timeSince} min ago). Use cached data or wait.`);
			return false;
		}
	} catch {
		// No session file, proceed
	}
	return true;
}

async function updateSession() {
	const sessionData = {
		lastFetch: Date.now(),
		lastFetchDate: new Date().toISOString()
	};
	await fs.writeFile(SESSION_FILE, JSON.stringify(sessionData, null, 2), 'utf8');
}

// Fetch with retry and delay
async function fetchWithRetry(url, retries = 3, delay = 200) {
	for (let i = 0; i < retries; i++) {
		try {
			await new Promise(resolve => setTimeout(resolve, delay));
			const response = await fetch(url, {
				headers: {
					'User-Agent': 'Mozilla/5.0 (compatible; Lmaobox-Lua-TypeGenerator/1.0)'
				}
			});
			if (response.ok) {
				return await response.text();
			}
		} catch (error) {
			if (i === retries - 1) {
				console.error(`[CrawlDocs] Failed to fetch ${url}: ${error.message}`);
				throw error;
			}
			await new Promise(resolve => setTimeout(resolve, 1000 * (i + 1)));
		}
	}
	return null;
}

// Parse sitemap.xml
async function parseSitemap(sitemapXml) {
	const urls = [];
	const urlMatches = sitemapXml.matchAll(/<loc>(.*?)<\/loc>/g);

	for (const match of urlMatches) {
		const url = match[1].trim();
		if (url.startsWith(API_BASE_URL)) {
			urls.push(url);
		}
	}

	return [...new Set(urls)]; // Remove duplicates
}

// Build URL hierarchy tree
function buildHierarchy(urls) {
	const tree = {};

	for (const url of urls) {
		const relativePath = url.replace(API_BASE_URL, '').replace(/\/$/, '') || 'index';
		const segments = relativePath.split('/').filter(s => s);

		let current = tree;
		for (let i = 0; i < segments.length; i++) {
			const segment = segments[i];
			const isLast = i === segments.length - 1;

			if (!current[segment]) {
				current[segment] = isLast
					? { _url: url, _type: 'page', _children: {} }
					: { _children: {} };
			} else if (isLast) {
				current[segment]._url = url;
				current[segment]._type = 'page';
			}

			current = current[segment]._children || current[segment];
		}
	}

	return tree;
}

// Extract text content from HTML (removes tags)
function extractText(html) {
	return html
		.replace(/<script[\s\S]*?<\/script>/gi, '')
		.replace(/<style[\s\S]*?<\/style>/gi, '')
		.replace(/<[^>]+>/g, ' ')
		.replace(/&lt;/g, '<')
		.replace(/&gt;/g, '>')
		.replace(/&amp;/g, '&')
		.replace(/&quot;/g, '"')
		.replace(/&nbsp;/g, ' ')
		.replace(/\s+/g, ' ')
		.trim();
}

// Parse HTML to extract API documentation
function parseDocumentationPage(html, url) {
	const page = {
		url: url,
		path: url.replace(API_BASE_URL, ''),
		title: '',
		content: '',
		sections: [],
		functions: [],
		classes: [],
		libraries: [],
		examples: [],
		constants: []
	};

	// Extract title
	const titleMatch = html.match(/<title[^>]*>(.*?)<\/title>/i);
	if (titleMatch) {
		page.title = extractText(titleMatch[1]);
	}

	// Extract main content (usually in <main> or <article> or <div class="content">)
	const contentMatch = html.match(/<(main|article|div[^>]*class="[^"]*content[^"]*")[^>]*>([\s\S]*?)<\/(main|article|div)>/i);
	if (contentMatch) {
		page.content = contentMatch[2];
	} else {
		// Fallback: use body content
		const bodyMatch = html.match(/<body[^>]*>([\s\S]*?)<\/body>/i);
		if (bodyMatch) {
			page.content = bodyMatch[1];
		}
	}

	// Extract code blocks (examples)
	const codeMatches = page.content.matchAll(/<pre[^>]*><code[^>]*>([\s\S]*?)<\/code><\/pre>/gi);
	for (const match of codeMatches) {
		let code = match[1]
			.replace(/&lt;/g, '<')
			.replace(/&gt;/g, '>')
			.replace(/&amp;/g, '&')
			.replace(/&quot;/g, '"')
			.replace(/&nbsp;/g, ' ')
			.trim();

		// Check if it looks like Lua code
		if (code.match(/(function|local|callbacks|entities|client|draw|engine|print|if|then|end)/i)) {
			page.examples.push(code);
		}
	}

	// Extract headings to identify sections
	const h1Matches = page.content.matchAll(/<h1[^>]*>(.*?)<\/h1>/gi);
	const h2Matches = page.content.matchAll(/<h2[^>]*>(.*?)<\/h2>/gi);
	const h3Matches = page.content.matchAll(/<h3[^>]*>(.*?)<\/h3>/gi);

	// Process h2 headings (likely library/class names)
	for (const match of h2Matches) {
		const heading = extractText(match[1]);
		if (heading && heading.length > 0 && heading.length < 100) {
			// Check if it's a library (lowercase) or class (PascalCase)
			if (/^[a-z][a-z0-9_]*$/.test(heading)) {
				page.libraries.push(heading);
			} else if (/^[A-Z][a-zA-Z0-9]*$/.test(heading)) {
				page.classes.push(heading);
			}
		}
	}

	// Extract function signatures (h3 headings with function names)
	for (const match of h3Matches) {
		const heading = extractText(match[1]);
		// Look for function pattern: functionName(params)
		const funcMatch = heading.match(/^(\w+)\s*\(([^)]*)\)/);
		if (funcMatch) {
			const funcName = funcMatch[1];
			const paramsStr = funcMatch[2].trim();

			const params = [];
			if (paramsStr) {
				// Parse parameters like "param:type" or "[param:type]"
				const paramPattern = /\[?(\w+):(\w+)\]?/g;
				let paramMatch;
				while ((paramMatch = paramPattern.exec(paramsStr)) !== null) {
					params.push({
						name: paramMatch[1],
						type: paramMatch[2]
					});
				}
			}

			page.functions.push({
				name: funcName,
				params: params,
				section: heading
			});
		}
	}

	// Extract constants (look for CONSTANT_NAME = value patterns in code blocks)
	for (const example of page.examples) {
		const constMatches = example.matchAll(/([A-Z_][A-Z0-9_]*)\s*=\s*([^\n,;]+)/g);
		for (const match of constMatches) {
			page.constants.push({
				name: match[1],
				value: match[2].trim()
			});
		}
	}

	return page;
}

// Cache management
async function getCachePath(url) {
	const relativePath = url.replace(API_BASE_URL, '').replace(/\/$/, '') || 'index';
	return path.join(CACHE_DIR, relativePath + '.html');
}

async function saveCache(url, html) {
	const cachePath = await getCachePath(url);
	await fs.mkdir(path.dirname(cachePath), { recursive: true });
	await fs.writeFile(cachePath, html, 'utf8');
}

async function loadCache(url) {
	try {
		const cachePath = await getCachePath(url);
		return await fs.readFile(cachePath, 'utf8');
	} catch {
		return null;
	}
}

// Crawl all documentation
async function crawlAllDocumentation() {
	console.log('[CrawlDocs] Starting documentation crawl from sitemap...\n');

	const canFetch = await shouldFetch();

	// Fetch sitemap
	console.log('[CrawlDocs] Fetching sitemap...');
	const sitemapXml = await fetchWithRetry(SITEMAP_URL);
	if (!sitemapXml) {
		throw new Error('Failed to fetch sitemap');
	}

	// Parse URLs
	const urls = await parseSitemap(sitemapXml);
	console.log(`[CrawlDocs] Found ${urls.length} documentation pages`);

	// Build hierarchy
	const hierarchy = buildHierarchy(urls);
	console.log('[CrawlDocs] Built URL hierarchy\n');

	// Fetch and parse pages
	const pages = [];
	let fetched = 0;
	let cached = 0;
	let skipped = 0;

	console.log('[CrawlDocs] Processing pages...');
	for (let i = 0; i < urls.length; i++) {
		const url = urls[i];
		const progress = `[${i + 1}/${urls.length}]`;

		// Try cache first
		let html = await loadCache(url);

		if (html) {
			cached++;
			console.log(`${progress} Using cache: ${url}`);
		} else if (canFetch) {
			try {
				console.log(`${progress} Fetching: ${url}`);
				html = await fetchWithRetry(url, 2, 300);
				if (html) {
					await saveCache(url, html);
					fetched++;
				}
			} catch (error) {
				console.error(`${progress} Error fetching ${url}: ${error.message}`);
				skipped++;
				continue;
			}
		} else {
			console.log(`${progress} Skipped (rate limited): ${url}`);
			skipped++;
			continue;
		}

		if (html) {
			const page = parseDocumentationPage(html, url);
			pages.push(page);
		}
	}

	console.log(`\n[CrawlDocs] Summary: Fetched: ${fetched}, Cached: ${cached}, Skipped: ${skipped}, Parsed: ${pages.length}`);

	if (canFetch && fetched > 0) {
		await updateSession();
	}

	return { hierarchy, pages };
}

// Generate type definitions organized by URL hierarchy
async function generateTypesByHierarchy(hierarchy, pages) {
	console.log('\n[CrawlDocs] Generating type definitions by hierarchy...');

	// Group pages by directory path
	const pagesByDir = {};
	for (const page of pages) {
		const dirPath = path.dirname(page.path) || '.';
		if (!pagesByDir[dirPath]) {
			pagesByDir[dirPath] = [];
		}
		pagesByDir[dirPath].push(page);
	}

	// Generate type files for each directory
	for (const [dirPath, dirPages] of Object.entries(pagesByDir)) {
		const typeDir = path.join(TYPES_DIR, 'hierarchy', dirPath === '.' ? '' : dirPath);
		await fs.mkdir(typeDir, { recursive: true });

		// Merge all pages in this directory
		const merged = {
			title: dirPath === '.' ? 'Root' : path.basename(dirPath),
			functions: [],
			classes: [],
			libraries: [],
			examples: [],
			constants: []
		};

		for (const page of dirPages) {
			merged.functions.push(...page.functions);
			merged.classes.push(...page.classes);
			merged.libraries.push(...new Set(page.libraries));
			merged.examples.push(...page.examples);
			merged.constants.push(...page.constants);
		}

		// Remove duplicates
		merged.libraries = [...new Set(merged.libraries)];
		merged.classes = [...new Set(merged.classes)];

		// Generate type file
		const fileName = dirPath === '.' ? 'index.d.lua' : path.basename(dirPath) + '.d.lua';
		const filePath = path.join(typeDir, fileName);

		const content = generateTypeFile(merged, dirPath);
		await fs.writeFile(filePath, content, 'utf8');

		console.log(`[CrawlDocs] Generated: ${filePath} (${merged.functions.length} functions, ${merged.libraries.length} libraries, ${merged.classes.length} classes)`);
	}

	console.log('\n[CrawlDocs] ✅ All type definitions generated by hierarchy');
}

// Generate type definition file content
function generateTypeFile(data, dirPath) {
	let content = `---@meta\n\n`;
	content += `-- Lmaobox Lua API: ${data.title}\n`;
	content += `-- Auto-generated from documentation crawl\n`;
	content += `-- Path: ${dirPath}\n`;
	content += `-- Last updated: ${new Date().toISOString()}\n\n`;

	if (data.examples.length > 0) {
		content += `-- Examples:\n`;
		data.examples.slice(0, 2).forEach((example, idx) => {
			content += `-- Example ${idx + 1}:\n`;
			const lines = example.split('\n').slice(0, 6);
			lines.forEach(line => {
				content += `-- ${line}\n`;
			});
			if (example.split('\n').length > 6) {
				content += `-- ...\n`;
			}
			content += `\n`;
		});
	}

	// Generate library definitions
	for (const libName of data.libraries) {
		content += `---@class ${libName}\n`;
		content += `${libName} = {}\n\n`;

		// Add functions for this library
		data.functions.forEach(func => {
			func.params.forEach(param => {
				const luaType = mapTypeToLua(param.type);
				content += `---@param ${param.name} ${luaType}\n`;
			});

			const returnType = inferReturnType(func.name, func.params);
			if (returnType !== 'void') {
				content += `---@return ${returnType}\n`;
			}

			const paramList = func.params.map(p => p.name).join(', ');
			content += `function ${libName}.${func.name}(${paramList}) end\n\n`;
		});
	}

	// Generate class definitions
	for (const className of data.classes) {
		content += `---@class ${className}\n`;

		// Add methods for this class
		data.functions.forEach(func => {
			func.params.forEach(param => {
				const luaType = mapTypeToLua(param.type);
				content += `---@param ${param.name} ${luaType}\n`;
			});

			const returnType = inferReturnType(func.name, func.params);
			if (returnType !== 'void') {
				content += `---@return ${returnType}\n`;
			}

			const paramTypes = func.params.map(p => `${p.name}: ${mapTypeToLua(p.type)}`).join(', ');
			content += `---@field ${func.name} fun(self: ${className}${func.params.length > 0 ? ', ' : ''}${paramTypes})${returnType !== 'void' ? `: ${returnType}` : ''}\n`;
		});

		content += `local ${className} = {}\n\n`;
	}

	// Generate constants
	if (data.constants.length > 0) {
		content += `-- Constants:\n`;
		for (const constant of data.constants) {
			content += `---@type number\n`;
			content += `${constant.name} = ${constant.value}\n\n`;
		}
	}

	return content;
}

// Map type to Lua type
function mapTypeToLua(docType) {
	const typeMap = {
		'integer': 'number', 'int': 'number', 'number': 'number', 'float': 'number',
		'string': 'string', 'bool': 'boolean', 'boolean': 'boolean',
		'vector': 'Vector3', 'vector3': 'Vector3', 'eulerangles': 'EulerAngles',
		'entity': 'Entity|nil', 'item': 'Item|nil', 'material': 'Material|nil',
		'color': 'Color|nil', 'table': 'table', 'usercmd': 'UserCmd',
		'gameevent': 'GameEvent', 'drawmodelcontext': 'DrawModelContext',
		'viewsetup': 'ViewSetup', 'netmessage': 'NetMessage', 'stringcmd': 'string',
		'any': 'any', 'function': 'function', 'void': 'void'
	};
	return typeMap[docType.toLowerCase()] || 'any';
}

// Infer return type
function inferReturnType(funcName, params) {
	if (funcName.startsWith('Is') || funcName.startsWith('Has') || funcName.startsWith('Can')) {
		return 'boolean';
	}
	if (funcName.includes('Int') || funcName.includes('Count') || funcName.includes('Index') ||
		funcName.includes('Time') || funcName.includes('Size') || funcName.includes('Length')) {
		return 'number';
	}
	if (funcName.includes('String') || funcName.includes('Name') || funcName.includes('Text') ||
		funcName.includes('Path') || funcName.includes('Dir')) {
		return 'string';
	}
	if (funcName.includes('Vector') || funcName.includes('Origin') || funcName.includes('Position') ||
		funcName.includes('Angles') || funcName.includes('Velocity')) {
		return 'Vector3';
	}
	if (funcName.includes('Entity') || funcName.includes('Player') || funcName.includes('Weapon')) {
		return 'Entity|nil';
	}
	return 'any';
}

// Main
async function main() {
	try {
		const { hierarchy, pages } = await crawlAllDocumentation();
		await generateTypesByHierarchy(hierarchy, pages);
		console.log('\n[CrawlDocs] ✅ Complete!');
	} catch (error) {
		console.error('[CrawlDocs] Fatal error:', error);
		process.exit(1);
	}
}

main();
