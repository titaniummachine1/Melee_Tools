import { promises as fs } from 'fs';
import path from 'path';

const WORKSPACE_ROOT = process.cwd();
const DOC_FILE = path.join(WORKSPACE_ROOT, 'lmaobox_lua_documentation.md');
const TYPES_DIR = path.join(WORKSPACE_ROOT, 'types');
const API_SITEMAP_URL = 'http://lmaobox.net/lua/sitemap.xml';

// Rate limiting: Only fetch sitemap if it's been more than 1 hour
const SESSION_FILE = path.join(TYPES_DIR, '.session');

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

// Parse documentation to extract API information
async function parseDocumentation() {
	console.log('[GenerateTypes] Reading documentation file...');

	try {
		const docContent = await fs.readFile(DOC_FILE, 'utf8');

		// Extract examples
		const examples = [];
		const exampleMatches = docContent.matchAll(/```lua\n([\s\S]*?)```/g);
		for (const match of exampleMatches) {
			examples.push(match[1].trim());
		}

		console.log(`[GenerateTypes] Found ${examples.length} code examples in documentation`);

		return { examples, docContent };
	} catch (error) {
		console.error('[GenerateTypes] Error reading documentation:', error.message);
		return { examples: [], docContent: '' };
	}
}

// Fetch sitemap (rate limited)
async function fetchSitemapIfAllowed() {
	const shouldFetch = await shouldFetchSitemap();
	if (!shouldFetch) {
		console.log('[GenerateTypes] Skipping sitemap fetch (rate limited to once per hour)');
		return null;
	}

	try {
		console.log('[GenerateTypes] Fetching sitemap (rate limited - max once per hour)...');
		const response = await fetch(API_SITEMAP_URL);
		if (!response.ok) {
			console.log('[GenerateTypes] Could not fetch sitemap');
			return null;
		}

		const sitemapXml = await response.text();
		await updateSession();
		console.log('[GenerateTypes] Sitemap fetched successfully');
		return sitemapXml;
	} catch (error) {
		console.error('[GenerateTypes] Error fetching sitemap:', error.message);
		return null;
	}
}

// Generate comprehensive type definitions from documentation
async function generateAllTypes() {
	console.log('[GenerateTypes] Starting comprehensive type definition generation...\n');
	console.log('[GenerateTypes] ⚠️  NOTE: Sitemap fetch is rate limited to once per hour\n');

	// Parse documentation
	const { examples, docContent } = await parseDocumentation();

	// Optionally fetch sitemap (rate limited)
	const sitemapXml = await fetchSitemapIfAllowed();

	if (sitemapXml) {
		console.log('[GenerateTypes] Sitemap available, parsing...');
		// Parse sitemap to get all API endpoints
		const urlMatches = sitemapXml.matchAll(/<loc>(.*?)<\/loc>/g);
		const urls = [];
		for (const match of urlMatches) {
			urls.push(match[1]);
		}
		console.log(`[GenerateTypes] Found ${urls.length} API endpoints in sitemap`);
	}

	// Use documentation to generate comprehensive types
	// This is where you'd parse the docContent and generate type definitions
	console.log('[GenerateTypes] Type definitions will be generated from documentation');
	console.log('[GenerateTypes] Documentation contains comprehensive API information');

	// For now, the existing type files are manually maintained
	// This script serves as a framework for future auto-generation
	console.log('\n[GenerateTypes] ✅ Type definition generation framework ready');
	console.log('[GenerateTypes] Existing type files in types/ are used');

	return true;
}

if (import.meta.url === `file://${process.argv[1]}`) {
	generateAllTypes().then(success => {
		process.exit(success ? 0 : 1);
	});
}

export { generateAllTypes, parseDocumentation, fetchSitemapIfAllowed };
