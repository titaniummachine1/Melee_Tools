import fs from 'fs';
import path from 'path';
import { TYPES_BASE_DIR, WORKSPACE_ROOT } from './crawler/config.js';

function mapTypeToLua(docType) {
  const t = docType.toLowerCase();
  if (['integer', 'int', 'number', 'float', 'double'].includes(t)) return 'number';
  if (t === 'string') return 'string';
  if (t === 'bool' || t === 'boolean') return 'boolean';
  if (t === 'vector' || t === 'vector3') return 'Vector3';
  if (['datatable', 'array', 'table'].includes(t)) return 'table';
  if (t === 'entity') return 'Entity|nil';
  return 'any';
}

function parseEntityPropsFromHtml(html) {
  const entities = [];
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
    const sectionText = section.replace(/<[^>]+>/g, ' ').replace(/&nbsp;/g, ' ').replace(/\s+/g, ' ').trim();
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

(async () => {
  const htmlPath = path.join(WORKSPACE_ROOT, '.cache', 'docs', 'TF2_props.html');
  const outDir = path.join(TYPES_BASE_DIR, 'entity_props');
  const html = fs.readFileSync(htmlPath, 'utf8');
  const entities = parseEntityPropsFromHtml(html);
  await fs.promises.mkdir(outDir, { recursive: true });
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
    const filePath = path.join(outDir, `${ent.name}.d.lua`);
    fs.writeFileSync(filePath, content, 'utf8');
    count++;
  }
  fs.writeFileSync(path.resolve('./entity-props-summary.txt'), `${count}`);
})();
