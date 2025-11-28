local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = "-"
vim.g.maplocalleader = "-"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.scrolloff = 999
vim.opt.timeoutlen = 500
vim.opt.termguicolors = true

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 1000 })
  end,
})

require("lazy").setup({

  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        -- Multiple keys to open it, just in case C-\ fails
        open_mapping = [[<c-\>]], 
        hide_numbers = true,
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true, -- Whether or not the open mapping applies in insert mode
        terminal_mappings = true, -- Whether or not the open mapping applies in the opened terminals
        persist_size = true,
        direction = 'float',
        close_on_exit = true, -- Close the terminal window when the process exits
        
        -- Do not use 'powershell.exe' in the generic shell option if global opts are set.
        -- Instead, use the 'shell' parameter inside the setup specifically for this buffer.
        shell = 'powershell.exe -NoLogo -ExecutionPolicy Bypass',
        
        float_opts = {
          border = 'curved',
          winblend = 0,
        }
      })
      
      -- Backup Keymap: F7 to toggle (Easier to hit)
      vim.keymap.set('n', '<F7>', '<cmd>ToggleTerm<cr>', { noremap = true, silent = true })
      vim.keymap.set('t', '<F7>', '<cmd>ToggleTerm<cr>', { noremap = true, silent = true })
    end
  },
  -- Theme
  { 
    "ellisonleao/gruvbox.nvim", 
    priority = 1000, 
    config = function()
      vim.cmd([[colorscheme gruvbox]])
      vim.o.background = "dark"
    end
  },

  -- File Explorer
  {
    "preservim/nerdtree",
    dependencies = { "ryanoasis/vim-devicons" },
    config = function()
      vim.g.NERDTreeWinPos = "right"
    end,
  },

  -- Status Line
  { 
    "vim-airline/vim-airline",
    dependencies = { "vim-airline/vim-airline-themes" },
  },

  -- Formatting & Linting
  { 
    "sbdchd/neoformat",
    config = function()
      vim.g.neoformat_basic_format_align = 1
      vim.g.neoformat_basic_format_retab = 1
      vim.g.neoformat_basic_format_trim = 1
    end
  },
  { "neomake/neomake" },

  -- Utilities
  { "jiangmiao/auto-pairs" },
  { "preservim/nerdcommenter" },
  { "pearofducks/ansible-vim" },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "powershell", "lua", "python", "c_sharp", "go", "markdown", "markdown_inline", "json" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- LSP & Mason
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { 
          "powershell_es", 
          "lua_ls",        
          "omnisharp",     
        },
      })
      
      local lspconfig = require("lspconfig")
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      
      -- PowerShell
      lspconfig.powershell_es.setup({
        bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
        settings = { powershell = { codeFormatting = { preset = "OTBS" } } },
        capabilities = capabilities,
      })

      -- C# (Omnisharp)
      lspconfig.omnisharp.setup({
        capabilities = capabilities,
        cmd = { vim.fn.stdpath("data") .. "/mason/bin/omnisharp" },
        enable_roslyn_analyzers = true,
        organize_imports_on_format = true,
      })

      -- Lua
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
          },
        },
      })
    end
  },

  -- Completion (CMP)
  {
    "hrsh7th/nvim-cmp",
    dependencies = { 
      "hrsh7th/cmp-buffer", 
      "hrsh7th/cmp-path", 
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({ 
          { name = 'nvim_lsp' },
          { name = 'buffer' }    
        })
      })
    end
  },

  
  -- Copilot Core (Ghost Text / Inline Suggestions)
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
      copilot_node_command = [[C:\Program Files\nodejs\node.exe]],
        suggestion = { 
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<M-l>", -- Alt+l to accept suggestion
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = { enabled = true },
      })
    end,
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "Main",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" }, 
    },
    opts = {
      debug = false,
      -- Default window options
      window = {
        layout = 'float', -- 'vertical', 'horizontal', 'float'
        width = 0.6,      -- fractional width of parent
        height = 0.6,     -- fractional height of parent
      },
    },
    keys = {
      { "<leader>Cc", ":CopilotChatToggle<cr>", desc = "Copilot Chat Toggle" },
      { "<leader>Ce", ":CopilotChatExplain<cr>", desc = "Copilot Explain" },
      { "<leader>Cf", ":CopilotChatFix<cr>", desc = "Copilot Fix" },
      { "<leader>Cr", ":CopilotChatReset<cr>", desc = "Copilot Reset" },
    },
  },

})

vim.keymap.set("i", "jj", "<Esc>", { noremap = true })

vim.keymap.set("n", "<leader>h", ":noh<CR>")
vim.keymap.set("n", "<leader>t", ":NERDTreeToggle<CR>")
vim.keymap.set("n", "<leader>n", ":set number<CR>")
vim.keymap.set("n", "<leader>nn", ":set nonumber<CR>")
vim.keymap.set("n", "<leader>mm", ":set mouse=<CR>")
vim.keymap.set("n", "<leader>m", ":set mouse=a<CR>")

-- Line Numbers Toggle
vim.keymap.set("n", "<leader>r", function()
  if vim.wo.relativenumber then
    vim.wo.relativenumber = false
    vim.wo.number = false
  else
    vim.wo.relativenumber = true
    vim.wo.number = true
  end
end)

-- LSP Shortcuts
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local nerd_group = augroup("NERDTreeGroup", { clear = true })

autocmd("VimEnter", {
  group = nerd_group,
  callback = function()
    local args = vim.fn.argv()
    if #args == 1 and vim.fn.isdirectory(args[1]) == 1 then
      vim.cmd("NERDTree")
      vim.cmd("wincmd p")
    else
      vim.cmd("NERDTree")
      vim.cmd("wincmd p")
    end
  end,
})

autocmd("BufEnter", {
  group = nerd_group,
  pattern = "NERD_tree_*",
  command = "execute 'normal R'",
})

autocmd("BufEnter", {
  group = nerd_group,
  callback = function()
    if vim.fn.winnr("$") == 1 and vim.b.NERDTree and vim.b.NERDTree.isTabTree then
      vim.cmd("quit")
    end
  end,
})

vim.g.neomake_python_enabled_makers = { 'pylint' }
vim.cmd([[call neomake#configure#automake('nrwi', 500)]])
