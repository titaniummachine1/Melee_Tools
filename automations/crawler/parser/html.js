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
	// Handle both <pre><code> and <div class="highlight"><pre><code> formats
	const codeMatches = page.content.matchAll(/(?:<div[^>]*class="[^"]*highlight[^"]*"[^>]*>)?<pre[^>]*><code[^>]*>([\s\S]*?)<\/code><\/pre>/gi);
	for (const match of codeMatches) {
		// Extract text content from nested HTML tags
		let code = match[1]
			// Remove line number anchors first
			.replace(/<a[^>]*>[\s\S]*?<\/a>/gi, '')
			// Extract text from span tags (preserve content, remove tags)
			.replace(/<span[^>]*>([\s\S]*?)<\/span>/gi, '$1')
			// Remove all remaining HTML tags
			.replace(/<[^>]+>/g, '')
			// Decode HTML entities
			.replace(/&lt;/g, '<')
			.replace(/&gt;/g, '>')
			.replace(/&amp;/g, '&')
			.replace(/&quot;/g, '"')
			.replace(/&nbsp;/g, ' ')
			// Clean up whitespace
			.replace(/\n\s*\n/g, '\n')
			.trim();

		if (code && code.length > 0 && code.match(/(function|local|callbacks|entities|client|draw|engine|print|if|then|end|aimbot|GetByIndex|targetID|target)/i)) {
			page.examples.push(code);
		}
	}

	// Extract class/library description from h1
	// Try with id first, then without
	let h1Match = html.match(/<h1[^>]*id="[^"]*"[^>]*>([\s\S]*?)<\/h1>/i);
	if (!h1Match) {
		h1Match = html.match(/<h1[^>]*>([\s\S]*?)<\/h1>/i);
	}
	if (h1Match) {
		const h1End = h1Match.index + h1Match[0].length;
		const afterH1 = html.slice(h1End, h1End + 500);
		const descMatch = afterH1.match(/<p[^>]*>([\s\S]*?)<\/p>/i);
		if (descMatch) {
			page.description = extractText(descMatch[1]).trim();
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

	// Extract function signatures
	// h2 can be constructors (like "Vector3( x, y, z )") or section headers (like "Fields", "Methods")
	// h3/h4 are usually functions
	const headingPatterns = [
		/<h2[^>]*>(.*?)<\/h2>/gi,
		/<h3[^>]*>(.*?)<\/h3>/gi,
		/<h4[^>]*>(.*?)<\/h4>/gi
	];

	function tryExtractFunctions(sourceMatches) {
		// Skip common section headings that aren't functions
		const skipHeadings = new Set(['Functions', 'Examples', 'Methods', 'Fields']);

		for (const match of sourceMatches) {
			const heading = extractText(match[1]);
			// Only match if it looks like a function signature (has parentheses) or is a single word
			const funcMatch = heading.match(/^(\w+)\s*\(([^)]*)\)/) || heading.match(/^(\w+)\s*$/);
			if (funcMatch) {
				const funcName = funcMatch[1];
				const hasParams = funcMatch[2] !== undefined;

				// Skip section headings (only if they don't have parentheses - constructors have params)
				if (!hasParams && skipHeadings.has(funcName)) continue;

				const paramsStr = funcMatch[2] ? funcMatch[2].trim() : '';

				const params = [];
				if (paramsStr) {
					const paramPattern = /\[?(\w+):(\w+)\]?/g;
					let paramMatch;
					while ((paramMatch = paramPattern.exec(paramsStr)) !== null) {
						// Support both name:type and Type:name forms
						const left = paramMatch[1];
						const right = paramMatch[2];
						const isTypeFirst = /^[A-Z]/.test(left) && (right === '' || /^[a-z]/.test(right));
						const name = isTypeFirst ? (right || 'param') : left;
						const type = isTypeFirst ? left : (right || 'any');
						params.push({ name, type });
					}
				}

				// Extract description: find the next <p> tag after this heading in the full HTML
				// Only extract if this is a real function (has params or is h3/h4, not a section header)
				let description = '';
				if (hasParams || match[0].includes('<h3') || match[0].includes('<h4')) {
					const headingEnd = match.index + match[0].length;
					const afterHeading = html.slice(headingEnd, headingEnd + 500);
					const pMatch = afterHeading.match(/<p[^>]*>([\s\S]*?)<\/p>/i);
					if (pMatch) {
						description = extractText(pMatch[1]).trim();
						// Skip if description is just a type name (like "number", "string")
						if (description.length > 1 && !/^(number|string|boolean|table|Vector3|Entity|nil|any)$/i.test(description)) {
							// Limit description length
							if (description.length > 300) {
								description = description.slice(0, 297) + '...';
							}
						} else {
							description = '';
						}
					}
				}

				page.functions.push({
					name: funcName,
					params: params,
					section: heading,
					description: description
				});
			}
		}
	}

	for (const pattern of headingPatterns) {
		const matches = page.content.matchAll(pattern);
		tryExtractFunctions(matches);
	}

	// Fallback: scan full HTML headings if still empty (only h3/h4, not h2)
	if (page.functions.length === 0) {
		const fallbackPatterns = [
			/<h3[^>]*>(.*?)<\/h3>/gi,
			/<h4[^>]*>(.*?)<\/h4>/gi
		];
		for (const pattern of fallbackPatterns) {
			const matches = html.matchAll(pattern);
			tryExtractFunctions(matches);
		}
	}

	// Additional fallback: code tags that look like signatures
	if (page.functions.length === 0) {
		const codeMatches = page.content.matchAll(/<code[^>]*>(.*?)<\/code>/gi);
		for (const match of codeMatches) {
			const text = extractText(match[1]);
			const funcMatch = text.match(/^(\w+)\s*\(([^)]*)\)/);
			if (funcMatch) {
				const funcName = funcMatch[1];
				const paramsStr = funcMatch[2] ? funcMatch[2].trim() : '';
				const params = [];
				if (paramsStr) {
					const paramPattern = /\[?(\w+):(\w+)\]?/g;
					let paramMatch;
					while ((paramMatch = paramPattern.exec(paramsStr)) !== null) {
						const left = paramMatch[1];
						const right = paramMatch[2];
						const isTypeFirst = /^[A-Z]/.test(left) && (right === '' || /^[a-z]/.test(right));
						const name = isTypeFirst ? (right || 'param') : left;
						const type = isTypeFirst ? left : (right || 'any');
						params.push({ name, type });
					}
				}
				page.functions.push({ name: funcName, params, section: text });
			}
		}
	}

	// Special handling for callbacks page: rebuild functions from h3 headings
	if (url.toLowerCase().includes('lua_callbacks')) {
		const cbFuncs = [];
		const h3All = html.matchAll(/<h3[^>]*>(.*?)<\/h3>/gi);
		for (const match of h3All) {
			const headingRaw = extractText(match[1]);
			const fm = headingRaw.match(/^(\w+)\s*\(([^)]*)\)/) || headingRaw.match(/^(\w+)\s*$/);
			if (!fm) continue;
			const name = fm[1];
			const paramsStr = fm[2] ? fm[2].trim() : '';
			const params = [];
			if (paramsStr) {
				const parts = paramsStr.split(',').map(p => p.trim()).filter(Boolean);
				for (const part of parts) {
					// Handle generic-style params like "Table< TempEntity, EventInfo > entEvtTable"
					const genericMatch = part.match(/^(.+)\s+([A-Za-z_][A-Za-z0-9_]*)$/);
					if (!part.includes(':') && genericMatch) {
						const rawType = genericMatch[1].replace(/\s+/g, '');
						const cleanType = rawType.replace(/^Table</, 'table<');
						const pName = genericMatch[2];
						params.push({ name: pName, type: cleanType });
						continue;
					}

					const pm = part.match(/^([^:]+):(.+)$/);
					if (pm) {
						const tLeft = pm[1].trim();
						const tRight = pm[2].trim();
						const isTypeFirst = /^[A-Z]/.test(tLeft) && (tRight === '' || /^[a-z]/.test(tRight));
						const pName = isTypeFirst ? (tRight || 'param') : tLeft;
						const pType = isTypeFirst ? tLeft : (tRight || 'any');
						params.push({ name: pName, type: pType });
					} else {
						params.push({ name: part || 'param', type: 'any' });
					}
				}
			}

			// Extract description for callback
			let description = '';
			const headingEnd = match.index + match[0].length;
			const afterHeading = page.content.slice(headingEnd, headingEnd + 500);
			const pMatch = afterHeading.match(/<p[^>]*>([\s\S]*?)<\/p>/i);
			if (pMatch) {
				description = extractText(pMatch[1]).trim();
				if (description.length > 200) {
					description = description.slice(0, 197) + '...';
				}
			}

			cbFuncs.push({ name, params, section: headingRaw, description });
		}
		if (cbFuncs.length > 0) {
			page.functions = cbFuncs;
			page.classes = [];
			page.libraries = [];
		}
	}

	// Special handling for constants page: prioritize table extraction
	if (url.toLowerCase().includes('lua_constants')) {
		// Clear any constants extracted from other methods first
		page.constants = [];
	}

	// Extract constants from HTML tables (for constants page)
	const tableMatches = page.content.matchAll(/<table[^>]*>([\s\S]*?)<\/table>/gi);
	for (const tableMatch of tableMatches) {
		const tableContent = tableMatch[1];

		// Extract table rows (skip the header row)
		const rowRegex = /<tr[^>]*>([\s\S]*?)<\/tr>/gi;
		let rowMatch;
		let isFirstRow = true;

		while ((rowMatch = rowRegex.exec(tableContent)) !== null) {
			// Skip header row
			if (isFirstRow) {
				isFirstRow = false;
				continue;
			}

			const rowContent = rowMatch[1];

			// Extract table cells
			const cellRegex = /<td[^>]*>([\s\S]*?)<\/td>/gi;
			const cells = [];
			let cellMatch;

			while ((cellMatch = cellRegex.exec(rowContent)) !== null) {
				let cellText = cellMatch[1]
					.replace(/<[^>]+>/g, '')
					.replace(/&lt;/g, '<')
					.replace(/&gt;/g, '>')
					.replace(/&amp;/g, '&')
					.replace(/&quot;/g, '"')
					.replace(/&nbsp;/g, ' ')
					.replace(/\s+/g, ' ')
					.trim();
				cells.push(cellText);
			}

			// First cell is name, second cell is value
			if (cells.length >= 2) {
				const name = cells[0].trim();
				let value = cells[1].trim();

				// Clean up the value - handle HTML entities and expressions
				value = value
					.replace(/&lt;/g, '<')
					.replace(/&gt;/g, '>')
					.replace(/&amp;/g, '&');

				// Only add if name looks like a constant (uppercase with underscores)
				if (name && /^[A-Z_][A-Z0-9_]*$/.test(name)) {
					page.constants.push({ name, value });
				}
			}
		}
	}

	// Extract constants from code examples (fallback - only for non-constants pages)
	// Constants page uses table parsing above, so skip this for constants page
	if (!url.toLowerCase().includes('lua_constants')) {
		for (const example of page.examples) {
			const constMatches = example.matchAll(/([A-Z_][A-Z0-9_]*)\s*=\s*([^\n,;]+)/g);
			for (const match of constMatches) {
				// Only extract if it looks like a real constant definition (has a value)
				const name = match[1];
				const value = match[2].trim();
				// Skip if value is just whitespace or common false positives
				if (value && value !== 'nil' && !value.match(/^(API|HTTP|SVG|XML|HTML)/i)) {
					page.constants.push({
						name: name,
						value: value
					});
				}
			}
		}
	}

	// Deduplicate constants
	const seenConst = new Set();
	page.constants = page.constants.filter(c => {
		if (seenConst.has(c.name)) return false;
		seenConst.add(c.name);
		return true;
	});

	return page;
}
