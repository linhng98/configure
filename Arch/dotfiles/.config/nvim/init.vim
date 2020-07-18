set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
"Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'dracula/vim', { 'name': 'dracula' }
Plugin 'preservim/nerdtree'
Plugin 'ryanoasis/vim-devicons'
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
Plugin 'Yggdroot/indentLine'

call vundle#end()            " required
filetype plugin indent on    " required

"--------------------------------------------
syntax enable
colorscheme dracula
set number
set relativenumber
set laststatus=0
set termguicolors
set expandtab

if has('mouse')
   set mouse=a
endif

vmap <C-c> "+y
nmap <C-t> :NERDTreeToggle<CR>
nmap <C-M-i> :vertical resize +5<CR>
nmap <C-M-o> :vertical resize -5<CR>
nmap <C-M-f> :Format<CR>

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"--------- AUTO INDENT ----------------------
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
"#---------------------------------------------

" automatic jump to previous position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

