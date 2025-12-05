import path from 'path';
import { promises as fs } from 'fs';
import { TYPES_DIR } from '../config.js';
import { buildFolderPath } from '../utils/paths.js';
import { db } from '../database/queries.js';

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

	// Generate constants
	if (page.constants && page.constants.length > 0) {
		content += `-- Constants:\n`;
		for (const constant of page.constants) {
			content += `---@type number\n`;
			content += `${constant.name} = ${constant.value}\n\n`;
		}
	}

	return content;
}

export async function generateTypesByShortestPath() {
	console.log('[TypeGenerator] Generating type definitions by shortest path...');
	
	const pages = db.getAllPagesWithPaths();
	
	// Group by directory path
	const pagesByDir = {};
	for (const page of pages) {
		if (!page.path) continue;
		
		const dirPath = path.dirname(page.path) || '.';
		const sanitizedDir = buildFolderPath(dirPath);
		
		if (!pagesByDir[sanitizedDir]) {
			pagesByDir[sanitizedDir] = [];
		}
		pagesByDir[sanitizedDir].push(page);
	}
	
	// Generate type files
	let generated = 0;
	for (const [dirPath, dirPages] of Object.entries(pagesByDir)) {
		const typeDir = path.join(TYPES_DIR, 'hierarchy', dirPath === '.' ? '' : dirPath);
		await fs.mkdir(typeDir, { recursive: true });
		
		// Generate one file per page (or merge pages in same dir if preferred)
		for (const page of dirPages) {
			const fileName = path.basename(page.path) + '.d.lua';
			const filePath = path.join(typeDir, fileName);
			
			// Get parsed page data (we'll need to store this or re-parse)
			// For now, generate basic type definition
			const content = generateTypeDefinition({
				url: page.url,
				title: page.title,
				path: page.path,
				examples: [], // Will be populated from parsed data
				libraries: [],
				classes: [],
				functions: [],
				constants: []
			});
			
			await fs.writeFile(filePath, content, 'utf8');
			db.saveTypeDefinition(page.url, page.path, content);
			generated++;
		}
	}
	
	console.log(`[TypeGenerator] Generated ${generated} type definition files`);
	return generated;
}
