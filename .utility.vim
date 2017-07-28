"bks
" align chapters in TOC, seperated by 3 or more dots.
command! -nargs=1 AlignTOC %s/^\(.* \)\.\{3,\}\( [0-9ivx]\+\)$/\=submatch(1).repeat('.',<args>-len(submatch(1))-len(submatch(2))).submatch(2)/
" contents in  xx.logmf
func! NextChapter() range
    " or test existence of b:pat_chapter
    for i in range(v:count1)
        call search('^\d\+ .* \d\+$')
    endfor
endfunc
func! PrevChapter() range
    for i in range(v:count1)
        call search('^\d\+ .* \d\+$','b')
    endfor
endfunc

" https://vi.stackexchange.com/a/1958/10254
command! -nargs=1 Silent execute ':silent !'.<q-args> | execute ':redraw!'

" func! Capture(command)
"     redir =>output
"     silent exec a:command
"     redir END
"     return output
" endfunc!

func! Capture(excmd) abort  " from tpope's scriptease.vim
  try
    redir => out
    exe 'silent! '.a:excmd
    " silent 'exe! '.a:excmd
  finally
    redir END
  endtry
  return out
endfunc

" TODO: add cache, for both command and result, result assumes @c not cluttered by other command.
func! PutAfterCapture(command)
    if a:command =~ '^\s*$'
        return
    endif
    let oldpos = getpos('.')
    silent! let @c = Capture(a:command)
    " :put =Capture(a:command)     " use '=' register, not to clutter register.
    " a:command may change cursor position
    call setpos('.', oldpos)
    put c
    " put change cursor position
    call setpos('.', oldpos)
endfunc!

func! ExternalCommandCapture(command)
endfunc!

" usage, 'Icapture ls'
command! -bar -nargs=+ Icapture call PutAfterCapture(<q-args>)
" TODO not work, usage, 'Capture ls|copen'
" see ~/.vim/bundle/vim-scriptease/plugin/scriptease.vim    -- ':copen' then search 'ease' then 'gf' then search 'copen'
" command! -bar -nargs=+ Capture call Capture(<q-args>)

" emacs <C-l> equivalent, similar to 'zz' then 'zt' then 'zb'
" todo

func! IcecreamInitialize()
python3 << EOF
class StrawberryIcecream:
    def __call__(self):
        print('EAT ME')
obj = StrawberryIcecream()
obj()
EOF
endfunc

" ~/.vim/bundle/vim-colors-solarized/autoload/togglebg.vim
" func! s:TogBG()
func! TogBG()
    let &background = ( &background == "dark"? "light" : "dark" )
    if exists("g:colors_name")
        exe "colorscheme " . g:colors_name
    endif
endfunc


" .utility.vim
" .vimrc
