function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end

local NvimConfigLoader = {
  profile_loads        = 0,
  default_packs      = {},

  settings = {
    colorscheme             = 'default',
    bg                      = 'light',

    vim_plug_bundle_path    = nil,
    vim_plug_bundle         = {},

    additional_config_files = {},

    vim_options             = {},
    vim_globals             = {},
    keymaps                 = {},
    autocommands            = {},
    packs                   = {},
  },

  vim_files_path = function()
    local path = vim.fn.resolve(vim.fn.expand('<sfile>:p'))
    return vim.fn.substitute(vim.fn.substitute(path, ".vimrc", '', ''), 'init.lua', '', '')
  end,

  plugin_managers = {
    plug = {
      install = function()
        -- TODO:
      end,

      load_plugin = function(plugin_data)
        if type(plugin_data) == 'string' then
          vim.fn['plug#'](plugin_data)
        elseif type(plugin_data) == 'table' then
          vim.fn['plug#'](unpack(plugin_data))
        end
      end,

      load_plugins = function(self, list)
        if type(list) ~= 'table' then return end

        for _, plugin_data in ipairs(list) do
          self.plugin_managers.plug.load_plugin(plugin_data)
        end
      end,

      load = function(self)
        local bundle_path = self.settings.vim_plug_bundle_path
        if type(bundle_path) ~= "string" then return end

        -- local vim = vim
        vim.o.rtp = vim.o.rtp .. bundle_path ..  '/Vundle.vim'
        vim.call('plug#begin', bundle_path)

        -- load presets bundle
        if type(self.default_packs) == 'table' then
          for _, preset in pairs(self.default_packs) do
            self.plugin_managers.plug.load_plugins(self, preset.vim_plug_bundle)
          end
        end

        -- load user defined bundle
        if type(self.settings.vim_plug_bundle) == 'table' then
          for _, group_bundle in ipairs(self.settings.vim_plug_bundle) do
            self.plugin_managers.plug.load_plugins(self, group_bundle.plugins)
          end
        end

        -- load user defined bundle from packs
        if type(self.settings.packs) == 'table' then
          for _, pack_data in pairs(self.settings.packs) do
            self.plugin_managers.plug.load_plugins(self, pack_data.vim_plug_bundle)
          end
        end

        vim.call('plug#end')
      end,
    }
  },

  load_additional_config_files = function(self)
    local opt = self.settings.additional_config_files
    if type(opt) ~= "table" then return end

    for _, setting_file in ipairs(opt) do
      vim.fn.execute('source ' .. self.vim_files_path() .. setting_file)
    end
  end,

  load_colorscheme = function(self)
    local opt = self.settings.colorscheme
    if type(opt) ~= "string" then return end

    -- Set colorscheme once at first profile load
    if self.profile_loads == 0 then
      vim.opt.bg = self.settings.bg or 'light'
      vim.cmd.colorscheme(opt)
    end
  end,

  log_reloading = function(self)
    if self.profile_loads > 1 then
      print("reloading profile #" .. tostring(self.profile_loads))
    end

    self.profile_loads = self.profile_loads + 1
  end,

  get_option_value = function(user_value)
    if type(user_value) == 'function' then
      return user_value()
    else
      return user_value
    end
  end,

  load_vim_options = function(self)
    local opt = self.settings.vim_options
    if type(opt) ~= "table" then return end

    for option, v in pairs(opt) do
      vim.opt[option] = self.get_option_value(v)
    end
  end,

  load_vim_globals = function(self)
    local opt = self.settings.vim_globals
    if type(opt) ~= "table" then return end

    for global, v in pairs(opt) do
      vim.g[global] = self.get_option_value(v)
    end
  end,

  load_autocommands = function(self)
    -- load presets bundle
    if type(self.default_packs) == 'table' then
      for group, preset in pairs(self.default_packs) do
        self:create_grouped_autocommands(group, preset)
      end
    end

    -- load user defined autocommands
    local opt = self.settings.autocommands
    if type(opt) == "table" then
      for group, commands in pairs(opt) do
        self:create_grouped_autocommands(group, commands)
      end
    end

    -- load user defined autocommands from packs
    if type(self.settings.packs) == 'table' then
      for pack_name, pack_data in pairs(self.settings.packs) do
        if type(pack_data.autocommands) == table then
          self:create_grouped_autocommands(pack_name, pack_data.autocommands)
        end
      end
    end
  end,

  create_autocommand = function(cmd, augroup)
    vim.api.nvim_create_autocmd(cmd.event, {
     pattern  = cmd.pattern,
     group    = augroup,
     command  = cmd.command,
     callback = cmd.callback,
    })
  end,

  create_grouped_autocommands = function(self, group_name, autocommands)
    local augroup = vim.api.nvim_create_augroup(group_name, { clear = true })

    for _, cmd in ipairs(autocommands) do self.create_autocommand(cmd, augroup) end
  end,

  load_keymaps = function(self)
    -- load user defined keymaps
    local opt = self.settings.keymaps
    if type(opt) == "table" then
      for _, group in pairs(opt) do
        for _, mapping in ipairs(group) do vim.keymap.set(unpack(mapping)) end
      end
    end

    -- load user defined keymaps from packs
    if type(self.settings.packs) == 'table' then
      for _, pack_data in pairs(self.settings.packs) do
        local pack_keymaps = pack_data['keymaps']

        if type(pack_keymaps) == 'table' then
          for _, mapping in ipairs(pack_keymaps) do vim.keymap.set(unpack(mapping)) end
        end
      end
    end
  end,

  setup_default_packs = function(self)
    if type(self.default_packs) ~= 'table' then return end

    for name, preset in pairs(self.default_packs) do
      if self.settings[name] ~= nil and type(preset.setup) == 'function' then
        preset.setup(self)
      end
    end
  end,

  setup_packs = function(self)
    if type(self.settings.packs) ~= 'table' then return end

    for pack_name, pack_data in pairs(self.settings.packs) do
      if type(pack_data.setup) == 'function' then
        pack_data.setup(self)
      end
    end
  end,

  setup = function(self, user_settings)
    for k, v in pairs(user_settings) do
      if k ~= 'setup' then self.settings[k] = v end
    end

    for _, manager in pairs(self.plugin_managers) do manager.load(self) end

    self:load_vim_options()
    self:load_vim_globals()

    self:setup_default_packs()

    if type(user_settings.setup) == 'function' then user_settings.setup(self) end

    self:load_keymaps()
    self:load_autocommands()
    self:load_colorscheme()

    self:load_additional_config_files()

    self:setup_packs()

    self:log_reloading()
  end
}

local DefaultPacks = {
  nvim_lint = {
    vim_plug_bundle = {
      'mfussenegger/nvim-lint' -- " TODO: use lsp linter support?
    },
    setup = function(self)
      if type(self.settings.nvim_lint) == 'table' then
        if type(self.settings.nvim_lint.linters_by_ft) == 'table' then
          require('lint').linters_by_ft = self.settings.nvim_lint.linters_by_ft

          local pattern = self.settings.nvim_lint.file_pattern or { "*.rb", "*.erb", "*.haml", "*.slim" }

          vim.api.nvim_create_autocmd({ "BufWritePost", "BufRead" }, {
            pattern = pattern,
            callback = function()
              require("lint").try_lint()
            end,
          })
        end
      end
    end,
  },
  nvim_treesitter = {
    vim_plug_bundle = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/playground',
      'SmiteshP/nvim-gps'
    },
    setup = function(self)
      if type(self.settings.nvim_treesitter) ~= 'table' or type(self.settings.nvim_treesitter.languages) ~= 'table' then return end

      require('nvim-treesitter.configs').setup {
        ensure_installed = self.settings.nvim_treesitter.languages,
        sync_install     = true,
        auto_install     = true,
        highlight        = { enable = true }
      }
    end
  },
  alpha_start_dashboard = {
    vim_plug_bundle = {
      'goolord/alpha-nvim'
    },
    autocommands = {
      -- Disable folding on alpha buffer
      { event = { 'FileType' }, pattern = 'alpha', command = 'setlocal nofoldenable' },
    },
    setup = function(self)
      local alpha = require("alpha")
      local startify = require("alpha.themes.startify")

      local title = self.settings.alpha_start_dashboard.title or 'Hello world'

      startify.section.header.val = { title }

      startify.opts.layout[1].val = 2
      startify.opts.opts.margin   = 3

      -- disable MRU
      startify.section.mru.val = { { type = "padding", val = 0 } }

      local buttons = {}

      for _, data in pairs(self.settings.alpha_start_dashboard.buttons or {}) do
        local btn = startify.button(unpack(data))
        table.insert(buttons, btn)
      end

      startify.section.top_buttons.val = buttons

      -- Send config to alpha
      alpha.setup(startify.config)
    end
  }
}

NvimConfigLoader.default_packs = DefaultPacks

return NvimConfigLoader
