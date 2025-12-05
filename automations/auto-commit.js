import { execSync } from 'child_process';
import { promises as fs } from 'fs';
import path from 'path';

async function main() {
	const workspaceRoot = process.cwd();

	try {
		// Check if we're in a git repo
		execSync('git rev-parse --git-dir', { cwd: workspaceRoot, stdio: 'ignore' });
	} catch (error) {
		console.log('[AutoCommit] Not a git repository, skipping commit');
		return;
	}

	try {
		// Get the diff stats for all changed files
		const diffOutput = execSync('git diff --numstat', {
			cwd: workspaceRoot,
			encoding: 'utf8',
			stdio: ['ignore', 'pipe', 'ignore']
		});

		// Also check staged files
		const stagedOutput = execSync('git diff --cached --numstat', {
			cwd: workspaceRoot,
			encoding: 'utf8',
			stdio: ['ignore', 'pipe', 'ignore']
		});

		// Parse the output to count changed lines
		let totalChangedLines = 0;

		const parseDiffStats = (output) => {
			if (!output || output.trim() === '') return 0;
			let lines = 0;
			for (const line of output.trim().split('\n')) {
				const parts = line.trim().split(/\s+/);
				if (parts.length >= 3) {
					const added = parseInt(parts[0]) || 0;
					const deleted = parseInt(parts[1]) || 0;
					lines += added + deleted;
				}
			}
			return lines;
		};

		totalChangedLines = parseDiffStats(diffOutput) + parseDiffStats(stagedOutput);

		if (totalChangedLines === 0) {
			console.log('[AutoCommit] No changes detected');
			return;
		}

		console.log(`[AutoCommit] Detected ${totalChangedLines} changed lines`);

		if (totalChangedLines > 10) {
			// Auto-commit (never push - push is manual only)
			console.log('[AutoCommit] Changes exceed 10 lines, auto-committing...');

			// Stage all changes
			try {
				execSync('git add -A', {
					cwd: workspaceRoot,
					stdio: ['ignore', 'pipe', 'pipe'],
					encoding: 'utf8'
				});
			} catch (error) {
				// If git add fails, check if files are already staged
				const stagedCheck = execSync('git diff --cached --numstat', {
					cwd: workspaceRoot,
					encoding: 'utf8',
					stdio: ['ignore', 'pipe', 'ignore']
				});

				if (!stagedCheck || stagedCheck.trim() === '') {
					// No staged files, so the error is real
					throw new Error(`git add -A failed: ${error.message}`);
				}
				// Files are already staged, continue
				console.log('[AutoCommit] Files already staged, continuing...');
			}

			// Get changed files with their line counts
			const changedFilesOutput = execSync('git diff --cached --numstat', {
				cwd: workspaceRoot,
				encoding: 'utf8',
				stdio: ['ignore', 'pipe', 'ignore']
			});

			const fileStats = [];
			for (const line of changedFilesOutput.trim().split('\n')) {
				const parts = line.trim().split(/\s+/);
				if (parts.length >= 3) {
					const added = parseInt(parts[0]) || 0;
					const deleted = parseInt(parts[1]) || 0;
					const fileName = parts.slice(2).join(' ');
					const fileLines = added + deleted;
					fileStats.push({ fileName, fileLines, added, deleted });
				}
			}

			// Sort by most changed first
			fileStats.sort((a, b) => b.fileLines - a.fileLines);

			// Build commit message with file names
			let commitMessage = '';
			if (fileStats.length === 1) {
				const file = fileStats[0];
				commitMessage = `${file.fileName} (${file.added}+${file.deleted}-)`;
			} else if (fileStats.length <= 3) {
				const fileNames = fileStats.map(f => f.fileName).join(', ');
				commitMessage = `${fileNames} (${totalChangedLines} lines)`;
			} else {
				const mainFiles = fileStats.slice(0, 2).map(f => f.fileName).join(', ');
				commitMessage = `${mainFiles} +${fileStats.length - 2} more (${totalChangedLines} lines)`;
			}

			// Commit (never push - that's manual only)
			execSync(`git commit -m "${commitMessage}"`, {
				cwd: workspaceRoot,
				stdio: 'inherit'
			});

			console.log(`[AutoCommit] Committed (not pushed): ${commitMessage}`);
		} else {
			console.log(`[AutoCommit] Only ${totalChangedLines} lines changed (threshold: 10), skipping auto-commit`);
		}
	} catch (error) {
		console.error('[AutoCommit] Error:', error.message);
		// Don't fail the build process if commit fails
	}
}

main().catch((error) => {
	console.error('[AutoCommit] Fatal error:', error);
	process.exit(0); // Exit with 0 to not break the build chain
});
