" Jan Paul's vim configuration
" Note: I don't like vim
"

set encoding=utf8
set ffs=unix,mac,dos
set history=9999

syntax enable
set background=dark
"colorscheme solarized
filetype plugin on
filetype indent on
set autoread
set shiftwidth=4
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set smarttab
set number              " show line numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]
set mat=2
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set ignorecase
set smartcase
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set ruler
set magic
nnoremap <space> za " space open/closes folds


"" no backups, we live in a git world
set nobackup
set nowb
set noswapfile

let mapleader = ","
let g:mapleader = ","
" fast saving
nmap <leader>w :w!<cr>
" :W sudo saves the file 
command W w !sudo tee % > /dev/null
set cmdheight=2

set noerrorbells
set novisualbell
set t_vb=
set tm=500
set foldcolumn=0

set lbr "use line break
set tw=120 "line break width

set ai "auto indent
set si "smart indent

" move to last file position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" status line
set laststatus=2
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

function! HasPaste()
  if &paste
    return 'PASTE MODE  '
  endif
  return ''
endfunction

" Unite
let g:unite_source_history_yank_enable = 1
try
  let g:unite_source_rec_async_command='ag --nocolor --nogroup -g ""'
  call unite#filters#matcher_default#use(['matcher_fuzzy'])
catch
endtry
" search a file in the filetree
nnoremap <space><space> :split<cr> :<C-u>Unite -start-insert file_rec/async<cr>
