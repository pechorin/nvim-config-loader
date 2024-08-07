# NvimConfigLoader

> — Setup all your Vim with a single Lua table!

## Idea & Concept

There are many ways to set up your Vim. We have tried many of them, each with its own benefits. 
NvimConfigLoader is a new attempt at different approaches and combinations of some ideas and concepts:

- Lua for all configurations
- Let's configure all things with lua tables! (where possible)
- Simple Lua table api over vim calls like `vim.o`, `vim.g`, `vim.api.nvim_create_autocmd`, `vim.api.nvim_create_augroup`, `vim.keymap.set`
- Configure plugins list with lua tables also! (vim-plug supported currently only)
- Download and setup the plugin manager automatically 

## Additional features list

- Flat & grouped lists support for plugins, autocommands and keymaps (groups will help your organize your keymaps, autocommands and plugins)
- Load config with one base file, but it's okay to have some separate files for large configuration areas
- Combine configurations into packs (example: pack for tree-sitter can contain tree-sitter specific plugins list, autocommands and mappings) [alpha dashboard pack example](https://github.com/pechorin/nvim-config-loader/discussions/2#discussioncomment-10269362), [telescope pack example](https://github.com/pechorin/nvim-config-loader/discussions/2#discussioncomment-10269359)
- Configuration statistics to track and prevent missing configurations (e.g., forgetting to define any Vim options or keymaps)

## Installation

Run the bash script to download the `nvim-config-loader.lua` file to your home directory (`~/.vim/lua/`)

```bash
curl -fLo ~/.vim/lua/nvim-config-loader.lua --create-dirs \
  https://raw.githubusercontent.com/pechorin/nvim-config-loader/master/nvim-config-loader.lua;
```

## Loading sequence

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

## Usage & configuration structure

```lua

require('nvim-config-loader').setup({
  -- vim colorscheme
  colorscheme = 'default',

  -- vim background
  bg = 'light',

  -- vim-plug bundle install dir
  vim_plug_bundle_path  = '~/.vim/bundle',

  -- vim-plug bundle
  vim_plug_bundle = {
    'author/plugin1', -- flat plugin list
    'author/plugin2',
    { 'author/plugin3', branch = 'v2' }, -- plugin with vim plug options like branch/rtp/do
    group_name_1 = {  -- grouped plugin list
      'author/plugin2',
      'author/plugin3'
    }
  },

  -- Additional .vim / .lua files with custom code placed in vim home dir
  additional_config_files = {
    'completion.lua', -- ~/.vim/completion.lua
    'custom.vim'      -- ~/.vim/custom.vim
  },

  -- All global vim options (vim.opt.some_option)
  vim_options = {
    wildmenu    = true,
    tabstop     = 2,
    softtabstop = 2,
    cursorline  = true,
    -- ...
  },

  -- All vim global varitables (vim.g.variable or let g:variable)
  vim_globals = {
    mapleader = ',',              -- let mapleader =
    minimap_git_colors = true,    -- let g:minimap_git_colors =
    fzf_layout = { window = {} }, -- let g:fzf_layoyt = { "witdth":
    -- ...
  },

  -- Keymappings (flat or grouped list)
  -- format: { 'mode', 'key', 'command', options }
  keymaps = {
    -- flat keymaps
    { 'n', '<leader>l', ':MinimapToggle<CR>', { noremap = true }},
    { 'n', 'Q', '<Nop>', { desc = 'disable ex mode' }},

    -- grouped list
    navigation = { 
      { 'n', 'T', ':tabnew<CR>' },
      { 'n', 'Q', ':tabclose<CR>' },
    },
    -- ...
  },

  -- Vim autocomamnds (flat or grouped list)
  -- Format: { event = '', pattern = '', command = '' }
  autocommands = {
    -- flat list
    { event = { 'BufWritePre' }, pattern = '*', command = ":%s/\\s\\+$//e" },

    -- grouped list
    languages_settings = {
      -- pretty colymn hi for yaml modes
      { event = { 'FileType' }, pattern = 'yaml',       command = 'setlocal cursorcolumn' },
      { event = { 'FileType' }, pattern = 'eruby.yaml', command = 'setlocal cursorcolumn' },
    },
    -- ...
  },

  -- Each pack can contain a setup() function, autocommands, keymaps) - this is another level of configuration nesting
  packs = {
    -- pack structure example
    my_pack_1 = {
      autcommands = {},
      keymaps = {},
      vim_plug_bundle = {},
      setup = function() end
    },

    -- more real example, let's pack all tree-sitter settings!
    tree_sitter = {
      vim_plug_bundle = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-treesitter/playground',
      },
      setup = function(self)
        require('nvim-treesitter.configs').setup {
          ensure_installed = { 'ruby', 'bash', 'lua' },
          sync_install     = true,
          auto_install     = true,
          highlight        = { enable = true }
        }
      end
    }
  },

  -- show configuration stats on load
  show_stats = false,
})
```

## Examples

- [Configurations examples](https://github.com/pechorin/nvim-config-loader/discussions/1)
- [Packs examples](https://github.com/pechorin/nvim-config-loader/discussions/2)

## Plugin managers support

- [x] vim-plug auto downloading and installation
- [ ] vim-pack

## TODO

- [ ] predefine all vim options to provide autocompletion
- [ ] additional plugin managers
- [x] vimplug auto download & setup
