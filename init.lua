-- Basis instellingen
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")
vim.cmd("set relativenumber")
-- Clipboard support
vim.opt.clipboard = "unnamedplus"
vim.g.mapleader = " "

-- Lazy.nvim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  end
  vim.opt.rtp:prepend(lazypath)

  -- Plugins
  local plugins = {
    -- Kleurschema
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      config = function()
      require("catppuccin").setup()
      vim.cmd.colorscheme("catppuccin")
      end,
    },

    -- File browser
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
      config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        window = {
          width = 30,
        },
        filesystem = {
          follow_current_file = {
            enabled = true,
          },
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
          },
        },
      })
      end,
    },

    -- Git integratie
    {
      "lewis6991/gitsigns.nvim",
      config = function()
      require("gitsigns").setup()
      end,
    },

    -- GitHub Copilot
    {
      "github/copilot.vim",
      event = "InsertEnter",
      config = function()
      vim.g.copilot_no_tab_map = true
      vim.keymap.set("i", "<C-j>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        desc = "Accept Copilot suggestion"
      })
      end,
    },

    -- LazyGit
    {
      "kdheepak/lazygit.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
    },

    -- Syntax highlighting
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      lazy = false,
      config = function()
      local status_ok, configs = pcall(require, "nvim-treesitter.configs")
      if not status_ok then
        vim.notify("Treesitter not yet installed. Run :TSUpdate", vim.log.levels.WARN)
        return
        end

        configs.setup({
          ensure_installed = { "lua", "vim", "vimdoc" },
          sync_install = false,
          auto_install = false,
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
          indent = { enable = true },
        })
        end,
    },

    -- Autocompletion
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
      },
      config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
          require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                                            ["<C-f>"] = cmp.mapping.scroll_docs(4),
                                            ["<C-Space>"] = cmp.mapping.complete(),
                                            ["<C-e>"] = cmp.mapping.abort(),
                                            ["<CR>"] = cmp.mapping.confirm({ select = true }),
                                            ["<Tab>"] = cmp.mapping.select_next_item(),
                                            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        })
      })
      end,
    },

    -- Telescope
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
      require("telescope").setup{}
      end,
    },

    -- Statusline
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
      require("lualine").setup({
        options = { theme = "catppuccin" }
      })
      end,
    },

    -- Auto-pairs
    {
      "windwp/nvim-autopairs",
      config = function()
      require("nvim-autopairs").setup{}
      end,
    },

    -- Comment
    {
      "numToStr/Comment.nvim",
      config = function()
      require("Comment").setup()
      end,
    },

    -- Indent guides
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      config = function()
      require("ibl").setup()
      end,
    },

    -- Which-key
    {
      "folke/which-key.nvim",
      config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup()
      end,
    },
  }

  require("lazy").setup(plugins, {})

  -- Keybindings
  local keymap = vim.keymap.set

  -- File browser
  keymap("n", "<C-n>", ":Neotree toggle<CR>", { silent = true, desc = "Toggle file tree" })

  -- Telescope
  keymap("n", "<C-p>", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
  keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
  keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })

  -- LazyGit
  keymap("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })

  -- Buffer navigatie
  keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
  keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
  keymap("n", "<leader>x", ":bdelete<CR>", { desc = "Close buffer" })

  -- Opslaan
  keymap("n", "<C-s>", ":w<CR>", { desc = "Save" })
  keymap("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save" })

  -- Split vensters
  keymap("n", "<leader>sv", ":vsplit<CR>", { desc = "Vertical split" })
  keymap("n", "<leader>sh", ":split<CR>", { desc = "Horizontal split" })

  -- Lazy plugin manager
  keymap("n", "<leader>l", ":Lazy<CR>", { desc = "Open Lazy" })
  -- Clipboard
  keymap("v", "<C-c>", '"+y', { desc = "Copy to clipboard" })
  keymap("n", "<C-v>", '"+p', { desc = "Paste from clipboard" })
  keymap("i", "<C-v>", '<Esc>"+pa', { desc = "Paste from clipboard" })

