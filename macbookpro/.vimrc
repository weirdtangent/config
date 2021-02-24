set shell=/bin/bash
set nocompatible

" ===================================================
" Plugins
" ===================================================

call plug#begin('~/.vim/plugged')

" Syntastic                                                                                                                                                                     
"   git clone --depth=1 https://github.com/vim-syntastic/syntastic.git ~/.vim/bundle/syntastic                                                                                  
Plug 'vim-syntastic/syntastic'                                                                                                                                                  
                                                                                                                                                                                
" LanguageClient                                                                                                                                                                
" https://github.com/autozimu/LanguageClient-neovim                                                                                                                             
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh', }                                                                                           
                                                                                                                                                                                
" (Optional) Multi-entry selection UI.                                                                                                                                          
Plug 'junegunn/fzf'

" Ale
"   git clone https://github.com/dense-analysis/ale ~/.vim/bundle/ale
Plug 'w0rp/ale'

" Rust
"   git clone --depth=1 https://github.com/rust-lang/rust.vim.git ~/.vim/bundle/rust.vim
"Plug 'rust-lang/rust.vim'

" Perl
"Plug 'skaji/syntax-check-perl'

" Go
Plug 'fatih/vim-go', { 'do': 'GoUpdateBinaries' }

" CSS
"   git clone https://github.com/hail2u/vim-css3-syntax.git ~/.vim/bundle/vim-css-color
Plug 'ap/vim-css-color'

" Lightline
"   git clone https://github.com/itchyny/lightline.vim.git
Plug 'itchyny/lightline.vim'

" ===================================================
" Plugin Settings
" ===================================================

" ale/perl
let g:ale_linters = {
  \  'perl': ['syntax-check'],
  \  'go': ['gometalinter', 'gofmt'],
\ }
let g:ale_fixers = {
  \  '*': ['remove_trailing_lines', 'trim_whitespace'],
  \  'go': ['gofmt'],
\ }

" rust
"let $RUST_SRC_PATH = systemlist("rustc --print sysroot")[0] . "/lib/rustlib/src/rust/src"
let g:rustfmt_command = "rustfmt +nightly"
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_clip_command = 'xclip -selection clipboard'

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

" checkers
let g:syntastic_rust_checkers = ['cargo']

" Lightline
"let g:lightline = { 'colorscheme': 'wombat' }
"let g:lightline = { 'component_function': { 'filename': 'LightlineFilename', }, }
let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste'],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'syntastic', 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ],
      \ },
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag',
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \ },
\ }

function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.rs call s:syntastic()
augroup END
function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction

set laststatus=2

call plug#end()

" ===================================================
" Editor settings
" ===================================================

filetype plugin indent on
filetype plugin on

set relativenumber
set hlsearch
set incsearch
set timeoutlen=300 " http://stackoverflow.com/questions/2158516/delay-before-o-opens-a-new-line
set autoindent
set timeoutlen=300
set encoding=utf-8
set scrolloff=2
set noshowmode
set hidden
set nowrap
set nojoinspaces
set printfont=:h10
set printencoding=utf-8
set printoptions=paper:letter
set signcolumn=yes

set splitright
set splitbelow

set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

set mouse-=a
set path+=**
set tags=./tags,tags

" Proper search
set incsearch
set ignorecase
set smartcase
set gdefault

set cmdheight=2

" fix paste
set pastetoggle=pt

" Permanent undo
set undodir=~/.vimdid
set undofile

syntax on
set background=dark
colorscheme badwolf

" ===================================================
" Keyboad shortcuts
" ===================================================

" fix paste
set pastetoggle=<F2>

syntax on
set background=dark
colorscheme badwolf

nmap <silent> pm :set invpaste<CR>
nmap <silent> ln :set invrnu<CR>

" =============================================================================
" Autocommands
" =============================================================================

" Leave paste mode when leaving insert mode
autocmd InsertLeave * set nopaste

" Jump to last edit position on opening file
" https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
