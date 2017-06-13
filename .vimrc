""""""""""""""""""""""""""""
"
"  This is Rz's vimrc
"
""""""""""""""""""""""""""""

" Vundle
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
filetype off    	" Vundle required!

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle, require!
Plugin 'VundleVim/Vundle.vim'

" And all your plugins here
"Plugin 'tmhedberg/SimpylFold'			" 代码折叠
Plugin 'vim-scripts/indentpython.vim'		" 自动缩进
Plugin 'Valloric/YouCompleteMe'			" 自动补全
Plugin 'scrooloose/nerdtree'			" 文件树形结构
"Plugin 'jistr/vim-nerdtree-tabs'		" 树形结构使用tab键
Plugin 'scrooloose/syntastic'			" 语法检查
Plugin 'nvie/vim-flake8'			" PEP8代码风格检查
Plugin 'jnurmine/Zenburn'			" Zenburn配色
Plugin 'altercation/vim-colors-solarized'	" Solarized配色方案
"Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
						" 状体栏插件
Plugin 'tpope/vim-fugitive'			" 在Vim中执行基本的Git命令

call vundle#end()
filetype plugin indent on		" Vundle required

" Set Plugin parameter
let python_highlight_all=1		" 让代码更漂亮

map <C-n> :NERDTreeToggle<CR>		" Open with Ctrl+n
let NERDTreelgnore=['\.pyc$', '\~$']	" Ingore files in NERDTree

let g:SimpylFold_docstring_preview=1	" 显示折叠代码的文档字符串

" for ycm
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:ycm_error_symbol = '>>'
let g:ycm_warning_symbol = '>*'
let g:ycm_autoclose_preview_window_after_conpletion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
nmap <F4> :YcmDiags<CR>

" Configuration file for vim
set modelines=0		" CVE-2007-2438
set nu			" 显示行号
set ruler		" 显示坐标
set showcmd		" 显示输入的命令
set confirm		" 处理未保存或只读文件时弹出确认
set nobackup		" 覆盖文件不备份
set cursorline		" 突出显示当前行
set encoding=utf-8  	" Set utf-8
set backspace=2		" more powerful backspacing
set clipboard=unnamed	" 访问系统剪贴板

syntax on		" 语法高亮

" Python indent
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |

" Else indent
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |

" 标示多余的空白字符
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup nobackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup nobackup

" Set split zone
set splitbelow
set splitright
" Split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


" Choose color
if has('gui_running')
    set background=dark
    colorscheme solarized
else
    colorscheme Zenburn
endif

""""""""""""""""""""""""""""""
" Quickly Run
""""""""""""""""""""""""""""""
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'cpp'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'java'
		exec "!javac %"
		exec "!time java %<"
	elseif &filetype == 'sh'
		:!time bash %
	elseif &filetype == 'python'
		exec "!time python3 %"
	elseif &filetype == 'html'
		exec "!firefox % &"
	elseif &filetype == 'go'
		exec "!time go run %"
	elseif &filetype == 'mkd'
		exec "!~/.vim/markdown.pl % > %.html &"
		exec "!firefox %.html &"
	endif
endfunc
