-- If no file or directory is specified open nvim in cwd
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() == 0 then
			vim.cmd("edit .")
		end
	end,
})
