import { promises as fs } from 'fs';
import path from 'path';

const WORKSPACE_ROOT = process.cwd();
const DOC_FILE = path.join(WORKSPACE_ROOT, 'lmaobox_lua_documentation.md');
const TYPES_DIR = path.join(WORKSPACE_ROOT, 'types');
const API_SITEMAP_URL = 'http://lmaobox.net/lua/sitemap.xml';
const SESSION_FILE = path.join(TYPES_DIR, '.session');

// Rate limiting: Only fetch sitemap if it's been more than 1 hour
async function shouldFetchSitemap() {
	try {
		const sessionData = await fs.readFile(SESSION_FILE, 'utf8');
		const session = JSON.parse(sessionData);
		const now = Date.now();
		const oneHour = 60 * 60 * 1000;

		if (session.lastFetch && (now - session.lastFetch) < oneHour) {
			const timeSince = Math.floor((now - session.lastFetch) / 1000 / 60);
			console.log(`[GenerateTypes] Already fetched ${timeSince} minutes ago, skipping (rate limited)`);
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

// Parse function signatures from documentation
function parseFunctionSignature(line) {
	// Match patterns like: ### functionName( param1:type1, param2:type2 )
	const match = line.match(/^###\s+(\w+)\s*\(([^)]*)\)/);
	if (!match) return null;

	const funcName = match[1];
	const paramsStr = match[2];
	const params = [];

	// Parse parameters
	if (paramsStr.trim()) {
		const paramMatches = paramsStr.matchAll(/(\w+):(\w+)/g);
		for (const paramMatch of paramMatches) {
			params.push({
				name: paramMatch[1],
				type: paramMatch[2]
			});
		}
	}

	return { funcName, params };
}

// Extract examples from documentation
function extractExamples(docContent) {
	const examples = [];
	const exampleMatches = docContent.matchAll(/```lua\n([\s\S]*?)```/g);
	for (const match of exampleMatches) {
		examples.push(match[1].trim());
	}
	return examples;
}

// Parse library sections
function parseLibraries(docContent) {
	const libraries = {};

	// Find library sections (pattern: ## LibraryName)
	const libraryMatches = docContent.matchAll(/^##\s+(\w+)\s*$/gm);

	for (const match of libraryMatches) {
		const libName = match[1];
		if (libName === 'Home' || libName === 'API' || libName === 'Lua' || libName === 'Predefined' || libName === 'Entity') {
			continue; // Skip non-library sections
		}

		// Extract functions for this library
		const libSection = docContent.substring(match.index);
		const nextSection = libSection.match(/\n^##\s+/m);
		const sectionEnd = nextSection ? nextSection.index : libSection.length;
		const sectionContent = libSection.substring(0, sectionEnd);

		const functions = [];
		const funcMatches = sectionContent.matchAll(/^###\s+(\w+)\s*\(([^)]*)\)/gm);
		for (const funcMatch of funcMatches) {
			const funcName = funcMatch[1];
			const paramsStr = funcMatch[2];
			const params = [];

			if (paramsStr.trim()) {
				const paramMatches = paramsStr.matchAll(/(\w+):(\w+)/g);
				for (const paramMatch of paramMatches) {
					params.push({
						name: paramMatch[1],
						type: paramMatch[2]
					});
				}
			}

			functions.push({ name: funcName, params });
		}

		if (functions.length > 0) {
			libraries[libName] = functions;
		}
	}

	return libraries;
}

// Generate type definition for a library
function generateLibraryTypes(libName, functions, examples) {
	let content = `---@meta\n\n`;
	content += `-- Lmaobox Lua API: ${libName} Library\n`;
	content += `-- Auto-generated from documentation\n`;
	content += `-- Last updated: ${new Date().toISOString()}\n\n`;

	if (examples.length > 0) {
		content += `-- Examples:\n`;
		examples.slice(0, 3).forEach(example => {
			const lines = example.split('\n').slice(0, 5); // First 5 lines
			lines.forEach(line => {
				content += `-- ${line}\n`;
			});
			if (example.split('\n').length > 5) {
				content += `-- ...\n`;
			}
		});
		content += `\n`;
	}

	content += `---@class ${libName}\n`;
	content += `${libName} = {}\n\n`;

	functions.forEach(func => {
		const paramTypes = func.params.map(p => {
			const luaType = mapTypeToLua(p.type);
			return `---@param ${p.name} ${luaType}`;
		}).join('\n');

		const returnType = inferReturnType(func.name, func.params);

		content += `${paramTypes}\n`;
		content += `---@return ${returnType}\n`;
		content += `function ${libName}.${func.name}(${func.params.map(p => p.name).join(', ')}) end\n\n`;
	});

	return content;
}

// Map documentation types to Lua types
function mapTypeToLua(docType) {
	const typeMap = {
		'integer': 'number',
		'int': 'number',
		'number': 'number',
		'float': 'number',
		'string': 'string',
		'bool': 'boolean',
		'boolean': 'boolean',
		'Vector': 'Vector3',
		'Vector3': 'Vector3',
		'EulerAngles': 'EulerAngles',
		'Entity': 'Entity',
		'Item': 'Item',
		'Material': 'Material',
		'Color': 'Color',
		'Table': 'table',
		'UserCmd': 'UserCmd',
		'GameEvent': 'GameEvent',
		'DrawModelContext': 'DrawModelContext',
		'ViewSetup': 'ViewSetup',
		'NetMessage': 'NetMessage',
		'StringCmd': 'string',
		'any': 'any'
	};

	return typeMap[docType.toLowerCase()] || 'any';
}

// Infer return type from function name
function inferReturnType(funcName, params) {
	if (funcName.startsWith('Get') || funcName.startsWith('Is') || funcName.startsWith('Has') || funcName.startsWith('Can')) {
		if (funcName.includes('Bool') || funcName.startsWith('Is') || funcName.startsWith('Has') || funcName.startsWith('Can')) {
			return 'boolean';
		}
		if (funcName.includes('Int') || funcName.includes('Count') || funcName.includes('Index')) {
			return 'number';
		}
		if (funcName.includes('String') || funcName.includes('Name') || funcName.includes('Text')) {
			return 'string';
		}
		if (funcName.includes('Vector') || funcName.includes('Origin') || funcName.includes('Position') || funcName.includes('Angles')) {
			return 'Vector3';
		}
		if (funcName.includes('Entity') || funcName.includes('Player') || funcName.includes('Weapon')) {
			return 'Entity|nil';
		}
		return 'any';
	}
	return 'void';
}

// Parse Entity class methods
function parseEntityMethods(docContent) {
	const entitySection = docContent.match(/# Entity[\s\S]*?(?=^## |$)/);
	if (!entitySection) return [];

	const methods = [];
	const methodMatches = entitySection[0].matchAll(/^###\s+(\w+)\s*\(([^)]*)\)/gm);

	for (const match of methodMatches) {
		const methodName = match[1];
		const paramsStr = match[2];
		const params = [];

		if (paramsStr.trim()) {
			const paramMatches = paramsStr.matchAll(/(\w+):(\w+)/g);
			for (const paramMatch of paramMatches) {
				params.push({
					name: paramMatch[1],
					type: paramMatch[2]
				});
			}
		}

		methods.push({ name: methodName, params });
	}

	return methods;
}

// Generate comprehensive Entity type definition
async function generateEntityTypes(methods, examples) {
	let content = `---@meta\n\n`;
	content += `-- Lmaobox Lua API: Entity Class\n`;
	content += `-- Auto-generated from documentation\n`;
	content += `-- Last updated: ${new Date().toISOString()}\n\n`;

	if (examples.length > 0) {
		content += `-- Examples:\n`;
		examples.slice(0, 2).forEach(example => {
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

	content += `---@class Entity\n`;

	methods.forEach(method => {
		const paramTypes = method.params.map(p => {
			const luaType = mapTypeToLua(p.type);
			return `---@param ${p.name} ${luaType}`;
		}).join('\n');

		const returnType = inferReturnType(method.name, method.params);

		content += `${paramTypes}\n`;
		content += `---@return ${returnType}\n`;
		content += `---@field ${method.name} fun(self: Entity${method.params.length > 0 ? ', ' : ''}${method.params.map(p => `${p.name}: ${mapTypeToLua(p.type)}`).join(', ')})${returnType !== 'void' ? `: ${returnType}` : ''}\n`;
	});

	content += `local Entity = {}\n\n`;

	return content;
}

// Main function to parse and generate all types
async function parseAndGenerateAllTypes() {
	console.log('[GenerateTypes] Starting comprehensive type definition generation...\n');
	console.log('[GenerateTypes] ⚠️  NOTE: Sitemap fetch is rate limited to once per hour\n');

	// Read documentation
	console.log('[GenerateTypes] Reading documentation...');
	const docContent = await fs.readFile(DOC_FILE, 'utf8');

	// Extract examples
	const examples = extractExamples(docContent);
	console.log(`[GenerateTypes] Found ${examples.length} code examples`);

	// Parse libraries
	const libraries = parseLibraries(docContent);
	console.log(`[GenerateTypes] Found ${Object.keys(libraries).length} libraries`);

	// Parse Entity methods
	const entityMethods = parseEntityMethods(docContent);
	console.log(`[GenerateTypes] Found ${entityMethods.length} Entity methods`);

	// Optionally fetch sitemap (rate limited)
	const shouldFetch = await shouldFetchSitemap();
	if (shouldFetch) {
		try {
			console.log('[GenerateTypes] Fetching sitemap (rate limited - max once per hour)...');
			const response = await fetch(API_SITEMAP_URL);
			if (response.ok) {
				const sitemapXml = await response.text();
				await updateSession();
				console.log('[GenerateTypes] Sitemap fetched successfully');

				// Parse sitemap
				const urlMatches = sitemapXml.matchAll(/<loc>(.*?)<\/loc>/g);
				const urls = [];
				for (const match of urlMatches) {
					urls.push(match[1]);
				}
				console.log(`[GenerateTypes] Found ${urls.length} API endpoints in sitemap`);
			}
		} catch (error) {
			console.log('[GenerateTypes] Could not fetch sitemap:', error.message);
		}
	}

	// Generate type definitions for each library
	console.log('\n[GenerateTypes] Generating type definition files...');

	// Update main lmaobox.d.lua with all libraries
	await generateMainAPITypes(libraries, examples);

	// Update Entity type definition
	if (entityMethods.length > 0) {
		await generateEntityTypeDefinition(entityMethods, examples);
	}

	console.log('\n[GenerateTypes] ✅ Type definitions generated successfully');
	console.log('[GenerateTypes] All types are now available for the linter');

	return true;
}

// Generate main API types file
async function generateMainAPITypes(libraries, examples) {
	const filePath = path.join(TYPES_DIR, 'lmaobox.d.lua');

	let content = `---@meta\n\n`;
	content += `-- Lmaobox Lua API Type Definitions\n`;
	content += `-- Auto-generated from documentation\n`;
	content += `-- Last updated: ${new Date().toISOString()}\n`;
	content += `-- API Documentation: http://lmaobox.net/lua/sitemap.xml\n\n`;

	// Add examples section
	if (examples.length > 0) {
		content += `-- Example Usage:\n`;
		content += `--[[\n`;
		examples.slice(0, 1).forEach(example => {
			content += `${example}\n\n`;
		});
		content += `--]]\n\n`;
	}

	// Generate all library definitions
	for (const [libName, functions] of Object.entries(libraries)) {
		content += `---@class ${libName}\n`;
		content += `${libName} = {}\n\n`;

		functions.forEach(func => {
			const paramTypes = func.params.map(p => {
				const luaType = mapTypeToLua(p.type);
				return `---@param ${p.name} ${luaType}`;
			}).join('\n');

			const returnType = inferReturnType(func.name, func.params);

			if (paramTypes) {
				content += `${paramTypes}\n`;
			}
			content += `---@return ${returnType}\n`;
			content += `function ${libName}.${func.name}(${func.params.map(p => p.name).join(', ')}) end\n\n`;
		});
	}

	// Read existing file and merge if needed
	try {
		const existing = await fs.readFile(filePath, 'utf8');
		// For now, we'll append new functions that don't exist
		// In a full implementation, you'd do a proper merge
	} catch {
		// File doesn't exist, create it
	}

	await fs.writeFile(filePath, content, 'utf8');
	console.log(`[GenerateTypes] Updated ${filePath}`);
}

// Generate Entity type definition
async function generateEntityTypeDefinition(methods, examples) {
	const filePath = path.join(TYPES_DIR, 'entity_props', 'entity_base.d.lua');

	let content = await fs.readFile(filePath, 'utf8').catch(() => '---@meta\n\n');

	// Append Entity methods if not already present
	if (!content.includes('GetAbsOrigin')) {
		content += `\n-- Entity Methods (auto-generated)\n`;
		methods.forEach(method => {
			const paramTypes = method.params.map(p => {
				const luaType = mapTypeToLua(p.type);
				return `---@param ${p.name} ${luaType}`;
			}).join('\n');

			const returnType = inferReturnType(method.name, method.params);

			if (paramTypes) {
				content += `${paramTypes}\n`;
			}
			content += `---@return ${returnType}\n`;
			content += `---@field ${method.name} fun(self: Entity${method.params.length > 0 ? ', ' : ''}${method.params.map(p => `${p.name}: ${mapTypeToLua(p.type)}`).join(', ')})${returnType !== 'void' ? `: ${returnType}` : ''}\n`;
		});
	}

	await fs.writeFile(filePath, content, 'utf8');
	console.log(`[GenerateTypes] Updated ${filePath}`);
}

if (import.meta.url === `file://${process.argv[1]}`) {
	parseAndGenerateAllTypes().then(success => {
		process.exit(success ? 0 : 1);
	});
}

export { parseAndGenerateAllTypes, parseLibraries, parseEntityMethods, extractExamples };
