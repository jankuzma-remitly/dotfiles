if vim.loader then
	vim.loader.enable()
end

vim.env.NPM_CONFIG_REGISTRY = "https://registry.npmjs.org/"

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.augment_workspace_folders = { "~/projects/narwhal", "~/.config/*" }
vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"

_G.dd = function(...)
	require("util.debug").dump(...)
end
vim.print = _G.dd

require("config.lazy")

if vim.uv.fs_stat(vim.g.base46_cache) then
	for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
		dofile(vim.g.base46_cache .. v)
	end
end

-- Setup project-wide diagnostics
require("config.project-diagnostics").setup()
