import fs from 'fs';
import { parseDocumentationPage } from './crawler/parser/html.js';

try {
    const htmlPath = '../.cache/docs/Lua_Classes/BitBuffer.html';
    const html = fs.readFileSync(htmlPath, 'utf8');
    const parsed = parseDocumentationPage(html, 'https://lmaobox.net/lua/Lua_Classes/BitBuffer/');
    fs.writeFileSync('./parsed-bitbuffer.json', JSON.stringify(parsed, null, 2));
    console.log('OK', parsed.title, parsed.functions.length, parsed.classes, parsed.libraries, parsed.constants.length, parsed.examples.length);
} catch (e) {
    console.error('ERR', e);
    fs.writeFileSync('./parsed-bitbuffer-error.txt', String(e.stack || e));
}
