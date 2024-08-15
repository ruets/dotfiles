-- if true, don't actually load anything here and return an empty spec
-- stylua: ignore
local disabled = true
if disabled then return {} end 

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  {
    "gaborvecsei/usage-tracker.nvim",
    config = function()
      require('usage-tracker').setup({
        keep_eventlog_days = 14,
        cleanup_freq_days = 7,
        event_wait_period_in_sec = 5,
        inactivity_threshold_in_min = 5,
        inactivity_check_freq_in_sec = 5,
        verbose = 0,
        telemetry_endpoint = "" -- you'll need to start the restapi for this feature
      })
    end
  },

  { 'juansalvatore/git-dashboard-nvim', dependencies = { 'nvim-lua/plenary.nvim' }, enabled = false },
}
