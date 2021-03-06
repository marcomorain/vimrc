" Necesary  for lots of cool vim things
set nocompatible
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-fugitive'
Plugin 'marcomorain/vim-colorschemes'
Plugin 'groenewege/vim-less'
Plugin 'vim-scripts/paredit.vim'
Plugin 'vim-airline/vim-airline'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

syntax on
set number
set colorcolumn=80
set laststatus=2
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smarttab
set nowrap
set scrolloff=2                   " minimum lines above/below cursor
set timeoutlen=2000
set clipboard=unnamed             " use the system clipboard
set relativenumber                " show relative line numbers
set list listchars=tab:»·,trail:· " show extra space characters

" Use comma as the leader
let mapleader=","

" Space to insert a single character
nmap <space> i <esc>r

" Show red after coloum 80
match ErrorMsg '\%>80v.\+'

" Ctrl G - git grep current word
map <c-g> :Ggrep <cword><kEnter>

nmap cr :Connect nrepl://dev.circlehost:6005 ~/dev/circleci/circle<cr>

" Programming Keys:
"   F9  = Make
"   F10 = Next Error
"   F11 = Prev Error
inoremap <F9> <Esc>:make<CR>
inoremap <F10> <Esc>:cnext<CR>
inoremap <F11> <Esc>:cprev<CR>
noremap <F9> <Esc>:make<CR>
noremap <F10> <Esc>:cnext<CR>
noremap <F11> <Esc>:cprev<CR>

" CTRL S Save
"Works in normal mode, must press Esc first
map <c-s> :w<kEnter>
"Works in insert mode, saves and puts back in insert mode
imap <c-s> <Esc>:w<kEnter>

map <c-e> :%Eval<kEnter>

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l


" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>

" Make smartindent stop outdenting lines beginning with #
inoremap # X#

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" From tpope/vim-markdown
" One difference between this repository and the upstream files in Vim is that
" the former forces *.md as Markdown, while the latter detects it as Modula-2,
" with an exception for README.md. If you'd like to force Markdown without
" installing from this repository, add the following to your vimrc
autocmd BufNewFile,BufRead *.md     set filetype=markdown
autocmd BufNewFile,BufRead Fastfile set filetype=ruby
autocmd BufNewFile,BufRead *.cljs set filetype=clojure
autocmd BufNewFile,BufRead *.edn  set filetype=clojure
autocmd FileType markdown,plaintex,tex,text setlocal textwidth=78

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

" alias gr="git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short)' | pick | xargs git checkout"

" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.
function! SelectaCommand(choice_command, selecta_args, vim_command)
  try
    let selection = system(a:choice_command . " | pick " . a:selecta_args)
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

" Find all files in all non-dot directories starting in the working directory.
" Fuzzy select one of those. Open the selected file with :e.
nnoremap <leader>f :call SelectaCommand("git ls-files", "", ":e")<cr>

function! SelectaBuffer()
  let buffers = map(range(1, bufnr("$")), 'bufname(bufnr(v:val))')
  call SelectaCommand('echo "' . join(buffers, "\n") . '"', "", ":b")
endfunction

" Fuzzy select a buffer. Open the selected buffer with :b.
nnoremap <leader>b :call SelectaBuffer()<cr>

set mouse=a

set background=dark
colorscheme harlequin
