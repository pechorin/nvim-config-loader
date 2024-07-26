# TODO: <name> - one-table modern nvim configuration loader / initializer

## Features

- Complete nvim configuration with one lua table
- vim-plug support out of the box (auto downloading and installation)

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

# Example

### TODO

- [ ] comments
- [ ] vimplug auto download & setup https://github.com/junegunn/vim-plug/wiki/tips
- [ ] checkhealth with main settings detection
- [ ] store saved settings status
- [*] add flat lists loading (without grouping)
- [ ] vim-plug setup() function per plugin support (https://dev.to/vonheikemen/neovim-using-vim-plug-in-lua-3oom)
- [ ] example folder
