-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.del("n", "<leader>l")

local wk = require("which-key")
wk.add({
  { "<leader>l", group = "+lazy" },
  { "<leader>m", group = "+multiple cursors" },
})

local map = LazyVim.safe_keymap_set
map("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>lc", LazyVim.pick.config_files(), { desc = "Config" })

-- Assuming you have 'hrsh7th/nvim-cmp' installed
local cmp = require("cmp")

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<A-c>"] = cmp.mapping.complete(),
  }),
})

local harpoon = require("harpoon")
harpoon:setup()
vim.keymap.set("n", "<leader>h", function()
  harpoon:list():add()
end)
vim.keymap.set("n", "<C-e>", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)
