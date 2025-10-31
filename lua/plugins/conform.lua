return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
		},
	},
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
			end,
			mode = { "n", "x" },
			desc = "Format the current buffer",
		},
	},
}
