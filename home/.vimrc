

"==================================
"    Vim基本配置
"===================================

"关闭vi的一致性模式 避免以前版本的一些Bug和局限
set nocompatible
"配置backspace键工作方式
set backspace=indent,eol,start

"显示行号
set number
"设置在编辑过程中右下角显示光标的行列信息
set ruler

"在状态栏显示正在输入的命令
set showcmd

"set font size
set guifont=monospace:h9

"设置历史记录条数
set history=1000


set nobackup

"设置匹配模式 类似当输入一个左括号时会匹配相应的那个右括号
set showmatch

"设置颜色方案
colorscheme molokai
let g:molokai_original = 1
let g:rehash256 = 1
set background=dark

"设置C/C++方式自动对齐
set autoindent
set cindent

"开启语法高亮功能
syntax enable
syntax on

"指定配色方案为256色
set t_Co=256

"设置搜索时忽略大小写
set ignorecase

"set highligh search
set hlsearch

:hi Search term=bold ctermbg=24 guibg=#13354A


"设置Tab宽度
set tabstop=4
"设置自动对齐空格数
set shiftwidth=4
"设置按退格键时可以一次删除4个空格
set softtabstop=4
"设置按退格键时可以一次删除4个空格
set smarttab
"将Tab键自动转换成空格 真正需要Tab键时使用[Ctrl + V + Tab]
set expandtab

"设置编码方式
set encoding=utf-8
"自动判断编码时 依次尝试一下编码
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'Lokaltog/vim-powerline'
Bundle 'Valloric/YouCompleteMe'
Bundle 'taglist.vim'
Bundle 'grep.vim'
Bundle 'ctrlp.vim'

let g:ycm_global_ycm_extra_conf = '/home/nyankosama/.ycm_extra_conf.py'


set laststatus=2
set t_Co=256
let g:Powline_symbols='fancy'




"检测文件类型
filetype on
"针对不同的文件采用不同的缩进方式
filetype indent on
"允许插件
filetype plugin on
"启动智能补全
filetype plugin indent on

" toggle between terminal and vim mouse

map <silent><F3> :set number <CR>
map <silent><F2> :set nonu <CR>
map <silent><C-y> :YcmDiags <CR>
map <silent><C-i> :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <silent><C-h> :nohl <CR>

nnoremap <silent> <F5> :NERDTree<CR>
"nnoremap <silent> <F4> :TlistToggle<CR>


map <silent><F12> :let &mouse=(&mouse == "a"?"":"a")<CR>:call ShowMouseMode()<CR>
imap <silent><F12> :let &mouse=(&mouse == "a"?"":"a")<CR>:call ShowMouseMode()<CR>
function ShowMouseMode()
    if (&mouse == 'a')
        echo "mouse-vim"
    else
        echo "mouse-xterm"
    endif
endfunction


" transfer/read and write one block of text between vim sessions
" Usage:
" `from' session:
" ma
" move to end-of-block
" xw
"
" `to' session:
" move to where I want block inserted
" xr
"
if has("unix")
nmap fp :r $HOME/.vimxfer<CR>
nmap fw :'a,.w! $HOME/.vimxfer<CR>
vmap fp c<esc>:r $HOME/.vimxfer<CR>
vmap fw :w! $HOME/.vimxfer<CR>
else
nmap fp :r c:/.vimxfer<CR>
nmap fw :'a,.w! c:/.vimxfer<CR>
vmap fp c<esc>:r c:/.vimxfer<cr>
vmap fw :w! c:/.vimxfer<CR>
endif

" auto generate head definition
" usage: in normal pattern, press ,ha

function InsertHeadDef(firstLine, lastLine)
    if a:firstLine <1 || a:lastLine> line('$')
        echoerr 'InsertHeadDef : Range overflow !(FirstLine:'.a:firstLine.';LastLine:'.a:lastLine.';ValidRange:1~'.line('$').')'
        return ''
    endif
    let sourcefilename=expand("%:t")
    let definename=substitute(sourcefilename,' ','','g')
    let definename=substitute(definename,'\.','_','g')
    let definename = toupper(definename)
    exe 'normal '.a:firstLine.'GO'
    call setline('.', '#ifndef _'.definename."_")
    normal ==o
    call setline('.', '#define _'.definename."_")
    exe 'normal =='.(a:lastLine-a:firstLine+1).'jo'
    call setline('.', '#endif')
    let goLn = a:firstLine+2
    exe 'normal =='.goLn.'G'
endfunction
function InsertHeadDefN()
    let firstLine = 1
    let lastLine = line('$')
    let n=1
    while n < 20
        let line = getline(n)
        if n==1 
            if line =~ '^\/\*.*$'
                let n = n + 1
                continue
            else
                break
            endif
        endif
        if line =~ '^.*\*\/$'
            let firstLine = n+1
            break
        endif
        let n = n + 1
    endwhile
    call InsertHeadDef(firstLine, lastLine)
endfunction
nmap ,ha :call InsertHeadDefN()<CR> 

"auto set file head info such as:author, modify time, etc..
"usage: in normal pattern, press F4
"进行版权声明的设置
"添加或更新头
map <F4> :call TitleDet()<cr>'s
function AddTitle()
    call append(0,"/*=============================================================================")
    call append(1,"#")
    call append(2,"# Author: liangrui.hlr email:i@nyankosama.com")
    call append(3,"#")
    call append(4,"# Last modified: ".strftime("%Y-%m-%d %H:%M"))
    call append(5,"#")
    call append(6,"# Filename: ".expand("%:t"))
    call append(7,"#")
    call append(8,"# Description: ")
    call append(9,"#")
    call append(10,"=============================================================================*/")
    echohl WarningMsg | echo "Successful in adding the copyright." | echohl None
endf
"更新最近修改时间和文件名
function UpdateTitle()
    normal m'
    execute '/# *Last modified:/s@:.*$@\=strftime(":\t%Y-%m-%d %H:%M")@'
    normal ''
    normal mk
    execute '/# *Filename:/s@:.*$@\=":\t\t".expand("%:t")@'
    execute "noh"
    normal 'k
    echohl WarningMsg | echo "Successful in updating the copy right." | echohl None
endfunction
"判断前10行代码里面，是否有Last modified这个单词，
"如果没有的话，代表没有添加过作者信息，需要新添加；
"如果有的话，那么只需要更新即可
function TitleDet()
    let n=1
    "默认为添加
    while n < 10
        let line = getline(n)
        if line =~ '^\#\s*\S*Last\smodified:\S*.*$'
            call UpdateTitle()
            return
        endif
        let n = n + 1
    endwhile
    call AddTitle()
endfunction
