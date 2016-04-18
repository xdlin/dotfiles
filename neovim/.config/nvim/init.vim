call plug#begin('~/.config/nvim/plugged')
"Syntax
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-git', { 'for': 'git' }
"UI
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug 'yggdroot/indentLine'
"Tool
Plug 'bufexplorer.zip'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ervandew/supertab'
Plug 'majutsushi/tagbar'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-unimpaired'
"dev
Plug 'scrooloose/syntastic'
Plug 'racer-rust/vim-racer'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" neovim
Plug 'shougo/deoplete.nvim'
Plug 'benekastah/neomake'

call plug#end()

set fileencodings=utf-8,gbk,latin1
set background=dark
set t_Co=256
set hidden
set tabstop=4 shiftwidth=4 expandtab
colo solarized
"
" plugin settings
let g:airline_powerline_fonts = 1
let g:deoplete#enable_at_startup = 1
let g:indentLine_char = "¦"

nnoremap <silent> <F1> :NERDTreeToggle<CR>
nnoremap <silent> <F2> :CtrlPTag<CR>
nnoremap <silent> <F3> :CtrlPBuffer<CR>
nnoremap <silent> <F4> :CtrlPMRUFiles<CR>
nnoremap <silent> <F5> :make<CR>
nnoremap <silent> <F6> :e $MYVIMRC<CR>
nnoremap <silent> <F11> :TagbarToggle<CR>
nnoremap <silent> <F12> :NERDTreeToggle<CR>

command! CN :e ++enc=cp936
command! CU :e ++enc=utf-8
command! Cd :cd %:p:h
