# TinyNvimLoader - one-table modern nvim configuration manager

### Install & update

Run bash script to download `tiny-nvim-loader.lua` and install to vim home directory:

```bash
curl -fLo ~/.vim/lua/tiny-nvim-loader.lua --create-dirs \
  https://raw.githubusercontent.com/pechorin/tiny-nvim-loader/master/tiny-nvim-loader.lua;
```

### Usage in your init.lua

```lua
require('tiny-nvim-loader'):setup {
  -- configuration here
}
```

TODO: add nvim home dir example

### Configuration structure

```lua
require('tiny-nvim-loader'):setup {
  colorscheme = 'default',
  bg          = 'light',


  vim_plug_bundle_path = '~/.vim/bundle',
  main_settings_files  = {
    -- additional .vim or .lua file configuration files
  }, -- TODO: rename

  use_rg   = true,
  use_zsh  = true,
  use_fzf  = true,

  use_lint = {
    file_pattern  = {},
    linters_by_ft = {}
  },

  use_treesitter = {
    languages = {}
  },

  -- TODO:
  use_lsp = {},

  start_dashboard = {
    title   = '',
    buttons = {}
  },

  keymaps = {
    group_name = {
      -- keymaps list
    }
  },
  autocommands = {
    group_name = {
      -- autocommands list
    }
  },

  vim_plug_bundle = {},

  vim_options = {},

  vim_globals = {},

  -- Custom setup for plugins
  setup = function()
  end,
}
```

# Loading sequence

TODO

# Examples

TODO
