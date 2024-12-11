-- if true, don't actually load anything here and return an empty spec
-- stylua: ignore
local disabled = false
if disabled then return {} end 

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  {
    "folke/zen-mode.nvim",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },

  { "NStefan002/screenkey.nvim", lazy = false, version = "*" },

  {
    "Pheon-Dev/pigeon",
    event = "",
    config = function()
      local config = {
        enabled = true,
        os = "linux", -- linux, windows, osx
        plugin_manager = "lazy", -- lazy, packer, paq, vim-plug
        callbacks = {
          killing_pigeon = nil,
          respawning_pigeon = nil,
        },
        -- more config options here
      }

      require("pigeon").setup(config)
    end,
    enabled = false
  },

  { "MAHcodes/roll.nvim", dependencies = "RRethy/nvim-base16", enabled = false },
}
