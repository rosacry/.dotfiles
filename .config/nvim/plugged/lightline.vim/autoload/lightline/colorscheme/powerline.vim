" =============================================================================
" Filename: autoload/lightline/colorscheme/powerline.vim
" Author: itchyny
" License: MIT License
" Last Change: 2013/09/07 15:54:41.
" =============================================================================

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
let s:p.normal.left = [ ['#282c34', '#98c379', 'bold'], ['white', 'gray4'] ]
let s:p.normal.right = [ ['#282c34', '#98c379', 'bold'], ['gray9', 'gray4'], ['gray8', 'gray2'] ]
let s:p.inactive.right = [ ['gray1', 'gray5'], ['gray4', 'gray1'], ['gray4', 'gray0'] ]
let s:p.inactive.left = s:p.inactive.right[1:]
let s:p.insert.left = [ ['#282c34', '#61afef', 'bold'], ['white', 'gray4'] ]
let s:p.insert.right = [ ['#282c34', '#61afef', 'bold'], ['gray9', 'gray4'],  ['gray8', 'gray2'] ]
let s:p.replace.left = [ ['white', 'brightred', 'bold'], ['white', 'gray4'] ]
let s:p.visual.left = [ ['#282c34', '#c678dd', 'bold'], ['white', 'gray4'] ]
let s:p.visual.right = [ ['#282c34', '#c678dd', 'bold'],  ['gray9', 'gray4'],  ['gray8', 'gray2'] ]
let s:p.normal.middle = [ [ 'gray7', 'gray2' ] ]
let s:p.insert.middle = [ [ 'gray7', 'gray2' ] ]
let s:p.replace.middle = s:p.normal.middle
let s:p.replace.right = s:p.normal.right
let s:p.tabline.left = [ [ 'gray9', 'gray4' ] ]
let s:p.tabline.tabsel = [ [ 'gray9', 'gray1' ] ]
let s:p.tabline.middle = [ [ 'gray2', 'gray8' ] ]
let s:p.tabline.right = [ [ 'gray9', 'gray3' ] ]
let s:p.normal.error = [ [ 'gray9', 'brightestred' ] ]
let s:p.normal.warning = [ [ 'gray1', 'yellow' ] ]

let g:lightline#colorscheme#powerline#palette = lightline#colorscheme#fill(s:p)
