return {
  {
    "hrsh7th/nvim-cmp",
    init = function()
      vim.g.copilot_proxy_strict_ssl = false
      vim.g.copilot_proxy = "http://internet-france.corp.thales:8080"
    end,
  },
  { "vyfor/cord.nvim", enabled = false },
}
