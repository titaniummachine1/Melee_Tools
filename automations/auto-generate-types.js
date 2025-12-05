import { promises as fs } from 'fs';
import path from 'path';

console.log('[AutoGenerate] Script loaded');

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
			console.log(`[AutoGenerate] Already fetched ${timeSince} minutes ago, skipping (rate limited)`);
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

// Parse function signature: ### functionName( param1:type1, param2:type2 )
function parseFunction(line) {
	const match = line.match(/^###\s+(\w+)\s*\(([^)]*)\)/);
	if (!match) return null;

	const name = match[1];
	const paramsStr = match[2].trim();
	const params = [];

	if (paramsStr) {
		// Parse parameters like "param:type" or "[param:type]"
		const paramPattern = /\[?(\w+):(\w+)\]?/g;
		let paramMatch;
		while ((paramMatch = paramPattern.exec(paramsStr)) !== null) {
			params.push({
				name: paramMatch[1],
				type: paramMatch[2],
				optional: paramsStr.includes('[')
			});
		}
	}

	return { name, params };
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

// Auto-discover libraries from documentation (## LibraryName sections with Functions)
function autoDiscoverLibraries(docContent) {
	const libraries = {};
	
	// Find all ## sections that have "Functions" subsection
	const sectionMatches = docContent.matchAll(/^##\s+(\w+)\s*$/gm);
	
	for (const match of sectionMatches) {
		const libName = match[1];
		const startIdx = match.index;
		
		// Skip known non-library sections
		if (['Home', 'API', 'Lua', 'Predefined', 'Entity', 'Community', 'IDE', 'Learning', 'How', 'Interaction', 'Top', 'Changelog', 'Callbacks', 'Examples', 'Globals', 'Props'].includes(libName)) {
			continue;
		}
		
		// Find the end of this section
		const nextSection = docContent.substring(startIdx + match[0].length).match(/\n^##\s+/m);
		const endIdx = nextSection ? startIdx + match[0].length + nextSection.index : docContent.length;
		const sectionContent = docContent.substring(startIdx, endIdx);
		
		// Check if this section has functions (look for "Functions" or "### FunctionName")
		if (sectionContent.includes('Functions') || sectionContent.match(/^###\s+\w+\s*\(/m)) {
			const functions = [];
			const funcMatches = sectionContent.matchAll(/^###\s+(\w+)\s*\(([^)]*)\)/gm);
			
			for (const funcMatch of funcMatches) {
				const func = parseFunction(funcMatch[0]);
				if (func) {
					functions.push(func);
				}
			}
			
			if (functions.length > 0) {
				// Extract examples from this section
				const examples = [];
				const exampleMatches = sectionContent.matchAll(/```lua\n([\s\S]*?)```/g);
				for (const exMatch of exampleMatches) {
					examples.push(exMatch[1].trim());
				}
				libraries[libName] = { functions, examples };
			}
		}
	}
	
	return libraries;
}

// Auto-discover classes from documentation (# ClassName sections, not ##)
function autoDiscoverClasses(docContent) {
	const classes = {};
	
	// Find all # ClassName sections (single #, not ##)
	const classMatches = docContent.matchAll(/^#\s+([A-Z][\w]+)\s*$/gm);
	
	for (const match of classMatches) {
		const className = match[1];
		
		// Skip known non-class sections
		if (['Home', 'Lmaobox', 'Lua'].includes(className)) {
			continue;
		}
		
		const startIdx = match.index;
		// Find the end of this class section (next # or ##)
		const nextSection = docContent.substring(startIdx + match[0].length).match(/\n^#+\s+/m);
		const endIdx = nextSection ? startIdx + match[0].length + nextSection.index : docContent.length;
		const sectionContent = docContent.substring(startIdx, endIdx);
		
		// Check if this has methods or fields
		if (sectionContent.includes('Methods') || sectionContent.includes('Fields') || sectionContent.includes('Constructor') || sectionContent.match(/^###\s+\w+/m)) {
			const methods = [];
			const methodMatches = sectionContent.matchAll(/^###\s+(\w+)\s*\(([^)]*)\)/gm);
			
			for (const methodMatch of methodMatches) {
				const method = parseFunction(methodMatch[0]);
				if (method) {
					methods.push(method);
				}
			}
			
			// Also check for fields (like Vector3.x, Vector3.y)
			const fields = [];
			const fieldMatches = sectionContent.matchAll(/^###\s+(\w+)\s*\/\s*(\w+)/gm);
			for (const fieldMatch of fieldMatches) {
				fields.push({
					name: fieldMatch[1] || fieldMatch[2],
					type: 'number' // Fields are usually numbers
				});
			}
			
			if (methods.length > 0 || fields.length > 0) {
				const examples = [];
				const exampleMatches = sectionContent.matchAll(/```lua\n([\s\S]*?)```/g);
				for (const exMatch of exampleMatches) {
					examples.push(exMatch[1].trim());
				}
				classes[className] = { methods, fields, examples };
			}
		}
	}
	
	return classes;
}

// Auto-discover callbacks from "Lua Callbacks" section
function autoDiscoverCallbacks(docContent) {
	const callbacks = {};
	
	const callbacksSection = docContent.match(/## Lua Callbacks[\s\S]*?(?=^## |$)/);
	if (!callbacksSection) return callbacks;
	
	const section = callbacksSection[0];
	const callbackMatches = section.matchAll(/^###\s+(\w+)\s*\(([^)]*)\)/gm);
	
	for (const match of callbackMatches) {
		const callbackName = match[1];
		const paramsStr = match[2].trim();
		const params = [];
		
		if (paramsStr) {
			const paramPattern = /\[?(\w+):(\w+)\]?/g;
			let paramMatch;
			while ((paramMatch = paramPattern.exec(paramsStr)) !== null) {
				params.push({
					name: paramMatch[1],
					type: paramMatch[2]
				});
			}
		}
		
		callbacks[callbackName] = { params };
	}
	
	return callbacks;
}

// Auto-discover globals from "Lua Globals" section
function autoDiscoverGlobals(docContent) {
	const globals = {};
	
	const globalsSection = docContent.match(/## Lua Globals[\s\S]*?(?=^## |$)/);
	if (!globalsSection) return globals;
	
	const section = globalsSection[0];
	const globalMatches = section.matchAll(/^###\s+(\w+)\s*\(([^)]*)\)/gm);
	
	for (const match of globalMatches) {
		const globalName = match[1];
		const paramsStr = match[2].trim();
		const params = [];
		
		if (paramsStr) {
			const paramPattern = /\[?(\w+):(\w+)\]?/g;
			let paramMatch;
			while ((paramMatch = paramPattern.exec(paramsStr)) !== null) {
				params.push({
					name: paramMatch[1],
					type: paramMatch[2]
				});
			}
		}
		
		globals[globalName] = { params };
	}
	
	return globals;
}

// Auto-discover constants from "Predefined constants" section
function autoDiscoverConstants(docContent) {
	const constants = {};
	
	const constantsSection = docContent.match(/## Predefined constants[\s\S]*?(?=^## |$)/);
	if (!constantsSection) return constants;
	
	const section = constantsSection[0];
	
	// Look for constant definitions (various patterns)
	// Pattern 1: CONSTANT_NAME = value
	const constMatches1 = section.matchAll(/([A-Z_][A-Z0-9_]*)\s*=\s*([^\n]+)/g);
	for (const match of constMatches1) {
		constants[match[1]] = { value: match[2].trim() };
	}
	
	// Pattern 2: Lists in code blocks
	const codeBlocks = section.matchAll(/```[\s\S]*?```/g);
	for (const block of codeBlocks) {
		const blockContent = block[0];
		const constMatches2 = blockContent.matchAll(/([A-Z_][A-Z0-9_]*)\s*=\s*([^\n]+)/g);
		for (const match of constMatches2) {
			if (!constants[match[1]]) {
				constants[match[1]] = { value: match[2].trim() };
			}
		}
	}
	
	return constants;
}

// Parse Entity class methods (special handling)
function parseEntityClass(docContent) {
	const entitySection = docContent.match(/# Entity[\s\S]*?(?=^## |$)/);
	if (!entitySection) return { methods: [], examples: [] };

	const section = entitySection[0];
	const methods = [];
	const methodMatches = section.matchAll(/^###\s+(\w+)\s*\(([^)]*)\)/gm);

	for (const match of methodMatches) {
		const method = parseFunction(match[0]);
		if (method) {
			methods.push(method);
		}
	}

	const examples = [];
	const exampleMatches = section.matchAll(/```lua\n([\s\S]*?)```/g);
	for (const match of exampleMatches) {
		examples.push(match[1].trim());
	}

	return { methods, examples };
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
		'vector': 'Vector3',
		'vector3': 'Vector3',
		'eulerangles': 'EulerAngles',
		'entity': 'Entity|nil',
		'item': 'Item|nil',
		'material': 'Material|nil',
		'color': 'Color|nil',
		'table': 'table',
		'usercmd': 'UserCmd',
		'gameevent': 'GameEvent',
		'drawmodelcontext': 'DrawModelContext',
		'viewsetup': 'ViewSetup',
		'netmessage': 'NetMessage',
		'stringcmd': 'string',
		'any': 'any',
		'function': 'function',
		'void': 'void'
	};

	return typeMap[docType.toLowerCase()] || 'any';
}

// Infer return type from function name and description
function inferReturnType(funcName, params, description = '') {
	const desc = description.toLowerCase();

	// Boolean returns
	if (funcName.startsWith('Is') || funcName.startsWith('Has') || funcName.startsWith('Can') ||
		funcName.includes('Bool') || desc.includes('returns true') || desc.includes('returns false')) {
		return 'boolean';
	}

	// Number returns
	if (funcName.includes('Int') || funcName.includes('Count') || funcName.includes('Index') ||
		funcName.includes('Time') || funcName.includes('Size') || funcName.includes('Length') ||
		desc.includes('returns integer') || desc.includes('returns number')) {
		return 'number';
	}

	// String returns
	if (funcName.includes('String') || funcName.includes('Name') || funcName.includes('Text') ||
		funcName.includes('Path') || funcName.includes('Dir') || desc.includes('returns string')) {
		return 'string';
	}

	// Vector returns
	if (funcName.includes('Vector') || funcName.includes('Origin') || funcName.includes('Position') ||
		funcName.includes('Angles') || funcName.includes('Velocity') || desc.includes('returns vector')) {
		return 'Vector3';
	}

	// Entity returns
	if (funcName.includes('Entity') || funcName.includes('Player') || funcName.includes('Weapon') ||
		desc.includes('returns entity') || desc.includes('returns player')) {
		return 'Entity|nil';
	}

	// Table returns
	if (desc.includes('returns table') || desc.includes('returns a table')) {
		return 'table';
	}

	// Multiple returns
	if (desc.includes('returns:') || desc.includes('returns 2') || desc.includes('returns 3')) {
		// Try to parse multiple return types
		const returnsMatch = desc.match(/returns[:\s]+([^\.]+)/);
		if (returnsMatch) {
			const returns = returnsMatch[1];
			if (returns.includes('width') && returns.includes('height')) {
				return 'number, number';
			}
			if (returns.includes('mask') && returns.includes('entity')) {
				return 'number, Entity|nil';
			}
		}
	}

	return 'any';
}

// Generate type definition for a library
function generateLibraryTypeDefinition(libName, functions, examples) {
	let content = `---@meta\n\n`;
	content += `-- Lmaobox Lua API: ${libName} Library\n`;
	content += `-- Auto-generated from documentation\n`;
	content += `-- Last updated: ${new Date().toISOString()}\n\n`;

	if (examples.length > 0) {
		content += `-- Examples:\n`;
		examples.slice(0, 2).forEach((example, idx) => {
			content += `-- Example ${idx + 1}:\n`;
			const lines = example.split('\n').slice(0, 10);
			lines.forEach(line => {
				content += `-- ${line}\n`;
			});
			if (example.split('\n').length > 10) {
				content += `-- ...\n`;
			}
			content += `\n`;
		});
	}

	content += `---@class ${libName}\n`;
	content += `${libName} = {}\n\n`;

	functions.forEach(func => {
		// Generate parameter annotations
		func.params.forEach(param => {
			const luaType = mapTypeToLua(param.type);
			const optional = param.optional ? '?' : '';
			content += `---@param ${param.name}${optional} ${luaType}\n`;
		});

		// Infer return type
		const returnType = inferReturnType(func.name, func.params);
		if (returnType !== 'void') {
			content += `---@return ${returnType}\n`;
		}

		// Function signature
		const paramList = func.params.map(p => p.name).join(', ');
		content += `function ${libName}.${func.name}(${paramList}) end\n\n`;
	});

	return content;
}

// Generate comprehensive Entity type definition
async function generateEntityTypes(methods, examples) {
	const filePath = path.join(TYPES_DIR, 'entity_props', 'entity_base.d.lua');

	let content = `---@meta\n\n`;
	content += `-- Lmaobox Lua API: Entity Class\n`;
	content += `-- Auto-generated from documentation\n`;
	content += `-- Last updated: ${new Date().toISOString()}\n\n`;

	if (examples.length > 0) {
		content += `-- Examples:\n`;
		examples.slice(0, 2).forEach((example, idx) => {
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

	content += `---@class Entity\n`;

	methods.forEach(method => {
		method.params.forEach(param => {
			const luaType = mapTypeToLua(param.type);
			content += `---@param ${param.name} ${luaType}\n`;
		});

		const returnType = inferReturnType(method.name, method.params);
		if (returnType !== 'void') {
			content += `---@return ${returnType}\n`;
		}

		const paramTypes = method.params.map(p => `${p.name}: ${mapTypeToLua(p.type)}`).join(', ');
		content += `---@field ${method.name} fun(self: Entity${method.params.length > 0 ? ', ' : ''}${paramTypes})${returnType !== 'void' ? `: ${returnType}` : ''}\n`;
	});

	content += `local Entity = {}\n\n`;

	await fs.writeFile(filePath, content, 'utf8');
	console.log(`[AutoGenerate] Generated Entity types with ${methods.length} methods`);
}

// Generate class type definitions
async function generateClassTypes(className, classData, examples) {
	const filePath = path.join(TYPES_DIR, `classes_${className.toLowerCase()}.d.lua`);

	let content = `---@meta\n\n`;
	content += `-- Lmaobox Lua API: ${className} Class\n`;
	content += `-- Auto-generated from documentation\n`;
	content += `-- Last updated: ${new Date().toISOString()}\n\n`;

	if (examples.length > 0) {
		content += `-- Examples:\n`;
		examples.slice(0, 1).forEach(example => {
			const lines = example.split('\n').slice(0, 6);
			lines.forEach(line => {
				content += `-- ${line}\n`;
			});
			if (example.split('\n').length > 6) {
				content += `-- ...\n`;
			}
		});
		content += `\n`;
	}

	content += `---@class ${className}\n`;

	// Add fields if any
	if (classData.fields && classData.fields.length > 0) {
		classData.fields.forEach(field => {
			content += `---@field ${field.name} ${field.type}\n`;
		});
	}

	// Add methods
	classData.methods.forEach(method => {
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

	await fs.writeFile(filePath, content, 'utf8');
	console.log(`[AutoGenerate] Generated ${className} class with ${classData.methods.length} methods${classData.fields ? ` and ${classData.fields.length} fields` : ''}`);
}

// Generate callbacks type definitions
async function generateCallbacksTypes(callbacks) {
	const filePath = path.join(TYPES_DIR, 'callbacks.d.lua');

	let content = `---@meta\n\n`;
	content += `-- Lmaobox Lua API: Callbacks\n`;
	content += `-- Auto-generated from documentation\n`;
	content += `-- Last updated: ${new Date().toISOString()}\n\n`;

	content += `---@class callbacks\n`;
	content += `callbacks = {}\n\n`;

	// Register function
	content += `---@param eventName string\n`;
	content += `---@param name string\n`;
	content += `---@param callback function\n`;
	content += `function callbacks.Register(eventName, name, callback) end\n\n`;

	// Unregister function
	content += `---@param eventName string\n`;
	content += `---@param name string\n`;
	content += `function callbacks.Unregister(eventName, name) end\n\n`;

	// Callback type definitions
	for (const [callbackName, callbackData] of Object.entries(callbacks)) {
		const paramTypes = callbackData.params.map(p => `${p.name}: ${mapTypeToLua(p.type)}`).join(', ');
		content += `---@alias Callback_${callbackName} fun(${paramTypes})\n`;
	}

	await fs.writeFile(filePath, content, 'utf8');
	console.log(`[AutoGenerate] Generated callbacks with ${Object.keys(callbacks).length} callback types`);
}

// Generate globals type definitions
async function generateGlobalsTypes(globals) {
	const filePath = path.join(TYPES_DIR, 'globals.d.lua');

	let content = `---@meta\n\n`;
	content += `-- Lmaobox Lua API: Global Functions\n`;
	content += `-- Auto-generated from documentation\n`;
	content += `-- Last updated: ${new Date().toISOString()}\n\n`;

	for (const [globalName, globalData] of Object.entries(globals)) {
		globalData.params.forEach(param => {
			const luaType = mapTypeToLua(param.type);
			content += `---@param ${param.name} ${luaType}\n`;
		});

		const returnType = inferReturnType(globalName, globalData.params);
		if (returnType !== 'void') {
			content += `---@return ${returnType}\n`;
		}

		const paramList = globalData.params.map(p => p.name).join(', ');
		content += `function ${globalName}(${paramList}) end\n\n`;
	}

	await fs.writeFile(filePath, content, 'utf8');
	console.log(`[AutoGenerate] Generated ${Object.keys(globals).length} global functions`);
}

// Main function to auto-generate all types
async function autoGenerateAllTypes() {
	console.log('[AutoGenerate] Starting comprehensive type definition generation...\n');
	console.log('[AutoGenerate] ⚠️  NOTE: Sitemap fetch is rate limited to once per hour\n');

	// Check if documentation file exists
	try {
		await fs.access(DOC_FILE);
	} catch (error) {
		console.error(`[AutoGenerate] Documentation file not found: ${DOC_FILE}`);
		console.error('[AutoGenerate] Please ensure lmaobox_lua_documentation.md exists in the workspace root');
		return false;
	}

	// Read documentation
	console.log('[AutoGenerate] Reading documentation...');
	const docContent = await fs.readFile(DOC_FILE, 'utf8');

	// Extract all examples
	const allExamples = extractExamples(docContent);
	console.log(`[AutoGenerate] Found ${allExamples.length} total examples`);

	// Auto-discover libraries
	console.log('[AutoGenerate] Auto-discovering libraries...');
	const libraries = autoDiscoverLibraries(docContent);
	console.log(`[AutoGenerate] Found ${Object.keys(libraries).length} libraries: ${Object.keys(libraries).join(', ')}`);

	// Auto-discover classes
	console.log('[AutoGenerate] Auto-discovering classes...');
	const classes = autoDiscoverClasses(docContent);
	console.log(`[AutoGenerate] Found ${Object.keys(classes).length} classes: ${Object.keys(classes).join(', ')}`);

	// Auto-discover callbacks
	console.log('[AutoGenerate] Auto-discovering callbacks...');
	const callbacks = autoDiscoverCallbacks(docContent);
	console.log(`[AutoGenerate] Found ${Object.keys(callbacks).length} callbacks: ${Object.keys(callbacks).join(', ')}`);

	// Auto-discover globals
	console.log('[AutoGenerate] Auto-discovering globals...');
	const globals = autoDiscoverGlobals(docContent);
	console.log(`[AutoGenerate] Found ${Object.keys(globals).length} globals: ${Object.keys(globals).join(', ')}`);

	// Auto-discover constants
	console.log('[AutoGenerate] Auto-discovering constants...');
	const constants = autoDiscoverConstants(docContent);
	console.log(`[AutoGenerate] Found ${Object.keys(constants).length} constants`);

	// Parse Entity class (special handling)
	console.log('[AutoGenerate] Parsing Entity class...');
	const entityClass = parseEntityClass(docContent);
	console.log(`[AutoGenerate] Found ${entityClass.methods.length} Entity methods`);

	// Optionally fetch sitemap (rate limited)
	const shouldFetch = await shouldFetchSitemap();
	if (shouldFetch) {
		try {
			console.log('[AutoGenerate] Fetching sitemap (rate limited - max once per hour)...');
			const response = await fetch(API_SITEMAP_URL);
			if (response.ok) {
				const sitemapXml = await response.text();
				await updateSession();
				console.log('[AutoGenerate] Sitemap fetched successfully');
			}
		} catch (error) {
			console.log('[AutoGenerate] Could not fetch sitemap:', error.message);
		}
	}

	// Generate type definitions
	console.log('\n[AutoGenerate] Generating type definition files...');

	// Generate main API file with all libraries
	await generateMainAPITypes(libraries, allExamples);

	// Generate Entity types
	if (entityClass.methods.length > 0) {
		await generateEntityTypes(entityClass.methods, entityClass.examples);
	}

	// Generate class type definitions
	for (const [className, classData] of Object.entries(classes)) {
		if (className !== 'Entity') { // Entity already handled
			await generateClassTypes(className, classData, classData.examples || []);
		}
	}

	// Generate callbacks
	if (Object.keys(callbacks).length > 0) {
		await generateCallbacksTypes(callbacks);
	}

	// Generate globals
	if (Object.keys(globals).length > 0) {
		await generateGlobalsTypes(globals);
	}

	console.log('\n[AutoGenerate] ✅ All type definitions generated successfully');
	console.log('[AutoGenerate] Types are now available for the linter with examples');
	console.log('[AutoGenerate] All categories auto-discovered and updated');

	return true;
}

// Generate main API types file with all libraries
async function generateMainAPITypes(libraries, examples) {
	const filePath = path.join(TYPES_DIR, 'lmaobox.d.lua');

	let content = `---@meta\n\n`;
	content += `-- Lmaobox Lua API Type Definitions\n`;
	content += `-- Auto-generated from documentation\n`;
	content += `-- Last updated: ${new Date().toISOString()}\n`;
	content += `-- API Documentation: http://lmaobox.net/lua/sitemap.xml\n\n`;

	// Add a comprehensive example
	if (examples.length > 0) {
		content += `-- Example Usage:\n`;
		content += `--[[\n`;
		content += `${examples[0]}\n`;
		content += `--]]\n\n`;
	}

	// Generate all library definitions
	for (const [libName, libData] of Object.entries(libraries)) {
		const libContent = generateLibraryTypeDefinition(libName, libData.functions, libData.examples || []);
		// Extract just the library definition part (skip the meta header)
		const libDef = libContent.split('---@class')[1];
		content += `---@class ${libName}\n`;
		content += libDef;
	}

	await fs.writeFile(filePath, content, 'utf8');
	console.log(`[AutoGenerate] Generated main API types with ${Object.keys(libraries).length} libraries`);
}

// Run if executed directly
autoGenerateAllTypes().then(success => {
	process.exit(success ? 0 : 1);
}).catch(error => {
	console.error('[AutoGenerate] Fatal error:', error);
	process.exit(1);
});

export { autoGenerateAllTypes, autoDiscoverLibraries, autoDiscoverClasses, autoDiscoverCallbacks, autoDiscoverGlobals, autoDiscoverConstants, parseEntityClass, extractExamples };
