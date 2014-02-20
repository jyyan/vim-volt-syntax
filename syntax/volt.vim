" .vimrc variable to disable html highlighting
if !exists('g:volt_syntax_html')
   let g:volt_syntax_html=1
endif

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
  finish
endif
  let main_syntax = 'volt'
endif

" Pull in the HTML syntax.
if g:volt_syntax_html
  if version < 600
    so <sfile>:p:h/html.vim
  else
    runtime! syntax/html.vim
    unlet b:current_syntax
  endif
endif

syntax case match

" Jinja template built-in tags and parameters (without filter, macro, is and raw, they
" have special threatment)
syn keyword voltStatement containedin=voltVarBlock,voltTagBlock,voltNested contained and if else in not or recursive as import

syn keyword voltStatement containedin=voltVarBlock,voltTagBlock,voltNested contained is filter skipwhite nextgroup=voltFilter
syn keyword voltStatement containedin=voltTagBlock contained macro skipwhite nextgroup=voltFunction
syn keyword voltStatement containedin=voltTagBlock contained block skipwhite nextgroup=voltBlockName

" Variable Names
syn match voltVariable containedin=voltVarBlock,voltTagBlock,voltNested contained /[a-zA-Z_][a-zA-Z0-9_]*/
syn keyword voltSpecial containedin=voltVarBlock,voltTagBlock,voltNested contained false true none False True None loop super caller varargs kwargs

" Filters
syn match voltOperator "|" containedin=voltVarBlock,voltTagBlock,voltNested contained skipwhite nextgroup=voltFilter
syn match voltFilter contained /[a-zA-Z_][a-zA-Z0-9_]*/
syn match voltFunction contained /[a-zA-Z_][a-zA-Z0-9_]*/
syn match voltBlockName contained /[a-zA-Z_][a-zA-Z0-9_]*/

" Jinja template constants
syn region voltString containedin=voltVarBlock,voltTagBlock,voltNested contained start=/"/ skip=/\\"/ end=/"/
syn region voltString containedin=voltVarBlock,voltTagBlock,voltNested contained start=/'/ skip=/\\'/ end=/'/
syn match voltNumber containedin=voltVarBlock,voltTagBlock,voltNested contained /[0-9]\+\(\.[0-9]\+\)\?/

" Operators
syn match voltOperator containedin=voltVarBlock,voltTagBlock,voltNested contained /[+\-*\/<>=!,:]/
syn match voltPunctuation containedin=voltVarBlock,voltTagBlock,voltNested contained /[()\[\]]/
syn match voltOperator containedin=voltVarBlock,voltTagBlock,voltNested contained /\./ nextgroup=voltAttribute
syn match voltAttribute contained /[a-zA-Z_][a-zA-Z0-9_]*/

" Jinja template tag and variable blocks
syn region voltNested matchgroup=voltOperator start="(" end=")" transparent display containedin=voltVarBlock,voltTagBlock,voltNested contained
syn region voltNested matchgroup=voltOperator start="\[" end="\]" transparent display containedin=voltVarBlock,voltTagBlock,voltNested contained
syn region voltNested matchgroup=voltOperator start="{" end="}" transparent display containedin=voltVarBlock,voltTagBlock,voltNested contained
syn region voltTagBlock matchgroup=voltTagDelim start=/{%-\?/ end=/-\?%}/ containedin=ALLBUT,voltTagBlock,voltVarBlock,voltRaw,voltString,voltNested,voltComment

syn region voltVarBlock matchgroup=voltVarDelim start=/{{-\?/ end=/-\?}}/ containedin=ALLBUT,voltTagBlock,voltVarBlock,voltRaw,voltString,voltNested,voltComment

" Jinja template 'raw' tag
syn region voltRaw matchgroup=voltRawDelim start="{%\s*raw\s*%}" end="{%\s*endraw\s*%}" containedin=ALLBUT,voltTagBlock,voltVarBlock,voltString,voltComment

" Jinja comments
syn region voltComment matchgroup=voltCommentDelim start="{#" end="#}" containedin=ALLBUT,voltTagBlock,voltVarBlock,voltString

" Block start keywords.  A bit tricker.  We only highlight at the start of a
" tag block and only if the name is not followed by a comma or equals sign
" which usually means that we have to deal with an assignment.
syn match voltStatement containedin=voltTagBlock contained /\({%-\?\s*\)\@<=\<[a-zA-Z_][a-zA-Z0-9_]*\>\(\s*[,=]\)\@!/

" and context modifiers
syn match voltStatement containedin=voltTagBlock contained /\<with\(out\)\?\s\+context\>/


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_volt_syn_inits")
  if version < 508
    let did_volt_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink voltPunctuation voltOperator
  HiLink voltAttribute voltVariable
  HiLink voltFunction voltFilter

  HiLink voltTagDelim voltTagBlock
  HiLink voltVarDelim voltVarBlock
  HiLink voltCommentDelim voltComment
  HiLink voltRawDelim volt

  HiLink voltSpecial Special
  HiLink voltOperator Normal
  HiLink voltRaw Normal
  HiLink voltTagBlock PreProc
  HiLink voltVarBlock PreProc
  HiLink voltStatement Statement
  HiLink voltFilter Function
  HiLink voltBlockName Function
  HiLink voltVariable Identifier
  HiLink voltString Constant
  HiLink voltNumber Constant
  HiLink voltComment Comment

  delcommand HiLink
endif

let b:current_syntax = "volt"

if main_syntax == 'volt'
  unlet main_syntax
endif
