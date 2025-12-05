import { promises as fs } from 'fs';
import path from 'path';
import { parseDocumentationPage } from '../parser/html.js';
import { WORKSPACE_ROOT } from '../config.js';

async function main() {
	const htmlPath = path.join(WORKSPACE_ROOT, '.cache', 'docs', 'Lua_Classes', 'Vector3.html');
	const html = await fs.readFile(htmlPath, 'utf8');
	const parsed = parseDocumentationPage(html, 'https://lmaobox.net/lua/Lua_Classes/Vector3/');

	console.log('Title:', parsed.title);
	console.log('Description:', parsed.description);
	console.log('\nFunctions with descriptions:');
	parsed.functions.forEach(func => {
		if (func.description) {
			console.log(`  ${func.name}(): ${func.description}`);
		} else {
			console.log(`  ${func.name}(): (no description)`);
		}
	});
}

main().catch(console.error);
