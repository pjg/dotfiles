" VIM-PLUG

" automatic installation of vim-plug if it's not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" plugins

call plug#begin('~/.vim/plugged')

" file finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" file navigation/management
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-vinegar'
Plug 'pbrisbin/vim-mkdir'

" git related
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'

" colors (parenthesis, css colors, etc.)
Plug 'luochen1990/rainbow'
Plug 'chrisbra/Colorizer'

" Ruby related
Plug 'ecomba/vim-ruby-refactoring'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'

" text objects
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'bootleq/vim-textobj-rubysymbol'
Plug 'michaeljsmith/vim-indent-object'
Plug 'wellle/targets.vim'

if has("nvim")
  Plug 'neovim/nvim-lspconfig'

  " code completion (nvim only)
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'

  " code formatting
  Plug 'stevearc/conform.nvim'

  " AI code completion
  Plug 'zbirenbaum/copilot.lua'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'CopilotC-Nvim/CopilotChat.nvim', { 'branch': 'main' }

  " Syntax highlighting
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  " text editing improvements
  Plug 'gbprod/substitute.nvim'
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'
else
  " Regular VIM

  " code completion (vim only)
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }

  " AI code completion
  Plug 'github/copilot.vim'
endif

" syntax highlighting (vim/nvim)
Plug 'vim-ruby/vim-ruby'
Plug 'keith/rspec.vim'
Plug 'pangloss/vim-javascript'
Plug 'AndrewRadev/vim-jsx-pretty'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

" grepping files from vim
Plug 'mileszs/ack.vim'

" text editing improvements
Plug 'AndrewRadev/splitjoin.vim'
Plug 'godlygeek/tabular'
Plug 'terryma/vim-multiple-cursors'
Plug 'suy/vim-context-commentstring'
Plug 'tpope/vim-commentary'
Plug 'itspriddle/vim-stripper'

" general vim improvements
Plug 'andymass/vim-matchup'
Plug 'sickill/vim-pasta'
Plug 'mbbill/undotree'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-endwise'
Plug 'alvan/vim-closetag'
Plug 'LunarWatcher/auto-pairs'
Plug 'junegunn/vim-peekaboo'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'justinmk/vim-sneak'
Plug 'lambdalisue/suda.vim'
Plug 'nelstrom/vim-visual-star-search'
Plug 'bogado/file-line'
Plug 'pechorin/any-jump.vim'

" statusline (and related)
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'

call plug#end()



" BASIC SETTINGS

" no vi compatible mode
set nocompatible

" syntax highlight on
syntax on

" when determining syntax highlighting for the current line, always look at the entire file
augroup ResetSyntaxHighlighting
  autocmd!
  autocmd BufNewFile,BufRead,BufEnter * syntax sync fromstart
augroup END

" syntax coloring up until column number
set synmaxcol=300

" you can change buffers without saving
set hidden

" do not autoresize windows
set noequalalways

" Resize splits when the window is resized
autocmd VimResized * :wincmd =

" split below/right
set splitbelow
set splitright

" no backup files
set nobackup
set nowritebackup

" show line numbers
set number
set numberwidth=2

" also show relative numbers, besides current line (Vim 7.4+)
set relativenumber

" highlight searches
set hlsearch

" find as you type
set incsearch

" smartcase -- normally ignores case, but when we type uppercase character in search box it will be CASE SENSITIVE
set ignorecase smartcase

" always display current cursor position
set ruler

" make it obvious where the textwidth is
set colorcolumn=+1

" display incomplete commands
set showcmd

" lazy redraw the screen
set lazyredraw

" explicitly set ttyfast
set ttyfast

" 256-color VIM
set t_Co=256

" colorscheme
colorscheme beautiful256

" enable 24-bit colors in the terminal
set termguicolors

" GUI settings (MacVIM/gVim)
if has("gui_running")
  " encoding
  set encoding=utf-8

  " Windows
  if has("win32")
    " font
    set guifont=DejaVu_Sans_Mono:h10:cEASTEUROPE

    " simulate alt key behaviour
    autocmd GUIEnter * simalt ~s

    " use shellslash
    set shellslash

  " MacOS
  elseif has("mac")
    " font
    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h14

    " disable scrollbars in MacVim
    set guioptions=

    " default window size
    set columns=248
    set lines=87

    " special font configuration for neovide
    if exists("g:neovide")
      set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h14:#e-subpixelantialias:#h-full
    endif

  " Unix/Linux
  elseif has("unix")
    " font
    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10

    " window position / size
    winpos 70 40
    winsize 140 50

    " set English language in Vim's UI
    language en_US.utf8
    language messages en_US.utf8
  endif
endif

" enable filetype detection and filetype-specific plugins and indenting
filetype plugin indent on

" do not wrap lines
set nowrap

" wrap around beginning and end of file when searching
set wrapscan

" autoindent
set autoindent

" by default TABS are standard 8 characters filled with SPACES (expandtab) with softtabstop at 2 (TAB moves 2 characters); indent stays at 2 characters (shiftwidth)
set tabstop=8
set softtabstop=2
set shiftwidth=2
set expandtab

" round indent to multiple of 'shiftwidth' (applies to > and < commands)
set shiftround

" set virtual edit only when in visual block selection mode
set virtualedit=block

" the /g flag on :s substitutions by default
set gdefault

" keep 3 lines (top/bottom) for scope when scrolling
set scrolloff=3
set sidescrolloff=3

" avoid moving cursor to BOL when jumping around
set nostartofline

" briefly jump to a parenthesis once it's balanced (but only for 200ms)
set showmatch
set matchtime=2

" keep longer vim commands history
set history=500

" show available TAB-completions in command line
set wildmenu

" have TAB-completion behave similarly to a shell (i.e. complete the longest part, then cycle through the matches)
set wildmode=longest:full,full

" ignore these files and directories when completing names and in Explorer
set wildignore=*.o,*.out,*.obj,.git,*.rbc,*.class,.svn,*.gem                 " output & scm files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz                      " archive files
set wildignore+=*.jpg,*.jpeg,*.png,*.xpm,*.gif,*.bmp                         " pictures
set wildignore+=public/*                                                     " rails/gatsby public
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/* " bundler and sass
set wildignore+=*/node_modules/*                                             " node modules
set wildignore+=*/log/*,*.log,*/coverage/*                                   " logs and rcov
set wildignore+=*.swp,*~,._*                                                 " swp and backup files
set wildignore+=*/.cache/*                                                   " gatsby cache

" short messages in command line (so that they don't overflow and require pressing <ENTER>) (h :shortmess)
set shortmess=acoOtI

" disable visual/audible bells
set noerrorbells
set visualbell
set t_vb=
autocmd GUIEnter * set vb t_vb=

" time out on key codes but not on mappings
set notimeout
set ttimeout
set ttimeoutlen=5

" allow backspacing over autoindent, EOL, and BOL
set backspace=2

" never write unless requested
set noautowrite
set noautowriteall

" never automatically re-read files changed outside of vim
set noautoread

" write swap files after some inactivity [ms] (will trigger coc)
" cannot be too low, otherwise eslint messages will be disappearing
set updatetime=500

" global directory for .swp files
set directory=$HOME/.vim/tmp/

" yes/no/cancel prompt if closing with unsaved changes
set confirm

" persistent undo (preserved after restarting vim) (separate between vim/nvim due to incompatibilities)
set undofile

if has("nvim")
  set undodir=$HOME/.vim/undo-nvim/
else
  set undodir=$HOME/.vim/undo-vim/
endif

" mouse support in xterm
set mouse=a

" inverse space as a vsplit character (instead of |)
set fcs+=vert:\ " the space after the backslash is intentional

" always start on first line when editing git commit message
autocmd FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" automatically open files in read-only mode if swapfile exists
augroup NoSimultaneousEdits
  autocmd!
  autocmd SwapExists * let v:swapchoice = 'o'
  autocmd SwapExists * echohl ErrorMsg
  autocmd SwapExists * echo 'Duplicate edit session (readonly)'
  autocmd SwapExists * echohl None
  autocmd SwapExists * sleep 1
augroup END

" netrw configuration sort files case insensitive
let g:netrw_sort_options = "i"

" netrw 1 level of dir history (more performance)
let g:netrw_dirhistmax = 1

" fast directory browsing
let g:netrw_fastbrowse = 2

" tree style listing
let g:netrw_liststyle = 3

" add path for tags created by git hooks
set tags+=.git/tags

" cursor shape
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" explicit window separator
set fillchars+=vert:▊

" set ruby for neovim/goneovim/VimR using chruby
let g:ruby_host_prog = '~/bin/chruby-wrapper'

" set python3 for neovim
if executable('/opt/homebrew/bin/python3')
  let g:python3_host_prog = '/opt/homebrew/bin/python3'
endif

" neovide.dev
if exists("g:neovide")
  " disable all animations
  let g:neovide_position_animation_length = 0
  let g:neovide_cursor_animation_length = 0
  let g:neovide_scroll_animation_far_lines = 0
  let g:neovide_scroll_animation_length = 0
endif



" FILE TYPES

" set fixed columns only for some file types
autocmd FileType * setlocal textwidth=0
autocmd FileType ruby,eruby,javascript,javascript.jsx,javascript.tsx,vue,css,scss setlocal textwidth=80
autocmd FileType gitcommit setlocal textwidth=72

" set various characters to be treated as a part of words
autocmd FileType lisp,clojure,html,xml,xhtml,haml,eruby,css,scss,sass,less,javascript,javascript.jsx,javascript.tsx,coffee,yaml setlocal iskeyword+=-,$,#
autocmd FileType scss,sass,less,ruby,eruby setlocal iskeyword+=@

augroup filetypedetect
  " YAML files read as Ruby
  autocmd BufNewFile,BufRead {*.yml} setfiletype eruby

  " ActiveAdmin views read as Ruby
  autocmd BufNewFile,BufRead {*.arb} setfiletype ruby

  " 2 spaces for TAB in JS/CSS/HTML files
  autocmd BufNewFile,BufRead {*.css,*.scss,*.sass,*.html,*.html.erb,*.js,*.jsx,*.tsx,*.svg} setlocal softtabstop=2 tabstop=2 shiftwidth=2

  " explicitly set filetype to Ruby for some well-known files
  autocmd BufNewFile,BufRead {Gemfile,Rakefile,Vagrantfile,Thorfile,Procfile,Capfile,Guardfile,.Guardfile,config.ru,importmap,.railsrc,.irbrc,.pryrc} set filetype=ruby

  " explicitly set filetype to shell for dotenv's files
  autocmd BufRead,BufNewFile {.env.development.local,.env.production,.env.sample,.env.test} set filetype=sh

  " explicitly set filetype to slim for slim view files (not sure why it's needed...)
  autocmd BufNewFile,BufRead {*.html.slim} set filetype=slim

  " explicitly set filetype to JSON for some well-known files
  autocmd BufNewFile,BufRead {.prettierrc} set filetype=json

  " set filetype for React files
  autocmd BufNewFile,BufRead {*.jsx} set filetype=javascript.jsx

  " set filetype for Typescript files
  autocmd BufNewFile,BufRead {*.tsx} set filetype=javascript.tsx

  " [rspec.vim] fix filetype set by rspec.vim
  autocmd BufNewFile,BufRead *_spec.rb,*_shared_examples.rb,*_shared_context.rb set filetype=ruby syntax=rspec
augroup END


" ADVANCED SETTINGS

" reposition the cursor in the buffer after reopening vim
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif



" ABBREVIATIONS

abbreviate apge page
abbreviate glboal global
abbreviate ilke like
abbreviate invitaion invitation
abbreviate invitaiton invitation
abbreviate invitatoin invitation
abbreviate pgae page
abbreviate recieve receive
abbreviate sgined signed
abbreviate taht that
abbreviate teh the
abbreviate tewak tweak
abbreviate upadting updating
abbreviate coudln couldn

" Rails specific
abbreviate bpr binding.pry;
abbreviate brp binding.pry;



" KEY MAPPINGS

" have Y behave analogously to D and C rather than to dd and cc (which is already done by yy)
noremap Y y$

" swap ` with ' (so that ' will jump to line *and* column)
nnoremap ' `
nnoremap ` '

" scroll faster & move cursor too
nnoremap <c-e> 3<c-e>3j
nnoremap <c-y> 3<c-y>3k
vnoremap <c-e> 3<c-e>3j
vnoremap <c-y> 3<c-y>3k

" move faster between windows
nmap <c-h> <c-w>h
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-l> <c-w>l

" resize window
nmap <C-S-h> <C-w><
nmap <C-S-l> <C-w>>
nmap <C-S-k> <C-w>+
nmap <C-S-j> <C-w>-

" improve movement on wrapped lines
nnoremap j gj
nnoremap k gk
nnoremap $ g$
nnoremap ^ g^
nnoremap 0 g0
vnoremap j gj
vnoremap k gk
vnoremap $ g$
vnoremap ^ g^
vnoremap 0 g0

" go to home/end using capitalized directions
noremap H ^
noremap L $

" make g$/g^/g0 go to 'true' home/end
nnoremap g$ $
nnoremap g^ ^
nnoremap g0 0
vnoremap g$ $
vnoremap g^ ^
vnoremap g0 0

" gw to swap the current word with the one next to it
nmap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<cr>'':nohlsearch<cr>

" CTRL+s always saves file
nmap <c-s> :w<cr>
vmap <c-s> <esc><c-s>
imap <c-s> <esc><c-s>

" CTRL+q quits
nmap <c-q> :q<cr>
imap <c-q> <esc><c-q>

" tab/s-tab to move between tabs
nnoremap <silent> <tab> :tabnext<cr>
nnoremap <silent> <s-tab> :tabprevious<cr>

" use sane regexes
nnoremap / /\v
vnoremap / /\v

" don't move on star search (*)
nnoremap * :keepjumps normal! mi*`i<CR>

" keep search matches in the middle of the window
nnoremap n nzzzv
nnoremap N Nzzzv

" same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz

" gi already moves to 'last place you exited insert mode', so we'll map gI to something similar: move to last change
nnoremap gI `.

" lists navigation
nnoremap <left> :cprev<cr>zvzz
nnoremap <right> :cnext<cr>zvzz
nnoremap <up> :lprev<cr>zvzz
nnoremap <down> :lnext<cr>zvzz

" quickselect tabs with CMD + #
nnoremap <D-1> :tabn 1<CR>
nnoremap <D-2> :tabn 2<CR>
nnoremap <D-3> :tabn 3<CR>
nnoremap <D-4> :tabn 4<CR>
nnoremap <D-5> :tabn 5<CR>
nnoremap <D-6> :tabn 6<CR>
nnoremap <D-7> :tabn 7<CR>
nnoremap <D-8> :tabn 8<CR>
nnoremap <D-9> :tabn 9<CR>

inoremap <D-1> <C-o>:tabn 1<cr><Esc>
inoremap <D-2> <C-o>:tabn 2<cr><Esc>
inoremap <D-3> <C-o>:tabn 3<cr><Esc>
inoremap <D-4> <C-o>:tabn 4<cr><Esc>
inoremap <D-5> <C-o>:tabn 5<cr><Esc>
inoremap <D-6> <C-o>:tabn 6<cr><Esc>
inoremap <D-7> <C-o>:tabn 7<cr><Esc>
inoremap <D-8> <C-o>:tabn 8<cr><Esc>
inoremap <D-9> <C-o>:tabn 9<cr><Esc>

" pasting
nnoremap <D-v> a<C-r>+<Esc>
inoremap <D-v> <C-r>+
cnoremap <D-v> <C-r>+

" new tab
nnoremap <D-t> :tabnew<cr>
inoremap <D-t> <C-o>:tabnew<cr>

" disable F1 binding for help
nnoremap <F1> <Nop>
inoremap <F1> <Nop>
vnoremap <F1> <Nop>

" F10 to wipe buffer
nnoremap <F10> :bwipeout<cr>

" polish letters (goneovim requires those mappings)
if exists('g:goneovim')
  inoremap <M-a> ą
  inoremap <M-c> ć
  inoremap <M-e> ę
  inoremap <M-l> ł
  inoremap <M-n> ń
  inoremap <M-o> ó
  inoremap <M-s> ś
  inoremap <M-x> ź
  inoremap <M-z> ż
  inoremap <M-A> Ą
  inoremap <M-C> Ć
  inoremap <M-E> Ę
  inoremap <M-L> Ł
  inoremap <M-N> Ń
  inoremap <M-O> Ó
  inoremap <M-S> Ś
  inoremap <M-X> Ź
  inoremap <M-Z> Ż
endif



" INSERT MODE KEY MAPPINGS

" Ruby: convert word into Ruby symbol
imap <C-k> <C-o>b:<Esc>Ea

" basic readline shortcuts
inoremap <c-a> <esc>I
inoremap <c-e> <esc>A


" VISUAL MODE KEY MAPPINGS

" reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" press Shift+P while in visual mode to replace the selection without overwriting the default register
vmap P p :call setreg('"', getreg('0')) <cr>

" make backspace work sanely in visual mode
vnoremap <bs> x

" select entire buffer
nnoremap vaa ggvGg_
nnoremap Vaa ggVG

" fix linewise visual selection of various text objects
nnoremap VV V
nnoremap Vit vitVkoj
nnoremap Vat vatV
nnoremap Vab vabV
nnoremap VaB vaBV


" COMMAND LINE KEY MAPPINGS

" bash like keys for the command line
cnoremap <c-a> <Home>
cnoremap <c-e> <End>
cnoremap <c-p> <Up>
cnoremap <c-n> <Down>
cnoremap <c-b> <Left>
cnoremap <c-f> <Right>
cnoremap <c-d> <Del>
cnoremap <c-k> <C-\>estrpart(getcmdline(), 0, getcmdpos()-1)<cr>

" swap <Up>/<Down> with <PageUp>/<PageDown>
cnoremap <Up> <S-Up>
cnoremap <PageUp> <Up>
cnoremap <Down> <S-Down>
cnoremap <PageDown> <Down>



" LEADER KEY MAPPINGS

" leader/localleader mappings
let mapleader = "\<space>"
let localmapleader = "\\"

" select all text in current buffer
nmap <leader>A ggVG

" upper/lower word
nmap <leader>u mQviwU'Q
nmap <leader>l mQviwu'Q

" upper/lower first char of word
nmap <leader>U mQgewvU'Q
nmap <leader>L mQgewvu'Q

" fugitive.vim
nmap <leader>gb :Git blame<cr>
nmap <leader>gc :Git commit<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gl :!git l<cr>
nmap <leader>gp :Git push<cr>
nmap <leader>gr :GRemove!<cr>
nmap <leader>gs :Gstatus<cr>
nmap <leader>gw :Gwrite<cr>

" vimdiff conflict resolution for 3-way merge
map <Leader>g1 :diffget LOCAL<CR>
map <Leader>g2 :diffget BASE<CR>
map <Leader>g3 :diffget REMOTE<CR>

" fzf.vim
map <leader>t :Files<cr>
map <leader>b :Buffers<cr>
map <leader>h :History<cr>

" delete current buffer
noremap <leader>c :bdelete<cr>

" quit
nmap <leader>q :q<cr>

" save file / all files
map <leader>w :w<cr>
map <leader>W :wall<cr>

" [vim-rails] Rake
map <leader>rr :.Rake<cr>

" system clipboard interaction
noremap <leader>d "*d
noremap <leader>D "*d$
noremap <leader>y "*y
noremap <leader>Y "*y$
nnoremap <leader>p :set paste<cr>"*p:set nopaste<cr>
nnoremap <leader>P :set paste<cr>"*P:set nopaste<cr>

" select just pasted text
noremap <leader>V V`]

" easier splits
noremap <leader>s <C-w>s
noremap <leader>v <C-w>v

" adjust viewports to the same size
map <leader>= <C-w>=

" make current window max height
noremap <leader>- <C-w>_

" underline the current line
nmap <silent> <leader>1 :t.<CR>Vr-
nmap <silent> <leader>2 :t.<CR>Vr=

" turn line wrap on/off
nmap <leader>4 :set wrap!<cr>

" Undotree
nmap <leader>6 :UndotreeToggle<cr>

" turn off the highlight search & redraw screen, sign column, statusline, colors
nmap <leader>8 :syntax sync fromstart<cr>:nohlsearch<cr>:redrawstatus!<cr>:redraw!<cr>:GitGutter<cr>

" toggle the paste mode (when vim either adds or not spaces in the front of lines)
set pastetoggle=<leader>0


" quick insertion of newline in normal mode
nnoremap <silent> <cr> :-1put=''<cr><down>

" convert file to utf-8 and cleanup whitespace garbage
map <leader>xx :call CleanupFileConvertToUnixUtf8()<cr>

function! CleanupFileConvertToUnixUtf8()
  " insert 'tabstop' characters instead of <TAB>s
  execute '%retab!'
  " UNIX fileformat
  set fileformat=unix
  " UTF-8 encoding by default
  set fileencoding=utf-8
  " cleanup trailing whitespace
  execute '%s/\s\+$//e'
endfunction

" vim-vinegar/netrw overrides

augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END

function! NetrwMapping()
  " <C-l> to move right
  noremap <buffer> <C-l> <C-w>l

  " <C-^> to quit netrw / return to the previous buffer
  nnoremap <buffer> <C-^> :Rexplore<cr>
endfunction



" STATUSLINE

" always show the status line
set laststatus=2

" don't show mode text (which vim shows below the statusline)
set noshowmode

" [lightline.vim]
fun! WhitespaceStatus() abort
  let elements = []

  " empty lines at the EOF
  let s:contains_empty_lines = search('\v($\n\s*)+%$', 'nw')

  " mixed indentation
  if &expandtab
    " If spaces are being used and we find a line starting with tab.
    let s:contains_mixed_indent = search('\v(^( +)?\t+)', 'nw')
  el
    " We only check mixed indents (tabs + spaces)
    let s:contains_mixed_indent = search('\v(^\t+ +)|(^ +\t+)', 'nw')
  en

  " trailing whitespace
  let s:contains_trailing_whitespaces = search('\v\s+$', 'nw')

  if s:contains_empty_lines > 0
    let elements = elements + ['empty-lines' . ':' . s:contains_empty_lines]
  en

  if s:contains_mixed_indent > 0
    let elements = elements + ['mixed-indent' . ':' . s:contains_mixed_indent]
  en

  if s:contains_trailing_whitespaces > 0
    let elements = elements + ['trailing' . ':' . s:contains_trailing_whitespaces]
  en

  return join(elements, ' ')
endf

let g:lightline = {
  \   'colorscheme': 'wombat',
  \   'active': {
  \     'left': [['mode', 'paste'], ['filename', 'readonly', 'modified']],
  \     'right': [['lineinfo'], ['percent'], ['whitespace_status'], ['fileformat', 'fileencoding', 'filetype']]
  \   },
  \   'inactive': {
  \     'left': [['filename'], ['modified']],
  \     'right': [['lineinfo'], ['percent']]
  \   },
  \   'component_expand': {
  \     'whitespace_status': 'WhitespaceStatus'
  \   },
  \   'component_type': {
  \     'whitespace_status': 'warning'
  \   }
  \ }

" in wombat colorscheme swap normal/insert colors
let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette

let old_normal_left = s:palette.normal.left
let old_insert_left = s:palette.insert.left

let s:palette.normal.left = old_insert_left
let s:palette.insert.left = old_normal_left

" update on write
autocmd BufWritePost * call lightline#update()



" PLUGINS

" [ack.vim] (using ag aka 'the_silver_searcher')
if executable('ag')
  let g:ackprg = 'ag --vimgrep --smart-case'
  cnoreabbrev ag Ack
  cnoreabbrev aG Ack
  cnoreabbrev Ag Ack
  cnoreabbrev AG Ack
endif

" [autoclose.vim]
let g:AutoCloseProtectedRegions = ["Comment"]

" [vim-ragtag]
inoremap <M-o> <Esc>o
inoremap <C-j> <Down>
let g:ragtag_global_maps = 1

" [fzf.vim]
let g:fzf_buffers_jump = 0
let g:fzf_layout = { 'down': '10' }

" required for VimR/MacVim (MacOS)
let $FZF_DEFAULT_COMMAND = 'ag --nocolor --ignore-dir=./public --ignore-dir=./node_modules --ignore-dir=./.cache --ignore-dir=./tmp --ignore-dir=./vendor/bundle --ignore-dir=./vendor/plugins --ignore=''*.jpg'' --ignore=''*.png'' --ignore=''*.svg'' -g ""'

" hl  (non matched lines, matched letters fg)
" fg+ (first matched line fg)
" bg+ (first matched line bg)
" hl+ (first matched line: matched letters fg)
let g:fzf_colors = {
  \ 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'helpNote'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" [fugitive.vim] auto clean fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete

" [vim-multiple-cursors]
let g:multi_cursor_exit_from_insert_mode = 1

" [vim-ruby] compatibility with standardrb
let g:ruby_indent_assignment_style = 'variable'
let g:ruby_indent_hanging_elements = 0

" [vim-rails / rails.vim] custom commands
command! Ecircle edit .circleci/config.yml
command! Edatabase edit config/database.yml
command! Egemfile edit Gemfile
command! Ejroutes Ejinitializer
command! Eprocfile edit Procfile
command! Erailshelper edit spec/rails_helper.rb
command! Ereadme edit README.md
command! Eroutes edit config/routes.rb
command! Esecrets edit config/secrets.yml
command! Eseeds edit db/seeds.rb
command! Espechelper edit spec/spec_helper.rb
command! Estructure edit db/structure.sql

" [vim-rails] Rails projections - typing `:Eservice accept_bid` will open /app/services/accept_bid.rb, etc.
let g:rails_projections = {
    \   "app/services/*.rb": {
    \     "command":   "service",
    \     "affinity":  "collection",
    \     "test":      "spec/services/{}_spec.rb",
    \     "template":  "class {camelcase|capitalize|colons}\nend"
    \   },
    \   "app/core/*.rb": {
    \     "command":   "core",
    \     "affinity":  "collection",
    \     "test":      "spec/core/{}_spec.rb",
    \     "template":  "class {camelcase|capitalize|colons}\nend"
    \   },
    \   "app/gateways/*_gateway.rb": {
    \     "command":   "gateway",
    \     "affinity":  "collection",
    \     "test":      "spec/gateways/{}_spec.rb",
    \     "template":  "class {camelcase|capitalize|colons}\nend"
    \   },
    \   "app/finders/*.rb": {
    \     "command":   "finder",
    \     "affinity":  "collection",
    \     "test":      "spec/finders/{}_spec.rb",
    \     "template":  "class {camelcase|capitalize|colons}\nend"
    \   },
    \   "app/controllers/api/*_controller.rb": {
    \     "command":   "apicontroller",
    \     "test":      "spec/controllers/api/{}_controller_spec.rb",
    \     "template":  "class Api::{camelcase|capitalize|colons}Controller < Api::ApplicationController\nend"
    \   },
    \   "spec/requests/*_spec.rb": {
    \     "command":   "request",
    \     "template":  "describe '{underscore|capitalize|blank}' do\n\nend"
    \   },
    \   "spec/support/*.rb": {
    \     "command":   "support"
    \   },
    \   "spec/system/*_spec.rb": {
    \     "command":   "system",
    \     "template":  "describe '{underscore|capitalize|blank}' do\n\nend"
    \   }
    \ }

" [vim-rails] gem projections - typing `:Efactory users` will open the users factory, etc.
let g:rails_gem_projections = {
    \   "factory_bot": {
    \     "test/factories/*.rb": {
    \       "command":    "factory",
    \       "affinity":   "collection",
    \       "alternate":  "app/models/{singular}.rb",
    \       "collection": "model",
    \       "related":    "db/schema.rb#{}",
    \       "test":       "test/models/{singular}_test.rb",
    \       "template":   "FactoryBot.define do\n  factory :{singular} do\n  end\nend",
    \       "keywords":   "factory sequence"
    \     },
    \     "spec/factories/*.rb": {
    \       "command":    "factory",
    \       "affinity":   "collection",
    \       "alternate":  "app/models/{singular}.rb",
    \       "collection": "model",
    \       "related":    "db/schema.rb#{}",
    \       "test":       "spec/models/{singular}_test.rb",
    \       "template":   "FactoryBot.define do\n  factory :{singular} do\n  end\nend",
    \       "keywords":   "factory sequence"
    \     }
    \   },
    \   "factory_girl": {
    \     "test/factories/*.rb": {
    \       "command":   "factory",
    \       "affinity":  "collection",
    \       "alternate": "app/models/{singular}.rb",
    \       "related":   "db/schema.rb#{}",
    \       "test":      "test/models/{singular}_test.rb",
    \       "template":  "FactoryGirl.define do\n  factory :{singular} do\n  end\nend",
    \       "keywords":  "factory sequence"
    \     },
    \     "spec/factories/*.rb": {
    \       "command":   "factory",
    \       "affinity":  "collection",
    \       "alternate": "app/models/{singular}.rb",
    \       "related":   "db/schema.rb#{}",
    \       "test":      "spec/models/{singular}_test.rb",
    \       "template":  "FactoryGirl.define do\n  factory :{singular} do\n  end\nend",
    \       "keywords":  "factory sequence"
    \     }
    \   },
    \   "settingslogic": {
    \     "config/application.yml": {
    \       "command":   "settings"
    \     }
    \   },
    \   "config": {
    \     "config/settings.yml": {
    \       "command":   "settings"
    \     }
    \   },
    \   "capistrano": {
    \     "config/deploy.rb": {
    \       "command":   "deploy"
    \     }
    \   },
    \   "capybara": {
    \     "spec/features/*_spec.rb": {
    \       "command":   "feature",
    \       "template":  "feature '{underscore|capitalize|blank}' do\n\nend"
    \     }
    \   },
    \   "activeadmin": {
    \     "app/admin/*.rb": {
    \       "command":   "admin",
    \       "affinity":  "model",
    \       "test":      "spec/admin/{}_spec.rb",
    \       "related":   "app/models/{singular}.rb",
    \       "template":  "ActiveAdmin.register {camelcase|capitalize|colons} do\n  config.sort_order = 'created_at_desc'\nend"
    \     }
    \   },
    \   "active_model_serializers": {
    \     "app/serializers/*_serializer.rb": {
    \       "command":   "serializer",
    \       "affinity":  "model",
    \       "test":      "spec/serializers/{}_spec.rb",
    \       "related":   "app/models/{}.rb",
    \       "template":  "class {camelcase|capitalize|colons}Serializer < ActiveModel::Serializer\nend"
    \     }
    \   },
    \   "draper": {
    \     "app/decorators/*_decorator.rb": {
    \       "command":   "decorator",
    \       "affinity":  "model",
    \       "test":      "spec/decorators/{}_spec.rb",
    \       "related":   "app/models/{}.rb",
    \       "template":  "class {camelcase|capitalize|colons}Decorator < Draper::Decorator\n  delegate_all\nend"
    \     }
    \   },
    \   "carrierwave": {
    \     "app/uploaders/*_uploader.rb": {
    \       "command":   "uploader",
    \       "affinity":  "model",
    \       "test":      "spec/uploaders/{}_spec.rb",
    \       "related":   "app/models/{}.rb",
    \       "template":  "class {camelcase|capitalize|colons}Uploader < CarrierWave::Uploader::Base\nend"
    \     }
    \   },
    \   "turnip": {
    \     "spec/acceptance/*.feature": {
    \       "command":   "acceptance"
    \     },
    \     "spec/acceptance/steps/*_steps.rb": {
    \       "command":   "steps",
    \       "template":  "steps_for :{} do\nend"
    \     }
    \   },
    \   "pundit": {
    \     "app/policies/*_policy.rb": {
    \       "command":   "policy",
    \       "affinity":  "model",
    \       "test":      "spec/policies/{}_spec.rb",
    \       "related":   "app/models/{}.rb",
    \       "template":  "class {camelcase|capitalize|colons}Policy < Struct.new(:user, :{})\nend"
    \     }
    \   },
    \   "resque": {
    \     "app/jobs/*_job.rb": {
    \       "command":   "job",
    \       "test":      "spec/jobs/{}_spec.rb",
    \       "template":  "class {camelcase|capitalize|colons}Job\n\n  def self.perform\n  end\n\nend"
    \     }
    \   },
    \   "ember-rails": {
    \     "app/assets/javascripts/router.js.coffee": {
    \       "command":   "jinitializer"
    \     },
    \     "app/assets/javascripts/models/*.js.coffee": {
    \       "command":   "jmodel",
    \       "alternate": "spec/javascripts/models/{}_spec.js.coffee",
    \       "template":  "App.{camelcase|capitalize|dot} = DS.Model.extend"
    \     },
    \     "app/assets/javascripts/views/*_view.js.coffee": {
    \       "command":   "jview",
    \       "alternate": "spec/javascripts/views/{}_spec.js.coffee",
    \       "template":  "App.{camelcase|capitalize|dot}View = Ember.View.extend"
    \     },
    \     "app/assets/javascripts/controllers/*_controller.js.coffee": {
    \       "command":   "jcontroller",
    \       "alternate": "spec/javascripts/controllers/{}_spec.js.coffee",
    \       "template":  "App.{camelcase|capitalize|dot}Controller = Ember.ObjectController.extend"
    \     },
    \     "app/assets/javascripts/routes/*_route.js.coffee": {
    \       "command":   "jroute",
    \       "alternate": "spec/javascripts/routes/{}_spec.js.coffee",
    \       "template":  "App.{camelcase|capitalize|dot}Route = Ember.Route.extend"
    \     },
    \     "app/assets/javascripts/mixins/*.js.coffee": {
    \       "command":   "jmixin",
    \       "alternate": "spec/javascripts/mixins/{}_spec.js.coffee",
    \       "template":  "App.{camelcase|capitalize|dot} = Ember.Mixin.create"
    \     },
    \     "app/assets/javascripts/templates/*.js.emblem": {
    \       "command":   "jtemplate"
    \     },
    \     "app/assets/javascripts/serializers/*_serializer.js.coffee": {
    \       "command":   "jserializer",
    \       "alternate": "spec/javascripts/serializers/{}_spec.js.coffee",
    \       "template":  "App.{camelcase|capitalize|dot}Serializer = DS.RESTSerializer.extend"
    \     },
    \     "app/assets/javascripts/adapters/*_adapter.js.coffee": {
    \       "command":   "jadapter",
    \       "alternate": "spec/javascripts/adapters/{}_spec.js.coffee",
    \       "template":  "App.{camelcase|capitalize|dot}Adapter = App.ApplicationAdapter.extend"
    \     },
    \     "spec/javascripts/**/*_spec.js.coffee": {
    \       "command":   "jspec",
    \       "alternate": "app/assets/javascripts/{}.coffee"
    \     }
    \   },
    \   "whenever": {
    \     "config/schedule.rb": {
    \       "command":   "schedule"
    \     }
    \   },
    \ }

" [vim-gitgutter]
highlight GitGutterAdd    guibg=NONE ctermbg=NONE ctermfg=46  guifg=#339933
highlight GitGutterChange guibg=NONE ctermbg=NONE ctermfg=76  guifg=#BB9933
highlight GitGutterDelete guibg=NONE ctermbg=NONE ctermfg=196 guifg=#BB3333

" customize vim-gitgutter sign for removed line
let g:gitgutter_sign_removed = '-'

" do not let vim-gitgutter overwrite keymappings (<leader>h especially)
let g:gitgutter_map_keys = 0

" Recently vim can merge signcolumn and number column into one
if has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif

" [suda.vim] will ask for sudo password when editing a non-writeable file
let g:suda_smart_edit = 1

" [rainbow]
let g:rainbow_active = 1
let g:rainbow_conf = {
  \    'guifgs': ['DarkOrange4', 'RoyalBlue3', 'DarkOrchid3', 'DarkGreen'],
  \    'operators': '_,_',
  \    'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
  \    'separately': {
  \      '*': {},
  \      'tex': {
  \        'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
  \      },
  \      'vim': {
  \        'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
  \      },
  \      'html': {
  \        'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
  \      },
  \      'eruby': {
  \        'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
  \      },
  \      'css': 0,
  \      'scss': 0,
  \      'sass': 0
  \    }
  \  }

" [coc.nvim] (conditionally)
if &rtp =~ 'coc.nvim'
  let g:coc_global_extensions = [
    \ 'coc-css',
    \ 'coc-eslint',
    \ 'coc-json',
    \ 'coc-html',
    \ 'coc-prettier',
    \ 'coc-styled-components',
    \ 'coc-tsserver',
    \ 'coc-yaml'
    \ ]

  " <cr> to 1) confirm and close pum when item is selected or 2) enter newline when no item is selected
  " \<C-g>u is used to break undo level
  inoremap <silent><expr> <cr> coc#pum#visible() && coc#pum#info()['index'] != -1 ? coc#pum#confirm() : "\<c-g>u\<cr>"

  " remap completion to use tab/s-tab and <cr>
  inoremap <silent><expr> <tab> coc#pum#visible() ? coc#pum#next(1): CheckBackSpace() ? "\<Tab>" : coc#refresh()
  inoremap <expr><s-tab> coc#pum#visible() ? coc#pum#prev(1) : "\<c-h>"

  " <c-space> to refresh available completions
  inoremap <silent><expr> <c-space> coc#refresh()

  " refresh completions list on <backspace>
  inoremap <silent><expr> <backspace> coc#pum#visible() ? "\<bs>\<c-r>=coc#start()\<CR>" : "\<bs>"

  function! CheckBackSpace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " completions popup colors (normal/unselected items)
  highlight CocFloating ctermbg=240 ctermfg=247 guibg=#585858 guifg=#9E9E9E

  " completions popup colors (selected item)
  highlight CocMenuSel ctermbg=214 guibg=Yellow

  " highlight for error signs
  highlight CocErrorSign guibg=NONE ctermbg=NONE ctermfg=196 guifg=#BB3333

  " Use `[g` and `]g` to navigate diagnostics
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<cr>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocActionAsync('doHover')
    endif
  endfunction

  " Function to toggle Coc
  function! ToggleCoc()
    if g:coc_enabled
      CocDisable
    else
      CocEnable
    endif
  endfunction

  " Map F2 to toggle Coc
  nnoremap <F2> :call ToggleCoc()<cr>
endif

" [vim-sneak] disable in netrw buffers (fixes <leader>s mapping)
let g:sneak#map_netrw = 0

" [auto-pairs] delete brackets and quotes in pair
let g:AutoPairsMapBS = 1

" [auto-pairs] compatbility mode
let g:AutoPairsCompatibleMaps = 0

" [auto-pairs] change default prefix
let g:AutoPairsPrefix = "<C-1>"

" [auto-pairs] custom pairs
let g:AutoPairs = autopairs#AutoPairsDefine([
  \   {"open": "<%", "close": "%>", "filetype": ["eruby"]},
  \ ])

" [vim-closetag] filetypes where vim-closetag should be enabled
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.html.erb'
let g:closetag_filetypes = 'html,xhtml,phtml,eruby'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.tsx'
let g:closetag_xhtml_filetypes = 'xhtml,javascript.jsx,javascript.tsx'

" [vim-closetag] enables closing tags for React fragments
let g:closetag_enable_react_fragment = 1

" [vim-closetag] disables auto-close if not in a valid region of the file
let g:closetag_regions = {
  \ 'typescript.tsx': 'jsxRegion,tsxRegion',
  \ 'javascript.jsx': 'jsxRegion',
  \ }

" [copilot.vim]
if !has("nvim")
  " remap keybinding from <Tab> to <C-p> (to match zsh autocomplete suggestions behaviour)
  imap <silent><script><expr> <C-p> copilot#Accept("\<CR>")
  let g:copilot_no_tab_map = v:true

  " remap <C-n> to request next Copilot suggestion
  imap <silent> <C-n> <Plug>(copilot-next)
end

" [Colorizer] enable for various file types, disable removing of colors on buffer leave, disable for large files
let g:colorizer_auto_color = 0
let g:colorizer_disable_bufleave = 1
let g:colorizer_maxlines = 300

augroup auto_colorize
  autocmd!
  autocmd FileType css,html,eruby,scss,sass,less,javascript,javascript.jsx,javascript.tsx,yaml :ColorHighlight
augroup END

" [any-jump.vim] Preserve cursor position when closing the AnyJump window
" https://github.com/pechorin/any-jump.vim/issues/88#issuecomment-853323352
function! Preserve(command)
  " preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")

  " do the business:
  execute a:command

  " clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

" disable global keymappings for AnyJump
let g:any_jump_disable_default_keybindings = 1

nnoremap <leader>j :call Preserve("AnyJump")<cr>
xnoremap <leader>j :call Preserve("AnyJump")<cr>

" [vim-matchup] custom mapping for matching quotes
" https://github.com/andymass/vim-matchup/issues/341
let s:quotes = ['"', '''', '`']

function! s:matchquote()
  normal! m'

  " character_at_cursor
  let c = matchstr(getline('.'), '\%'.col('.').'c.')

  if index(s:quotes, c) >= 0
    let num = len(split(getline('.'), c, 1)) - 1

    if num % 2 == 1
      return
    endif

    " is quotation mark under cursor odd or even?
    let col = getpos('.')[2]
    let num = len(split(getline('.')[0:col-1], c, 1)) - 1

    let mvmt = num % 2 == 0 ? 'F' : 'f'
    execute 'normal!' mvmt.c
  else
    " fallback
    execute "normal \<plug>(matchup-%)"
  endif
endfunction

nnoremap <silent> <Plug>(MatchMetaN) :call <SID>matchquote()<CR>
nmap % <Plug>(MatchMetaN)



" NVIM LUA INITIALIZER

if has("nvim")
  " if we're running nvim, execute nvim specific initializer [lua]
  lua require('init')
endif
