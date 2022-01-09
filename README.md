# Neovim from scratch

**Note** this was taken from [LunarVim/Neovim-from-scratch](https://github.com/LunarVim/Neovim-from-scratch)

I *[marcus-grant](https://github.com/marcus-grant)* will be creating my own neovim build from [this](https://github.com/LunarVim/Neovim-from-scratch) from scratch tutorial repository because trying to learn everything from scratch using LUA and the neovim v0.6+ API took way too long and I need a more useable neovim configuration faster than that.

## Keymaps

I removed only the `move text` keymaps from the scratch repo. I need the alt modifier for my terminal work and I don't find those commands particularly useful.

## Plugins

Everything should be configured for plugins inside of `lua/user/plugins.lua`. Let's explain a few of the features of the configuration file for clarity.

```lua
-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end
```

This will check if the `packer.nvim` file containing the entrypoint for the packer plugin manager is present on the local system. If not it will use `git` to clone in the file to `~/.local/share/nvim/site..`. A subdirectory in there is also where all plugins will get installed which is nice because it should seperate the plugins from this git controlled dotfiles repository.

```lua
-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]
```

This Autocommand will look for the `plugins.lua` file and if it ever gets changed, it will call `PackerSync` to synchronize locally installed plugins with the plugins listed in `lua/user/plugins.lua` under the `use` keyword.
```lua
-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end
```

This is a **protected call** which is a very useful pattern for lua-based configurations because it allows calling a function like `require` without causing any halting errors during the configuration using funciton `pcall`. It gets used to call the `packer` function to protect against any potential errors it creates.

```lua
-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}
```

In future parts of the README, this portion above will show the float window usage shown here. Basically this tells packer to run within a buffer using a popup window. This is nice due to the modal nature of all `packer` operations.

```lua
-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins

  -- ... other plugins ...

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
```

Most of the work done in this module will be done inside the above block of code around `other plugins` listed in the comments. Basically just use the `use` keyword with a github repository string pointing to the plugin in question. Those first three plugins are a pretty useful set of base functions and utilities to configure neovim more broadly. *Tons* of plugins make use of  `popup` & `plenary`.

When `packer` downloads plugins they all end up in `~/.local/share/nvim/site/pack/packer`. Now if you look in this directory, you'll see a `opt` & `start` directory. `start` gets used to load plugins directly at start of neovim. `opt` will get used to lazy load plugins

### Lazy Loading

There's *excruciating detail* on how to `use` plugins with `packer` over on their [repository](https://github.com/wbthomason/packer.nvim). The `opt` directory inside the packer plugins path is where all `opt`tional plugins go.

```lua
 -- Lazy loading:
  -- Load on specific commands
  use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}

  -- Load on an autocommand event
  use {'andymass/vim-matchup', event = 'VimEnter'}

  -- Load on a combination of conditions: specific filetypes or commands
  -- Also run code after load (see the "config" key)
  use {
    'w0rp/ale',
    ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
    cmd = 'ALEEnable',
    config = 'vim.cmd[[ALEEnable]]'
  }
```

In the above snippet you how this is specified using the `opt = true` dictionary pair inside the `use` dictionary. Typically an event will be specified that triggers the lazy loading of the plugin's modules. This is specified with the `cmd = {'Command1', 'Command2'}` dictionary pair.

### Post Install

Post install scripts can also be run for plugins that require for example running `yarn install` for node based plugins. This can be true for any other build system.

```lua
-- Plugins can have post-install/update hooks
  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}
```

Just use the `run` property like above and provide a string representing a command to run post install. This is still lazy loading because this `run` command will only be run when the vim command `MarkdownPreview` is run, as specified by the `cmd` property.

**TODO** Create a nice table in this README to show all keymaps.

## Color Schemes



## End of My User Customizations

The README below here is all taken from LunarVim's README

Each video will be associated with a branch so checkout the one you are interested in, you can follow along with this [playlist](https://www.youtube.com/watch?v=ctH-a-1eUME&list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ).

## Try out this config

Make sure to remove or move your current `nvim` directory

**IMPORTANT** Requires [Neovim v0.6.0](https://github.com/neovim/neovim/releases/tag/v0.6.0) or [Nightly](https://github.com/neovim/neovim/releases/tag/nightly). 
```
git clone https://github.com/LunarVim/Neovim-from-scratch.git ~/.config/nvim
```

Run `nvim` and wait for the plugins to be installed 

**NOTE** (You will notice treesitter pulling in a bunch of parsers the next time you open Neovim) 

## Get healthy

Open `nvim` and enter the following:

```
:checkhealth
```

You'll probably notice you don't have support for copy/paste also that python and node haven't been setup

So let's fix that

First we'll fix copy/paste

- On mac `pbcopy` should be builtin

- On Ubuntu

  ```
  sudo apt install xsel
  ```

- On Arch Linux

  ```
  sudo pacman -S xsel
  ```

Next we need to install python support (node is optional)

- Neovim python support

  ```
  pip install pynvim
  ```

- Neovim node support

  ```
  npm i -g neovim
  ```
---

**NOTE** make sure you have [node](https://nodejs.org/en/) installed, I recommend a node manager like [fnm](https://github.com/Schniz/fnm).

> The computing scientist's main challenge is not to get confused by the complexities of his own making. 

\- Edsger W. Dijkstra
