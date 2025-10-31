return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"gri",
			"<cmd>Telescope lsp_implementations<cr>",
			desc = "Goto the implementation of the word under the cursor if there's only one, otherwise show all options in Telescope",
		},
		{
			"grr",
			"<cmd>Telescope lsp_references<cr>",
			desc = "Lists LSP references for word under the cursor",
		},
		{
			"grt",
			"<cmd>Telescope lsp_type_definitions<cr>",
			desc = "Goto the definition of the type of the word under the cursor, if there's only one, otherwise show all options in Telescope",
		},
		{
			"gO",
			"<cmd>Telescope lsp_document_symbols<cr>",
			desc = "Lists LSP document symbols in the current buffer",
		},
		{
			"gdd",
			"<cmd>Telescope lsp_definitions<cr>",
			desc = "Goto the definition of the type of the word under the cursor, if there's only one, otherwise show all options in Telescope",
		},
	},
	branch = "master",
}
