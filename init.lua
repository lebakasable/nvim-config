local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local opt = vim.opt

opt.wrap = false
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.scrolloff = 5
opt.undofile = true
vim.opt.fillchars = { eob = ' ' }

vim.g.mapleader = ' '

require('lazy').setup({
  { 'ethanholz/nvim-lastplace', opts = {} },

	{ 
		'catppuccin/nvim',
    name = 'catppuccin',
		opts = { transparent_background = true },
	},

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = { 
        component_separators = { left = '', right = '' } ,
        section_separators = { left = '', right = '' } ,
      },
      sections = {
        lualine_x = { 'filetype' },
      },
    },
  },

  { 'junegunn/fzf' },
  { 'junegunn/fzf.vim' },

  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {}
  },

  { 'tpope/vim-fugitive' },
  { 'stevearc/oil.nvim', opts = {} },

  { 'lebakasable/mochi.vim', ft = 'mochi' },

  { 'lebakasable/boba.vim', ft = 'boba' },
})

vim.cmd.colorscheme 'catppuccin'

local keymaps = {
  n = {
    ['<esc>'] = {'noh', true},
    ['<S-u>'] = {'<C-r>', true},
    ['<tab>'] = {'bn', true},
    ['<S-tab>'] = {'bp', true},
    
    ['<leader>'] = {
      f = {
        f = 'Files',
        b = 'Buffers',
        l = 'Lines',
      },
 
      x = 'bd',
      o = 'Oil',

      g = {
        g = 'G',
        i = 'G init',
        s = 'G status',
        f = 'G fetch',
        p = 'G push',
        P = 'G pull',
      },
    },
  },
}

function parse_map(mode, mapped, to)
  if type(to) == 'table' then
    if not to[1] then
      for sm, st in pairs(to) do
        parse_map(mode, mapped..sm, st)
      end
    else
      local nto = to[1]:byte(1) == 60 and to[1] or ':'..to[1]..'<cr>'
      vim.keymap.set(mode, mapped, nto, { silent = to[2] })
    end
  else
    local to = to[1] == '<' and to or ':'..to..'<cr>'
    vim.keymap.set(mode, mapped, to)
  end
end

for mode, maps in pairs(keymaps) do
  for mapped, to in pairs(maps) do
    parse_map(mode, mapped, to)
  end
end

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = "*.php",
  callback = function()
    vim.o.errorformat = "%m in %f on line %l"
  end,
})
