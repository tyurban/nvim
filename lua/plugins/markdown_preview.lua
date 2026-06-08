return {
	"iamcco/markdown-preview.nvim",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	build = "cd app && npm install",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
}
