# NvimConfigLoader - one-table modern nvim configuration loader / initializer

TODO: logic map

## Idea & Concept

Where are many ways to setup your vim. We tried many of them. Each has own benefits.
NvimConfigLoader is evolution of different approaches and represent combination of ideas into one compact vim configuration loader.

Lets use lua only for configuration, but go further!

## Features list

- Use only lua tables and functions, no special vim function calls for basic configuration like vim options, autocommands or keymaps
- Flat & grouped lists support for plugins, autocommands and keymaps
- Load config with one base file (but its okay to have some separate files for big configuration areas)
- Combine configurations into packs (for example, pack for tree-sitter will contain tree-sitter specific plugins list, autocommands, mappings)
- Dont warry about plugin managers, NvimConfigLoader should install and configure it for you
- Configuration statistics (how many options, keymaps, plugins was defined) to track and prevent missing configurations

## Plugin managers support

- [x] vim-plug auto downloading and installation
- [ ] vim-pack

### Install & update

Run bash script to download `tiny-nvim-loader.lua` and install it to vim home directory:

```bash
curl -fLo ~/.vim/lua/tiny-nvim-loader.lua --create-dirs \
  https://raw.githubusercontent.com/pechorin/tiny-nvim-loader/master/tiny-nvim-loader.lua;
```

### Usage in your init.lua

```lua
require('nvim-config-loader').setup({
  -- configuration here
})
```

TODO: add nvim home dir example

### Configuration structure

```lua
require('nvim-config-loader').setup({
  -- configuration here
})
```

# Loading sequence

```
-> require('nvim-config-loader').setup(config)
    1. save user defined settings from defined config
    2. load configs from additional_config_files
    3. init plugin manager and load plugins from user settings and packs
    4. load vim options
    5. load vim globals
    6. load keymaps
    7. load autocommands
    8. load colorscheme
    9. run user setup()
    10. run packs setup()
    11. show stats if required
    12 check health if required
```

# Example

### TODO

- [ ] predefine all vim options to provide autocompletion?
- [ ] comments
- [ ] packs list
- [ ] вариант загрузки с предустановленным dev pack'ом?
- [x] vimplug auto download & setup
