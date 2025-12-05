import { promises as fs } from 'fs';
import path from 'path';
import { execSync } from 'child_process';

const WORKSPACE_ROOT = process.cwd();
const TYPES_DIR = path.join(WORKSPACE_ROOT, 'types');
const API_SITEMAP_URL = 'http://lmaobox.net/lua/sitemap.xml';
const VERSION_FILE = path.join(TYPES_DIR, '.version');

async function checkForUpdates() {
	console.log('[UpdateTypes] Checking for API updates...');

	try {
		// Fetch current sitemap to check for updates
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
			return false;
		}

		// Save new version
		await fs.writeFile(VERSION_FILE, contentHash, 'utf8');
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
