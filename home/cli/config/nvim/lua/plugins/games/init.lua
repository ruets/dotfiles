-- if true, don't actually load anything here and return an empty spec
-- stylua: ignore
local disabled = false
if disabled then return {} end

-- enabled games
local enable_snake = false
local enable_tetris = false

local enable_minesweeper = true
local enable_sudoku = true
local enable_15puzzle = false
local enable_2048 = false

local enable_playtime = false
local enable_blackjack = false

local enable_pond = false
local enable_td = false
local enable_killersheep = false
local enable_lasersinc = false
local enable_rogue = false

local enable_vim_be_good = false
local enable_make_like_a_code = false
local enable_speedtyper = false

local enable_cellular_automaton = true
local enable_hacker = false

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
        persist_settings = false, -- safe the settings under vim.fn.stdpath("data"), usually ~/.local/share/nvim,
        persist_games = false, -- persist a history of all played games
        default_mappings = false, -- if set to false you need to set your own, like the following:
        mappings = {
          { key = "0",     action = "clear_cell" },
          { key = "1",     action = "insert=1" },
          { key = "2",     action = "insert=2" },
          { key = "3",     action = "insert=3" },
          { key = "4",     action = "insert=4" },
          { key = "5",     action = "insert=5" },
          { key = "6",     action = "insert=6" },
          { key = "7",     action = "insert=7" },
          { key = "8",     action = "insert=8" },
          { key = "9",     action = "insert=9" },

          { key = "gn",    action = "new_game" },
          { key = "gr",    action = "reset_game" },
          { key = "gs",    action = "view=settings" },
          { key = "gt",    action = "view=tip" },
          { key = "gz",    action = "view=zen" },
          { key = "gh",    action = "view=help" },
          { key = "u",     action = "undo" },
          { key = "<C-r>", action = "redo" },
          { key = "+",     action = "increment" },
          { key = "-",     action = "decrement" },
        },
        custom_highlights = {
          board = { fg = "#7d7d7d" },
          number = { fg = "white", bg = "black" },
          active_menu = { fg = "white", bg = "black", gui = "bold" },
          hint_cell = { fg = "white", bg = "yellow" },
          square = { bg = "#292b35", fg = "white" },
          column = { bg = "#14151a", fg = "#d5d5d5" },
          row = { bg = "#14151a", fg = "#d5d5d5" },
          settings_disabled = { fg = "#8e8e8e", gui = "italic" },
          same_number = { fg = "white", gui = "bold" },
          set_number = { fg = "white", gui = "italic" },
          error = { fg = "white", bg = "#843434" },
        }
      })
    end,
    enabled = enable_sudoku
  },
  {
    "NStefan002/15puzzle.nvim",
    cmd = "Play15puzzle",
    config = true,
    enabled = enable_15puzzle
  },
  {
    "NStefan002/2048.nvim",
    cmd = "Play2048",
    config = true,
    enabled = enable_2048
  },

  {'rktjmp/playtime.nvim', enabled = enable_playtime},
  {'alanfortlink/blackjack.nvim', enabled = enable_blackjack},

  {
    "FireIsGood/pond.nvim",
    lazy = false,
    opts = {
      name = "The Coolest Fisher",
      cooldown = 0,
      use_default_keymaps = false,
      data_path = vim.fn.stdpath("data") .. "/pond-data.json",
    },
    enabled = enable_pond
  },
  { "efueyo/td.nvim", enabled = enable_td },
  { 'seandewar/killersheep.nvim', enabled = enable_killersheep },
  { "josephcagle/LasersInc.nvim", enabled = enable_lasersinc },
  { "nvim-rogue/rogue.nvim", enabled = enable_rogue },

  {'ThePrimeagen/vim-be-good', enabled = enable_vim_be_good},
  { "mebble/make-like-a-code.nvim", enabled = enable_make_like_a_code },
  { "NStefan002/speedtyper.nvim", cmd = "Speedtyper", opts = {}, enabled = enable_speedtyper },

  {'eandrju/cellular-automaton.nvim', enabled = enable_cellular_automaton},
  { "letieu/hacker.nvim", enabled = enable_hacker },
}
