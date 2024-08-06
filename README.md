# NvimConfigLoader — one-lua-table nvim configuration loader and manager

## Idea & Concept

Where are many ways to setup your vim. We tried many of them. Each has own benefits.
NvimConfigLoader is evolution of different approaches and represent combination of ideas into one compact vim configuration loader.

Lets use lua only for configuration, but go further!

## Features list

- Use only lua tables and functions to define your vim config; no vim function calls required for basic configuration things like vim options, autocommands or keymaps
- Flat & grouped lists support for plugins, autocommands and keymaps (groups will help your organize your keymaps, autocommands and plugins)
- Load config with one base file (but its okay to have some separate files for big configuration areas)
- Don't warry about plugin manager installation, NvimConfigLoader will download and install `vim-plug` for you 
- Combine configurations into packs (example: pack for tree-sitter can contain tree-sitter specific plugins list, autocommands, mappings)
- Configuration statistics to track and prevent missing configurations (example: forget to define any vim options or keymap)

## Plugin managers support

- [x] vim-plug auto downloading and installation
- [ ] vim-pack

### Install & update

Run bash script to download `nvim-config-loader.lua` and install it to vim home directory:

TODO: Ъ nvim variant

```bash
curl -fLo ~/.vim/lua/nvim-config-loader.lua --create-dirs \
  https://raw.githubusercontent.com/pechorin/nvim-config-loader/master/nvim-config-loader.lua;
```

### Usage in your init.lua

```lua
require('nvim-config-loader').setup({
  -- configuration here
})
```

# Loading sequence

Running `require('nvim-config-loader').setup(config)` will:

```
1. store user settings from `config`
2. load and eval files from `additional_config_files`
3. init plugin manager and load plugins from user settings and user packs
4. load vim options
5. load vim globals
6. load keymaps
7. load autocommands
8. load colorscheme
9. run user `setup()`
10. run packs `setup()`
11. show stats if required
12. check health if required
```

TODO: add nvim home dir example

### Configuration structure

```lua
require('nvim-config-loader').setup({
  -- configuration here
})
```

# Example

### TODO

- [ ] predefine all vim options to provide autocompletion?
- [ ] comments
- [ ] packs list
- [ ] вариант загрузки с предустановленным dev pack'ом?
- [x] vimplug auto download & setup
