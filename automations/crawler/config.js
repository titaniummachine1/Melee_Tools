import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export const API_BASE_URL = 'https://lmaobox.net/lua/';
export const SITEMAP_URL = 'https://lmaobox.net/lua/sitemap.xml';
export const WORKSPACE_ROOT = path.resolve(__dirname, '../..');
export const TYPES_DIR = path.join(WORKSPACE_ROOT, 'types');
export const CACHE_DIR = path.join(WORKSPACE_ROOT, '.cache', 'docs');
export const DB_PATH = path.join(WORKSPACE_ROOT, '.cache', 'docs-graph.db');
export const LAST_UPDATE_FILE = path.join(WORKSPACE_ROOT, '.cache', 'last-update.json');
export const SESSION_FILE = path.join(TYPES_DIR, '.session');
export const TWENTY_FOUR_HOURS = 24 * 60 * 60 * 1000;
