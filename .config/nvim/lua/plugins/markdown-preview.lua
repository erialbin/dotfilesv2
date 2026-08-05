return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	build = function()
		require("lazy").load({ plugins = { "markdown-preview.nvim" } })
		vim.fn["mkdp#util#install"]()
	end,
	config = function()
		-- the plugin only defines its :MarkdownPreview* commands from a
		-- BufEnter/FileType autocmd, which has already fired by the time lazy
		-- loads it on :MarkdownPreview. re-fire FileType so the current buffer
		-- actually gets the commands.
		vim.cmd([[do FileType]])
	end,
}
