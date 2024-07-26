function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end

-- TODO: private / public interface

local NvimConfigLoader = {
  profile_loads = 0,

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

      unpack_and_load_plugins = function(self, data)
        local plug = self.plugin_managers.plug

        -- regular string plugin definition
        if type(data) == 'string' then
          plug.load_plugin(data)

        -- table plugin definition
        elseif type(data) == 'table' then
          if data[1] then
            plug.load_plugin(data)
          else
            local iter = pairs(data)
            local _, list = iter(data)

            plug.load_plugins(self, list)
          end
        end
      end,

      load = function(self)
        local bundle_path = self.settings.vim_plug_bundle_path
        if type(bundle_path) ~= "string" then return end

        local plug = self.plugin_managers.plug

        -- local vim = vim
        vim.o.rtp = vim.o.rtp .. bundle_path ..  '/Vundle.vim'
        vim.call('plug#begin', bundle_path)

        -- load user defined bundle
        if type(self.settings.vim_plug_bundle) == 'table' then
          for _, data in pairs(self.settings.vim_plug_bundle) do
            plug.unpack_and_load_plugins(self, data)
          end
        end

        -- load user defined bundle from packs
        if type(self.settings.packs) == 'table' then
          for _, pack_data in pairs(self.settings.packs) do
            for _, data in pairs(pack_data.vim_plug_bundle) do
              plug.unpack_and_load_plugins(self, data)
            end
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

  unpack_and_create_grouped_autocommands = function(self, key, data)
    if type(data) ~= 'table' then return end

    if type(key) == "number" then
      self.create_autocommand(data, nil)
    else
      self.create_grouped_autocommands(self, key, data)
    end
  end,

  load_autocommands = function(self)
    -- load user defined autocommands
    local opt = self.settings.autocommands
    if type(opt) == "table" then
      for key, data in pairs(opt) do
        self:unpack_and_create_grouped_autocommands(key, data)
      end
    end

    -- load user defined autocommands from packs
    if type(self.settings.packs) == 'table' then
      for _, pack_data in pairs(self.settings.packs) do
        if type(pack_data.autocommands) == 'table' then
          for key, data in pairs(pack_data.autocommands) do
            self:unpack_and_create_grouped_autocommands(key, data)
          end
        end
      end
    end
  end,

  unpack_and_load_keymaps = function(key, data)
    if type(data) ~= 'table' then return end

    if type(key) == "number" then
      vim.keymap.set(unpack(data))
    else
      for _, mapping in ipairs(data) do
        vim.keymap.set(unpack(mapping))
      end
    end
  end,

  load_keymaps = function(self)
    -- load user defined keymaps
    if type(self.settings.keymaps) == "table" then
      for key, data in pairs(self.settings.keymaps) do
        self.unpack_and_load_keymaps(key, data)
      end
    end

    -- load user defined keymaps from packs
    if type(self.settings.packs) == 'table' then
      for _, pack_data in pairs(self.settings.packs) do
        local keymaps = pack_data.keymaps

        if type(keymaps) == 'table' then
          for key, data in pairs(keymaps) do
            self.unpack_and_load_keymaps(key, data)
          end
        end
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

    if type(user_settings.setup) == 'function' then user_settings.setup(self) end

    self:load_keymaps()
    self:load_autocommands()
    self:load_colorscheme()

    self:load_additional_config_files()

    self:setup_packs()

    self:log_reloading()
  end
}

return NvimConfigLoader
