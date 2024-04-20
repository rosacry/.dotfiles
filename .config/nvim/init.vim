"Plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'airblade/vim-gitgutter'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-fugitive'
Plug 'amix/open_file_under_cursor.vim'
Plug 'dense-analysis/ale'
Plug 'maximbaz/lightline-ale'
Plug 'tpope/vim-commentary'
Plug 'terryma/vim-expand-region'
Plug 'terryma/vim-multiple-cursors'
Plug 'editorconfig/editorconfig-vim'
Plug 'github/copilot.vim'
Plug 'preservim/nerdtree'
Plug 'thisisrandy/vim-outdated-plugins'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'ryanoasis/vim-devicons'
Plug 'aymericbeaumet/vim-symlink'
Plug 'itchyny/lightline.vim'
Plug 'Mofiqul/vscode.nvim'
Plug 'Igorjan94/codeforces.vim'
call plug#end()

"-------------------------------------------------------------------------------------------
"-------------------------------------------------------------------------------------------

"Unbind Function Keys
noremap <F1> :
noremap <F2> :
noremap <F3> :
noremap <F4> :
noremap <F5> :
noremap <F6> :
noremap <F7> :
noremap <F8> :
noremap <F9> :
noremap <F10> :
noremap <F11> :
noremap <F12> :

"-------------------------------------------------------------------------------------------

"Vim Settings
set number relativenumber
set smarttab
set cindent
set tabstop=2
set shiftwidth=2
set expandtab
set laststatus=2
set noshowmode
set hidden
set updatetime=100
set shortmess+=c
set signcolumn=no
set foldcolumn=0
set wrap linebreak
set splitbelow
set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
set background=dark
set autochdir

"-------------------------------------------------------------------------------------------

"Compiling and Executing Commands
augroup JavaCompile
  autocmd!
  autocmd Filetype java set makeprg=javac\ %
augroup END
function Compile()
  if (&ft=='c' || &ft=='cpp')
    echo "Compiling..."
    :silent :w | :make! CC=clang
    echo "Compiled"
  elseif (&ft=='java')
    echo "Compiling..."
    :silent :w | :make!
    echo "Compiled"
  endif
endfunction
function Execute()
    if (&ft=='c' || &ft=='cpp')
      echo "Executing..."
      :split term:// ./%<
    elseif (&ft=='java')
      echo "Executing..."
      :split term:// java -cp %:p:h %:t:r
    elseif (&ft=='python')
      echo "Executing..."
      :split term:// python3 %:r.py
  endif
endfunction

"-------------------------------------------------------------------------------------------

"Ale Settings
let g:ale_linters= {
 \   'python': ['flake8'],
 \   'cpp': ['clang', 'clangd', 'clangtidy', 'clangcheck'],
 \}
let g:ale_fixers = {
 \   '*': ['remove_trailing_lines', 'trim_whitespace'],
 \   'python': ['autoflake' , 'autoimport' ,'black' , 'autopep8', 'isort' , 'reorder-python-imports' , 'yapf'],
 \}
let g:ale_cpp_cc_options = '-std=c++17 -Wall -Wextra'
let g:ale_fix_on_save = 1

"-------------------------------------------------------------------------------------------

"NerdTree Settings
let NERDTreeShowHidden=1

"-------------------------------------------------------------------------------------------

"Copilot Settings
let g:copilot_no_tab_map = v:true
let g:toggle = 0
function CopilotToggle(toggle)
  if g:toggle == 0
    :Copilot enable
    let g:toggle = 1
    echo "Copilot Enabled"
  else
    :Copilot disable
    let g:toggle = 0
    echo "Copilot Disabled"
  endif
endfunction


let g:copilot_filetypes = {
\ '*': v:false,
\ 'python': v:true,
\ 'cpp': v:true,
\ 'java': v:true,
\ 'vim': v:true,
\ }

"-------------------------------------------------------------------------------------------

"Git Gutter Settings
function! s:Git(args)
  :Git add .
  :Git commit -m args
  :Git push
endfunction

"-------------------------------------------------------------------------------------------

"Coc Settings
let g:coc_global_extensions = [
  \ 'coc-clangd',
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ 'coc-pyright',
  \ 'coc-java',
  \ 'coc-jedi',
  \ 'coc-json'
  \ ]
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
autocmd CursorHold * silent call CocActionAsync('highlight')
augroup CocGroup
  autocmd!
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

"-------------------------------------------------------------------------------------------

"Lightline Settings
let g:lightline = {
  \ 'colorscheme': 'powerline',
  \ 'active': {
  \   'left': [['mode', 'paste'],
  \            ['zoom', 'githunks', 'gitbranch', 'readonly', 'filename', 'method']],
  \   'right': [['linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok', 'trailing', 'lineinfo'],
  \             ['percent'],
  \             ['fileformat', 'fileencoding', 'filetype']]
  \ },
  \ 'tabline': {
  \   'left': [['buffers']],
  \   'right': [['close']]
  \ },
  \ 'component_expand': {
  \   'linter_checking': 'lightline#ale#checking',
  \   'linter_errors': 'lightline#ale#errors',
  \   'linter_warnings': 'lightline#ale#warnings',
  \   'linter_ok': 'lightline#ale#ok',
  \   'trailing': 'lightline#trailing_whitespace#component',
  \   'buffers': 'lightline#bufferline#buffers'
  \ },
  \ 'component_type': {
  \   'linter_checking': 'right',
  \   'linter_warnings': 'right',
  \   'linter_errors': 'right',
  \   'linter_ok': 'right',
  \   'trailing': 'right',
  \   'buffers': 'right'
  \ },
  \ 'component_function': {
  \   'zoom': 'zoom#statusline',
  \   'githunks': 'LightlineGitGutter',
  \   'gitbranch': 'Lightlinegit',
  \   'filename': 'LightlineFilename',
  \   'method': 'NearestMethodOrFunction'
  \ },
  \   'separator': {'left': '', 'right': ''},
  \   'subseparator': {'left': '', 'right': ''}
  \ }
let g:lightline#bufferline#enable_devicons  = 1
let g:lightline#bufferline#min_buffer_count = 2
let g:lightline#bufferline#show_number      = 1
let g:lightline#bufferline#unicode_symbols  = 1
let g:lightline#trailing_whitespace#indicator = '•'

function! Lightlinegit()
    let l:branch = FugitiveHead()
    return l:branch ==# '' ? '' : ' ' . l:branch
endfunction

function! LightlineGitGutter()
  if !get(g:, 'gitgutter_enabled', 0) || empty(FugitiveHead())
    return ''
  endif
  let [ l:added, l:modified, l:removed ] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', l:added, l:modified, l:removed)
endfunction

function! LightlineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  let modified = &modified ? ' [+]' : ''
  return filename . modified
endfunction

function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction
if exists('+termguicolors') && ($TERM == "st-256color" || $TERM == "tmux-256color")
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	set termguicolors
endif

"-------------------------------------------------------------------------------------------

"Colorscheme

" Vim-Script:
" For dark theme
let g:vscode_style = "dark"
" Enable transparent background
let g:vscode_transparency = 1
" Enable italic comment
let g:vscode_italic_comment = 1
" Disable nvim-tree background color
let g:vscode_disable_nvimtree_bg = v:true
colorscheme vscode

"-------------------------------------------------------------------------------------------

"Key Mappings

"show lines highlighted in visual mode
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

"Insert empty new line without entering insert mode
nnoremap <leader>o o<Esc>
nnoremap <leader>O O<Esc>

"Refactoring
let g:multi_cursor_select_all_word_key = '<C-b>'

"Yanking to clipboard
vnoremap y "*y
nnoremap yy "*yy

nnoremap <C-]> :sp $MYVIMRC<CR>

"New line
inoremap {<CR> {<CR>}<ESC>O

"Clear last search
map <silent><C-C> :noh<CR>

"-------------------------------------------------------------------------------------------

"Function mappings
nnoremap <F1> :Rename
nnoremap <F2> :Move
nnoremap <F3> :Wall
nnoremap <F4> :Remove
nnoremap <F5> :NERDTreeToggle<CR>
nnoremap <F6> :NERDTreeCWD<CR>
nnoremap <silent><F7> :call Compile()<CR>
nnoremap <silent><F8> :call Execute()<CR>
map <F9> :cnext<Return>
map <F10> :cnext<Return>
noremap <silent><F11> :call CopilotToggle(g:toggle)<CR>
noremap <silent><F12> :call source init.vim<CR>

"-------------------------------------------------------------------------------------------

"Non-key Mappings


"-------------------------------------------------------------------------------------------

"Plugin Key Mappings

"Ultisnips mappings
let g:UltiSnipsExpandTrigger = "<CR>"

"Coc Mappings
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> gs :call <SID>show_documentation()<CR>
nmap <leader>rn <Plug>(coc-rename)
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"Expand Region Mappings
map K <Plug>(expand_region_expand)
map J <Plug>(expand_region_shrink)

"Accept Suggestion from Copilot
imap <silent><script><expr> <C-A> copilot#Accept("\<CR>")

"-------------------------------------------------------------------------------------------

"Plugin Non-Key Mappings
command! -nargs=1 Gitt call s:Git(<f-args>)

"-------------------------------------------------------------------------------------------