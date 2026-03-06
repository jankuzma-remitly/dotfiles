local M = {}

M.base46 = {
	theme = "onedark",
	transparency = false,
	theme_toggle = { "onedark", "one_light" },
}

M.ui = {
	statusline = { enabled = false },
	tabufline = { enabled = false },
}

M.nvdash = { load_on_startup = false }
M.lsp = { signature = false }
M.colorify = { enabled = false }

return M
