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
    "bgaillard/readonly.nvim",
    dependencies = {
      "rcarriga/nvim-notify"
    },
    opts = {
      -- see https://neovim.io/doc/user/lua.html#vim.fs.normalize()
      secured_files = {
        "~/%.aws/config",
        "~/%.aws/credentials",
        "~/%.ssh/.",
        "~/%.secrets.yaml",
        "~/%.vault-crypt-files/.",
      }
    },
    lazy = false
  },

  {
    "NStefan002/visual-surround.nvim",
    config = function()
      require("visual-surround").setup({
        -- your config
      })
    end,
    -- or if you don't want to change defaults
    -- config = true
    enabled = false
  }
}
