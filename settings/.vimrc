syntax on
colorscheme molokai "evening
set number
set smartindent
set showmatch
set hlsearch
set listchars=tab:>-,trail:-
"set list
set smarttab
set shiftwidth=4
set autoindent
set paste
set ruler
set tabstop=4
set expandtab
set cindent
set smarttab
"set rtp+=/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim/
set laststatus=2
set t_Co=256

"###################    set file head start  #########################
"autocmd创建新文件自动调用setfilehead()函数
autocmd BufNewFile *.v,*.sv,*.cpp,*.c,*.h exec ":call Setfilehead()"
func Setfilehead()
    call append(0, '/**********************************************************************************************')
    call append(1, '*')
    call append(2, '*   Filename: '.expand("%"))
    call append(3, '*')
    call append(4, '*   Author: theArcticOcean - wei_yang1994@163.com')
    call append(5, '*')
"    call append(6, '*   Create: '.strftime("%Y-%m-%d %H:%M:%S"))
    call append(6, '**********************************************************************************************/')
"    call append(9, '')
endfunc

"map F2 to creat file head comment
"映射F2快捷键，生成后跳转至第10行，然后使用o进入vim的插入模式
map <F2> :call Setfilehead()<CR>:10<CR>o
"###################    set file head end   ##########################



"###################    set comment to introduct code block  #########################
func SetCommentBlock()
    call append(line(".")  , '////////////////////////////////////////////////')
	call append(line(".")+1, '////////////////////////////////////////////////')
endfunc

"映射F11快捷键，生成后跳转，然后使用O进入vim的插入模式
map <F3> :call SetCommentBlock()<CR>j<CR>O
"###################    set comment end   ##########################

"open or close files tree
nnoremap <silent> <F12> :NERDTree<CR>

"对于 Pathogen 这个”插件中的插件“
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
Helptags
