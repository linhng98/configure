set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
" Plugin install
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'Yggdroot/indentLine'
Plugin 'airblade/vim-gitgutter'
Plugin 'ap/vim-buftabline'
Plugin 'dracula/vim', { 'as': 'dracula' }
Plugin 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plugin 'itchyny/lightline.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'neoclide/coc.nvim', { 'branch': 'release' }
Plugin 'preservim/nerdtree'
Plugin 'rlue/vim-barbaric'
Plugin 'ryanoasis/vim-devicons'
Plugin 'sheerun/vim-polyglot'
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-surround'

call vundle#end()            " required


"--------- AUTO INDENT ----------------------
" show existing tab with 2 spaces width
set tabstop=2
" when indenting with '>', use 2 spaces width
set shiftwidth=2
" On pressing tab, insert 2 spaces
set expandtab
"#---------------------------------------------
syntax enable
colorscheme dracula
set number
set relativenumber
set laststatus=2
set termguicolors

if has('mouse')
   set mouse=a
endif

" key binding==============
vmap <C-c> "+y
nmap <C-t> :NERDTreeToggle<CR>
nmap <C-M-i> :vertical resize +5<CR>
nmap <C-M-o> :vertical resize -5<CR>

" Save and quit
nnoremap <C-s> :w<CR>
nnoremap <C-q> :q<CR>

" Buffer
nnoremap <TAB> :bnext<CR>
nnoremap <S-TAB> :bprevious<CR>
nnoremap <LEADER>d :bp<CR>:bd #<CR>

" Clear last search highlighting
nnoremap <C-c> :noh<CR>

" nertree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" automatic jump to previous position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" coc-extensions
let g:coc_global_extensions = [
\ 'coc-json',
\ 'coc-tsserver',
\ 'coc-html',
\ 'coc-css',
\ 'coc-yaml',
\ 'coc-highlight',
\ ]


" Lightline
let g:lightline = {
    \ 'colorscheme': 'dracula',
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' }
    \ }

" Barbaric
let g:barbaric_default = 'xkb:us::eng'
