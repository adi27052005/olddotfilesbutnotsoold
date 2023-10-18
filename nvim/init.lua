--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/


  And then you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--vim.cmd("so $HOME/.config/nvim/theme.lua")

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({'n', 'v'}, ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true, buffer = bufnr, desc = "Jump to next hunk"})
        vim.keymap.set({'n', 'v'}, '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true, buffer = bufnr, desc = "Jump to previous hunk"})
      end,
    },
  },

  -- COLORSCHEMES

  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme 'onedark'
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
      },
    },
    config = function()
      -- Using Lualine as the statusline.

      -- Custom mode names.
      local mode_map = {
          ['COMMAND'] = 'COMMND',
          ['V-BLOCK'] = 'V-BLCK',
          ['TERMINAL'] = 'TERMNL',
      }
      local function fmt_mode(s) return mode_map[s] or s end

      -- Show git status.
      local function diff_source()
          local gitsigns = vim.b.gitsigns_status_dict
          if gitsigns then return { added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed } end
      end

      -- Get the current buffer's filetype.
      local function get_current_filetype() return vim.api.nvim_buf_get_option(0, 'filetype') end

      -- Get the current buffer's type.
      local function get_current_buftype() return vim.api.nvim_buf_get_option(0, 'buftype') end

      -- Get the buffer's filename.
      local function get_current_filename()
          local bufname = vim.api.nvim_buf_get_name(0)
          return bufname ~= '' and vim.fn.fnamemodify(bufname, ':t') or ''
      end

      -- Gets the current buffer's filename with the filetype icon supplied
      -- by devicons.
      local M = require('lualine.components.filetype'):extend()
      Icon_hl_cache = {}
      local lualine_require = require 'lualine_require'
      local modules = lualine_require.lazy_require {
          highlight = 'lualine.highlight',
          utils = 'lualine.utils.utils',
      }

      function M:get_current_filetype_icon()
          -- Get setup.
          local icon, icon_highlight_group
          local _, devicons = pcall(require, 'nvim-web-devicons')
          local f_name, f_extension = vim.fn.expand '%:t', vim.fn.expand '%:e'
          f_extension = f_extension ~= '' and f_extension or vim.bo.filetype
          icon, icon_highlight_group = devicons.get_icon(f_name, f_extension)

          -- Fallback settings.
          if icon == nil and icon_highlight_group == nil then
              icon = ''
              icon_highlight_group = 'DevIconDefault'
          end

          -- Set colors.
          local highlight_color = modules.utils.extract_highlight_colors(icon_highlight_group, 'fg')
          if highlight_color then
              -- local default_highlight = self:get_default_hl()
              local icon_highlight = Icon_hl_cache[highlight_color]
              if not icon_highlight or not modules.highlight.highlight_exists(icon_highlight.name .. '_normal') then
                  icon_highlight = self:create_hl({ fg = highlight_color }, icon_highlight_group)
                  Icon_hl_cache[highlight_color] = icon_highlight
              end
              -- icon = self:format_hl(icon_highlight) .. icon .. default_highlight
          end

          -- Return the formatted string.
          return icon
      end

      function M:get_current_filename_with_icon()
          local suffix = ''

          -- Get icon and filename.
          local icon = M.get_current_filetype_icon(self)
          local f_name = get_current_filename()

          -- Add readonly icon.
          local readonly = vim.api.nvim_buf_get_option(0, 'readonly')
          local modifiable = vim.api.nvim_buf_get_option(0, 'modifiable')
          local nofile = get_current_buftype() == 'nofile'
          if readonly or nofile or not modifiable then suffix = ' ' end

          -- Return the formatted string.
          return icon .. ' ' .. f_name .. suffix
      end

      local function parent_folder()
          local current_buffer = vim.api.nvim_get_current_buf()
          local current_file = vim.api.nvim_buf_get_name(current_buffer)
          local parent = vim.fn.fnamemodify(current_file, ':h:t')
          if parent == '.' then return '' end
          return parent .. '/'
      end

      local function get_native_lsp()
          local buf_ft = get_current_filetype()
          local clients = vim.lsp.get_active_clients()
          if next(clients) == nil then return '' end
          local current_clients = ''
          for _, client in ipairs(clients) do
              local filetypes = client.config.filetypes
              if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                  current_clients = current_clients .. client.name .. ' '
              end
          end
          return current_clients
      end

      -- Display the difference in commits between local and head.
      local Job = require 'plenary.job'
      local function get_git_compare()
          -- Get the path of the current directory.
          local curr_dir = vim.api.nvim_buf_get_name(0):match('(.*' .. '/' .. ')')

          -- Run job to get git.
          local result = Job:new({
              command = 'git',
              cwd = curr_dir,
              args = { 'rev-list', '--left-right', '--count', 'HEAD...@{upstream}' },
          })
              :sync(100)[1]

          -- Process the result.
          if type(result) ~= 'string' then return '' end
          local ok, ahead, behind = pcall(string.match, result, '(%d+)%s*(%d+)')
          if not ok then return '' end

          -- No file, so no git.
          if get_current_buftype() == 'nofile' then return '' end
          local string = ''
          if behind ~= '0' then string = string .. '󱦳' .. behind end
          if ahead ~= '0' then string = string .. '󱦲' .. ahead end
          return string
      end

      local text_hl
      local icon_hl

      if vim.g.colors_name == 'nordic' then
          local C = require 'nordic.colors'
          text_hl = { fg = C.gray3 }
          icon_hl = { fg = C.gray4 }
      elseif vim.g.colors_name == 'tokyonight' then
          local C = require 'tokyonight.colors'
          text_hl = { fg = C.default.fg_gutter }
          icon_hl = { fg = C.default.dark3 }
      end

      local function get_short_cwd() return vim.fn.fnamemodify(vim.fn.getcwd(), ':~') end
      local tree = {
          sections = {
              lualine_a = {
                  {
                      'mode',
                      fmt = fmt_mode,
                      icon = { '' },
                      separator = { right = ' ', left = '' },
                  },
              },
              lualine_b = {},
              lualine_c = {
                  {
                      get_short_cwd,
                      padding = 0,
                      icon = { '   ', color = icon_hl },
                      color = text_hl,
                  },
              },
              lualine_x = {},
              lualine_y = {},
              lualine_z = {
                  {
                      'location',
                      icon = { '', align = 'left' },
                  },
                  {
                      'progress',
                      icon = { '', align = 'left' },
                      separator = { right = '', left = '' },
                  },
              },
          },
          filetypes = { 'NvimTree' },
      }

      local function telescope_text() return 'Telescope' end

      local telescope = {
          sections = {
              lualine_a = {
                  {
                      'mode',
                      fmt = fmt_mode,
                      icon = { '' },
                      separator = { right = ' ', left = '' },
                  },
              },
              lualine_b = {},
              lualine_c = {
                  {
                      telescope_text,
                      color = { fg = text_hl },
                      icon = { '  ', color = icon_hl },
                  },
              },
              lualine_x = {},
              lualine_y = {},
              lualine_z = {
                  {
                      'location',
                      icon = { '', align = 'left', color = icon_hl },
                  },
                  {
                      'progress',
                      icon = { '', align = 'left', color = icon_hl },
                      separator = { right = '', left = '' },
                  },
              },
          },
          filetypes = { 'TelescopePrompt' },
      }

      require('lualine').setup {
          sections = {
              lualine_a = {
                  {
                      'mode',
                      fmt = fmt_mode,
                      icon = { '' },
                      separator = { right = ' ', left = '' },
                  },
              },
              lualine_b = {},
              lualine_c = {
                  {
                      parent_folder,
                      color = text_hl,
                      icon = { '   ', color = icon_hl },
                      separator = '',
                      padding = 0,
                  },
                  {
                      get_current_filename,
                      color = text_hl,
                      separator = ' ',
                      padding = 0,
                  },
                  {
                      'branch',
                      color = text_hl,
                      icon = { '   ', color = icon_hl },
                      separator = ' ',
                      padding = 0,
                  },
                  {
                      get_git_compare,
                      separator = ' ',
                      padding = 0,
                      color = text_hl,
                  },
                  {
                      'diff',
                      padding = 0,
                      color = text_hl,
                      icon = { ' ', color = text_hl },
                      source = diff_source,
                      symbols = { added = ' ', modified = ' ', removed = ' ' },
                      diff_color = { added = icon_hl, modified = icon_hl, removed = icon_hl },
                  },
              },
              lualine_x = {
                  {
                      'diagnostics',
                      sources = { 'nvim_diagnostic' },
                      symbols = { error = ' ', warn = ' ', info = ' ', hint = '󱤅 ', other = '󰠠 ' },
                      colored = true,
                      padding = 2,
                  },
                  {
                      get_native_lsp,
                      padding = 1,
                      separator = ' ',
                      color = text_hl,
                      icon = { ' ', color = icon_hl },
                  },
              },
              lualine_y = {},
              lualine_z = {
                  {
                      'location',
                      icon = { '', align = 'left' },
                  },
                  {
                      'progress',
                      icon = { '', align = 'left' },
                      separator = { right = '', left = '' },
                  },
              },
          },
          options = {
              disabled_filetypes = { 'dashboard' },
              globalstatus = true,
              section_separators = { left = ' ', right = ' ' },
              component_separators = { left = '', right = '' },
          },
          extensions = {
              telescope,
              ['nvim-tree'] = tree,
          },
      }

      -- Ensure correct backgrond for lualine.
      vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
          callback = function(_) require('lualine').setup {} end,
          pattern = { '*.*' },
          once = true,
      })

    end
  },

  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
  --

  -- CUSTOM PLUGINS ADDED ON TOP OF Kickstart.nvim

  -- colorschemes
  { "romgrk/doom-one.vim" },
  { "rose-pine/neovim", name="rose-pine" },
  { "AhmedAbdulrahman/aylin.vim" },
  { "sainnhe/everforest" },
  { "sainnhe/gruvbox-material" },
  { "shaunsingh/nord.nvim" },
  { "Everblush/everblush.nvim" },
  { "Shatur/neovim-ayu" },
  { "sainnhe/sonokai",
  { "AlexvZyl/nordic.nvim",
    config = function()
      require('nordic').load {
          reduced_blue = true,
          cursorline = {
              theme = 'dark',
              bold = false,
              bold_number = true,
              blend = 0.7,
    },
}
      end},
    config = function()
      vim.g.sonokai_style = 'andromeda'
      vim.g.sonokai_better_performance = 1
    end
  },
  {  "nyoom-engineering/oxocarbon.nvim" },
  { "sainnhe/edge" },

  -- Used for visualizing colors
  { "norcalli/nvim-colorizer.lua" },

  -- Automatically closing brackets and quotes
  { "jiangmiao/auto-pairs" },

  { "nvim-tree/nvim-tree.lua" },
  {
    "gelguy/wilder.nvim",
    config = function()

    end
  },
  {
    "kelly-lin/ranger.nvim",
    config = function()
      require("ranger-nvim").setup({ replace_netrw = false })
      vim.api.nvim_set_keymap("n", "<leader>ef", "", {
        noremap = true,
        callback = function()
          require("ranger-nvim").open(true)
        end,
      })
    end,
  },
  { "folke/zen-mode.nvim" },
  { "folke/twilight.nvim" },
  { "zaldih/themery.nvim",
    config = function()
      -- Minimal config
      require("themery").setup({
        themes = {"aylin", "ayu-dark", "ayu-mirage", "doom-one", "edge", "everblush", "everforest", "gruvbox-material", "nord", "nordic", "onedark", "oxocarbon", "rose-pine-main", "rose-pine-moon", "sonokai"}, -- Your list of installed colorschemes
        livePreview = true, -- Apply theme while browsing. Default to true.
        themeConfigFile = "~/.config/nvim/theme.lua", -- Described below
      })
    end},
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {}, -- Loads default behaviour
          ["core.concealer"] = {}, -- Adds pretty icons to your documents
          ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
              workspaces = {
                notes = "~/notes",
              },
            },
          },
        },
      }
    end,
  }, 
    {'romgrk/barbar.nvim',
      dependencies = {
        'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
        'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
      },
      init = function() vim.g.barbar_auto_setup = false end,
      opts = {
        -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
        -- animation = true,
        -- insert_at_start = true,
        -- …etc.
      },
      version = '^1.0.0', -- optional: only update when a new 1.x version is released
    },
    { "xiyaowong/transparent.nvim" },
    {'akinsho/toggleterm.nvim', version = "*", config = true},
    {
      'nvim-orgmode/orgmode',
      dependencies = {
        { 'nvim-treesitter/nvim-treesitter', lazy = true },
      },
      event = 'VeryLazy',
      config = function()
        -- Load treesitter grammar for org
        require('orgmode').setup_ts_grammar()

        -- Setup treesitter
        require('nvim-treesitter.configs').setup({
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = { 'org' },
          },
          ensure_installed = { 'org' },
        })

        -- Setup orgmode
        require('orgmode').setup({
          org_agenda_files = '~/orgfiles/**/*',
          org_default_notes_file = '~/orgfiles/refile.org',
        })
      end,
    },
    { "akinsho/org-bullets.nvim",
        config = function()
            require('org-bullets').setup()
        end,
    },
    -- {
    --     'lukas-reineke/headlines.nvim',
    --     dependencies = "nvim-treesitter/nvim-treesitter",
    --     config = true, -- or `opts = {}`
    -- },
    { "dhruvasagar/vim-table-mode" },
}, {})

-- CUSTOM VIM KEYMAP 

vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>th', ':Themery<CR>')
vim.keymap.set('n', '<C-t>', ':ToggleTerm direction=horizontal<CR>')
vim.keymap.set('t', '<C-t>', '<C-\\><C-n>:ToggleTerm direction=horizontal<CR>')
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('n', '<C-a>', 'ggVG')
vim.keymap.set('n', '<C-x>', ":!case $(echo $(basename %) | cut -d '.' -f2) in; 'cpp') g++ -o output % && ./output;; 'py') python3 %;; 'sh') sh -c %;; 'cs') cd %:p:h && dotnet build && dotnet run ;; *) echo 'Invalid File Type';; esac<CR>")
vim.keymap.set('n', 'J', '10zl', { noremap = true })
vim.keymap.set('n', 'K', '10zh', { noremap = true })

-- Buffer related
vim.keymap.set('n', '<A-j>', ':BufferNext<CR>')
vim.keymap.set('n', '<A-k>', ':BufferPrevious<CR>')
vim.keymap.set('n', '<A-/>', ':BufferGoto ')
vim.keymap.set('n', '<A-c><A-c>', ':BufferClose<CR>')
vim.keymap.set('n', '<A-T>', ':BufferRestore<CR>')
vim.keymap.set('n', '<A-c><A-x>', ':BufferCloseAllButCurrent<CR>')
vim.keymap.set('n', '<A-J>', ':BufferMoveNext<CR>')
vim.keymap.set('n', '<A-K>', ':BufferMovePrevious<CR>')
vim.keymap.set('n', '<A-x>', ':qa<CR>')

-- Retain selection after indentation in visual mode
vim.api.nvim_set_keymap('x', '>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<', '<gv', { noremap = true, silent = true })

-- Tab space
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.scrolloff = 10

-- Custom CMDS

vim.cmd("set cursorline")
vim.cmd("set nowrap")
-- vim.cmd("IndentBlanklineDisable")

-- Wilder.nvim for command completion
local wilder = require('wilder')
wilder.setup({modes = {':', '/', '?'}})
wilder.set_option('renderer', wilder.popupmenu_renderer(
  wilder.popupmenu_border_theme({
    highlighter = wilder.basic_highlighter(),
    min_width = '20%', -- minimum height of the popupmenu, can also be a number
    max_width = '50%', -- minimum height of the popupmenu, can also be a number
    reverse = 0,        -- if 1, shows the candidates from bottom to top
    left = {' ', wilder.popupmenu_devicons()},
    right = {' ', wilder.popupmenu_scrollbar()},
    border = 'rounded',
    max_height = '25%',      -- max height of the palette
    min_height = 0,          -- set to the same as 'max_height' for a fixed height window
    prompt_position = 'top',
  })
))

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = false

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]resume' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'c_sharp', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'kotlin'},

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('<C-k>', vim.lsp.buf.hover, 'Hover Documentation')
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.hover)
  nmap('<C-j>', vim.lsp.buf.signature_help, 'Signature Documentation')
  vim.keymap.set('i', '<C-j>', vim.lsp.buf.signature_help)

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  clangd = {},
  -- gopls = {},
  pyright = {},
  rust_analyzer = {},
  tsserver = {},
  html = { filetypes = { 'html', 'twig', 'hbs'} },
  kotlin_language_server = {},
  bashls = {},
  csharp_ls = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
  window = {
      completion = cmp.config.window.bordered(),  
    },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

-- Load kotlin
local kotlin_language_server = require "mason-lspconfig.server_configurations.kotlin_language_server"

-- NVIMTREE
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true


-- Set different flavours for sonokai theme
function SetSonokaiStyle(style)
    local valid_styles = { "default", "atlantis", "andromeda", "shusia", "maia", "espresso" }

    -- Check if the provided style is valid
    if vim.tbl_contains(valid_styles, style) then
        vim.g.sonokai_style = style
        vim.cmd("colo sonokai")
        print("Sonokai style set to: " .. style)
    else
        print("Invalid Sonokai style. Available styles are: default, atlantis, andromeda, shusia, maia, espresso")
    end
end
vim.cmd("command! -nargs=1 SetSonokaiStyle lua SetSonokaiStyle(<args>)")

-- Set different flavours for edge theme
function SetEdgeStyle(style)
    local valid_styles = { "default", "aura", "neon"}

    -- Check if the provided style is valid
    if vim.tbl_contains(valid_styles, style) then
        vim.g.edge_style = style
        vim.cmd("colo edge")
        print("edge style set to: " .. style)
    else
        print("Invalid edge style. Available styles are: default, aura, neon")
    end
end
-- Step 3: Create a custom Neovim command
vim.cmd("command! -nargs=1 SetEdgeStyle lua SetEdgeStyle(<args>)")

-- from themery
-- require('theme')
-- Load theme.lua from any directory
dofile(vim.fn.expand('~/.config/nvim/theme.lua'))

require("ibl").setup()
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 40,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
