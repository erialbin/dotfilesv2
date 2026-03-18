return {
	"nvim-telescope/telescope.nvim",
	version = "*",
	-- or                              , branch = '0.1.x',
	dependencies = { "nvim-lua/plenary.nvim", { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
	config = function()
		require("telescope").setup({
			-- defualts = {
			--     file_ignore_patterns = {
			--         "%.git/",
			--         "%.venv",
			--         "vcpkg_installed/",
			--     },
			-- },
			-- pickers = {
			--     find_files = {
			--         hidden = true,
			--     },
			-- },
		}) -- basic setup

		require("telescope").load_extension("fzf")

		-- Plugin-specific keymaps
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Telescope find files" })
		vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Telescope find git files" })
		vim.keymap.set("n", "<leader>ps", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end, { desc = "Search files for str" })
	end,
}
