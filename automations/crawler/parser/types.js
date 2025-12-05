import path from 'path';
import { promises as fs } from 'fs';
import { TYPES_DIR, API_BASE_URL, CACHE_DIR, WORKSPACE_ROOT } from '../config.js';
import { buildFolderPath } from '../utils/paths.js';
import { db } from '../database/queries.js';
import { parseDocumentationPage } from './html.js';

async function walkCache(dir, results = []) {
	const entries = await fs.readdir(dir, { withFileTypes: true });
	for (const entry of entries) {
		const full = path.join(dir, entry.name);
		if (entry.isDirectory()) {
			await walkCache(full, results);
		} else if (entry.isFile() && entry.name.endsWith('.html')) {
			results.push(full);
		}
	}
	return results;
}

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

function parseEntityPropsFromHtml(html) {
	const entities = [];
	// Find entity sections by h3
	const h3Regex = /<h3[^>]*>([^<]+)<\/h3>/gi;
	let match;
	const positions = [];
	while ((match = h3Regex.exec(html)) !== null) {
		positions.push({ name: match[1].trim(), index: match.index });
	}
	for (let i = 0; i < positions.length; i++) {
		const current = positions[i];
		const end = i + 1 < positions.length ? positions[i + 1].index : html.length;
		const section = html.slice(current.index, end);
		// Collect from code blocks first (props are often inside <pre><code>)
		const codeBlocks = [];
		const codeRegex = /<pre[^>]*>([\s\S]*?)<\/pre>/gi;
		let c;
		while ((c = codeRegex.exec(section)) !== null) {
			codeBlocks.push(c[1]);
		}
		const rawText = codeBlocks.length > 0 ? codeBlocks.join('\n') : section;
		const sectionText = rawText
			.replace(/<[^>]+>/g, ' ')
			.replace(/&nbsp;/g, ' ')
			.replace(/\s+/g, ' ')
			.trim();
		const props = [];
		const propRegex = /([A-Za-z0-9_]+)\s*:\s*([A-Za-z]+)/g;
		let pm;
		while ((pm = propRegex.exec(sectionText)) !== null) {
			const propName = pm[1];
			const propType = mapTypeToLua(pm[2]);
			props.push({ name: propName, type: propType });
		}
		if (props.length > 0) {
			const cleanName = current.name.replace(/[^A-Za-z0-9_]/g, '');
			entities.push({ name: cleanName, props });
		}
	}
	return entities;
}

function parseConstantsByCategory(html) {
	const sections = [];

	// Find h3 headings (these are the constant category names like E_UserCmd, E_ButtonCode, etc.)
	// Try with id first (more specific)
	const h3Regex = /<h3[^>]*id="([^"]+)"[^>]*>([\s\S]*?)<\/h3>/gi;
	let h3Match;
	const h3Positions = [];
	while ((h3Match = h3Regex.exec(html)) !== null) {
		const id = h3Match[1].trim();
		const name = h3Match[2].replace(/<[^>]+>/g, '').trim();
		if (name) {
			h3Positions.push({ id, name, index: h3Match.index });
		}
	}

	// If no h3 with id found, try h3 without id (fallback)
	if (h3Positions.length === 0) {
		const h3SimpleRegex = /<h3[^>]*>([\s\S]*?)<\/h3>/gi;
		// Reset regex lastIndex
		h3SimpleRegex.lastIndex = 0;
		while ((h3Match = h3SimpleRegex.exec(html)) !== null) {
			const name = h3Match[1].replace(/<[^>]+>/g, '').trim();
			if (name) {
				h3Positions.push({ id: null, name, index: h3Match.index });
			}
		}
	}

	// Process each h3 section
	for (let i = 0; i < h3Positions.length; i++) {
		const current = h3Positions[i];
		const end = i + 1 < h3Positions.length ? h3Positions[i + 1].index : html.length;
		const section = html.slice(current.index, end);

		const constants = [];

		// Find the table after the h3 heading (use non-greedy but ensure we get the full table)
		const tableMatch = section.match(/<table[^>]*>([\s\S]*?)<\/table>/is);
		if (tableMatch) {
			const tableContent = tableMatch[1];

			// Extract table rows (skip the header row)
			const rowRegex = /<tr[^>]*>([\s\S]*?)<\/tr>/gi;
			let rowMatch;
			let isFirstRow = true;

			while ((rowMatch = rowRegex.exec(tableContent)) !== null) {
				// Skip header row
				if (isFirstRow) {
					isFirstRow = false;
					continue;
				}

				const rowContent = rowMatch[1];

				// Extract table cells
				const cellRegex = /<td[^>]*>([\s\S]*?)<\/td>/gi;
				const cells = [];
				let cellMatch;

				while ((cellMatch = cellRegex.exec(rowContent)) !== null) {
					let cellText = cellMatch[1]
						.replace(/<[^>]+>/g, '')
						.replace(/&lt;/g, '<')
						.replace(/&gt;/g, '>')
						.replace(/&amp;/g, '&')
						.replace(/&quot;/g, '"')
						.replace(/&nbsp;/g, ' ')
						.replace(/\s+/g, ' ')
						.trim();
					cells.push(cellText);
				}

				// First cell is name, second cell is value
				if (cells.length >= 2) {
					const name = cells[0].trim();
					let value = cells[1].trim();

					// Clean up the value - handle HTML entities and expressions
					value = value
						.replace(/&lt;/g, '<')
						.replace(/&gt;/g, '>')
						.replace(/&amp;/g, '&');

					// Only add if name looks like a constant (uppercase with underscores)
					if (name && /^[A-Z_][A-Z0-9_]*$/.test(name)) {
						constants.push({ name, value });
					}
				}
			}
		}

		// Fallback: try to extract from text if no table found
		if (constants.length === 0) {
			const sectionText = section
				.replace(/<[^>]+>/g, ' ')
				.replace(/&nbsp;/g, ' ')
				.replace(/&lt;/g, '<')
				.replace(/&gt;/g, '>')
				.replace(/&amp;/g, '&')
				.replace(/\s+/g, ' ')
				.trim();
			const constRegex = /([A-Z_][A-Z0-9_]+)\s*=\s*([^\s,;]+)/g;
			let cm;
			while ((cm = constRegex.exec(sectionText)) !== null) {
				const name = cm[1];
				const value = cm[2];
				if (name && value) {
					constants.push({ name, value });
				}
			}
		}

		if (constants.length > 0) {
			const cleanName = current.name.replace(/[^A-Za-z0-9_]/g, '_') || 'constants';
			sections.push({ name: cleanName, constants });
		}
	}

	return sections;
}

function generateTypeDefinition(page) {
	let content = `---@meta\n\n`;
	content += `-- Lmaobox Lua API: ${page.title || 'Documentation'}\n`;
	content += `-- Auto-generated from: ${page.url}\n`;
	content += `-- Path: ${page.path}\n`;
	content += `-- Last updated: ${new Date().toISOString()}\n\n`;

	if (page.examples && page.examples.length > 0) {
		content += `-- Examples:\n`;
		page.examples.slice(0, 2).forEach((example, idx) => {
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
	if (page.libraries && page.libraries.length > 0) {
		for (const libName of [...new Set(page.libraries)]) {
			content += `---@class ${libName}\n`;
			content += `${libName} = {}\n\n`;

			if (page.functions && page.functions.length > 0) {
				page.functions.forEach(func => {
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
		}
	}

	// Generate class definitions
	if (page.classes && page.classes.length > 0) {
		for (const className of [...new Set(page.classes)]) {
			content += `---@class ${className}\n`;

			if (page.functions && page.functions.length > 0) {
				page.functions.forEach(func => {
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
			}

			content += `local ${className} = {}\n\n`;
		}
	}

	// Fallback: global functions when no classes/libraries
	if ((!page.classes || page.classes.length === 0) && (!page.libraries || page.libraries.length === 0)) {
		if (page.functions && page.functions.length > 0) {
			for (const func of page.functions) {
				func.params.forEach(param => {
					const luaType = mapTypeToLua(param.type);
					content += `---@param ${param.name} ${luaType}\n`;
				});

				const returnType = inferReturnType(func.name, func.params);
				if (returnType !== 'void') {
					content += `---@return ${returnType}\n`;
				}

				const paramList = func.params.map(p => p.name).join(', ');
				content += `function ${func.name}(${paramList}) end\n\n`;
			}
		}
	}

	// Generate constants (filter out false positives)
	if (page.constants && page.constants.length > 0) {
		// Filter out useless constants (short names, common false positives, or nil values from fallback)
		const validConstants = page.constants.filter(c => {
			// Skip if value is nil (from fallback extraction)
			if (c.value === 'nil' || c.value === '') return false;
			// Skip very short names that are likely false positives
			if (c.name.length < 4) return false;
			// Skip common false positives
			if (['API', 'API_', 'HTTP', 'SVG', 'XML', 'HTML', 'CSS', 'URL', 'DOM'].includes(c.name)) return false;
			// Skip if name doesn't look like a constant (needs underscore or all caps)
			if (!c.name.includes('_') && !c.name.match(/^[A-Z]{3,}$/)) return false;
			return true;
		});

		if (validConstants.length > 0) {
			content += `-- Constants:\n`;
			for (const constant of validConstants) {
				content += `---@type any\n`;
				content += `${constant.name} = ${constant.value}\n\n`;
			}
		}
	}

	return content;
}

function buildPathFromUrl(url) {
	const relative = url.replace(API_BASE_URL, '').replace(/\/+$/, '');
	if (!relative) return 'index';
	return relative;
}

export async function generateTypeForPage(parsedDataInput) {
	// Special case: entity props page emits many per-entity files
	if (parsedDataInput.url && parsedDataInput.url.toLowerCase().includes('tf2_props')) {
		try {
			const rel = parsedDataInput.url.replace(API_BASE_URL, '').replace(/\/$/, '') || 'TF2_props';
			const cachePath = path.join(CACHE_DIR, rel + '.html');
			const html = await fs.readFile(cachePath, 'utf8');
			const entities = parseEntityPropsFromHtml(html);
			if (entities.length > 0) {
				const baseDir = path.join(TYPES_DIR, 'hierarchy', 'entity_props');
				await fs.mkdir(baseDir, { recursive: true });
				for (const ent of entities) {
					let content = `---@meta\n\n`;
					content += `-- Entity Props: ${ent.name}\n`;
					content += `-- Auto-generated from: ${parsedDataInput.url}\n`;
					content += `-- Last updated: ${new Date().toISOString()}\n\n`;
					content += `---@class ${ent.name}\n`;
					for (const prop of ent.props) {
						content += `---@field ${prop.name} ${prop.type}\n`;
					}
					content += `local ${ent.name} = {}\n`;
					const filePath = path.join(baseDir, `${ent.name}.d.lua`);
					await fs.writeFile(filePath, content, 'utf8');
				}
			}
		} catch (e) {
			console.warn(`[TypeGenerator] Entity props generation failed: ${e.message}`);
		}
		// Do not write a single monolith file for TF2_props; handled above
		return { filePath: null };
	}

	// Special case: constants page emits many per-category files
	if (parsedDataInput.url && parsedDataInput.url.toLowerCase().includes('lua_constants')) {
		try {
			const rel = parsedDataInput.url.replace(API_BASE_URL, '').replace(/\/$/, '') || 'Lua_Constants';
			const cachePath = path.join(CACHE_DIR, rel + '.html');
			const html = await fs.readFile(cachePath, 'utf8');
			const sections = parseConstantsByCategory(html);
			if (sections.length > 0) {
				const baseDir = path.join(TYPES_DIR, 'hierarchy', 'constants');
				await fs.mkdir(baseDir, { recursive: true });
				for (const sec of sections) {
					let content = `---@meta\n\n`;
					content += `-- Constants: ${sec.name}\n`;
					content += `-- Auto-generated from: ${parsedDataInput.url}\n`;
					content += `-- Last updated: ${new Date().toISOString()}\n\n`;
					for (const c of sec.constants) {
						content += `---@type any\n`;
						content += `${c.name} = ${c.value}\n\n`;
					}
					const filePath = path.join(baseDir, `${sec.name}.d.lua`);
					await fs.writeFile(filePath, content, 'utf8');
				}
			}
		} catch (e) {
			console.warn(`[TypeGenerator] Constants generation failed: ${e.message}`);
		}
		// Do not write a single monolith file for Lua_Constants; handled above
		return { filePath: null };
	}

	const pagePath = parsedDataInput.path || buildPathFromUrl(parsedDataInput.url);
	const dirPath = path.dirname(pagePath) || '.';
	const sanitizedDir = buildFolderPath(dirPath);
	const typeDir = path.join(TYPES_DIR, 'hierarchy', sanitizedDir === '.' ? '' : sanitizedDir);
	await fs.mkdir(typeDir, { recursive: true });

	const fileName = path.basename(pagePath) + '.d.lua';
	const filePath = path.join(typeDir, fileName);

	const content = generateTypeDefinition(parsedDataInput);
	await fs.writeFile(filePath, content, 'utf8');
	db.saveTypeDefinition(parsedDataInput.url, pagePath, content);
	return { filePath };
}

export async function generateEntityPropsFromCache() {
	try {
		const htmlPath = path.join(WORKSPACE_ROOT, '.cache', 'docs', 'TF2_props.html');
		const html = await fs.readFile(htmlPath, 'utf8');
		const entities = parseEntityPropsFromHtml(html);
		if (!entities || entities.length === 0) {
			console.log('[TypeGenerator] No entity props found in cache.');
			return 0;
		}
		const baseDir = path.join(TYPES_DIR, 'hierarchy', 'entity_props');
		await fs.mkdir(baseDir, { recursive: true });
		let count = 0;
		for (const ent of entities) {
			let content = `---@meta\n\n`;
			content += `-- Entity Props: ${ent.name}\n`;
			content += `-- Auto-generated from: https://lmaobox.net/lua/TF2_props/\n`;
			content += `-- Last updated: ${new Date().toISOString()}\n\n`;
			content += `---@class ${ent.name}\n`;
			for (const prop of ent.props) {
				content += `---@field ${prop.name} ${prop.type}\n`;
			}
			content += `local ${ent.name} = {}\n`;
			const filePath = path.join(baseDir, `${ent.name}.d.lua`);
			await fs.writeFile(filePath, content, 'utf8');
			count++;
		}
		console.log(`[TypeGenerator] Generated ${count} entity prop files`);
		return count;
	} catch (e) {
		console.warn(`[TypeGenerator] Entity props generation failed: ${e.message}`);
		return 0;
	}
}

export async function generateConstantsByCategoryFromCache() {
	try {
		const htmlPath = path.join(WORKSPACE_ROOT, '.cache', 'docs', 'Lua_Constants.html');
		const html = await fs.readFile(htmlPath, 'utf8');
		const sections = parseConstantsByCategory(html);
		if (!sections || sections.length === 0) {
			console.log('[TypeGenerator] No constants found in cache.');
			return 0;
		}
		const baseDir = path.join(TYPES_DIR, 'hierarchy', 'constants');
		await fs.mkdir(baseDir, { recursive: true });
		let count = 0;
		for (const sec of sections) {
			let content = `---@meta\n\n`;
			content += `-- Constants: ${sec.name}\n`;
			content += `-- Auto-generated from: https://lmaobox.net/lua/Lua_Constants/\n`;
			content += `-- Last updated: ${new Date().toISOString()}\n\n`;
			for (const c of sec.constants) {
				content += `---@type any\n`;
				content += `${c.name} = ${c.value}\n\n`;
			}
			const filePath = path.join(baseDir, `${sec.name}.d.lua`);
			await fs.writeFile(filePath, content, 'utf8');
			count++;
		}

		// Delete the old main Lua_Constants.d.lua file if it exists (we use folder structure now)
		const oldMainFile = path.join(TYPES_DIR, 'hierarchy', 'Lua_Constants.d.lua');
		try {
			await fs.unlink(oldMainFile);
			console.log(`[TypeGenerator] Removed old main constants file: ${oldMainFile}`);
		} catch (e) {
			// File doesn't exist, that's fine
		}

		console.log(`[TypeGenerator] Generated ${count} constants files`);
		return count;
	} catch (e) {
		console.warn(`[TypeGenerator] Constants generation failed: ${e.message}`);
		return 0;
	}
}

export async function generateTypesByShortestPath() {
	console.log('[TypeGenerator] Generating type definitions by shortest path...');

	// Use all pages that have parsed data (even if path not computed)
	const pages = db.getAllPagesWithParsedData();
	if (!pages || pages.length === 0) {
		console.log('[TypeGenerator] No pages with parsed data, will fall back to cache crawl.');
	}

	let generated = 0;

	const processPage = async (page) => {
		// Special handling: entity props page emits many files
		if (page.url.toLowerCase().includes('tf2_props')) {
			try {
				const rel = page.url.replace(API_BASE_URL, '').replace(/\/$/, '') || 'TF2_props';
				const cachePath = path.join(CACHE_DIR, rel + '.html');
				const html = await fs.readFile(cachePath, 'utf8');
				const entities = parseEntityPropsFromHtml(html);
				if (entities.length > 0) {
					const baseDir = path.join(TYPES_DIR, 'hierarchy', 'entity_props');
					await fs.mkdir(baseDir, { recursive: true });
					for (const ent of entities) {
						let content = `---@meta\n\n`;
						content += `-- Entity Props: ${ent.name}\n`;
						content += `-- Auto-generated from: ${page.url}\n`;
						content += `-- Last updated: ${new Date().toISOString()}\n\n`;
						content += `---@class ${ent.name}\n`;
						for (const prop of ent.props) {
							content += `---@field ${prop.name} ${prop.type}\n`;
						}
						content += `local ${ent.name} = {}\n`;
						const filePath = path.join(baseDir, `${ent.name}.d.lua`);
						await fs.writeFile(filePath, content, 'utf8');
						generated++;
					}
					return;
				}
			} catch (e) {
				console.warn(`[TypeGenerator] Entity props parse failed: ${e.message}`);
			}
		}

		// Determine output path
		const pagePath = page.path || buildPathFromUrl(page.url);
		const dirPath = path.dirname(pagePath) || '.';
		const sanitizedDir = buildFolderPath(dirPath);
		const typeDir = path.join(TYPES_DIR, 'hierarchy', sanitizedDir === '.' ? '' : sanitizedDir);
		await fs.mkdir(typeDir, { recursive: true });

		const fileName = path.basename(pagePath) + '.d.lua';
		const filePath = path.join(typeDir, fileName);

		// Get parsed page data from database
		let parsedData = {
			url: page.url,
			title: page.title,
			path: pagePath,
			examples: [],
			libraries: [],
			classes: [],
			functions: [],
			constants: []
		};

		if (page.parsed_data) {
			try {
				const parsed = JSON.parse(page.parsed_data);
				parsedData = {
					...parsedData,
					examples: parsed.examples || [],
					libraries: parsed.libraries || [],
					classes: parsed.classes || [],
					functions: parsed.functions || [],
					constants: parsed.constants || []
				};
			} catch (e) {
				console.warn(`[TypeGenerator] Failed to parse stored data for ${page.url}: ${e.message}`);
			}
		}

		// Fallback: if functions/examples/constants are empty, try re-parsing cached HTML
		const needsEnrich = (!parsedData.functions || parsedData.functions.length === 0) ||
			(!parsedData.constants || parsedData.constants.length === 0) ||
			(!parsedData.examples || parsedData.examples.length === 0);
		if (needsEnrich) {
			try {
				const relative = page.url.replace(API_BASE_URL, '').replace(/\/$/, '') || 'index';
				const cachePath = path.join(CACHE_DIR, relative + '.html');
				const html = await fs.readFile(cachePath, 'utf8');
				const reparsed = parseDocumentationPage(html, page.url);

				// Fallback function extraction directly from HTML if still empty
				if (!reparsed.functions || reparsed.functions.length === 0) {
					const funcMatches = html.matchAll(/<h3[^>]*>(.*?)<\/h3>/gi);
					const funcs = [];
					for (const m of funcMatches) {
						const raw = m[1];
						const text = raw.replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ').trim();
						const fm = text.match(/^(\w+)\s*\(([^)]*)\)/);
						if (fm) {
							const name = fm[1];
							const paramsStr = fm[2].trim();
							const params = [];
							if (paramsStr) {
								const paramPattern = /\[?(\w+):(\w+)\]?/g;
								let pm;
								while ((pm = paramPattern.exec(paramsStr)) !== null) {
									params.push({ name: pm[1], type: pm[2] });
								}
							}
							funcs.push({ name, params, section: text });
						}
					}
					if (funcs.length > 0) {
						reparsed.functions = funcs;
					}
				}

				parsedData = {
					...parsedData,
					title: parsedData.title || reparsed.title,
					examples: parsedData.examples?.length ? parsedData.examples : (reparsed.examples || []),
					libraries: parsedData.libraries?.length ? parsedData.libraries : (reparsed.libraries || []),
					classes: parsedData.classes?.length ? parsedData.classes : (reparsed.classes || []),
					functions: parsedData.functions?.length ? parsedData.functions : (reparsed.functions || []),
					constants: parsedData.constants?.length ? parsedData.constants : (reparsed.constants || [])
				};
			} catch (e) {
				console.warn(`[TypeGenerator] Could not enrich from cache for ${page.url}: ${e.message}`);
			}
		}

		const content = generateTypeDefinition(parsedData);
		await fs.writeFile(filePath, content, 'utf8');
		db.saveTypeDefinition(page.url, pagePath, content);
		generated++;
	};

	if (pages && pages.length > 0) {
		for (const page of pages) {
			await processPage(page);
		}
	} else {
		// Fallback: crawl cache HTML files directly
		const htmlFiles = await walkCache(CACHE_DIR);
		for (const file of htmlFiles) {
			const relativeHtml = path.relative(CACHE_DIR, file).replace(/\\/g, '/');
			const url = new URL('./' + relativeHtml.replace(/\.html$/, ''), API_BASE_URL).href;
			const page = {
				url,
				path: relativeHtml.replace(/\.html$/, ''),
				title: path.basename(relativeHtml, '.html'),
				parsed_data: null
			};
			// Skip non-api files like assets if any
			if (!url.startsWith(API_BASE_URL)) continue;

			// Re-parse HTML
			try {
				const html = await fs.readFile(file, 'utf8');
				const parsed = parseDocumentationPage(html, url);
				page.parsed_data = parsed;
				page.title = parsed.title || page.title;
			} catch (e) {
				console.warn(`[TypeGenerator] Cache parse failed for ${file}: ${e.message}`);
			}
			await processPage(page);
		}
	}

	console.log(`[TypeGenerator] Generated ${generated} type definition files`);
	return generated;
}
