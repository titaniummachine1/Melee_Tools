import { promises as fs } from 'fs';
import path from 'path';

const WORKSPACE_ROOT = process.cwd();
const TYPES_DIR = path.join(WORKSPACE_ROOT, 'types');
const API_SITEMAP_URL = 'http://lmaobox.net/lua/sitemap.xml';
const VERSION_FILE = path.join(TYPES_DIR, '.version');
const SESSION_FILE = path.join(TYPES_DIR, '.session');

// Check if we've already fetched recently (rate limiting - 1 hour minimum)
async function shouldFetchSitemap() {
	try {
		const sessionData = await fs.readFile(SESSION_FILE, 'utf8');
		const session = JSON.parse(sessionData);
		const now = Date.now();
		const oneHour = 60 * 60 * 1000; // 1 hour in milliseconds

		// Only fetch if last fetch was more than 1 hour ago
		if (session.lastFetch && (now - session.lastFetch) < oneHour) {
			const timeSince = Math.floor((now - session.lastFetch) / 1000 / 60);
			console.log(`[UpdateTypes] Already checked ${timeSince} minutes ago, skipping sitemap fetch (rate limited)`);
			return false;
		}
	} catch (error) {
		// Session file doesn't exist or is invalid, proceed with fetch
	}
	return true;
}

// Update session file to track last fetch time
async function updateSession() {
	const sessionData = {
		lastFetch: Date.now(),
		lastFetchDate: new Date().toISOString()
	};
	await fs.writeFile(SESSION_FILE, JSON.stringify(sessionData, null, 2), 'utf8');
}

async function checkForUpdates() {
	console.log('[UpdateTypes] Checking for API updates...');

	// Rate limiting: Only fetch sitemap if it's been more than 1 hour since last fetch
	const shouldFetch = await shouldFetchSitemap();
	if (!shouldFetch) {
		// Still check version file for updates without fetching sitemap
		try {
			const versionContent = await fs.readFile(VERSION_FILE, 'utf8');
			console.log('[UpdateTypes] Type definitions version checked (no sitemap fetch - rate limited)');
			return false;
		} catch {
			// Version file missing, but we won't fetch now (rate limited)
			console.log('[UpdateTypes] Version file missing, but skipping fetch (rate limited to once per hour)');
			return false;
		}
	}

	try {
		// Fetch current sitemap to check for updates (rate limited to once per hour)
		console.log('[UpdateTypes] Fetching sitemap (rate limited - max once per hour)...');
		const response = await fetch(API_SITEMAP_URL);
		if (!response.ok) {
			console.log('[UpdateTypes] Could not fetch sitemap, skipping auto-update');
			return false;
		}

		const sitemapText = await response.text();
		// Extract last modified or use content hash as version indicator
		const contentHash = simpleHash(sitemapText);

		let lastKnownVersion = null;
		try {
			const versionContent = await fs.readFile(VERSION_FILE, 'utf8');
			lastKnownVersion = versionContent.trim();
		} catch (error) {
			// Version file doesn't exist, first run
			console.log('[UpdateTypes] First run - type definitions will be checked');
		}

		if (lastKnownVersion === contentHash) {
			console.log('[UpdateTypes] Type definitions are up to date');
			// Update session even if no changes (to track the fetch time)
			await updateSession();
			return false;
		}

		// Save new version
		await fs.writeFile(VERSION_FILE, contentHash, 'utf8');
		// Update session to track this fetch
		await updateSession();
		console.log('[UpdateTypes] API has been updated, type definitions may need updating');
		console.log('[UpdateTypes] Please check http://lmaobox.net/lua/sitemap.xml for changes');
		console.log('[UpdateTypes] Update the relevant files in types/ directory');
		return true;
	} catch (error) {
		console.log('[UpdateTypes] Error checking for updates:', error.message);
		return false;
	}
}

function simpleHash(str) {
	let hash = 0;
	for (let i = 0; i < str.length; i++) {
		const char = str.charCodeAt(i);
		hash = ((hash << 5) - hash) + char;
		hash = hash & hash; // Convert to 32bit integer
	}
	return hash.toString(36);
}

async function verifyTypeFiles() {
	console.log('[UpdateTypes] Verifying type definition files...');

	const requiredFiles = [
		'types/lmaobox.d.lua',
		'types/constants/lmaobox_constants.d.lua',
		'types/constants/lmaobox_constants_tf2.d.lua',
		'types/entity_props/entity_base.d.lua',
		'types/entity_props/entity_player.d.lua',
	];

	const missing = [];
	for (const file of requiredFiles) {
		const filePath = path.join(WORKSPACE_ROOT, file);
		try {
			await fs.access(filePath);
		} catch {
			missing.push(file);
		}
	}

	if (missing.length > 0) {
		console.warn('[UpdateTypes] Missing type definition files:');
		missing.forEach(file => console.warn(`  - ${file}`));
		return false;
	}

	console.log('[UpdateTypes] All required type definition files present');
	return true;
}

async function main() {
	console.log('[UpdateTypes] Starting type definition check...\n');
	console.log('[UpdateTypes] ⚠️  RATE LIMITED: Sitemap fetch is limited to once per hour maximum');
	console.log('[UpdateTypes] ⚠️  This script should ONLY run on workspace load, NOT on file save\n');

	// Auto-generate types to ensure all are up to date
	const generateScript = path.join(WORKSPACE_ROOT, 'automations', 'auto-generate-types.js');
	try {
		const generateModule = await import(`file:///${generateScript.replace(/\\/g, '/')}`);
		if (generateModule.autoGenerateAllTypes) {
			console.log('[UpdateTypes] Running auto-generation to ensure all types are up to date...\n');
			await generateModule.autoGenerateAllTypes();
			console.log('');
		}
	} catch (error) {
		console.log('[UpdateTypes] Auto-generation not available, continuing with check only');
		console.log(`[UpdateTypes] Error: ${error.message}`);
	}

	const filesOk = await verifyTypeFiles();
	if (!filesOk) {
		console.error('[UpdateTypes] Some type definition files are missing!');
		process.exit(1);
	}

	const needsUpdate = await checkForUpdates();

	if (needsUpdate) {
		console.log('\n[UpdateTypes] ⚠️  Type definitions may need manual updating');
		console.log('[UpdateTypes] Check http://lmaobox.net/lua/sitemap.xml for API changes');
	} else {
		console.log('\n[UpdateTypes] ✅ Type definitions are up to date');
	}

	console.log('\n[UpdateTypes] Done');
}

main().catch((error) => {
	console.error('[UpdateTypes] Fatal error:', error);
	process.exit(1);
});
