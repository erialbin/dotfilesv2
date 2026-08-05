local M = {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")

		ts.setup({}) -- only install_dir is configurable here

		local ensure = {
			"cpp",
			"python",
			"c",
			"lua",
			"vim",
			"vimdoc",
			"query",
			"markdown",
			"markdown_inline",
		}

		local installed = require("nvim-treesitter.config").get_installed("parsers")
		local missing = vim.tbl_filter(function(lang)
			return not vim.tbl_contains(installed, lang)
		end, ensure)
		if #missing > 0 then
			ts.install(missing)
		end

		-- highlighting is no longer a plugin option; start it per buffer
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
				if not lang then
					return
				end
				pcall(vim.treesitter.start, args.buf, lang)
			end,
		})
	end,
}
return { M }
