-- if true, don't actually load anything here and return an empty spec
-- stylua: ignore
local disabled = true
if disabled then return {} end 

-- Argument pour sélectionner un seul plugin
local selected_plugin = "Xuyuanp/scrollbar.nvim" -- Remplacez nil par le nom du plugin que vous souhaitez charger, par exemple "Xuyuanp/scrollbar.nvim"

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
local plugins = {
  {
    "Xuyuanp/scrollbar.nvim",
    config = function()
      vim.api.nvim_exec([[
        augroup ScrollbarInit
          autocmd!
          autocmd WinScrolled,VimResized,QuitPre * silent! lua require('scrollbar').show()
          autocmd WinEnter,FocusGained           * silent! lua require('scrollbar').show()
          autocmd WinLeave,BufLeave,BufWinLeave,FocusLost * silent! lua require('scrollbar').clear()
        augroup end
      ]], false)
    end
  },
  {
    "dstein64/nvim-scrollview"
  },
  {
    'gorbit99/codewindow.nvim',
    config = function()
      local codewindow = require('codewindow')
      codewindow.setup()
      codewindow.apply_default_keybinds()
    end,
  }
}

-- Filtrer les plugins en fonction de l'argument selected_plugin
if selected_plugin then
  plugins = vim.tbl_filter(function(plugin)
    return plugin[1] == selected_plugin
  end, plugins)
end

return plugins
