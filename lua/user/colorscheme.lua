vim.cmd [[
try
  colorscheme darkplus
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]

-- Color globals
vim.g.is_dark_mode = true
-- local vim.g.current_colorscheme = 'tokyonight'
vim.g.dark_scheme = 'gruvbox'
vim.g.lite_scheme = 'tokyonight'
vim.g.current_colorscheme = lite_scheme

if is_dark_mode then
  vim.g.current_colorscheme = dark_scheme
end

function _G.DarkModeSet()
  is_dark_mode = true
  vim.o.background = 'light'
  vim.g.current_colorscheme = dark_scheme
  -- Add other settings here for dark mode
  -- Now safely call colorscheme
  local status_ok, _ = pcall(vim.cmd, 'colorscheme ' .. vim.g.current_colorscheme)
  if not status_ok then
    print('Error during colorscheme ' .. vim.g.current_colorscheme .. ' call')
  end
end
vim.cmd([[command! DarkModeSet lua DarkModeSet()]])

function _G.DarkModeUnset()
  is_dark_mode = false
  vim.o.background = 'light'
  vim.g.current_colorscheme = light_scheme
  -- Add other settings here for dark mode
  -- Now safely call colorscheme
  local status_ok, _ = pcall(vim.cmd, 'colorscheme ' .. vim.g.current_colorscheme)
  if not status_ok then
    print('Error during colorscheme ' .. vim.g.current_colorscheme .. ' call')
  end
end
vim.cmd([[command! DarkModeUnset lua DarkModeUnset()]])

function _G.DarkModeToggle()
  if is_dark_mode then
    DarkModeUnset()
  else
    DarkModeSet()
  end
end
vim.cmd([[command! DarkModeToggle lua DarkModeToggle()]])



-- Tokyonight
vim.g.tokyonight_style = 'day' -- 'day', 'night', 'storm' (med dark)
-- FIXME: Something about the appearance of tokyonight is off
-- Tokyonight seems like a good colorscheme to use for light mode
-- function DarkModeSet() {
--   vim.g.tokyonight.style = 'night'
-- }

-- Gruvbox

-- local status_ok, _ = pcall(vim.cmd, 'colorscheme ' .. g:current_colorscheme)
local status_ok, _ = pcall(vim.cmd, 'colorscheme gruvbox')


