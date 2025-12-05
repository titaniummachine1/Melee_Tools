import Database from 'better-sqlite3';
import path from 'path';
import { DB_PATH } from '../config.js';
import { promises as fs } from 'fs';

export function createDatabase() {
	// Ensure cache directory exists
	const dbDir = path.dirname(DB_PATH);
	fs.mkdir(dbDir, { recursive: true }).catch(() => { });

	const db = new Database(DB_PATH);
	db.pragma('journal_mode = WAL');
	db.pragma('foreign_keys = ON');

	// Create tables
	db.exec(`
		CREATE TABLE IF NOT EXISTS pages (
			url TEXT PRIMARY KEY,
			path TEXT,
			title TEXT,
			content_hash TEXT,
			last_fetched INTEGER,
			fetch_count INTEGER DEFAULT 0,
			page_type TEXT,
			parent_url TEXT,
			depth INTEGER DEFAULT 0,
			sitemap_order INTEGER,
			parsed_data TEXT,
			FOREIGN KEY (parent_url) REFERENCES pages(url)
		);

		CREATE TABLE IF NOT EXISTS links (
			from_url TEXT,
			to_url TEXT,
			link_text TEXT,
			link_type TEXT,
			PRIMARY KEY (from_url, to_url),
			FOREIGN KEY (from_url) REFERENCES pages(url),
			FOREIGN KEY (to_url) REFERENCES pages(url)
		);

		CREATE TABLE IF NOT EXISTS sitemap_snapshots (
			snapshot_id INTEGER PRIMARY KEY AUTOINCREMENT,
			timestamp INTEGER,
			url_count INTEGER,
			urls_json TEXT
		);

		CREATE TABLE IF NOT EXISTS type_definitions (
			url TEXT PRIMARY KEY,
			path TEXT,
			generated_at INTEGER,
			type_content TEXT,
			FOREIGN KEY (url) REFERENCES pages(url)
		);

		CREATE TABLE IF NOT EXISTS update_log (
			update_id INTEGER PRIMARY KEY AUTOINCREMENT,
			timestamp INTEGER,
			update_type TEXT,
			pages_updated INTEGER,
			duration_ms INTEGER
		);

		CREATE INDEX IF NOT EXISTS idx_pages_path ON pages(path);
		CREATE INDEX IF NOT EXISTS idx_pages_parent ON pages(parent_url);
		CREATE INDEX IF NOT EXISTS idx_links_from ON links(from_url);
		CREATE INDEX IF NOT EXISTS idx_links_to ON links(to_url);
	`);

	// Migration: Add parsed_data column if it doesn't exist
	try {
		db.exec(`ALTER TABLE pages ADD COLUMN parsed_data TEXT`);
	} catch (e) {
		// Column already exists, ignore
	}

	return db;
}

export function getDatabase() {
	return createDatabase();
}
