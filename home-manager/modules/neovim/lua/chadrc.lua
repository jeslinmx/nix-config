-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {
	base46 = { theme = "catppuccin", transparency = true },
	ui = {
		cmp = {
			style = "atom",
			icons_left = true,
			format_colors = { tailwind = true },
		},
		telescope = { style = "bordered" },
		statusline = { theme = "vscode_colored", enabled = true },
		tabufline = { enabled = true }
	},
	term = { winopts = { number = true }, sizes = { vsp = 0.5 } },
}

return M
