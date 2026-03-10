-- ========================================
-- LEADER (must be first)
-- ========================================
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

-- ========================================
-- LAZY BOOTSTRAP
-- ========================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git","clone","--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- ========================================
-- BASIC OPTIONS (minimal sane defaults)
-- ========================================
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.signcolumn = "yes"

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2

-- ========================================
-- KEYMAPS
-- ========================================
local opts = { noremap = true, silent = true }

-- window switching
vim.keymap.set("n", "<leader>t", "<C-w>w", opts)

-- format
-- vim.keymap.set("n", "<leader>c", function()
vim.lsp.buf.format({ async = false })
end, opts)

  -- LSP
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

  -- diagnostics
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

  -- comment toggle (//)
  vim.keymap.set("v", "<leader>/", function()
    local s = vim.fn.line("v")
    local e = vim.fn.line(".")
    if s > e then s, e = e, s end
    for l = s, e do
      local c = vim.fn.getline(l)
      if c:match("^%s*//") then
        vim.fn.setline(l, c:gsub("^(%s*)//%s?", "%1"))
      else
        vim.fn.setline(l, "// " .. c)
      end
    end
  end, opts)

  -- disable arrows
  for _, k in ipairs({ "Up","Down","Left","Right" }) do
    vim.keymap.set({ "n","i" }, "<"..k..">", "<Nop>", opts)
end

    -- ========================================
    -- PLUGINS
    -- ========================================
    require("lazy").setup({

    -- Theme: catppuccin
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      lazy = false,
      config = function()
        require("catppuccin").setup({ flavour = "mocha" })
        vim.cmd.colorscheme("catppuccin")
      end,
    },

    -- Icons (nerd font)
    { "nvim-tree/nvim-web-devicons" },

    -- Sidebar file explorer: nvim-tree
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },

      -- loads automatically when pressing \e
      keys = {
        { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "toggle tree" },
      },

      config = function()
        require("nvim-tree").setup({
          view = {
            width = 30,
            number = true,
            relativenumber = true,
          },
          git = { enable = false },
          filters = { dotfiles = false },
        })
      end,
    },

    -- Git gutter signs
    {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup()
      end,
    },

    -- Statusline
    {
      "nvim-lualine/lualine.nvim",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
        "lewis6991/gitsigns.nvim"
      },
      config = function()
        require("lualine").setup({
          options = {
            theme = "catppuccin",
            icons_enabled = true,
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
          },
          sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff" },
            lualine_c = { { "filename", path = 1 } },
            lualine_x = { "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
          },
        })
      end,
    },
  })

