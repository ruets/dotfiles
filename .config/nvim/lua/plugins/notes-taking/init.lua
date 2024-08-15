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
    "nocksock/do.nvim",
    opts = {
      -- default options
      message_timeout = 2000, -- how long notifications are shown
      kaomoji_mode = 0, -- 0 kaomoji everywhere, 1 skip kaomoji in doing
      winbar = true,
      doing_prefix = "Doing: ",
      store = {
        auto_create_file = false, -- automatically create a .do_tasks when calling :Do
        file_name = ".do_tasks",
      },
    },
  },
  {
    "LintaoAmons/scratch.nvim",
    event = "VeryLazy",
  }
}
