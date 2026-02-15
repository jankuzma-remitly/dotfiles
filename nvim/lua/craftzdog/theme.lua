local M = {}

local themes = { "solarized-osaka", "catppuccin" }
local current_index = 1

function M.toggle()
	current_index = current_index % #themes + 1
	local theme = themes[current_index]
	vim.cmd("colorscheme " .. theme)
	vim.notify("Switched to " .. theme, vim.log.levels.INFO)
end

function M.set(theme_name)
	vim.cmd("colorscheme " .. theme_name)
	vim.notify("Switched to " .. theme_name, vim.log.levels.INFO)
end

return M
