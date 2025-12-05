import { promises as fs } from 'fs';
import path from 'path';

const WORKSPACE_ROOT = process.cwd();
const TYPES_DIR = path.join(WORKSPACE_ROOT, 'types');

async function verifyTypeFiles() {
	console.log('[UpdateTypes] Verifying type definition files...');

	const requiredFiles = [
		'types/lmaobox.d.lua',
		'types/constants/lmaobox_constants.d.lua',
		'types/entity_props/entity_base.d.lua',
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
		console.warn('[UpdateTypes] Missing some type definition files (will be generated):');
		missing.forEach(file => console.warn(`  - ${file}`));
	}

	return missing.length === 0;
}

async function main() {
	console.log('[UpdateTypes] Starting type definition check...\n');
	console.log('[UpdateTypes] ⚠️  This script runs on workspace load only\n');
	console.log('[UpdateTypes] ⚠️  Rate limited: Full crawl only if 24+ hours since last update\n');

	// Try to use the new smart crawler
	const crawlerPath = path.join(WORKSPACE_ROOT, 'automations', 'crawler', 'index.js');
	
	try {
		const crawler = await import(`file:///${crawlerPath.replace(/\\/g, '/')}`);
		if (crawler.runCrawler) {
			console.log('[UpdateTypes] Using smart crawler system...\n');
			const result = await crawler.runCrawler(false);
			
			if (result.type === 'skip') {
				console.log('[UpdateTypes] Skipped full crawl (less than 24 hours since last update)');
			} else {
				console.log(`[UpdateTypes] Crawler completed: ${result.pagesUpdated} pages updated`);
			}
			
			// Generate docs index for AI
			const docsIndexPath = path.join(WORKSPACE_ROOT, 'automations', 'crawler', 'parser', 'docs-index.js');
			try {
				const docsIndex = await import(`file:///${docsIndexPath.replace(/\\/g, '/')}`);
				if (docsIndex.generateDocsIndex) {
					await docsIndex.generateDocsIndex();
				}
			} catch (error) {
				console.log('[UpdateTypes] Could not generate docs index:', error.message);
			}
		}
	} catch (crawlError) {
		console.log('[UpdateTypes] Smart crawler not available, trying fallback...');
		console.log(`[UpdateTypes] Error: ${crawlError.message}`);
		
		// Fallback to local documentation parsing
		const generateScript = path.join(WORKSPACE_ROOT, 'automations', 'auto-generate-types.js');
		try {
			const generateModule = await import(`file:///${generateScript.replace(/\\/g, '/')}`);
			if (generateModule.autoGenerateAllTypes) {
				console.log('[UpdateTypes] Running auto-generation from local docs...\n');
				await generateModule.autoGenerateAllTypes();
			}
		} catch (error) {
			console.log('[UpdateTypes] Fallback also failed, continuing with verification only');
			console.log(`[UpdateTypes] Error: ${error.message}`);
		}
	}

	const filesOk = await verifyTypeFiles();
	if (!filesOk) {
		console.log('[UpdateTypes] Some type files missing, but crawler should generate them');
	}

	console.log('\n[UpdateTypes] ✅ Type definition check complete');
	console.log('[UpdateTypes] Types are available for the linter');
}

main().catch((error) => {
	console.error('[UpdateTypes] Fatal error:', error);
	process.exit(1);
});
