-- My fork of https://github.com/LunarVim/Neovim-from-scratch
-- Meant to eventually become my completely rewritten neovim config
-- Took too long to rewrite everything myself while learning lua + neovim v0.6
-- Will be merged into my https://github.com/marcus-grant/dots-neovim
-- Forked by marcus-grant to marcus-grant/Neovim-from-scratch
-- forked at 2022-01-09

-- The list of in-order lazy loaded modules
require "user.options"
require "user.keymaps"
require "user.plugins"
require "user.colorscheme"
require "user.cmp"
require "user.lsp"
require "user.telescope"
require "user.treesitter"
require "user.autopairs"
require "user.comment"
require "user.gitsigns"
require "user.nvim-tree"
require "user.bufferline"
require "user.lualine"
require "user.toggleterm"
require "user.project"
require "user.impatient"
require "user.indentline"
require "user.alpha"
require "user.whichkey"
require "user.autocommands"
