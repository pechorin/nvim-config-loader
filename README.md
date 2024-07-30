# NvimConfigLoader - one-table modern nvim configuration loader / initializer

TODO: logic map

## Idea & Concept

Where are many ways to setup your vim. We tried many of them. Each has own benefits.
NvimConfigLoader is evolution of different approaches and represent combination of ideas into one compact vim configuration loader.

Lets use lua only for configuration, but go further:

- Use only lua tables and functions, no special vim function calls for basic configuration like vim options, autocommands or keymaps
- Load config with one base file (but its okay to have some separate files for big configuration areas)
- Combine configurations into packs (for example, pack for tree-sitter will contain tree-sitter specific plugins list, autocommands, mappings)
- Dont warry about plugin managers, NvimConfigLoader should install and configure it for you
- Nvim checkhealth support: will report if you miss some configurations (like forget to setup any autocommands)

## Plugin managers support

- [*] vim-plug auto downloading and installation
- [ ] vim-plug plugin lazy-loading setup support
- [ ] vim-pack

### Install & update

Run bash script to download `tiny-nvim-loader.lua` and install it to vim home directory:

```bash
curl -fLo ~/.vim/lua/tiny-nvim-loader.lua --create-dirs \
  https://raw.githubusercontent.com/pechorin/tiny-nvim-loader/master/tiny-nvim-loader.lua;
```

### Usage in your init.lua

```lua
require('nvim-config-loader').setup {
  -- configuration here
}
```

TODO: add nvim home dir example

### Configuration structure

```lua
require('nvim-config-loader').setup {
}
```

# Loading sequence

TODO

# Example

### TODO

- [ ] vim-plug setup() function per plugin support (https://dev.to/vonheikemen/neovim-using-vim-plug-in-lua-3oom)
- [ ] comments
- [ ] api interface for settings
- [ ] packs list
- [ ] ?example folder
- [*] vimplug auto download & setup https://github.com/junegunn/vim-plug/wiki/tips
- [*] store saved settings stats
- [*] public/private interface
- [*] check all base settings supplied on setup()
- [*] add_pack setup function()
- [*] add flat lists loading (without grouping)
