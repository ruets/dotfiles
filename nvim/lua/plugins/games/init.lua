-- if true, don't actually load anything here and return an empty spec
-- stylua: ignore
local disabled = false
if disabled then return {} end

-- enabled games
local enable_snake = true
local enable_tetris = true

local enable_minesweeper = true
local enable_sudoku = true

local enable_playtime = true
local enable_blackjack = true

local enable_killersheep = true

local enable_vim_be_good = true
local enable_cellular_automaton = true

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {

  {
    "Febri-i/snake.nvim",
    dependencies = {"Febri-i/fscreen.nvim"},
    opts = {},
    enabled = enable_snake
  },
  {'alec-gibson/nvim-tetris', enabled = enable_tetris},

  {'seandewar/nvimesweeper', enabled = enable_minesweeper}, 
  {
    'jim-fx/sudoku.nvim',
    cmd = "Sudoku",
    config = function()
      require("sudoku").setup({
        -- configuration ...
      })
    end,
    enabled = enable_sudoku
  },

  {'rktjmp/playtime.nvim', enabled = enable_playtime},
  {'alanfortlink/blackjack.nvim', enabled = enable_blackjack},

  {'seandewar/killersheep.nvim', enabled = enable_killersheep},

  {'ThePrimeagen/vim-be-good', enabled = enable_vim_be_good},
  {'eandrju/cellular-automaton.nvim', enabled = enable_cellular_automaton},
}
