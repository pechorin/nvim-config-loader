# TODO: <name> - one-table modern nvim configuration loader / initializer

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

```lua
require('tiny-nvim-loader'):setup {
  colorscheme = 'adwaita',
  bg          = 'light',

  vim_plug_bundle_path = '~/.vim/bundle',

  main_settings_files  = {
    'lsp.lua',
    'completion.lua',
  },

  use_rg   = true,
  use_zsh  = true,
  use_fzf  = true,

  use_lint = {
    file_pattern  = {"*.rb", "*.erb", "*.haml", "*.slim"},
    linters_by_ft = {
      ruby = {'rubocop'}
    }
  },

  use_treesitter = {
    languages = {
      "ruby",
      "bash",
      "lua",
      "c", "cpp",
      "go", "gomod",
      "rust",
      "css", "html", "javascript", "json", "typescript", "vue",
      "python",
      "embedded_template",
      "sql",
      "regex",
      "vim", "vimdoc"
    }
  },

  -- TODO:
  use_lsp = {
  },

  start_dashboard = {
    title = 'Hello world!',
    buttons = {
      {"e", " > New File", "<cmd>ene<CR>"},
      {"n", " > Toggle file explorer", "<cmd>Neotree<CR>"},
      {"f", " > Find File", "<cmd>Telescope find_files<CR>"},
      {"F", " > Find Word", "<cmd>Telescope live_grep<CR>"},
      {"m", " > Keymaps", "<cmd>Telescope keymaps<CR>"},
      {"g", " > Git status", "<cmd>Git<CR>"},
      {"u", " > Update plugins", "<cmd>PlugUpdate<CR>"},
      {"H", " > Edit .vimrc", "<cmd>e ~/.vimrc<CR>"},
      {"c", " > Change colorscheme", "<cmd>Telescope themes<CR>"},
    }
  },

  keymaps = {
    general = {
      -- search plugin
      { 'n', '<Leader>gS', ":lua require('search').open()<CR>", { desc = "Run search window", noremap = true }},

      -- " from: https://vim.fandom.com/wiki/Search_for_visually_selected_text
      { 'v', '//', "y/V<C-R>=escape(@\",'/\')<CR><CR>", { desc = "Search visual selected text via //", noremap = true }},

      -- " Minimap
      { 'n', '<leader>l', ':MinimapToggle<CR>', { desc = "Toggle minimap"}},
    },
    neotree = {
      -- Neotree
      { 'n', '<leader>m', ':Neotree<CR>', { desc = "Neotree" }},
      { 'n', '<leader>M', ':Neotree %<CR>', { desc = "Neotree for current file" }},
      { 'n', '<leader>,', ':Neotree buffers<CR>', { desc = "Neotree buffers" }},
      { 'n', '<leader>.', ':Neotree float git_status<CR>', { desc = "Neotree git" }},
    },
    commenting = {
      { 'n', '<leader>c', '<Plug>CommentaryLine', { desc = "Comment current line" }},
      { 'v', '<leader>c', '<Plug>Commentary', { desc = "Comment visualy selected text" }},
    },
    fzf = {
      { 'n', '<leader>b', ':Buffers<CR>', { desc = "fzf Buffers"}},
      { 'n', '<leader>q', ':Files<CR>', { desc = "fzf Project files"}},
    },
    git = {
      { 'n', '<leader>gg', ':tab Git<CR>', { desc = "Open Git in new tab"}},
      { 'n', '<leader>gG', ':Git<CR>', { desc = "Open Git in split"}},
      { 'n', '<leader>gb', ':Git blame<CR>', { desc = "Git blame for file"}},
    },
    neotest_runners = {
      { 'n', '<leader>rf', ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>', { noremap = true, desc = "Neotest file", silent = true }},
      { 'n', '<leader>rn', ':lua require("neotest").run.run()<CR>', { noremap = true, desc = "Neotest nearest test suite", silent = true}},
      { 'n', '<leader>rs', ':lua require("neotest").run.stop()<CR>', { noremap = true, desc = "Neotest stop nearest test suite", silent = true}},
      { 'n', '<leader>ra', ':lua require("neotest").run.attach()<CR>', { noremap = true, desc = "Neotest attach to nearest test suite", silent = true}},
      { 'n', '<leader>rw', ':lua require("neotest").watch.toggle(vim.fn.expand("%"))<CR>', { noremap = true, desc = "Neotest watch current file", silent = true}},
      { 'n', '<leader>ro', ':lua require("neotest").output.toggle({ enter = true })<CR>', { noremap = true, desc = "Neotest toggle output panel", silent = true}},
    },
    telescope = {
      { 'n', '<leader>gT', '<cmd>Telescope<cr>',             { noremap = true, desc = "Telescope" }},
      { 'n', '<leader>gf', '<cmd>Telescope find_files<cr>',  { noremap = true, desc = "Files" }},
      { 'n', '<leader>gb', '<cmd>Telescope buffers<cr>',     { noremap = true, desc = "Buffers" }},
      { 'n', '<leader>gl', '<cmd>Telescope oldfiles<cr>',    { noremap = true, desc = "Old files" }},
      { 'n', '<leader>gc', '<cmd>Telescope themes<cr>',      { noremap = true, desc = "Themes" }},
      { 'n', '<leader>gk', '<cmd>Telescope keymaps<cr>',     { noremap = true, desc = "Keys" }},
      { 'n', '<leader>gh', '<cmd>Telescope git_commits<cr>', { noremap = true, desc = "Git commits" }},
      { 'n', '<leader>gs', '<cmd>Telescope git_status<cr>',  { noremap = true, desc = "Git status" }},
      { 'n', '<leader>gr', '<cmd>Telescope registers<cr>',   { noremap = true, desc = "Keys" }},
      { 'n', '<leader>gd', '<cmd>Telescope diagnostics<cr>', { noremap = true, desc = "Keys" }},
    },
  },

  autocommands = {
    language_detection = {
      { event = { 'BufNewFile' , 'BufRead' }, pattern = '*.yml.j2', command = 'set filetype=yaml' },
    },
    languages_settings = {
      -- pretty colymn hi for yaml modes
      { event = { 'FileType' }, pattern = 'yaml',       command = 'setlocal cursorcolumn' },

      -- js with 2 tabs
      { event = { 'FileType' }, pattern = 'javascript', command = 'setlocal sw=2 sw=2 sts=2' },
    },
    reload_buffer_if_file_changed = {
      {
        pattern = '*',
        command = 'checktime',
        event = {
          'BufEnter', 'WinLeave', 'CursorHold', 'CursorHoldI', 'CursorMoved', 'CursorMovedI', 'FocusGained', 'FocusLost'
        }
      },
    },
    auto_remove_trailing_whitespaces = {
      { event = { 'BufWritePre' }, pattern = '*', command = ":%s/\\s\\+$//e" },
    },
  },

  vim_plug_bundle = {
    {
      group = 'General toolkits',
      plugins = {
        { 'ray-x/guihua.lua', { ['do'] = 'cd lua/fzy && make' }},
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        'tpope/vim-commentary',
        'windwp/nvim-autopairs', -- " Auto close quotes and other pairs
        'kylechui/nvim-surround', -- " Change surrodings on fly
        'folke/which-key.nvim', -- " Display key definitions in cool menu
        'simeji/winresizer', -- " Resize windows with ctrl+e
        'AndrewRadev/linediff.vim', -- " Diff between lines
      }
    },
    {
      group = 'snippets',
      {
        { 'L3MON4D3/LuaSnip', { tag = 'v2.*', ['do'] = 'make install_jsregexp'}}, -- " Snippets
        'rafamadriz/friendly-snippets',
      }
    },
    {
      group = 'Search tools',
      plugins = {
        'jremmen/vim-ripgrep',
      }
    },
    {
      group = 'User inteface',
      plugins = {
        'goolord/alpha-nvim', -- " Starup dashboard
        'nvim-lualine/lualine.nvim', -- " Statusline
        'lewis6991/hover.nvim', -- LSP doc on hover
        'Bekaboo/dropbar.nvim', -- vscode like dropbar
        'nvim-neo-tree/neo-tree.nvim',
        'wfxr/minimap.vim', -- " Code minimap
      }
    },
    {
      group = 'Code completion',
      plugins = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'hrsh7th/cmp-nvim-lsp-document-symbol',
        'quangnguyen30192/cmp-nvim-tags',
        'hrsh7th/nvim-cmp',
        'ray-x/cmp-treesitter',
        'hrsh7th/cmp-omni',
        'saadparwaiz1/cmp_luasnip',
      }
    },
    {
      group = 'Git',
      plugins = {
        'tpope/vim-fugitive',
        'lewis6991/gitsigns.nvim',
      }
    },
    {
      group = 'Test',
      plugins = {
        'tpope/vim-dispatch',
        'nvim-neotest/nvim-nio',
        'nvim-neotest/neotest',
        'olimorris/neotest-rspec',
      }
    },
    {
      group = 'Fzf',
      plugins = {
        '/opt/homebrew/opt/fzf',
        'junegunn/fzf.vim',
      }
    },
    {
      group = 'Programming languages',
      plugins = {
        'tpope/vim-haml',
        'plasticboy/vim-markdown',
        'slim-template/vim-slim',

        'vim-ruby/vim-ruby',

        'jelera/vim-javascript-syntax',
        'pangloss/vim-javascript',
        'leafgarland/typescript-vim',

        -- " Lsp & tree-sitter support
        'nvim-tree/nvim-web-devicons',
        'nvim-treesitter/nvim-treesitter',
        'nvim-treesitter/playground',

        'neovim/nvim-lspconfig',

        'mfussenegger/nvim-lint' -- " TODO: use lsp linter support?
      }
    },
    {
      group = 'Colorschemes',
      plugins = {
        { 'rockyzhang24/arctic.nvim', { branch = 'v2' }},
        'Mofiqul/adwaita.nvim',
      }
    },
    {
      group = 'Telescope',
      plugins = {
        { 'nvim-telescope/telescope.nvim', { branch = '0.1.x' }},
        'andrew-george/telescope-themes',
        'otavioschwanck/telescope-alternate',
        'FabianWirth/search.nvim',
        'isak102/telescope-git-file-history.nvim',
      },
    },
  },

  vim_options = {
    wildoptions    = 'pum',
    pumblend       = 0,
    completeopt    = 'menu,menuone,noselect',
    mouse          = 'a',
    -- floatblend     = 8,

    inccommand     = 'nosplit',
    showmode       = true, -- always show what mode we're currently editing in
    termguicolors  = true,
    complete       = '.,w,b,u,t,i', -- set completion options
    omnifunc       = 'syntaxcomplete#Complete',
    updatetime     = 200,
    encoding       = 'utf-8',
    fileencodings  = {'utf-8', 'cp1251'},
    -- t_Co           = '256', -- Explicitly tell Vim that the terminal supports 256 colors

    wildmenu       = true, -- display command-line autocomplete variants
    wildmode       = 'full',
    wildignore     = function() return vim.opt.wildignore + '.hg,.git,.svn,*.DS_Store,*.pyc' end,
    title          = true, -- change the terminal's title

    visualbell     = true, -- Use visual bell instead of beeping
    -- scrolloff      = 15, -- makes vim centered like a iA Writer
    showtabline    = 1, -- display tabline only if where is more then one tab

    linebreak      = true,
    -- showbreak      = vim.fn.nr2char(8618) .. ' ',
    showbreak      = '>> ',
    autoindent     = true, -- always set autoindenting on
    expandtab      = true,
    shiftwidth     = 2,
    tabstop        = 2,
    softtabstop    = 2,
    cursorline     = true,
    splitbelow     = true,
    splitright     = true,
    mousehide      = true, -- Hide the mouse when typing text
    laststatus     = 2,

    hidden         = true, -- this allows to edit several files in the same time without having to save them

    incsearch      = true, -- show search matches as you type
    ignorecase     = true, -- ignore case when searching
    smartcase      = true,
    showmatch      = true, -- set show matching parenthesis
    gdefault       = true, -- all matches in a line are substituted instead of one.

    history        = 1000, -- store lots of :cmdline history
    undolevels     = 1000, --  use many muchos levels of undo
    timeoutlen     = 250,

    swapfile       = false,
  },

  vim_globals = {
    mapleader = ',',

    ['$FZF_DEFAULT_OPTS'] = '--layout=reverse --multi',
    fzf_layout            = { window = { width = 0.9, height = 0.6, border = 'sharp' } },

    -- ~ ruby
    ruby_path             = function() return vim.fn.system('rbenv prefix') end,
    ruby_host_prog        = function() return vim.fn.substitute(vim.fn.system('rbenv prefix') .. '/bin/ruby', "\n", '', 'g') end,
    ruby_operators        = 1,
    ruby_pseudo_operators = 1,
    ruby_no_expensive     = 1,

    -- minimap
    minimap_git_colors    = true,

    -- winresize
    winresizer_vert_resize = 25,
    winresizer_horiz_resize = 5,
  },

  setup = function()
    require("which-key").setup({})
    require("nvim-autopairs").setup({})
    require("nvim-surround").setup({})
    require('neotest').setup({ adapters = { require('neotest-rspec'), } })
    require("neo-tree").setup({
      sources = { "filesystem", "buffers", "git_status", "document_symbols" }
    })
    require('gitsigns').setup({})

    -- Dropbar
    local dropbar = require('dropbar')
    dropbar.setup({})
    vim.ui.select = require('dropbar.utils.menu').select

    -- Lualine
    require('lualine').setup({
      options = {
        theme              = 'auto',
        globalstatus       = true,
        refresh            = { statusline = 3000, tabline = 3000, winba = 3000 },
        section_separators = '', component_separators = '',
        disabled_filetypes = { winbar = { 'nerdtree', 'neo-tree' , 'alpha', 'fugitive', '', 'esearch'} },
      },
      extensions = {'quickfix', 'fzf', 'nerdtree', 'neo-tree', 'fugitive', 'man', 'trouble'}
    })

    -- Telescope
    local telescope = require('telescope')

    telescope.load_extension('themes')
    telescope.load_extension('telescope-alternate')
    telescope.load_extension("git_file_history")

    telescope.setup({
      defaults = {
        layout_config = { vertical = { width = 0.6 }, horizontal = { width = 0.5 } }
      },
      pickers = {
        buffers = { theme = "dropdown" }, find_files = { theme = "dropdown" }
      },
      extensions = {
        themes = {
          enable_previewer = false, enable_live_preview = true, persist = { enable = false },
          layout_config = { horizontal = { width = 0.3, height = 0.5 } },
        },
        -- TODO: setup: https://github.com/otavioschwanck/telescope-alternate.nvim
        ["telescope-alternate"] = {
          presets = { 'rails', 'rspec' }
        },
      }
    })

    -- .. your next configuration goes above:
  end
}
```

TODO: example folder
