
"--------------------
" Basic
"--------------------

let mapleader=" "
set pastetoggle=<F12>
set nocompatible
set mouse-=a
set backspace=indent,eol,start
set encoding=utf-8 fileencodings=utf-8
set updatetime=250
set cmdheight=2
set signcolumn=yes

set nobackup
set nowritebackup

"--------------------
" Appearance
"--------------------

syntax on
set t_Co=256
set guifont=iosevka:h14:cANSI
set nowrap
set background=dark
set number
set showcmd
set wildmenu

" Indent
filetype on
filetype indent on

set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

autocmd filetype sh                     setlocal shiftwidth=4 softtabstop=4 tabstop=4 autoindent expandtab
autocmd filetype go                     setlocal shiftwidth=4 softtabstop=4 tabstop=4 autoindent noexpandtab
autocmd filetype make,makefile,Makefile setlocal shiftwidth=4 softtabstop=4 tabstop=4 autoindent noexpandtab
autocmd filetype cpp                    setlocal shiftwidth=4 softtabstop=4 tabstop=4 autoindent noexpandtab smartindent cindent
autocmd filetype javascript             setlocal shiftwidth=2 softtabstop=2 tabstop=2 autoindent expandtab
autocmd BufNewFile,BufRead *.api        setlocal shiftwidth=4 softtabstop=4 tabstop=4 autoindent noexpandtab

"--------------------
" Keymap
"--------------------

map ; $
map j gj
map k gk

"--------------------
" Search
"--------------------

set hlsearch
set incsearch
set ignorecase
set smartcase
exec "nohlsearch"

"--------------------
" View
"--------------------

"set viewoptions=cursor
"au BufWinLeave * mkview
"au VimEnter * silent loadview
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"--------------------
" Plug
"--------------------

filetype off
filetype plugin indent on
filetype plugin on

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

    "--------------------
    " Appearance
    "--------------------

    "[startify]"

        Plug 'mhinz/vim-startify'

    "[easymotion]"

        Plug 'easymotion/vim-easymotion'
        nmap ss <Plug>(easymotion-s2)

    "[color]"

        Plug 'morhetz/gruvbox'

    "[vim airline]"

        Plug 'vim-airline/vim-airline'
            " statistic
            let g:airline#extensions#whitespace#enabled = 1
            let g:airline#extensions#wordcount#enabled = 1

            " powerline symbols
            let g:airline_powerline_fonts = 1
            if !exists('g:airline_symbols')
                let g:airline_symbols = {}
            endif
            let g:airline_left_sep = ''
            let g:airline_left_alt_sep = ''
            let g:airline_right_sep = ''
            let g:airline_right_alt_sep = ''
            let g:airline_symbols.branch = ''
            let g:airline_symbols.readonly = ''
            let g:airline_symbols.linenr = '☰'
            let g:airline_symbols.maxlinenr = ''
            let g:airline_symbols.dirty='⚡'

            " tab line
            let g:airline#extensions#tabline#enabled = 1
            let g:airline#extensions#tabline#overflow_marker = '…'
            let g:airline#extensions#tabline#show_tabs = 1
            let g:airline#extensions#tabline#buffer_idx_mode = 1
            let g:airline#extensions#branch#enabled = 1
            let g:airline#extensions#branch#vcs_priority = ["git", "mercurial"]

            " time
            let g:airline_section_b = '%{strftime("%H:%M:%S")}'

            nmap <leader>1 <Plug>AirlineSelectTab1
            nmap <leader>2 <Plug>AirlineSelectTab2
            nmap <leader>3 <Plug>AirlineSelectTab3
            nmap <leader>4 <Plug>AirlineSelectTab4
            nmap <leader>5 <Plug>AirlineSelectTab5
            nmap <leader>6 <Plug>AirlineSelectTab6
            nmap <leader>7 <Plug>AirlineSelectTab7
            nmap <leader>8 <Plug>AirlineSelectTab8
            nmap <leader>9 <Plug>AirlineSelectTab9
            nmap <leader>- <Plug>AirlineSelectPrevTab
            nmap <leader>= <Plug>AirlineSelectNextTab
            nmap <leader>` :bdelete<cr>

        Plug 'vim-airline/vim-airline-themes'
            let g:airline_theme='luna'

    "--------------------
    " Formater
    "--------------------

    "[markdown preview]"

        Plug 'plasticboy/vim-markdown', { 'for': ['markdown'] }
            let g:vim_markdown_folding_disabled = 1
            let g:vim_markdown_toc_autofit = 1
            let g:vim_markdown_follow_anchor = 1

        Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
            let g:mkdp_auto_start = 0
            let g:mkdp_auto_close = 1
            let g:mkdp_refresh_slow = 0
            let g:mkdp_command_for_global = 0
            let g:mkdp_open_to_the_world = 1
            let g:mkdp_open_ip = ''
            let g:mkdp_port = '7777'
            let g:mkdp_browser = 'echo'
            let g:mkdp_echo_preview_url = 1
            let g:mkdp_browserfunc = ''
            let g:mkdp_preview_options = {
                \ 'mkit': {},
                \ 'katex': {},
                \ 'uml': {},
                \ 'maid': {},
                \ 'disable_sync_scroll': 0,
                \ 'sync_scroll_type': 'middle',
                \ 'hide_yaml_meta': 1,
                \ 'sequence_diagrams': {},
                \ 'flowchart_diagrams': {},
                \ 'content_editable': v:false,
                \ 'disable_filename': 0
                \ }
            let g:mkdp_markdown_css = ''
            let g:mkdp_highlight_css = ''
            let g:mkdp_page_title = '「${name}」'
            let g:mkdp_filetypes = ['markdown']

            nmap <leader>m <Plug>MarkdownPreviewToggle
            nmap <F8> <Plug>MarkdownPreviewToggle

    "[tagbar-markdown]"

        Plug 'lvht/tagbar-markdown'

    "[markdown-toc]"

        Plug 'mzlogin/vim-markdown-toc'
            " :GenToc

    "[git gutter]"

        Plug 'airblade/vim-gitgutter'
            let g:gitgutter_max_signs = 500
            " map key
            let g:gitgutter_map_keys = 0
            " colors
            let g:gitgutter_override_sign_column_highlight = 0

            nmap <leader>g <Plug>(GitGutterPreviewHunk)
            nmap <leader><backspace> <Plug>(GitGutterUndoHunk)

    "--------------------
    " SideBar
    "--------------------

    "[NERDTree]"

        nmap <leader>b :NERDTreeToggle<cr>:TagbarToggle<cr><C-w>l

        Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

        Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
            let g:NERDTreeGitStatusIndicatorMapCustom = {
                    \ "Modified"  : "✹",
                    \ "Staged"    : "✚",
                    \ "Untracked" : "✭",
                    \ "Renamed"   : "➜",
                    \ "Unmerged"  : "═",
                    \ "Deleted"   : "✖",
                    \ "Dirty"     : "✗",
                    \ "Clean"     : "✔︎",
                    \ "Ignored"   : "☒",
                    \ "Unknown"   : "?"
                    \ }
            nmap <leader>t :NERDTreeToggle<cr>
            nmap <leader>v :NERDTreeFind<cr>


        Plug 'majutsushi/tagbar', { 'do': 'apt install ctags -y', 'on': 'TagbarToggle' }
            let g:tagbar_type_go = {
                    \ 'ctagstype' : 'go',
                    \ 'kinds'     : [
                        \ 'p:package',
                        \ 'i:imports:1',
                        \ 'c:constants',
                        \ 'v:variables',
                        \ 't:types',
                        \ 'n:interfaces',
                        \ 'w:fields',
                        \ 'e:embedded',
                        \ 'm:methods',
                        \ 'r:constructor',
                        \ 'f:functions'
                    \ ],
                    \ 'sro' : '.',
                    \ 'kind2scope' : {
                        \ 't' : 'ctype',
                        \ 'n' : 'ntype'
                    \ },
                    \ 'scope2kind' : {
                        \ 'ctype' : 't',
                        \ 'ntype' : 'n'
                    \ },
                    \ 'ctagsbin'  : 'gotags',
                    \ 'ctagsargs' : '-sort -silent',
                    \ 'sort' : 0
                \ }
            set tags=tags;
            set autochdir
            nmap <leader>y :TagbarToggle<cr>

    "--------------------
    " Coding Support
    "--------------------

    "[CoC]"

        Plug 'neoclide/coc.nvim', {'branch': 'release'}
            " coc-extensions
            let g:coc_global_extensions = [
                \ "coc-marketplace",
                \ "coc-sh",
                \ "coc-sql",
                \ "coc-json",
                \ "coc-css",
                \ "coc-html",
                \ "coc-go",
                \ "coc-clangd",
                \ "coc-prettier",
                \ "coc-highlight",
                \ "coc-vimlsp"
                \ ]

            " Use tab for trigger completion with characters ahead and navigate.
            " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
            " other plugin before putting this into your config.
            inoremap <silent><expr> <TAB>
                  \ coc#pum#visible() ? coc#pum#next(1) :
                  \ CheckBackspace() ? "\<Tab>" :
                  \ coc#refresh()
            inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

            " Make <CR> to accept selected completion item or notify coc.nvim to format
            " <C-g>u breaks current undo, please make your own choice.
            inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                          \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

            function! CheckBackspace() abort
              let col = col('.') - 1
              return !col || getline('.')[col - 1]  =~# '\s'
            endfunction

            " Use <c-space> to trigger completion.
            if has('nvim')
              inoremap <silent><expr> <c-space> coc#refresh()
            else
              inoremap <silent><expr> <c-@> coc#refresh()
            endif

            " Use `[g` and `]g` to navigate diagnostics
            " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
            nmap <silent> [g <Plug>(coc-diagnostic-prev)
            nmap <silent> ]g <Plug>(coc-diagnostic-next)

            " GoTo code navigation.
            nmap <silent> gd <Plug>(coc-definition)
            nmap <silent> gy <Plug>(coc-type-definition)
            nmap <silent> gi <Plug>(coc-implementation)
            nmap <silent> gr <Plug>(coc-references)

            " Editor command
            nmap <silent> gp :CocCommand editor.action.organizeImport<CR>
            nmap <silent> gm :CocCommand go.gopls.tidy<CR>

            " Use K to show documentation in preview window.
            nnoremap <silent> K :call ShowDocumentation()<CR>

            function! ShowDocumentation()
              if CocAction('hasProvider', 'hover')
                call CocActionAsync('doHover')
              else
                call feedkeys('K', 'in')
              endif
            endfunction

            " Highlight the symbol and its references when holding the cursor.
            autocmd CursorHold * silent call CocActionAsync('highlight')

            " Symbol renaming.
            nmap <leader>rn <Plug>(coc-rename)

            " Coc restart
            nmap <leader>rr :CocRestart<CR>

            " Formatting selected code.
            xmap <leader>f  <Plug>(coc-format-selected)
            nmap <leader>f  <Plug>(coc-format-selected)

            augroup mygroup
                autocmd!
                " Setup formatexpr specified filetype(s).
                autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
                " Update signature help on jump placeholder.
                autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
            augroup end

            " Applying codeAction to the selected region.
            " Example: `<leader>aap` for current paragraph
            xmap <leader>a  <Plug>(coc-codeaction-selected)
            nmap <leader>a  <Plug>(coc-codeaction-selected)

            " Remap keys for applying codeAction to the current buffer.
            nmap <leader>ac  <Plug>(coc-codeaction)
            " Apply AutoFix to problem on the current line.
            nmap <leader>qf  <Plug>(coc-fix-current)
            " Run the Code Lens action on the current line.
            nmap <leader>cl  <Plug>(coc-codelens-action)

            " Map function and class text objects
            " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
            xmap if <Plug>(coc-funcobj-i)
            omap if <Plug>(coc-funcobj-i)
            xmap af <Plug>(coc-funcobj-a)
            omap af <Plug>(coc-funcobj-a)
            xmap ic <Plug>(coc-classobj-i)
            omap ic <Plug>(coc-classobj-i)
            xmap ac <Plug>(coc-classobj-a)
            omap ac <Plug>(coc-classobj-a)

            " Remap <C-f> and <C-b> for scroll float windows/popups.
            if has('nvim-0.4.0') || has('patch-8.2.0750')
                nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
                nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
                inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
                inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
                vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
                vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
            endif

            " Use CTRL-S for selections ranges.
            " Requires 'textDocument/selectionRange' support of language server.
            nmap <silent> <C-s> <Plug>(coc-range-select)
            xmap <silent> <C-s> <Plug>(coc-range-select)

            " Add `:Format` command to format current buffer.
            command! -nargs=0 Format :call CocActionAsync('format')

            " Add `:Fold` command to fold current buffer.
            command! -nargs=? Fold :call     CocAction('fold', <f-args>)

            " Add `:OR` command for organize imports of the current buffer.
            command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

            " Add (Neo)Vim's native statusline support.
            " NOTE: Please see `:h coc-status` for integrations with external plugins that
            " provide custom statusline: lightline.vim, vim-airline.
            "set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

            " Mappings for CoCList
            " Show all diagnostics.
            " nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
            " Manage extensions.
            " nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
            " Show commands.
            " nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
            " Find symbol of current document.
            " nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
            " Search workspace symbols.
            " nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
            " Do default action for next item.
            " nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
            " Do default action for previous item.
            " nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
            " Resume latest coc list.
            " nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

    "[ALE]"

        Plug 'dense-analysis/ale'
            " ale-setting {{{
            let g:ale_set_highlights = 1
            let g:ale_set_quickfix = 1
            let g:ale_sign_error = '✖'
            let g:ale_sign_warning = 'ℹ'
            let g:ale_statusline_format = ['✖ %d', 'ℹ %d', '✔ OK']
            let g:ale_echo_msg_error_str = 'E'
            let g:ale_echo_msg_warning_str = 'W'
            let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
            let g:ale_lint_on_enter = 1

            nmap sp <Plug>(ale_previous_wrap)
            nmap sn <Plug>(ale_next_wrap)
            "nmap <Leader>l :ALEToggle<CR>
            nmap <Leader>d :ALEDetail<CR>
            let g:ale_linters = {
                \ 'go': ['go vet', 'go fmt'],
                \ }

    "[vim-rego]"

        Plug 'tsandall/vim-rego'

        Plug 'sbdchd/neoformat'
            let g:neoformat_rego_opa = {
                  \ 'exe': 'opa',
                  \ 'args': ['fmt'],
                  \ 'stdin': 1,
                  \ }
            let g:neoformat_enabled_rego = ['opa']
            " augroup fmt
            "   autocmd!
            "   autocmd BufWritePre * undojoin | Neoformat
            " augroup END

    "[commentary]"

        Plug 'tpope/vim-commentary'

call plug#end()

"========================================
" Keymap
"========================================
"
" | cmd   | command   | normal | visual | operator pending | insert only | command line |
" |-------|-----------|--------|--------|------------------|-------------|--------------|
" | :map  | :noremap  | √      | √      | √                |             |              |
" | :nmap | :nnoremap | √      |        |                  |             |              |
" | :vmap | :vnoremap |        | √      |                  |             |              |
" | :omap | :onoremap |        |        | √                |             |              |
" | :map! | :noremap! |        |        |                  | √           | √            |
" | :imap | :inoremap |        |        |                  | √           |              |
" | :cmap | :cnoremap |        |        |                  |             | √            |

"--------------------
" Default
"--------------------

" source vimrc
nmap <leader>s :source $MYVIMRC<cr>

" no highlight
nmap <leader><cr> :nohlsearch<cr>

"--------------------
" Golang
"--------------------

:command -nargs=* GoTest call GoTest(<f-args>)
function! GoTest(...)
    if a:0
        execute '!go test -v . -test.run' a:1 '| less'
    else
        execute '!go test -v ./... | less'
    endif
endfunction

"--------------------
" Print
"--------------------

" date
:command PrintDate call PrintDate()
function! PrintDate()
    r!date --iso-8601=seconds
endfunction

" uuid
:command PrintUuid call PrintUuid()
function! PrintUuid()
    r!uuidgen
endfunction

"--------------------
" Format
"--------------------

" underline to little camel
:command -range ToLittleCamel <line1>,<line2>call ToLittleCamel()
function ToLittleCamel() range
    execute a:firstline ',' a:lastline 'substitute /_\(\w\)/\u\1/g'
endfunction

" remove trailing spaces
:command RemoveTrailingSpaces call RemoveTrailingSpaces()
function! RemoveTrailingSpaces()
    %s/[ \t]*$//
    nohlsearch
    execute "normal \<C-o>"
endfunction

" fix tab
:command FixIndent call FixIndent()
function! FixIndent()
    execute "normal gg=G<C-o><C-o>zz"
endfunction

" unix format
nmap <leader>ff :set ff=unix<cr>:set ff?<cr>

" remove ^M
nmap <leader>fm :%s/<C-V><C-M>//ge<CR>

" indent
nmap =b =iB<C-o>

"--------------------
" Color
"--------------------

" Black、DarkBlue、DarkGreen、DarkCyan、DarkRed、DarkMagenta、
" Brown(DarkYellow)、LightGray(LightGrey、Gray、Grey)、DarkGray(DarkGrey)、
" Blue(LightBlue)、Green(LightGreen)、Cyan(LightCyan)、Red(LightRed)、
" Magenta(LightMagenta)、Yellow(LightYellow)、White
" PrintColor: curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/ | bash

" pop up
hi Pmenu      ctermfg=223 ctermbg=239 guifg=#ebdbb2 guibg=#504945
hi PmenuSel   cterm=bold ctermfg=239 ctermbg=109 gui=bold guifg=#504945 guibg=#83a598
hi PmenuSbar  ctermbg=239 guibg=#504945
hi PmenuThumb ctermbg=243 guibg=#7c6f64

" coc plugin
hi FgCocErrorFloatBgCocFloating cterm=reverse ctermfg=15 ctermbg=160
hi CocErrorHighlight            ctermfg=White ctermbg=Red
hi CocWarningHighlight          ctermfg=Black ctermbg=Yellow
hi CocInfoHighlight             ctermfg=108

" git gutter plugin
highlight clear SignColumn
highlight GitGutterAdd ctermfg=2
highlight GitGutterChange ctermfg=3
highlight GitGutterDelete ctermfg=1
highlight GitGutterChangeDelete ctermfg=4

" list char
set nolist
set listchars=tab:\┊\ ,trail:~,extends:>,precedes:<,space:·
hi SpecialKey ctermfg=DarkGray

" color column
execute "set colorcolumn=".join(range(81,120), ',')
hi ColorColumn cterm=NONE ctermbg=235

" Cursor
set cursorcolumn
set cursorline
hi CursorLine   cterm=NONE ctermbg=237
hi CursorColumn cterm=NONE ctermbg=233

" Diff
hi DiffAdd    cterm=reverse ctermfg=108 ctermbg=235 gui=reverse guifg=#b8bb26 guibg=#282828
hi DiffChange cterm=reverse ctermfg=108 ctermbg=235 gui=reverse guifg=#8ec07c guibg=#282828
hi DiffDelete cterm=reverse ctermfg=167 ctermbg=235 gui=reverse guifg=#fb4934 guibg=#282828
hi DiffText   cterm=reverse ctermfg=114 ctermbg=235 gui=reverse guifg=#fabd2f guibg=#282828

" spell
if has("spell")
   hi SpellBad                ctermbg=52
   hi SpellCap                ctermbg=17
   hi SpellLocal              ctermbg=17
   hi SpellRare  ctermfg=none ctermbg=none  cterm=reverse
endif

" search
hi IncSearch cterm=reverse ctermfg=208 ctermbg=235 gui=reverse guifg=#fe8019 guibg=#282828
hi Search    cterm=reverse ctermfg=214 ctermbg=235 gui=reverse guifg=#fabd2f guibg=#282828

" markdown
hi mkdCodeDelimiter ctermfg=244
hi mkdCode          ctermfg=244
hi Title            ctermfg=226 gui=bold guifg=gold
hi htmlStatement    ctermfg=180

