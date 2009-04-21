" BASIC SETTINGS

" no vi compatible mode
set nocompatible

" you can change buffer without saving
set hidden

" show line numbers
set number
set numberwidth=4

" highlight searches
set hlsearch

" find as you type
set incsearch

" smartcase -- normaly ignores case, but when we type uppercase character in search box it will be CASE SENSITIVE
set ignorecase smartcase

" always display current cursor position
set ruler

" syntax highlight on
syntax on

" 256-color VIM
set t_Co=256

" colorscheme
colorscheme beautiful256

" enable filetype detection and filetype-specific plugins and indenting
filetype plugin indent on

" do not wrap lines
set nowrap

" autoindent
set autoindent

" by default TABS are standard 8 characters filled with SPACES (expandtab) with softtabstop at 2 (TAB moves 2 characters); indent stays at 2 characters (shiftwidth)
set tabstop=8
set softtabstop=2
set shiftwidth=2
set expandtab

" set various characters to be treated as a part of words
set iskeyword+=-,_,$,@,#

" set virtual edit only when in visual block selection mode
set virtualedit=block

" Keep 3 lines (top/bottom) for scope when scrolling
set scrolloff=3
set sidescrolloff=3

" Keep longer vim commands history
set history=1000

" show available TAB-completions in command line
set wildmenu

" have TAB-completion behave similarly to a shell (ie: complete the longest part, then cycle through the matches)
set wildmode=list:longest,full

" ignore these files when completing names and in Explorer
set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif

" short messages
set shortmess=atI

" always show status line
set laststatus=2

" no blinking
set novisualbell

" no noise
set noerrorbells

" time to wait after ESC (default causes an annoying delay)
set timeoutlen=400



" FILE TYPES

" auto-completion
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

" special auto-completion settings for Ruby
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1

" Do not auto-indent HTML-like files
autocmd BufEnter *.html setlocal indentexpr=
autocmd BufEnter *.htm setlocal indentexpr=
autocmd BufEnter *.html.erb setlocal indentexpr=

" YAML files read as Ruby
augroup filetypedetect
  autocmd BufNewFile,BufRead *.yml setf eruby
augroup END

" 4 spaces for TAB in CSS files
autocmd BufEnter *.css setlocal softtabstop=4 shiftwidth=4



" ADVANCED SETTINGS

" % should also match if/else/begin/end/etc.
runtime macros/matchit.vim

" reposition the cursor in the buffer after reopening vim
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" use TAB for word-completion (tip #102)
function! InsertTabWrapper(direction)
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  elseif "backward" == a:direction
    return "\<c-p>"
  else
    return "\<c-n>"
  endif
endfunction

inoremap <tab> <c-r>=InsertTabWrapper ("forward")<cr>
inoremap <s-tab> <c-r>=InsertTabWrapper ("backward")<cr>



" PLUGINS

" FuzzyFinder
let g:fuzzy_ignore = "*.log"
let g:fuzzy_matching_limit = 70



" KEYS

" have Y behave analogously to D and C rather than to dd and cc (which is already done by yy)
noremap Y y$

" <F8> to temporary turn off the highlight search
map <F8> :nohlsearch<cr>
imap <F8> <esc><F8>
vmap <F8> <esc><F8>

" <F10> to wipe buffer (closes buffer)
nmap <F10> :bw<cr>

" <F11> to toggle the paste mode (when vim either adds or not spaces in the front of lines)
set pastetoggle=<F11>

" <F12> to toggle the display of unvisible characters ($\t)
nmap <F12> :set list!<bar>set list?<cr>

" scroll faster & move cursor too
nnoremap <c-e> 3<c-e>3j
nnoremap <c-y> 3<c-y>3k
vnoremap <c-e> 3<c-e>3j
vnoremap <c-y> 3<c-y>3k

" switch between buffers
nmap <c-h> :bp<cr>
nmap <c-l> :bn<cr>

" CTRL+s always saves file
nmap <c-s> :w<cr>
vmap <c-s> <esc><c-s>
imap <c-s> <esc><c-s>

" CTRL+q quits
nmap <c-q> :q<cr>
imap <c-q> <esc><c-q>

" leader/localleader mappings
let mapleader = ","
let localmapleader = "\\"

" for quick opening of :Ack/:grep results
map <leader>n :cnext<cr>
map <leader>p :cprevious<cr>

" FuzzyFinder
map <leader>t :FuzzyFinderTextMate<cr>
map <leader>b :FuzzyFinderBuffer<cr>
map <leader>h :FuzzyFinderMruFile<cr>

" NERD_tree
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<cr>

" git blame (for visually selected lines)
vmap <Leader>g :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

" rails.vim
map <leader>rr :.Rake<cr>

" FUNCTIONS (keymappings)
map <leader>cc :call CleanupFileConvertToUnixUtf8()<cr>


" FUNCTIONS (definitions)

function! CleanupFileConvertToUnixUtf8()
  " insert 'tabstop' characters instead of <TAB>s
  execute '%retab!'
  " UNIX fileformat
  set fileformat=unix
  " UTF-8 encoding by default
  set fileencoding=utf-8
  " Cleanup unnecessary spaces at the end of all lines
  execute '%s/\s\+$//e'
endfunction
