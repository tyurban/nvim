return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets" },
	opts = {
		sources = {
			default = { "lazydev", "lsp", "path", "snippets", "buffer" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
			},
		},
		signature = {
			enabled = true,
		},
	},
	version = "1.*",
}
