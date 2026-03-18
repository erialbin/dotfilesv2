return {
	"tpope/vim-fugitive",
	cmd = { "Git", "G", "Gdiffsplit", "Gwrite", "Gread", "Glog" },
	keys = {
		{ "<leader>gs", "<cmd>Git<CR>", desc = "Git status" },
		{ "<leader>gd", "<cmd>Gdiffsplit<CR>", desc = "Git diff" },
		{ "<leader>gb", "<cmd>Git blame<CR>", desc = "Git blame" },
		{ "<leader>gl", "<cmd>Git log<CR>", desc = "Git log" },
		{
			"<leader>gc",
			function()
				vim.ui.input({ prompt = "Commit Message: " }, function(msg)
					if not msg or msg == "" then
						return
					end
					vim.cmd('Git commit -m "' .. msg .. '"')
				end)
			end,
			desc = "Git Commit -m",
		},
	},
}
