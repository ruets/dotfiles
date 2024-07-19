-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.del("n", "<leader>l")

local wk = require("which-key")
wk.register({
  ["<leader>m"] = { name = "+multiple cursors" },
  ["<leader>l"] = { name = "+lazy"}
})

local map = LazyVim.safe_keymap_set
map("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>lc", LazyVim.pick.config_files(), { desc = "Config" })

-- Assuming you have 'hrsh7th/nvim-cmp' installed
local cmp = require'cmp'

cmp.setup({
  mapping = {
    ['<CR>'] = cmp.config.disable,
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'}),
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'}),
    ['<Right>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
    ['<A-c>'] = cmp.mapping.complete(),
  },
})

