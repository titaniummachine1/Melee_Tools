import { API_BASE_URL } from '../config.js';

export function extractText(html) {
	return html
		.replace(/<script[\s\S]*?<\/script>/gi, '')
		.replace(/<style[\s\S]*?<\/style>/gi, '')
		.replace(/<[^>]+>/g, ' ')
		.replace(/&lt;/g, '<')
		.replace(/&gt;/g, '>')
		.replace(/&amp;/g, '&')
		.replace(/&quot;/g, '"')
		.replace(/&nbsp;/g, ' ')
		.replace(/\s+/g, ' ')
		.trim();
}

export function parseDocumentationPage(html, url) {
	const page = {
		url: url,
		title: '',
		content: '',
		links: [],
		functions: [],
		classes: [],
		libraries: [],
		examples: [],
		constants: []
	};

	// Extract title
	const titleMatch = html.match(/<title[^>]*>(.*?)<\/title>/i);
	if (titleMatch) {
		page.title = extractText(titleMatch[1]);
	}

	// Derive class/library from URL if present
	try {
		const urlObj = new URL(url);
		const path = urlObj.pathname.replace(/^\/+|\/+$/g, '');
		const segments = path.split('/');
		const last = segments[segments.length - 1] || segments[segments.length - 2] || '';
		if (path.toLowerCase().includes('lua_classes') && last) {
			page.classes.push(last.replace(/[^A-Za-z0-9_]/g, ''));
		}
		if (path.toLowerCase().includes('lua_libraries') && last) {
			page.libraries.push(last.replace(/[^A-Za-z0-9_]/g, ''));
		}
	} catch { }

	// Extract main content
	const contentMatch = html.match(/<(main|article|div[^>]*class="[^"]*content[^"]*")[^>]*>([\s\S]*?)<\/(main|article|div)>/i);
	if (contentMatch) {
		page.content = contentMatch[2];
	} else {
		const bodyMatch = html.match(/<body[^>]*>([\s\S]*?)<\/body>/i);
		if (bodyMatch) {
			page.content = bodyMatch[1];
		}
	}

	// Fallback: if content looks empty, use full HTML
	if (!page.content || page.content.length < 50) {
		page.content = html;
	}

	// Extract links (<a href>)
	const linkMatches = page.content.matchAll(/<a[^>]*href=["']([^"']+)["'][^>]*>(.*?)<\/a>/gi);
	for (const match of linkMatches) {
		let href = match[1];
		const linkText = extractText(match[2]);

		// Resolve relative URLs
		if (href.startsWith('/')) {
			href = new URL(href, API_BASE_URL).href;
		} else if (!href.startsWith('http')) {
			href = new URL(href, url).href;
		}

		// Only include internal links
		if (href.startsWith(API_BASE_URL)) {
			page.links.push({
				to_url: href,
				link_text: linkText,
				link_type: 'internal'
			});
		}
	}

	// Extract code blocks (examples)
	const codeMatches = page.content.matchAll(/<pre[^>]*><code[^>]*>([\s\S]*?)<\/code><\/pre>/gi);
	for (const match of codeMatches) {
		let code = match[1]
			.replace(/&lt;/g, '<')
			.replace(/&gt;/g, '>')
			.replace(/&amp;/g, '&')
			.replace(/&quot;/g, '"')
			.replace(/&nbsp;/g, ' ')
			.trim();

		if (code.match(/(function|local|callbacks|entities|client|draw|engine|print|if|then|end)/i)) {
			page.examples.push(code);
		}
	}

	// Extract headings
	const h2Matches = page.content.matchAll(/<h2[^>]*>(.*?)<\/h2>/gi);
	for (const match of h2Matches) {
		const heading = extractText(match[1]);
		if (heading && heading.length > 0 && heading.length < 100) {
			if (/^[a-z][a-z0-9_]*$/.test(heading)) {
				page.libraries.push(heading);
			} else if (/^[A-Z][a-zA-Z0-9]*$/.test(heading)) {
				page.classes.push(heading);
			}
		}
	}

	// Extract function signatures (h3 headings)
	const h3Matches = page.content.matchAll(/<h3[^>]*>(.*?)<\/h3>/gi);
	for (const match of h3Matches) {
		const heading = extractText(match[1]);
		// Accept headings with or without explicit params
		const funcMatch = heading.match(/^(\w+)\s*\(([^)]*)\)/) || heading.match(/^(\w+)\s*$/);
		if (funcMatch) {
			const funcName = funcMatch[1];
			const paramsStr = funcMatch[2] ? funcMatch[2].trim() : '';

			const params = [];
			if (paramsStr) {
				const paramPattern = /\[?(\w+):(\w+)\]?/g;
				let paramMatch;
				while ((paramMatch = paramPattern.exec(paramsStr)) !== null) {
					params.push({
						name: paramMatch[1],
						type: paramMatch[2]
					});
				}
			}

			page.functions.push({
				name: funcName,
				params: params,
				section: heading
			});
		}
	}

	// Fallback: if no functions parsed, scan full HTML for h3 headings
	if (page.functions.length === 0) {
		const h3All = html.matchAll(/<h3[^>]*>(.*?)<\/h3>/gi);
		for (const match of h3All) {
			const heading = extractText(match[1]);
			const funcMatch = heading.match(/^(\w+)\s*\(([^)]*)\)/) || heading.match(/^(\w+)\s*$/);
			if (funcMatch) {
				const funcName = funcMatch[1];
				const paramsStr = funcMatch[2] ? funcMatch[2].trim() : '';
				const params = [];
				if (paramsStr) {
					const paramPattern = /\[?(\w+):(\w+)\]?/g;
					let paramMatch;
					while ((paramMatch = paramPattern.exec(paramsStr)) !== null) {
						params.push({ name: paramMatch[1], type: paramMatch[2] });
					}
				}
				page.functions.push({ name: funcName, params, section: heading });
			}
		}
	}

	// Extract constants
	for (const example of page.examples) {
		const constMatches = example.matchAll(/([A-Z_][A-Z0-9_]*)\s*=\s*([^\n,;]+)/g);
		for (const match of constMatches) {
			page.constants.push({
				name: match[1],
				value: match[2].trim()
			});
		}
	}

	return page;
}
