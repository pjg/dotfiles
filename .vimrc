" BASIC SETTINGS

" no vi compatible mode
set nocompatible

" you can change buffers without saving
set hidden

" no backup files
set nobackup nowritebackup

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

" font/colorscheme/encoding
if has("gui_running")
  " Windows GUI
  set guifont=DejaVu_Sans_Mono:h10:cEASTEUROPE
  set encoding=utf-8
  " maximize editor window
  autocmd GUIEnter * simalt ~s
  " set English language
  language en
  " On win32, use shellslash
  set shellslash
else
  " Linux terminal
  colorscheme beautiful256
endif

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

" the /g flag on :s substitutions by default
set gdefault

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

" disable visual/audible bells
set noerrorbells
set visualbell
set t_vb=
autocmd GUIEnter * set vb t_vb=

" time to wait after ESC (default causes an annoying delay)
set timeoutlen=400

" set keyword app (Shift+k) to ack
autocmd BufEnter * setlocal keywordprg=ack-grep

" backspace in gVim
set bs=2


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
let g:fuzzy_ignore = "*.log;*.git;*.svn;*.jpg;*.jpeg;*.gif;*.png"
let g:fuzzy_matching_limit = 70
let g:fuzzy_ceiling = 50000

" ragtag
inoremap <M-o> <Esc>o
inoremap <C-j> <Down>
let g:ragtag_global_maps = 1

" ack.vim
let g:ackprg="ack-grep -H --nocolor --nogroup --column"



" KEYS

" have Y behave analogously to D and C rather than to dd and cc (which is already done by yy)
noremap Y y$

" <F2> to save current session in tmp/current.vim
map <F2> :mksession! tmp/current.vim<cr>
imap <F2> <esc><F2>
vmap <F2> <esc><F2>

" <F4> to turn line wrap on/off
map <F4> :set wrap!<cr>
imap <F4> <esc><F4>
vmap <F4> <esc><F4>

" <F5> to refresh directory contents
map <F5> :FuzzyFinderTextMateRefreshFiles<cr>
imap <F5> <esc><F5>
vmap <F5> <esc><F5>

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

" Press Shift+P while in visual mode to replace the selection without overwriting the default register
vmap P p :call setreg('"', getreg('0')) <cr>

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

" rails: bind control-l to hashrocket
imap <C-l> <Space>=><Space>'

" rails: convert word into ruby symbol
imap <C-k> <C-o>b:<Esc>Ea

" convert file to utf-8 and cleanup whitespace garbage
map <leader>cc :call CleanupFileConvertToUnixUtf8()<cr>

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



" STATUSLINE STUFF

set statusline=%f "path relative to current to the filename

"display a warning if fileformat isn't unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isn't utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h "help file flag
set statusline+=%y "filetype
set statusline+=%r "read only flag
set statusline+=%m "modified flag

"display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

set statusline+=%{StatuslineTrailingSpaceWarning()}

set statusline+=%#warningmsg#
set statusline+=%*

"display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%= "left/right separator
set statusline+=%c, "cursor column
set statusline+=%l/%L "cursor line/total lines
set statusline+=\ %P "percent through file

" always show status line
set laststatus=2

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction


"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning = '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction
