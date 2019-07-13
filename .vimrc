" VUNDLE
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()



" VUNDLES

" let vundle manage vundle
Plugin 'gmarik/vundle'

" file finder
set rtp+=/usr/local/opt/fzf
Plugin 'junegunn/fzf.vim'

" file navigation/management
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-vinegar'
Plugin 'pbrisbin/vim-mkdir'

" git related
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'

" parentheses coloring
Plugin 'luochen1990/rainbow'

" Ruby related
Plugin 'ecomba/vim-ruby-refactoring'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-rake'

" text objects
Plugin 'kana/vim-textobj-user'
Plugin 'nelstrom/vim-textobj-rubyblock'
Plugin 'bootleq/vim-textobj-rubysymbol'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'wellle/targets.vim'

" code completion
Plugin 'Valloric/YouCompleteMe'

" grepping files from vim
Plugin 'mileszs/ack.vim'

" general text-editing improvements
Plugin 'AndrewRadev/splitjoin.vim'
Plugin 'Raimondi/delimitMate'
Plugin 'godlygeek/tabular'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-commentary'
Plugin 'itspriddle/vim-stripper'

" general vim improvements
Plugin 'adelarsq/vim-matchit'
Plugin 'omh/Kwbd.vim'
Plugin 'sickill/vim-pasta'
Plugin 'sjl/gundo.vim'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-ragtag'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-speeddating'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'justinmk/vim-sneak'
Plugin 'lambdalisue/suda.vim'
Plugin 'nelstrom/vim-visual-star-search'

" statusline (and related)
Plugin 'mhinz/vim-signify'
Plugin 'itchyny/lightline.vim'

" syntax files
Plugin 'sheerun/vim-polyglot'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'M4R7iNP/vim-inky'



" BASIC SETTINGS

" no vi compatible mode
set nocompatible

" you can change buffers without saving
set hidden

" do not autoresize windows
set noequalalways

" Resize splits when the window is resized
au VimResized * :wincmd =

" split below/right
set splitbelow
set splitright

" no backup files
set nobackup nowritebackup

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

" GUI settings (gvim)
if has("gui_running")
  " encoding
  set encoding=utf-8

  " window size / position
  winsize 140 50
  winpos 70 40

  " Windows
  if has("win32")
    " font
    set guifont=DejaVu_Sans_Mono:h10:cEASTEUROPE

    " simulate alt key behaviour
    autocmd GUIEnter * simalt ~s

    " use shellslash
    set shellslash

  " Mac OS X
  elseif has("mac")
    " font
    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h14

  " Unix/Linux
  elseif has("unix")
    " font
    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10

    " set English language
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
set history=1000

" show available TAB-completions in command line
set wildmenu

" have TAB-completion behave similarly to a shell (i.e. complete the longest part, then cycle through the matches)
set wildmode=longest:full,full

" ignore these files when completing names and in Explorer
set wildignore=*.o,*.out,*.obj,.git,*.rbc,*.class,.svn,*.gem                 " output & scm files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz                      " archive files
set wildignore+=*.jpg,*.jpeg,*.png,*.xpm,*.gif,*.bmp                         " pictures
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/* " bundler and sass
set wildignore+=*/node_modules/*                                             " node modules
set wildignore+=*/log/*,*.log,*/coverage/*                                   " logs and rcov
set wildignore+=*.swp,*~,._*                                                 " swp and backup files

" short messages in command line (so that they don't overflow and require pressing <ENTER>) (h :shortmess)
set shortmess=aoOtI

" disable visual/audible bells
set noerrorbells
set visualbell
set t_vb=
autocmd GUIEnter * set vb t_vb=

" time out on key codes but not on mappings
set notimeout
set ttimeout
set ttimeoutlen=10

" even faster ESC-aping (https://powerline.readthedocs.org/en/latest/tipstricks.html#vim)
augroup FastEscape
  autocmd!
  au InsertEnter * set timeoutlen=0
  au InsertLeave * set timeoutlen=1000
augroup END

" allow backspacing over autoindent, EOL, and BOL
set backspace=2

" never write unless requested
set noautowrite
set noautowriteall

" automatically re-read files files changed outside of vim
set autoread

" write swap files after 2 seconds of inactivity
set updatetime=2000

" global directory for .swp files
set directory=$HOME/.vim/tmp/

" yes/no/cancel prompt if closing with unsaved changes
set confirm

" persistent undo (preserved after restarting vim)
if v:version >= 703
  set undofile
  set undodir=$HOME/.vim/tmp/
endif

" mouse support in xterm
set mouse=a

" inverse space as a vsplit character (instead of |)
set fcs+=vert:\ " the space after the backslash is intentional

" always start on first line when editing git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" explicitly set language to English
let $LANG = 'en'

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



" SYNTAX HIGHLIGHTING

" syntax highlight on
syntax on

" faster Ruby syntax highlighting
let ruby_no_expensive=1

" only highlight syntax up to this column (to make dealing with files with long Ruby lines faster)
set synmaxcol=300



" FILE TYPES

" auto-completion
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html,markdown set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

" special auto-completion settings for Ruby
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 0
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1

" set fixed columns only for some file types
autocmd FileType * setlocal textwidth=0
autocmd FileType ruby,eruby,javascript,vue,css,scss setlocal textwidth=80
autocmd FileType gitcommit setlocal textwidth=72

augroup filetypedetect
  " YAML files read as Ruby
  autocmd BufNewFile,BufRead *.yml setf eruby

  " ActiveAdmin views read as Ruby
  autocmd BufNewFile,BufRead *.arb setf ruby

  " 2 spaces for TAB in JS/CSS/HTML files
  autocmd BufNewFile,BufRead {*.css,*.scss,*.sass,*.html,*.html,*.js} setlocal softtabstop=2 tabstop=2 shiftwidth=2
augroup END

" explicitly set filetype to Ruby for some well-known files
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,Procfile,Capfile,Guardfile,.Guardfile,config.ru,.railsrc,.irbrc,.pryrc} set ft=ruby

" explicitly set filetype to shell for dotenv's sample file
autocmd BufNewFile,BufRead .env.sample setf sh

" explicitly set filetype to slim for slim view files (not sure why it's needed...)
au BufRead,BufNewFile {*.html.slim} set filetype=slim

" set various characters to be treated as a part of words
autocmd FileType lisp,clojure,html,xml,xhtml,haml,eruby,css,scss,sass,javascript,coffee,yaml setlocal iskeyword+=-,$,#



" ADVANCED SETTINGS

" % should also match if/else/begin/end/etc.
runtime macros/matchit.vim

" reposition the cursor in the buffer after reopening vim
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif



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

" required for VimR (MacOS)
let $FZF_DEFAULT_COMMAND = 'ag --nocolor --ignore-dir=public/pictures --ignore-dir=tmp --ignore-dir=vendor/bundle --ignore-dir=vendor/plugins --ignore=''*.jpg'' --ignore=''*.png'' --ignore=''*.svg'' -g ""'

" [fugitive.vim] auto clean fugitive buffers
au BufReadPost fugitive://* set bufhidden=delete

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
    \   "app/gateways/*.rb": {
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
    \   "spec/system/*_spec.rb": {
    \     "command":   "system",
    \     "template":  "describe '{underscore|capitalize|blank}' do\n\nend"
    \   }
    \ }

" [vim-rails] gem projections - typing `:Efactory users` will open the users factory, etc.
let g:rails_gem_projections = {
    \   "factory_bot": {
    \     "test/factories/*.rb": {
    \       "command":   "factory",
    \       "affinity":  "collection",
    \       "alternate": "app/models/{singular}.rb",
    \       "related":   "db/schema.rb#{}",
    \       "test":      "test/models/{singular}_test.rb",
    \       "template":  "FactoryBot.define do\n  factory :{singular} do\n  end\nend",
    \       "keywords":  "factory sequence"
    \     },
    \     "spec/factories/*.rb": {
    \       "command":   "factory",
    \       "affinity":  "collection",
    \       "alternate": "app/models/{singular}.rb",
    \       "related":   "db/schema.rb#{}",
    \       "test":      "spec/models/{singular}_test.rb",
    \       "template":  "FactoryBot.define do\n  factory :{singular} do\n  end\nend",
    \       "keywords":  "factory sequence"
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

" [vim-signify]
let g:signify_vcs_list = ['git']
let g:signify_sign_delete = '-'

" [vim-signify] custom highlighting
highlight SignifySignAdd    guibg=NONE ctermbg=NONE ctermfg=46  guifg=#339933
highlight SignifySignDelete guibg=NONE ctermbg=NONE ctermfg=196 guifg=#BB3333
highlight SignifySignChange guibg=NONE ctermbg=NONE ctermfg=76  guifg=#BB9933

" [vim-signify] always show the sign column (by adding a dummy sign)
function! ShowSignColumn()
  sign define dummy
  execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
endfunc
au BufRead,BufNewFile * call ShowSignColumn()

" [suda.vim] will ask for sudo password when editing a non-writeable file
let g:suda_smart_edit = 1

" CSS3 syntax (vendor prefixes highlighting)
highlight VendorPrefix guifg=#880000 gui=BOLD
match VendorPrefix /-\(moz\|webkit\|o\|ms\)-[a-zA-Z-]\+/

" [YouCompleteMe]
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 0
let g:ycm_min_num_identifier_candidate_chars = 3
let g:ycm_max_num_candidates = 20
let g:ycm_max_num_identifier_candidates = 20

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

" <F2> to save current session in tmp/current.vim
map <F2> :mksession! tmp/current.vim<cr>
imap <F2> <esc><F2>
vmap <F2> <esc><F2>

" <F4> to turn line wrap on/off
map <F4> :set wrap!<cr>
imap <F4> <esc><F4>
vmap <F4> <esc><F4>

" <F6> for gundo.vim
nmap <F6> :GundoToggle<cr><cr>
imap <F6> <esc>:GundoToggle<cr><cr>

" <F8> to turn off the highlight search & redraw screen, sign column and statusline
map <F8> :syntax sync fromstart<cr>:nohlsearch<cr>:redrawstatus!<cr>:redraw!<cr>:SignifyRefresh<cr>
imap <F8> <esc><F8>
vmap <F8> <esc><F8>

" close current buffer but don't close the window (Kwbd.vim)
nmap <F10> :Kwbd<cr>

" <F11> to toggle the paste mode (when vim either adds or not spaces in the front of lines)
set pastetoggle=<F11>

" <F12> to toggle the display of invisible characters ($\t)
nmap <F12> :set list!<bar>set list?<cr>

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

" K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" gw to swap the current word with the one next to it
nmap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<cr>'':nohlsearch<cr>

" CTRL+s always saves file
nmap <c-s> :w<cr>
vmap <c-s> <esc><c-s>
imap <c-s> <esc><c-s>

" CTRL+q quits
nmap <c-q> :q<cr>
imap <c-q> <esc><c-q>

" use sane regexes
nnoremap / /\v
vnoremap / /\v

" don't move on *
nnoremap * *<c-o>

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

" quickselect tabs with CMD + # (gvim only)
nnoremap <D-1> :tabn 1<CR>
nnoremap <D-2> :tabn 2<CR>
nnoremap <D-3> :tabn 3<CR>
nnoremap <D-4> :tabn 4<CR>
nnoremap <D-5> :tabn 5<CR>
nnoremap <D-6> :tabn 6<CR>
nnoremap <D-7> :tabn 7<CR>
nnoremap <D-8> :tabn 8<CR>
nnoremap <D-9> :tabn 9<CR>


" INSERT MODE KEY MAPPINGS

" Ruby: bind control-l to hashrocket
imap <C-l> <Space>=><Space>'

" Ruby: convert word into Ruby symbol
imap <C-k> <C-o>b:<Esc>Ea

" basic readline shortcuts
inoremap <c-a> <esc>I
inoremap <c-e> <esc>A

" map Ctrl+p to ESC (common misstype when you press Ctrl+[ for ESC)
inoremap <c-p> <esc>


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
nmap <leader>a ggVG

" upper/lower word
nmap <leader>u mQviwU'Q
nmap <leader>l mQviwu'Q

" upper/lower first char of word
nmap <leader>U mQgewvU'Q
nmap <leader>L mQgewvu'Q

" fugitive.vim
nmap <leader>gb :Gblame<cr>
nmap <leader>gc :Gcommit<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gl :!git l<cr>
nmap <leader>gp :Git push<cr>
nmap <leader>gr :Gremove!<cr>
nmap <leader>gs :Gstatus<cr>
nmap <leader>gw :Gwrite<cr>

" fzf.vim
map <leader>t :Files<cr>
map <leader>b :Buffers<cr>
map <leader>h :History<cr>

" delete current buffer
noremap <leader>c :bdelete<cr>

" quit
nmap <leader>q :q<cr>

" save file
map <leader>w :w<cr>

" [vim-rails] Rake
map <leader>rr :.Rake<cr>

" system clipboard interaction
noremap <leader>d "*d
noremap <leader>D "*d$
noremap <leader>y "*y
noremap <leader>Y "*y$
noremap <leader>p :set paste<cr>"*p<cr>:set nopaste<cr>
noremap <leader>P :set paste<cr>"*P<cr>:set nopaste<cr>

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
