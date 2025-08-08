-- install with: npm i -g vscode-langservers-extracted

return {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
	embeddedLanguages = { css = true, javascript = true },
}
