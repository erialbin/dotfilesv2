return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		lazy = false, -- neo-tree will lazily load itself
		config = function()
			require("neo-tree").setup({
				close_if_last_window = true,
				window = {
					mappings = {
						["P"] = {
							"toggle_preview",
							config = {
								use_float = false,
							},
						},
					},
				},
				event_handlers = {

					{
						event = "file_open_requested",
						handler = function()
							-- auto close
							-- vim.cmd("Neotree close")
							-- OR
							require("neo-tree.command").execute({ action = "close" })
						end,
					},
				},
			})
		end,
	},
}
