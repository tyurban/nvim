return {
	"mikavilpas/yazi.nvim",
	dependencies = {
		{
			"nvim-lua/plenary.nvim",
			lazy = true,
		},
		{
			"nvim-telescope/telescope.nvim",
			lazy = true,
		},
		{
			"folke/snacks.nvim",
			opts = {},
			priority = 1000,
			lazy = false,
		},
		{
			"MagicDuck/grug-far.nvim",
			dependencies = {
				{
					"nvim-mini/mini.icons",
					version = false,
				},
			},
			opts = {},
		},
	},
	init = function()
		vim.g.loaded_netrwPlugin = 1
	end,
	opts = {
		open_for_directories = true,
		keymaps = {
			show_help = "<f1>",
		},
	},
	event = "VeryLazy",
	keys = {
		{
			"<leader>-",
			mode = { "n", "v" },
			"<cmd>Yazi<cr>",
			desc = "Open Yazi at the current file",
		},
		{
			"<leader>cw",
			"<cmd>Yazi cwd<cr>",
			desc = "Open Yazi in nvim's working directory",
		},
		{
			"<c-up>",
			"<cmd>Yazi toggle<cr>",
			desc = "Resume the last Yazi session",
		},
	},
	version = "*",
}
