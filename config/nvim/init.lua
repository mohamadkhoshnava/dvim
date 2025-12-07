-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- OPTIONS & SETTINGS
-- ============================================================================
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- ============================================================================
-- KEY MAPPINGS
-- ============================================================================
local map = vim.keymap.set

-- File & Save
map("n", "<C-s>", ":w<CR>", { silent = true, desc = "Save" })
map("n", "<leader>w", ":w<CR>", { silent = true, desc = "Save" })
map("n", "<leader>q", ":q<CR>", { silent = true, desc = "Quit" })

-- Editing
map("n", "<C-a>", "ggVG", { silent = true, desc = "Select All" })
map("v", "<C-c>", '"+y', { silent = true, desc = "Copy" })
map("n", "<C-v>", '"+p', { silent = true, desc = "Paste" })
-- Move lines
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ============================================================================
-- PLUGINS
-- ============================================================================
require("lazy").setup({
  
  -- 🎨 THEMES
  { "Mofiqul/vscode.nvim" },
  { "folke/tokyonight.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { 
      "ellisonleao/gruvbox.nvim", 
      config = function()
          vim.cmd("colorscheme vscode") 
      end
  },

  -- 📁 FILES & EXPLORER
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = { enable = true, update_root = true },
        view = { width = 30 },
        renderer = { 
            group_empty = true,
            indent_markers = { enable = true },
            icons = { show = { git = true } }
        },
      })
      map('n', '<C-b>', ':NvimTreeToggle<CR>', { silent = true, desc = "Toggle Explorer" })
      map('n', '<leader>e', ':NvimTreeFocus<CR>', { silent = true, desc = "Focus Explorer" })
    end,
  },

  -- 🔭 FUZZY FINDER
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      map('n', '<C-p>', builtin.find_files, { desc = "Find Files" })
      map('n', '<C-f>', builtin.live_grep, { desc = "Global Search" })
      map('n', '<leader>fb', builtin.buffers, { desc = "Find Buffers" })
      map('n', '<leader>th', ":Telescope colorscheme<CR>", { desc = "Switch Theme" })
      require('telescope').setup{ defaults = { file_ignore_patterns = { "node_modules", ".git" } } }
    end
  },

  -- 📑 TABS
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup{
          options = {
              mode = "buffers",
              diagnostics = "nvim_lsp",
              offsets = { { filetype = "NvimTree", text = "Explorer", text_align = "left", separator = true } }
          }
      }
      map('n', '<Tab>', ':BufferLineCycleNext<CR>', { silent = true })
      map('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { silent = true })
      map('n', '<C-w>', ':bdelete<CR>', { silent = true, desc = "Close Buffer" })
    end
  },

  -- 🖥️ UI IMPROVEMENTS
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        lsp = {
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        presets = { bottom_search = true, command_palette = true, long_message_to_split = true },
    },
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" }
  },
  
  -- 🚀 DASHBOARD
  {
      'goolord/alpha-nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function () require'alpha'.setup(require'alpha.themes.theta'.config) end
  },

  -- 📊 STATUS LINE
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({ options = { theme = 'auto', globalstatus = true } })
    end
  },

  -- ⌨️ TERMINAL
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
        require("toggleterm").setup({ direction = "float", float_opts = { border = "curved" } })
        map('n', '<C-\\>', ':ToggleTerm<CR>', { silent = true })
        map('t', '<C-\\>', '<C-\\><C-n>:ToggleTerm<CR>', { silent = true })
        map('t', '<Esc>', [[<C-\><C-n>]], {noremap = true})
    end
  },

  -- 🧠 INTELLISENSE (LSP & CMP)
  {
      'williamboman/mason.nvim',
      config = function()
          require("mason").setup()
      end
  },
  {
      'williamboman/mason-lspconfig.nvim',
      dependencies = { 'williamboman/mason.nvim' },
      config = function()
          require("mason-lspconfig").setup({
              ensure_installed = { "lua_ls", "pyright", "ts_ls", "dockerls", "bashls" } 
          })
      end
  },
  {
      'neovim/nvim-lspconfig',
      dependencies = { 'mason-lspconfig.nvim' }, -- Ensure mason-lspconfig loads first
      config = function()
          local lspconfig = require('lspconfig')
          local capabilities = require('cmp_nvim_lsp').default_capabilities()
          require("mason-lspconfig").setup_handlers {
              function (server_name) 
                  lspconfig[server_name].setup { capabilities = capabilities }
              end,
          }
      end
  },
  {
      'hrsh7th/nvim-cmp',
      dependencies = {
          'hrsh7th/cmp-nvim-lsp',
          'L3MON4D3/LuaSnip',
          'saadparwaiz1/cmp_luasnip',
          'rafamadriz/friendly-snippets',
          'onsails/lspkind.nvim',
      },
      config = function()
          local cmp = require('cmp')
          local luasnip = require('luasnip')
          local lspkind = require('lspkind')
          require("luasnip.loaders.from_vscode").lazy_load()

          cmp.setup({
              formatting = {
                format = lspkind.cmp_format({ mode = 'symbol_text', maxwidth = 50, ellipsis_char = '...' })
              },
              snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
              mapping = cmp.mapping.preset.insert({
                  ['<C-Space>'] = cmp.mapping.complete(),
                  ['<CR>'] = cmp.mapping.confirm({ select = true }), 
                  ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                  ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
              }),
              sources = cmp.config.sources({
                  { name = 'nvim_lsp' },
                  { name = 'luasnip' },
                  { name = 'buffer' },
                  { name = 'path' },
              })
          })
      end
  },

  -- ✨ EXTRAS
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    cmd = "Trouble",
    keys = { { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" } },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {} 
  },
  {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
        map('n', '<C-_>', '<Plug>(comment_toggle_linewise_current)', { remap = true })
        map('v', '<C-_>', '<Plug>(comment_toggle_linewise_visual)', { remap = true })
    end
  },
  { 'windwp/nvim-autopairs', event = "InsertEnter", opts = {} },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  { "lewis6991/gitsigns.nvim", opts = {} },
  { "RRethy/vim-illuminate", config = function() require('illuminate').configure({}) end },
  
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "javascript", "typescript", "html", "css", "dockerfile", "json", "yaml", "bash" },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },
})
