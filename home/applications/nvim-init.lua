vim.loader.enable()
--- Basic config
local options = {
	number = true, -- show line numbers
	relativenumber = true, -- show the line number relative to the line with the cursor in front of each line
	cursorline = true, -- highlight the current line
	cmdheight = 2, -- number of screen lines to use for the command-line
	fileencoding = "utf-8", -- file-content encoding for the current buffer
	hlsearch = true, -- when there is a previous search pattern, highlight all its matches
	showmatch = true, -- when a bracket is inserted, briefly jump to the matching one
	termguicolors = true, -- enables 24-bit RGB color
	background = "dark", -- sets the backround to either 'dark' or 'light'
}

-- Treesitter config
require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
	},
	incremental_selection = {
		enable = true,
	},
	indent = {
		enable = true,
	},
})
