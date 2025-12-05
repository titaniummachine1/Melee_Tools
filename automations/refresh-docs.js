#!/usr/bin/env node

/**
 * Refresh Documentation Types
 * 
 * Manually triggers the crawler to fetch latest docs and generate type definitions.
 * This bypasses the 24-hour rate limit and forces a full refresh.
 * 
 * Usage: node automations/refresh-docs.js
 */

import { runCrawler } from './crawler/index.js';
import { generateDocsIndex } from './crawler/parser/docs-index.js';

async function main() {
	console.log('═══════════════════════════════════════════════════════════');
	console.log('  🔄 Refreshing Documentation Types');
	console.log('═══════════════════════════════════════════════════════════\n');

	try {
		// Force a full crawl (bypasses 24-hour check)
		console.log('[Refresh] Starting forced crawl...\n');
		const result = await runCrawler(true);

		if (result.type === 'skip') {
			console.log('[Refresh] ⚠️  Crawler skipped (unexpected)');
		} else {
			console.log(`\n[Refresh] ✅ Crawler completed successfully!`);
			console.log(`[Refresh] 📄 Pages updated: ${result.pagesUpdated || 0}`);
			console.log(`[Refresh] 📝 Type files generated: ${result.generated || 0}`);
			console.log(`[Refresh] ⏱️  Duration: ${result.duration || 0}ms\n`);
		}

		// Generate docs index for AI
		console.log('[Refresh] Generating docs index for AI...');
		try {
			await generateDocsIndex();
			console.log('[Refresh] ✅ Docs index generated\n');
		} catch (error) {
			console.log(`[Refresh] ⚠️  Could not generate docs index: ${error.message}\n`);
		}

		console.log('═══════════════════════════════════════════════════════════');
		console.log('  ✅ Refresh Complete!');
		console.log('═══════════════════════════════════════════════════════════');
		console.log('\n💡 Tip: Reload VS Code window (Ctrl+Shift+P → "Developer: Reload Window")');
		console.log('   to see the new type definitions in action.\n');

	} catch (error) {
		console.error('\n[Refresh] ❌ Error:', error);
		console.error(error.stack);
		process.exit(1);
	}
}

main();
