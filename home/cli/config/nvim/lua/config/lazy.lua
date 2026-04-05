local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  lockfile = "~/.lazy-lock.json",
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        -- "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    border = "double",
    custom_keys = {
      ["<C-r>"] = {
        function(_)
          ---@type LazyPlugin[]
          local plugins = require("lazy.core.config").plugins
          local file_content = {
            "## 💤 Plugin manager",
            "",
            "- [lazy.nvim](https://github.com/folke/lazy.nvim)",
            "",
            "## 🔌 Plugins",
            "",
          }

          local plugins_md = {}
          for plugin, spec in pairs(plugins) do
            if spec.url then
              table.insert(plugins_md, ("- [%s](%s)"):format(plugin, spec.url:gsub("%.git$", "")))
            end
          end

          table.sort(plugins_md, function(a, b)
            return a:lower() < b:lower()
          end)

          for _, p in ipairs(plugins_md) do
            table.insert(file_content, p)
          end

          -- table.insert(file_content, "")
          -- table.insert(file_content, "## 🗃️ Version manager")
          -- table.insert(file_content, "")
          -- table.insert(file_content, "- [NaN](https://fr.wikipedia.org/wiki/NaN)")
          -- table.insert(file_content, "")
          -- table.insert(file_content, "## ✨ GUI")
          -- table.insert(file_content, "")
          -- table.insert(file_content, "- [Nui](https://github.com/MunifTanjim/nui.nvim)")

          local file, err = io.open(vim.fn.stdpath("config") .. "/README.md", "w")
          if not file then
            error(err)
          end

          file:write(table.concat(file_content, "\n"))
          file:close()
          vim.notify("README.md succesfully generated", vim.log.levels.INFO, {})
        end,
        desc = "Generate README.md file",
      },
    },
  },
})
