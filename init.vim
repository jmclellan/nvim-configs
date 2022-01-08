set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching brackets.
set ignorecase              " case insensitive matching
set mouse=v                 " middle-click paste with mouse
set hlsearch                " highlight search results
set tabstop=4               " number of columns occupied by a tab character
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set cc=120                  " set an 80 column border for good coding style
filetype plugin indent on   " allows auto-indenting depending on file type
syntax on                   " syntax highlighting

" ensure that plug is here by installing if it is not
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
" dont remember what ployglot is meant to do
Plug 'sheerun/vim-polyglot'
" treesitter is fucking dope and does much better syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
" langauge server
Plug 'neovim/nvim-lspconfig'
" autocompletion
Plug 'hrsh7th/nvim-cmp'
" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'


Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'preservim/nerdtree' " this is a crutch and we should probably be using netrw instead
Plug 'folke/which-key.nvim'   " ill remove this once i feel less like a beginner

Plug 'mhinz/vim-signify'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug ‘tpope/vim-commentary’
Plug ‘tpope/vim-surround’
Plug ‘tpope/vim-sensible’


Plug 'junegunn/gv.vim'
" setting up slime
Plug 'jpalardy/vim-slime'
" themes
Plug 'morhetz/gruvbox'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'altercation/vim-colors-solarized'
call plug#end()

" Netrw
let g:netrw_liststyle = 3

" airline
let g:airline#extensions#tabline#enabled = 1 " Enable the list of buffers

" automatically enter gruvbox
autocmd vimenter * ++nested colorscheme dracula

" =============================================================================
"                       Which Key Configuration 
" =============================================================================
set timeoutlen=250

lua << EOF
  require("which-key").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF

" =============================================================================
"                        Language Server Configuration
" =============================================================================
" Copied from the suggestions in the nvim-lspconfig README:
" https://github.com/neovim/nvim-lspconfig
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  --commenting out while trying nvim-compe
  --buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<CMD>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<CMD>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<CMD>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<CMD>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<CMD>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>wa', '<CMD>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<CMD>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<CMD>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<CMD>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<CMD>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<CMD>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<CMD>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<CMD>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<CMD>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<CMD>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>q', '<CMD>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<leader>f", "<CMD>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindingd when the language server attaches
local servers = { "pyright", "bashls", "yamlls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
EOF


" =============================================================================
"                             treesitter modules
" =============================================================================
lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- Modules and its options go here
  highlight = { enable = true },
  incremental_selection = { enable = true,
                            keymaps = {
                              init_selection = "gnn",
                              node_incremental = "grn",
                              scope_incremental = "grc",
                              node_decremental = "grm",
                        },
  },
  textobjects = { enable = true },
}
EOF

" =============================================================================
"                               fzf
" =============================================================================
" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R --exclude=.venv'
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
" Highlighting in preview
let $FZF_DEFAULT_OPTS = "--layout=reverse --info=inline --preview 'bat --color=always --style=header,grid --line-range :300 {}'"

" =============================================================================
"                            Pendings 
" =============================================================================

let mapleader=" "
nnoremap <Space> <Nop>

let g:fzf_command_prefix = 'Fzf'
"nnoremap <leader>f          :FzfFiles<CR> 
"nnoremap <leader>b          :FzfBuffers<CR>
"nnoremap <leader>g          :FzfGitFiles<CR>
"nnoremap <leader>t          :FzfTags<CR>     
"nnoremap <leader>r          :FzfRg<CR>   
"nnoremap <leader>c          :FzfCommits<CR>
nnoremap sf :FzfFiles<CR>
nnoremap sb :FzfBuffers<CR>
nnoremap sg :FzfGitFiles<CR>
nnoremap st :FzfTags<CR>
nnoremap sr :FzfRg<CR>
nnoremap sc :FzfCommits<CR>


