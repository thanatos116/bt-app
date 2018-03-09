set number
set incsearch
set nocompatible
set cursorline
set ruler
set hlsearch
set title
set laststatus=2
set expandtab
set tabstop=4
set shiftwidth=4
set smartcase
set ic
set foldmethod=syntax
set nofoldenable

let mapleader=";"

colorscheme molokai
syntax on
set t_Co=256

map <F4> :set nu!<BAR>set nu?<CR>
" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" High light unwanted spaces in end of line
highlight ExtraWhitespace ctermbg=darkred guibg=darkcyan
autocmd BufEnter * if &ft != 'help' | match ExtraWhitespace /\s\+$/ | endif
autocmd BufEnter * if &ft == 'help' | match none /\s\+$/ | endif

" vundle 环境设置
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
" vundle 管理的插件列表必须位于 vundle#begin() 和 vundle#end() 之间
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'Lokaltog/vim-powerline'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'kshenoy/vim-signature'
Plugin 'majutsushi/tagbar'
Plugin 'dyng/ctrlsf.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'Valloric/YouCompleteMe'
" 插件列表结束
call vundle#end()
filetype plugin indent on

" 设置 tagbar 子窗口的位置出现在主编辑区的左边 
let tagbar_left=1 
" 设置显示／隐藏标签列表子窗口的快捷键。速记：identifier list by tag
nnoremap <Leader>ilt :TagbarToggle<CR> 
" 设置标签子窗口的宽度 
let tagbar_width=32 
" tagbar 子窗口中不显示冗余帮助信息 
let g:tagbar_compact=1
" " 设置 ctags 对哪些代码标识符生成标签
let g:tagbar_type_cpp = {
    \ 'kinds' : [
         \ 'c:classes:0:1',
         \ 'd:macros:0:1',
         \ 'e:enumerators:0:0', 
         \ 'f:functions:0:1',
         \ 'g:enumeration:0:1',
         \ 'l:local:0:1',
         \ 'm:members:0:1',
         \ 'n:namespaces:0:1',
         \ 'p:functions_prototypes:0:1',
         \ 's:structs:0:1',
         \ 't:typedefs:0:1',
         \ 'u:unions:0:1',
         \ 'v:global:0:1',
         \ 'x:external:0:1'
     \ ],
     \ 'sro'        : '::',
     \ 'kind2scope' : {
         \ 'g' : 'enum',
         \ 'n' : 'namespace',
         \ 'c' : 'class',
         \ 's' : 'struct',
         \ 'u' : 'union'
     \ },
     \ 'scope2kind' : {
         \ 'enum'      : 'g',
         \ 'namespace' : 'n',
         \ 'class'     : 'c',
         \ 'struct'    : 's',
         \ 'union'     : 'u'
     \ }
\ }


" 正向遍历同名标签
 nmap <Leader>tn :tnext<CR>
" 反向遍历同名标签
 nmap <Leader>tp :tprevious<CR>

 " 使用 ctrlsf.vim 插件在工程内全局查找光标所在关键字，设置快捷键。快捷键速记法：search in project
 nmap <Leader>sp :CtrlSF<CR>

 " 使用 NERDTree 插件查看工程文件。设置快捷键，速记：file list
  nmap <Leader>fl :NERDTreeToggle<CR>
 " " 设置NERDTree子窗口宽度
  let NERDTreeWinSize=32
 " " 设置NERDTree子窗口位置
  let NERDTreeWinPos="right"
 " " 显示隐藏文件
  let NERDTreeShowHidden=1
 " " NERDTree 子窗口中不显示冗余帮助信息
  let NERDTreeMinimalUI=1
 " " 删除文件时自动删除文件对应 buffer
  let NERDTreeAutoDeleteBuffer=1

  " 显示/隐藏 MiniBufExplorer 窗口
   map <Leader>bl :MBEToggle<cr>
  " buffer 切换快捷键
  " map <C-q> :MBEbn<cr>
  " map <Leader> :MBEbp<cr>

nnoremap <Leader>ff :set nomore<Bar>:ls<Bar>:set more<CR>:b<Space>
