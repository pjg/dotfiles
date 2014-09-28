" Beautiful256 - a vim 256 colors scheme
" Based on Beauty256 by Mahmoud Sahebi Afzal
" Maintainer: Paweł Gościcki <pawel.goscicki@gmail.com>
" Last Change: 16 February 2013
" Version: 0.4

" check for t_Co
if &t_Co != 256 && ! has("gui_running")
  echomsg ""
  echomsg "write 'set t_Co=256' in your .vimrc or this colorscheme won't work"
  echomsg ""
  finish
endif

" reset colors
set background=light
hi clear
if exists("syntax_on")
  syntax reset
endif

" set colors_name
let colors_name = 'beautiful256'

" setting ctermbg=NONE results in a transparent-like background (it will be set to your terminal's background color)
hi Normal gui=NONE guifg=Black guibg=#fffbf0 ctermfg=0 ctermbg=NONE

hi Cursor guifg=White guibg=Black ctermfg=231 ctermbg=16
hi LineNr guifg=#808080 ctermfg=244
hi NonText ctermfg=7
hi SpecialKey term=bold ctermfg=4
hi Title term=bold ctermfg=5 guifg=#800080
hi Visual term=reverse ctermbg=7 guifg=White guibg=#829db9
hi Ignore ctermfg=NONE guifg=NONE

hi SignColumn guibg=#fffbf0 ctermbg=NONE
hi FoldColumn guifg=Black guibg=#979797 ctermbg=7 ctermfg=4
hi ColorColumn guibg=#fefefe ctermbg=255
hi Folded guifg=Black guibg=#bbbbbb  ctermbg=7 ctermfg=244
hi StatusLine guifg=#ddddff guibg=#220088 ctermfg=5 ctermbg=231
hi StatusLineNC guifg=#829db9 guibg=Black ctermfg=8 ctermbg=188
hi VertSplit gui=bold guifg=#9ca6af guibg=Black cterm=bold ctermfg=231 ctermbg=8
hi Wildmenu guifg=Black guibg=#ffdf00 ctermfg=0 ctermbg=11
"hi CursorLine ctermbg=255
hi Pmenu guibg=Grey65 guifg=Black gui=NONE ctermfg=250 ctermbg=238
hi PmenuSbar guibg=Grey50 guifg=fg gui=NONE ctermbg=214
hi PmenuSel guibg=Yellow guifg=Black gui=NONE ctermbg=214 ctermfg=16
hi PmenuThumb guibg=Grey75 guifg=fg gui=NONE cterm=reverse

hi IncSearch gui=NONE guifg=White guibg=Black cterm=reverse
hi Search gui=NONE guifg=Black guibg=#ffdf00 ctermbg=11

hi MoreMsg gui=bold guifg=ForestGreen
hi Question gui=bold guifg=ForestGreen
hi WarningMsg gui=bold guifg=#df0000

hi Comment gui=italic guifg=#a8a8a8 ctermfg=248
hi Error gui=NONE guifg=White guibg=#df0000 ctermfg=15 ctermbg=197
hi Identifier gui=NONE guifg=#875f00 ctermfg=94
hi Special gui=NONE guifg=#5f87ff ctermfg=69
hi PreProc gui=NONE guifg=#0000df ctermfg=12
hi Todo gui=bold guifg=Black guibg=#ffaf00 ctermfg=214 ctermbg=232
hi Type gui=bold guifg=#5f5fdf ctermfg=62
hi Underlined gui=underline
hi Directory guifg=#af5f87 ctermfg=132
hi Pmenu ctermfg=250 ctermbg=238
hi PmenuSel ctermbg=214 ctermfg=16

hi Boolean gui=bold guifg=#df8700 ctermfg=172
hi Constant gui=NONE guifg=#af0000 ctermfg=124
hi Number gui=bold guifg=#df8700 ctermfg=172
hi String gui=NONE guifg=#008000 ctermfg=2
hi helpNote ctermbg=220 ctermfg=16

hi Label gui=bold,underline guifg=Sienna4
hi Statement gui=bold guifg=#af5f87 ctermfg=132
hi htmlStatement guifg=#af5f87 ctermfg=132

hi htmlBold gui=bold
hi htmlItalic gui=italic
hi htmlUnderline gui=underline
hi htmlBoldItalic gui=bold,italic
hi htmlBoldUnderline gui=bold,underline
hi htmlBoldUnderlineItalic gui=bold,underline,italic
hi htmlUnderlineItalic gui=underline,italic

hi djangoStatement guibg=#ddffaa ctermbg=150 ctermfg=22
" hi docSpecial guifg=RoyalBlue1
hi docTrans guibg=White guifg=White
hi docCode guifg=#00aa00

" taken from vividchalk.vim
hi link railsMethod         PreProc
hi link rubyDefine          Keyword
hi link rubySymbol          Constant
hi link rubyAccess          rubyMethod
hi link rubyAttribute       rubyMethod
hi link rubyEval            rubyMethod
hi link rubyException       rubyMethod
hi link rubyInclude         rubyMethod
hi link rubyStringDelimiter rubyString
hi link rubyRegexp          Regexp
hi link rubyRegexpDelimiter rubyRegexp
"hi link rubyConstant        Variable
"hi link rubyGlobalVariable  Variable
"hi link rubyClassVariable   Variable
"hi link rubyInstanceVariable Variable
hi link javascriptRegexpString  Regexp
hi link javascriptNumber        Number
hi link javascriptNull          Constant

" match git diff view colors with shell's gits diff colors
hi diffAdded ctermfg=2 guifg=#008000
hi diffRemoved ctermfg=1 guifg=#800000

" additional colors definitions (apart from those from beauty256)
hi Regexp guifg=#df00df ctermfg=13
hi railsUserClass guifg=#5f0000 ctermfg=52
hi Function guifg=#5f0000 ctermfg=52
