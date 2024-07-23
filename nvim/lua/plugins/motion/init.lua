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
    "tris203/precognition.nvim",
    -- event = "VeryLazy",
    opts = {
      -- startVisible = true,
      -- showBlankVirtLine = true,
      -- highlightColor = { link = "Comment" },
      -- hints = {
      --   Caret = { text = "^", prio = 2 },
      --   Dollar = { text = "$", prio = 1 },
      --   MatchingPair = { text = "%", prio = 5 },
      --   Zero = { text = "0", prio = 1 },
      --   w = { text = "w", prio = 10 },
      --   b = { text = "b", prio = 9 },
      --   e = { text = "e", prio = 8 },
      --   W = { text = "W", prio = 7 },
      --   B = { text = "B", prio = 6 },
      --   E = { text = "E", prio = 5 },
      -- },
      -- gutterHints = {
      --   G = { text = "G", prio = 10 },
      --   gg = { text = "gg", prio = 9 },
      --   PrevParagraph = { text = "{", prio = 8 },
      --   NextParagraph = { text = "}", prio = 8 },
      -- },
      -- disabled_fts = {
      --   "startify",
      -- },
    },
  },
  {
      'smoka7/hop.nvim',
      version = "*",
      opts = {
          keys = 'etovxqpdygfblzhckisuran'
      }
  }
}
