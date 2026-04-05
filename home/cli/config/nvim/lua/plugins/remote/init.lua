-- if true, don't actually load anything here and return an empty spec
-- stylua: ignore
local disabled = true
if disabled then
  return {}
end

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  {
    "chipsenkbeil/distant.nvim",
    branch = "v0.3",
    config = function()
      require("distant"):setup()
    end,
  },
}
