import { promises as fs } from 'fs';
import path from 'path';

const API_BASE_URL = 'https://lmaobox.net/lua/';
const SITEMAP_URL = 'https://lmaobox.net/lua/sitemap.xml';
const WORKSPACE_ROOT = process.cwd();
const TYPES_DIR = path.join(WORKSPACE_ROOT, 'types');
const SESSION_FILE = path.join(TYPES_DIR, '.session');
const CACHE_DIR = path.join(WORKSPACE_ROOT, '.cache', 'docs');

// Rate limiting: Only fetch if it's been more than 1 hour
async function shouldFetch() {
	try {
		const sessionData = await fs.readFile(SESSION_FILE, 'utf8');
		const session = JSON.parse(sessionData);
		const now = Date.now();
		const oneHour = 60 * 60 * 1000;

		if (session.lastFetch && (now - session.lastFetch) < oneHour) {
			const timeSince = Math.floor((now - session.lastFetch) / 1000 / 60);
			console.log(`[Crawl] Already fetched ${timeSince} minutes ago, skipping (rate limited)`);
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

// Fetch with retry
async function fetchWithRetry(url, retries = 3) {
	for (let i = 0; i < retries; i++) {
		try {
			const response = await fetch(url);
			if (response.ok) {
				return await response.text();
			}
		} catch (error) {
			if (i === retries - 1) throw error;
			await new Promise(resolve => setTimeout(resolve, 1000 * (i + 1)));
		}
	}
	return null;
}

// Parse sitemap.xml to get all URLs
async function parseSitemap(sitemapXml) {
	const urls = [];
	const urlMatches = sitemapXml.matchAll(/<loc>(.*?)<\/loc>/g);
	
	for (const match of urlMatches) {
		const url = match[1];
		// Only include URLs that start with our base URL
		if (url.startsWith(API_BASE_URL)) {
			urls.push(url);
		}
	}
	
	return urls;
}

// Build URL hierarchy
function buildHierarchy(urls) {
	const hierarchy = {};
	
	for (const url of urls) {
		// Remove base URL prefix
		const relativePath = url.replace(API_BASE_URL, '');
		
		// Split into path segments
		const segments = relativePath.split('/').filter(s => s);
		
		// Build nested structure
		let current = hierarchy;
		for (let i = 0; i < segments.length; i++) {
			const segment = segments[i];
			const isLast = i === segments.length - 1;
			
			if (!current[segment]) {
				current[segment] = isLast ? { _url: url, _type: 'page' } : {};
			} else if (isLast) {
				current[segment]._url = url;
				current[segment]._type = 'page';
			}
			
			current = current[segment];
		}
	}
	
	return hierarchy;
}

// Extract API information from HTML
function parseHTMLContent(html, url) {
	const apiInfo = {
		url: url,
		title: '',
		libraries: {},
		classes: {},
		functions: [],
		methods: [],
		callbacks: [],
		globals: [],
		constants: {},
		examples: []
	};
	
	// Extract title
	const titleMatch = html.match(/<title>(.*?)<\/title>/i);
	if (titleMatch) {
		apiInfo.title = titleMatch[1].trim();
	}
	
	// Extract code examples
	const codeMatches = html.matchAll(/<pre><code[^>]*>([\s\S]*?)<\/code><\/pre>/gi);
	for (const match of codeMatches) {
		const code = match[1]
			.replace(/&lt;/g, '<')
			.replace(/&gt;/g, '>')
			.replace(/&amp;/g, '&')
			.replace(/&quot;/g, '"')
			.trim();
		if (code.includes('lua') || code.match(/function|local|callbacks|entities|client|draw|engine/)) {
			apiInfo.examples.push(code);
		}
	}
	
	// Extract function signatures (look for patterns like functionName(param:type))
	const funcMatches = html.matchAll(/(\w+)\s*\(([^)]*)\)/g);
	for (const match of funcMatches) {
		const funcName = match[1];
		const paramsStr = match[2];
		
		// Skip if it's clearly not an API function
		if (funcName.length < 2 || funcName.startsWith('http') || funcName.includes('.')) {
			continue;
		}
		
		const params = [];
		if (paramsStr.trim()) {
			const paramPattern = /\[?(\w+):(\w+)\]?/g;
			let paramMatch;
			while ((paramMatch = paramPattern.exec(paramsStr)) !== null) {
				params.push({
					name: paramMatch[1],
					type: paramMatch[2]
				});
			}
		}
		
		apiInfo.functions.push({ name: funcName, params });
	}
	
	// Extract headings to identify sections
	const h2Matches = html.matchAll(/<h2[^>]*>(.*?)<\/h2>/gi);
	for (const match of h2Matches) {
		const heading = match[1].replace(/<[^>]+>/g, '').trim();
		// Could be a library or class name
		if (heading && heading.length > 0 && heading.length < 50) {
			// Check if it's a library (lowercase) or class (PascalCase)
			if (/^[a-z]+$/.test(heading)) {
				apiInfo.libraries[heading] = true;
			} else if (/^[A-Z][a-zA-Z0-9]+$/.test(heading)) {
				apiInfo.classes[heading] = true;
			}
		}
	}
	
	return apiInfo;
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

// Generate type definition from API info
function generateTypeDefinition(apiInfo, category, pathSegments) {
	let content = `---@meta\n\n`;
	content += `-- Lmaobox Lua API: ${apiInfo.title || category}\n`;
	content += `-- Auto-generated from: ${apiInfo.url}\n`;
	content += `-- Last updated: ${new Date().toISOString()}\n\n`;
	
	if (apiInfo.examples.length > 0) {
		content += `-- Examples from documentation:\n`;
		apiInfo.examples.slice(0, 2).forEach((example, idx) => {
			content += `-- Example ${idx + 1}:\n`;
			const lines = example.split('\n').slice(0, 8);
			lines.forEach(line => {
				content += `-- ${line}\n`;
			});
			if (example.split('\n').length > 8) {
				content += `-- ...\n`;
			}
			content += `\n`;
		});
	}
	
	// Generate library definitions
	for (const libName of Object.keys(apiInfo.libraries)) {
		content += `---@class ${libName}\n`;
		content += `${libName} = {}\n\n`;
		
		// Add functions for this library
		apiInfo.functions.forEach(func => {
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
	for (const className of Object.keys(apiInfo.classes)) {
		content += `---@class ${className}\n`;
		
		apiInfo.methods.forEach(method => {
			method.params.forEach(param => {
				const luaType = mapTypeToLua(param.type);
				content += `---@param ${param.name} ${luaType}\n`;
			});
			
			const returnType = inferReturnType(method.name, method.params);
			if (returnType !== 'void') {
				content += `---@return ${returnType}\n`;
			}
			
			const paramTypes = method.params.map(p => `${p.name}: ${mapTypeToLua(p.type)}`).join(', ');
			content += `---@field ${method.name} fun(self: ${className}${method.params.length > 0 ? ', ' : ''}${paramTypes})${returnType !== 'void' ? `: ${returnType}` : ''}\n`;
		});
		
		content += `local ${className} = {}\n\n`;
	}
	
	return content;
}

// Save cached HTML
async function saveCachedHTML(url, html) {
	const relativePath = url.replace(API_BASE_URL, '');
	const filePath = path.join(CACHE_DIR, relativePath + '.html');
	await fs.mkdir(path.dirname(filePath), { recursive: true });
	await fs.writeFile(filePath, html, 'utf8');
}

// Load cached HTML
async function loadCachedHTML(url) {
	try {
		const relativePath = url.replace(API_BASE_URL, '');
		const filePath = path.join(CACHE_DIR, relativePath + '.html');
		return await fs.readFile(filePath, 'utf8');
	} catch {
		return null;
	}
}

// Crawl all documentation pages
async function crawlDocumentation() {
	console.log('[Crawl] Starting documentation crawl...\n');
	
	// Check rate limiting
	const shouldFetch = await shouldFetch();
	if (!shouldFetch) {
		console.log('[Crawl] Rate limited, using cached data if available');
	}
	
	// Fetch sitemap
	console.log('[Crawl] Fetching sitemap...');
	const sitemapXml = await fetchWithRetry(SITEMAP_URL);
	if (!sitemapXml) {
		console.error('[Crawl] Failed to fetch sitemap');
		return null;
	}
	
	// Parse URLs
	const urls = await parseSitemap(sitemapXml);
	console.log(`[Crawl] Found ${urls.length} documentation pages`);
	
	// Build hierarchy
	const hierarchy = buildHierarchy(urls);
	console.log('[Crawl] Built URL hierarchy');
	
	// Fetch and parse each page
	const allApiInfo = [];
	let fetched = 0;
	let cached = 0;
	
	for (const url of urls) {
		// Check cache first
		let html = await loadCachedHTML(url);
		
		if (!html) {
			if (shouldFetch) {
				console.log(`[Crawl] Fetching: ${url}`);
				html = await fetchWithRetry(url);
				if (html) {
					await saveCachedHTML(url, html);
					fetched++;
					// Small delay to be respectful
					await new Promise(resolve => setTimeout(resolve, 100));
				}
			} else {
				console.log(`[Crawl] Skipping (rate limited): ${url}`);
				continue;
			}
		} else {
			cached++;
		}
		
		if (html) {
			const apiInfo = parseHTMLContent(html, url);
			allApiInfo.push(apiInfo);
		}
	}
	
	console.log(`\n[Crawl] Fetched: ${fetched}, Cached: ${cached}, Total: ${allApiInfo.length}`);
	
	if (shouldFetch) {
		await updateSession();
	}
	
	return { hierarchy, allApiInfo };
}

// Generate type definitions organized by hierarchy
async function generateHierarchicalTypes(hierarchy, allApiInfo) {
	console.log('\n[Crawl] Generating type definitions by hierarchy...');
	
	// Group API info by path
	const apiByPath = {};
	for (const apiInfo of allApiInfo) {
		const relativePath = apiInfo.url.replace(API_BASE_URL, '');
		const dirPath = path.dirname(relativePath);
		if (!apiByPath[dirPath]) {
			apiByPath[dirPath] = [];
		}
		apiByPath[dirPath].push(apiInfo);
	}
	
	// Generate type files organized by hierarchy
	for (const [dirPath, apiInfos] of Object.entries(apiByPath)) {
		const typeDir = path.join(TYPES_DIR, dirPath);
		await fs.mkdir(typeDir, { recursive: true });
		
		// Merge all API info for this directory
		const merged = {
			title: dirPath,
			functions: [],
			methods: [],
			libraries: {},
			classes: {},
			examples: []
		};
		
		for (const apiInfo of apiInfos) {
			merged.functions.push(...apiInfo.functions);
			merged.methods.push(...apiInfo.methods);
			merged.examples.push(...apiInfo.examples);
			Object.assign(merged.libraries, apiInfo.libraries);
			Object.assign(merged.classes, apiInfo.classes);
		}
		
		// Generate type file
		const fileName = dirPath === '.' ? 'index.d.lua' : path.basename(dirPath) + '.d.lua';
		const filePath = path.join(typeDir, fileName);
		const content = generateTypeDefinition(merged, dirPath, dirPath.split('/'));
		
		await fs.writeFile(filePath, content, 'utf8');
		console.log(`[Crawl] Generated: ${filePath}`);
	}
	
	console.log('\n[Crawl] ✅ All type definitions generated by hierarchy');
}

// Main function
async function main() {
	try {
		const result = await crawlDocumentation();
		if (result) {
			await generateHierarchicalTypes(result.hierarchy, result.allApiInfo);
		}
	} catch (error) {
		console.error('[Crawl] Fatal error:', error);
		process.exit(1);
	}
}

main();
