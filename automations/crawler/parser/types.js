import path from 'path';
import { promises as fs } from 'fs';
import { TYPES_DIR, API_BASE_URL, CACHE_DIR } from '../config.js';
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

	// Generate constants
	if (page.constants && page.constants.length > 0) {
		content += `-- Constants:\n`;
		for (const constant of page.constants) {
			content += `---@type any\n`;
			content += `${constant.name} = ${constant.value}\n\n`;
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

export async function generateTypesByShortestPath() {
	console.log('[TypeGenerator] Generating type definitions by shortest path...');

	// Use all pages that have parsed data (even if path not computed)
	const pages = db.getAllPagesWithParsedData();
	if (!pages || pages.length === 0) {
		console.log('[TypeGenerator] No pages with parsed data, will fall back to cache crawl.');
	}

	let generated = 0;

	const processPage = async (page) => {
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
