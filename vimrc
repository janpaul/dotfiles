execute pathogen#infect()
syntax on
filetype plugin indent on
set updatetime=100
set showcmd
set autoindent
set shiftwidth=2
set softtabstop=2
set tabstop=2
set number
set ignorecase
set smartcase
set incsearch
set hlsearch
set expandtab
set encoding=utf-8
set linebreak
set wrap
set ruler
set cursorline
set relativenumber
set backupdir=~/.cache/vim
set dir=~/.cache/vim

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
