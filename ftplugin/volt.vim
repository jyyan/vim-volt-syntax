" Vim filetype plugin
" Language:	        volt
" ----------------------------------------------------------------------------

if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

" Matchit support
if exists("loaded_matchit") && !exists("b:match_words")
  let b:match_ignorecase = 0
  let b:match_words =
        \ '<?php:?>,\<switch\>:\<endswitch\>,\<if\>:\<elseif\>:\<else\>:\<endif\>,\<while\>:\<endwhile\>,\<do\>:\<while\>,\<for\>:\<endfor\>,\<foreach\>:\<endforeach\>,(:),[:],{:},<:>,<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>'
endif
