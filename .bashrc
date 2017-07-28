# custFile for bash, sourced by ~/.bashrc
# . ~/notes/.bashrc     # append this line to ~/.bashrc to make sourced an interactive bash is invoked.
# check also ~/.bash_profile

# set vi mode editing
set -o vi
# insert-mode key bindings
#+ bind <Esc-.> to yank-last-arg, Nth last if type Nth time.
#+ for zsh, bindkey "\e." insert-last-word
#+ in zsh, bindkey -M viins 'kj' vi-cmd-mode
#+ bind 'kj' to return to vi-cmd-mode when in insert mode
# "key, see " bind " inputrc

# "bind, see " key " inputrc
bind '"\C-p":history-search-backward'
bind '"\ep":history-search-backward'
bind '"\e.":yank-last-arg'
bind '"Tab":complete'
bind '"\C-n":menu-complete'
bind '"\C-l":menu-complete-backward'
bind '"\ew":unix-filename-rubout'
bind '"\eh":unix-filename-rubout'
# bind '"\C-u":unix-line-discard'
bind '"\C-a":beginning-of-line'
bind '"\C-e":end-of-line'
bind '"\C-w":backward-kill-word'
bind '"\C-k":kill-line'
bind '"\C-o":undo'
bind '"\C-o":revert-line'
bind '"\C-f":forward-char'
bind '"\C-b":backward-char'
bind '"\ef":forward-word'
bind '"\eb":backward-word'
# keybindings are now defined in .inputrc
stty -ixon  # You will need to do stty -ixon before Ctrl-s will work. – Dennis Williamson Nov 15 '10 at 23:51   http://unix.stackexchange.com/questions/4079/put-history-command-onto-command-line-without-executing-it#comment4618_4086
# -- eg, !! last command , !-3 last third command, !222 222th command in .bash_history
# Another small one: Alt+# comments out the current line and moves it into the history buffer.  https://unix.stackexchange.com/a/78845/202329

# "inputrc, "readline setting, add below lines to, eg, ~/.inputrc , if not been included yet.
# set show-mode-in-prompt on
# set show-all-if-ambiguous on
# set completion-ignore-case on
# set bell-style none

# "completion, see " history
shopt -s nocaseglob     # ~/.inputrc文件中添加： set completion-ignore-case on
complete -c h   # https://unix.stackexchange.com/a/345205/202329
complete -c v   # version
complete -c w   # alias w='whatis'
complete -c wh  # alias wh='command -v'
_my_complete_ai_apt_install_alias() {
    # see file apt apt-get dpkg git in /usr/share/bash-completion/completions
    # a working example very similar to below for 'apt install' alias. Bash下实现alias补全 http://adam8157.info/blog/2010/05/bash-alias-completion/
    # git alias example  https://stackoverflow.com/questions/342969/how-do-i-get-bash-completion-to-work-with-aliases/1793178
    # a general solution  https://github.com/cykerway/complete-alias    https://unix.stackexchange.com/a/332522/202329
    local cur;
    cur=$(_get_cword);
    COMPREPLY=( $( apt-cache --no-generate pkgnames "$cur" 2> /dev/null ) )
    return 0
}
complete -F _my_complete_ai_apt_install_alias $default ai show vl  # both for apt
# todo: complete for alias apt not work, error completion: function _apt not found.
# alias apt='sudo apt'
# complete -F _apt apt

# "history setting ~/.bash_history
# use `^[^#].*\_$\n\_^[^#]` to search two consecutive line that are not comments in bash history file.
## and search `^\s*$` for blank lines, to remove blank entries.
shopt -s globstar   # pattern "**" used in pathname expansion context will match all files and zero or more directories and subdirectories.
shopt -s histappend
shopt -s histverify     # If you have the histverify option set (shopt -s histverify), you will always have the opportunity to edit the result of history substitutions.  http://unix.stackexchange.com/a/4086
# HISTFILE  # could set to a synced folder
HISTFILESIZE=-1
HISTSIZE=-1
HISTCONTROL=ignoreboth	# ignoredups and ignorespace (line begin with space are not stored)
HISTIGNORE='?:??:history'
HISTTIMEFORMAT='%F %T '	# Record timestamps, use `date -d @${timestamp} '+%D-%T'` (depend on your timezone)
shopt -s cmdhist	# attempt to save all lines of a multiple-line command in the same history entry	
PROMPT_COMMAND='history -a'	# Store history immediately
#+ execute last command
alias r='fc -s'
alias bP='bind -P |vim -i NONE "+setl bt=nofile |setf text" -c "nnoremap q :q<Enter>" -'

anyjobs() { [[ "$1" != 0 ]] && echo "$1"; } # https://unix.stackexchange.com/a/446149/202329
# prompt setting
PS1='\e[1;34m$(pp="$PWD/" q=${pp/#"$HOME/"/} p=${q%?};((${#p}>19))&&echo "${p::9}…${p:(-9)}"||echo "$p") \A $(anyjobs \j)\$ \e[m' # none if $HOME, ${t%?} to remove last char of string t. 
# PS1='\e[1;34m$(p=${PWD/#"$HOME/"/};((${#p}>19))&&echo "${p::9}…${p:(-9)}"||echo "$p") \A $(anyjobs \j)\$ \e[m'    # full pathname if $HOME
# PS1='\e[1;34m [$(p=${PWD/#"$HOME"/\047~\047};((${#p}>30))&&echo "${p::10}…${p:(-19)}"||echo "\w")]$(anyjobs \j)\$ \e[m'
# PS1='\e[1;34m /\W \t \j\$ \e[m'
    # https://askubuntu.com/questions/17723/trim-the-terminal-command-prompt-working-directory

function settitle() { echo -ne '\e]0;'"${1--bash}"'\a'; }

# "pager, "less, see " info " help
export PAGER="less"
# All three pager programs, more, less and lv, support passing parameters via separate environment variables. These variables are named LESS, MORE and LV, respectively. 
export LESS="-isRM"
# from http://www.refining-linux.org/archives/3/Configuring-your-console-pager/

# "edit, see " vim
alias vi=vim
# alias vf='vim -i ~/.viminfof'    # use vf for ft
function vf() {
    depth=${1:-1}
    if (($# >= 2)); then
    vim $(find -type f -maxdepth $depth -iname "*${2}"); else
    vim $(find -type f -maxdepth $depth);
    fi
}
alias v-='vim -c "set path=$PWD" -c "set bt=nofile" -c "nn q :q<CR>" --cmd "let g:ctrlp_cache_dir=\"~/swo/.cache/ctrlp/v-\"" -'
alias v--='vim -c "set path=$PWD" -c "set bt=nofile" -c "nn q :q<CR>" --cmd "let g:ctrlp_cache_dir=\"~/swo/.cache/ctrlp/v-\"" '
alias vN='vim -i NONE -c "set path+=$PWD" -c "setf text" -c "setl bt=nofile" -c "nnoremap q :q<Enter>" --cmd "let g:loaded_ctrlp = 1"'
alias vNN='vim -N -u NONE -c "set nocp| nn gt <C-^>|nn <C-l> :bn<CR>| nn <C-h> :bp<CR>| nn ; :|cno ; <C-e><C-u><C-h><Esc><Esc><Esc>| nnoremap q :q<Enter>"'
alias vnn=vNN
alias vq='vim -i NONE -c "set path+=$PWD" -c "nnoremap q :q<Enter>"'
alias npp='d:/programfiles/nppbin/notepad++.exe'
alias vimnoctrlp='vim --cmd "let g:loaded_ctrlp = 1"'

alias vimi='vim -i ~/.tmpiviminfo'
alias v.='vN .'
# "vim, see also " edit " cpp
# function v* { if (( $# == 0 )); then vi *; else vi *.$1; fi }
function vv {
    if (( $# == 0 )); then
        # vimnoctrlp *;
        find -L -maxdepth 1 -type f -exec vim --cmd "let g:loaded_ctrlp = 1" {} +
    elif (( $# == 2 )); then
        vimnoctrlp *.$1 *.$2;
    else    # use only first arg as extension.
        vimnoctrlp *.$1;
    fi
}
alias v*=vv
alias v8=vv
alias xvi='vimnoctrlp -c "sil argdo %!xxd" -c "sil argdo set bt=nofile"'

# "alias
#alias vim='d:/pkg/dt/vim/vim.exe'
# alias mysql='/c/Program\ Files/MySQL/MySQL\ Server\ 5.7/bin/mysql.exe'

# "dirs, see " cd " unix.scp:/^.dirs/
alias d='dirs -v'
alias pd='pushd'

# CDPATH, similar to PATH
# "cd, see " dirs " info
function abspath() { (cd ${1:-.} && pwd); }
alias c-='cd ~-'
alias c.='cd ..'
alias c..='cd ../..'
# pust this to '~/.bash_profile' to make it global?
# mkdir -p list_of_dir && cd list_of_dir[-1]. currently only first word (contain non-space solely) was used.
function mcd() {  # mkdir -p list_of_dir && cd list_of_dir[-1]. currently only first word (contain non-space solely) was used.
    if [ "$#" -ne 1 ]; then
        echo 'Too many or to few arguments. only one is expected.
        exited.';
		# echo 'Only **one** arg was expected.';
        return 1;
    elif ! cd $1 &>/dev/null; then
        mkdir -p $1 && cd $1;
        # cd $1 &>/dev/null ||
        #     (mkdir -p $1; cd $1);
        # Note that '||' and '&&' in bash are of same precedence.
        # also cd inside '()' never change current directory, since '()' creates subshell.
        # mkdir -p "$1" && cd "$1";
    fi
}

alias rm='rm -i'
alias rm-f='rm -f'
alias mv='mv -i'
alias cp='cp -i'
function cp- { if (( $# == 0 )); then echo '**one** arg, please.'; else cp ${OLDPWD}/$1 .; fi }

# "info, see " ll " ed " help
alias wh='command -v'   # use shell builtin hash, command -v, type -P. not external command which.
function wh() { command -v "$@"; }
function h() { "$*" --help || "$*" -h || help "$*"; }
# function pe() { str=${1^^}; printev ${str}; }
function pe() { str=${1^^}; echo ${!str}; }
alias str=strings

# "ls, see " ll " cd " dirs " info " edit " python
    # " ag " lang

# "ll, see " cd " dirs " info
# alias ll='ls -ahl --color=auto'
# NOTE: if use nested alias such as `alias llld='ls -d */'`, there will be two slash.  https://stackoverflow.com/a/40314363/3625404
_LS_PRINT_OPTION=' --color=auto --show-control-chars'
alias ls='\ls -F --color=auto --show-control-chars'
alias ll='ls -ahl'
alias ls.='ls ..'
alias ld="\ls -d $_LS_PRINT_OPTION */"          # directory
# function ld() { ls -d $_LS_PRINT_OPTION "${1}*/"; }     # todo: '$1./' or "".
alias lda="\ls -d $_LS_PRINT_OPTION .*/ */"     # directory, include hidden ones
alias ldc="\ls -1 -d $_LS_PRINT_OPTION .*/ */"     # directory, in one column
function lf_macro() {   # qeatzy's answer https://unix.stackexchange.com/questions/329994/alias-and-functions
    local CMD=${1:-ls} DIR=${2:-.};
    if [ ${CMD} != ls -a  ${CMD} != ll ]; then return 1; fi
    bash -c "$CMD" '$(find $DIR -maxdepth 1 -type f | cut -c3-)';
}
function lsf() { lf_macro ls "$1"; }
function lf() {	# show all files, no directories
	local DIR="${@:-.}"
	if [ $DIR = "." ]; then
		ll $(find $DIR -maxdepth 1 -type f | cut -c3-);
	fi
}
# alias lf='lf_macro ll'
# alias lf='ll $(find -maxdepth 1 -type f)'
# alias lsf='ls $(find -maxdepth 1 -type f)'
alias l.="\ls -dF $_LS_PRINT_OPTION .[!.]*"
alias l..='ls ..'
alias llt='ll -t |vN -'
# alias llt='ll -t |sed -r "s/(.*) ([^ ]+)$/\2 \1/" |vN -'
alias llh='ll |head'
alias llth='ll -t |head'
alias la='ls -A'
alias l-='ls ~-'
alias lld="\ls -ahl $_LS_PRINT_OPTION -d */"       # directory
alias lS='ls -S'
alias llS='ll -S'
alias lls='ll -S'
alias llsh='ll -S|head'
alias llsv='ll -S |v-'
function llv () { ll "$@" |v-; }
alias lsh='ls ~'
alias llh='ll ~'
alias lsv='la |v-'
alias laf='la ~'
alias lR='ls -R'
# alias cc='clear'

# "du
alias du='\du -h'
alias dus='\du -sh'
alias df='\df -h'

# "perl, see " lang
# alias pd='perldoc'
alias pdv='perldoc -v'
alias pdq='perldoc -q'
alias pdf='perldoc -f'

# "lang, see "" ls
#   " python " R

# "python, see "" lang " cygwin
# alias pip='python -m pip'     # bad for venv, could use wrong pip
alias py=python
alias py3=python3

# "R, see "" lang
alias R='/usr/bin/R --quiet'

# "cpp, see also " lang " edit " git
alias vc='vim -i ~/.viminfoc *.{hpp,h,cpp}'    
# alias vc='vim -i ~/.viminfoc *.cpp *.h'    
alias lsc='ls *.{h,cpp}'

alias lfc='find -type f|wc'
function llc() { find |wc; find -type f|wc; }
function llc() { echo $(find |wc) "	" $(find -type f|wc); }
# "dir, "tree, see also " explorer " find " fd(find)
# bash test if is a directory is git repo. https://stackoverflow.com/questions/2180270/
#     git rev-parse --is-inside-work-tree # works for subdirectories too
#     impl logic of git 'rev-parse'. inside .git dir, 2 folders: objects refs  1 file HEAD. https://stackoverflow.com/a/27452421/3625404
# alias treev='tree | v-'
function treev() { tree "$@" |v-; }
# alias findv='find | v-'
function findv() {
    if [[ $- != *i* ]]; then
        find $1 -type f;
    else
        find $1 -type f | v-;
    fi
}

# " explorer
alias explorer='cygstart .'  # Open Windows Explorer to the current working directory from Cygwin
alias udiff='vimdiff $HOME/notes/code/git/utility.h utility.h'
# alias vc='vim -i ~/.viminfoc'    # vc for work/project related
alias vif='vim -i ~/.viminfof'    # currently fangtian
alias vn='vim -i ~/.viminfon -c "pu_" -c "set bt=nofile" --cmd "let g:ctrlp_cache_dir=\"~/swo/.cache/ctrlp/vn\"" '     # use vn for general notes
alias vo='vim -i ~/.viminfoo +" cd ~/tmp"'    # use vo for general notes
alias vp='vim -i ~/.viminfop'    # use vp for python
alias vj='vim -i ~/.viminfoj -S ~/.vim.j.session'    # use vj for java
function vk() { set -o history && set -o histexpand; vim -i ~/.viminfok $($(history -p !!)); }
# both vk and vkk has a problem, not work for successive ones.
function vkk() { set -o history && set -o histexpand; eval $(history -p !!) |v-; }
alias vb='vim -i ~/.viminfob'    # use vp for bash
alias vbb='vq ~/notes/.bashrc'    # use vp for bash
# "java
alias lj='ls *.java'
alias lc='ls *.class'
alias rmj='rm -f *.class'
# alias vimn='vim -u NONE -N'
alias hs=history
# alias foo='cd /usr; ls; cd -' # no space before/after equal sign.
alias ln='ln -n'
alias lns='ln -s'
alias px='ps x'
alias ipp='ipython --quick --no-banner --no-confirm-exit -c "import numpy as np, pandas as pd; pd.options.display.max_rows = 12; np.set_printoptions(precision=4, suppress=True)" -i'
# compile C with here-doc, from file:///E:/bks/ndal/C/21st_Century_C_C_Tips_from_the_New_School_[2E,2015][Ben_Klemens](Book4You).pdf
go_libs="-lm"
go_flags="-g -Wall -include /cygdrive/e/notes/allheads.h -O3"
alias go_c="c99 -xc - $go_libs $go_flags"
alias grep-i='grep -i' 
alias mtmux='tmux start-server;sleep 0.3;tmux new-window notes;tmux new-window java;tmux new-window tmp;tmux new-window fmanager;tmux new-window swo;tmux new-window bks;'
# "diff
alias vd=vimdiff
vdd () { vimdiff $1 ../$1; }
vd- () { vimdiff $1 ${OLDPWD}/$1; }
# bdiff diff files in different branch
# "git
alias g-='git checkout -'   # co to alternate branch
alias gb='git branch'
alias gilog='git log'
# alias gls='git ls-tree -r --name-only'      # from Git: 1.List all files in a branch, 2.compare files from different branch  http://stackoverflow.com/a/1910822/3625404
function gls { if (($# == 0)); then name=$(git rev-parse --abbrev-ref HEAD); else name=$1; fi; echo branch $name; git ls-tree -r --name-only $name | grep -v "util\|ignore\|[mM]akefile\|\.mk"; }
function gll { for branch in adt bi comb dev fc graph lc master math mx of pac str tree trim; do printf "\nbranch $branch \n"; git ls-tree -r --name-only $branch | grep -v "util\|ignore\|[mM]akefile\|\.mk"; done; }
alias gl='git status'
alias gist='git status'
alias g='git status'
alias gis='git status'
alias gcl='(git status) && make clean'
# alias go='git checkout'   # use function instead, reuse zero arg form to 'git branch'.
function go {
    if (($# == 0)); then
        git branch;
    else
        git checkout "$@";
        return $?
    fi
}
# alias gi='git'   # use function instead, reuse zero arg form to 'git log'.
function gi {
    if (($# == 0)); then
        git log;
    else
        git "$@";
        return $?
    fi
}

# "emacs
alias em='emacsclient -c "$@" -a " vim"'
alias emq='emacs -nw -q'    # terminal capture keystroke 'C-c', fail to exit with 'C-x C-c'. use 'M-x kill-emacs' instead.

# "env, see also " variables
export EDITOR=vim
# "variables, see also " env
function e { tmp=${1^^}; echo ${!tmp}; }  # indirect expansion, ${!var} , http://stackoverflow.com/a/14204692/3625404
alias uv='unset -v'
function uuv { unset -v ${@^^}; }
# eg, `e ldlibs`, `e cflags`, `e path`.
# "echo, see also " env
# "print, see also " echo

# "func

function fj {
    # vim -i NONE -c "set path+=$PWD" -c "setf text" -c "setl bt=nofile" -c "nnoremap q :q<Enter>" <(ag "$*") ;
    # vim <(ag "$*") ;
    # cat <(ag "$*") ;
    # ag "$*" | vim -i NONE -c "set path+=$PWD" -c "setf text" -c "setl bt=nofile" -c "nnoremap q :q<Enter>" - ;
    # ag "$*" | vim -i NONE -c "set path+=$PWD" -c "setf text" -c "setl bt=nofile" -c "nnoremap q :q<Enter>" - ;
    # vim - < $(ag "$*")
    echo ag "$*"
}

# "grep(search,"ack), see " find
if hash ag &>/dev/null; then alias grep=ag; fi
# todo: bag for ag "\b$1\b" ??

# "find, see " grep " dir(tree)
#   " fd(find utils)

function ff() { if (( $# == 0 )); then printf "usage:\n\t ff arg <==> find | grep 'arg'\n"; else find | grep $@; fi }
function fd2() { find -maxdepth 2 -type d; }
function fd3() { find -maxdepth 3 -type d; }
alias findd='find -type d'
alias findf='find -type f'    # fails for 'findf *'
# function findf() {
# "fd(find), see " find " tree(dir)
# test speed on linux kernel source tree, could write your own version in C.
function cnd() { # count directories' entry. -- or better name ffcnt? 
# https://unix.stackexchange.com/questions/90106/whats-the-most-resource-efficient-way-to-count-how-many-files-are-in-a-director
    # ues rsync instead of find + wc.  `rsync --stats -ax --dry-run . /vvvvvvvv` https://stackoverflow.com/a/34941137/3625404
    # or using c, here is a rust version:  https://github.com/the8472/ffcnt  https://stackoverflow.com/a/41903547/3625404
    # local cnt_total=0;
    declare cnt;    # make `cnt` local
    declare cnt_total=0;
    for d in "$(find -maxdepth 1 -type d)"; do
        if [[ "$d" != . ]]; then
            cnt=$(find "$d" |wc -l);
            # cnt_total=$(( $cnt_total + $cnt ));
            ((cnt_total+=cnt))
            # cnt_total=`expr $cnt_total + $cnt`;
            # cnt_total=$[cnt_total + cnt];
            printf "$d:\t$cnt\n";
        fi;
    done;
    printf "total:\t$cnt_total\n";
}
function cndd() {
    declare cnt;    # make `cnt` local
    declare cnt_total=0;
    for d in "$(find -maxdepth 1 -type d)"; do
        if [[ "$d" != . ]]; then
            cnt=$(find "$d" -type d |wc -l);
            ((cnt_total+=cnt))
            printf "$d:\t$cnt\n";
        fi;
    done;
    printf "total:\t$cnt_total\n";
}
function cndf() {
    declare cnt;    # make `cnt` local
    declare cnt_total=0;
    for d in "$(find -maxdepth 1 -type d)"; do
        if [[ "$d" != . ]]; then
            cnt=$(find "$d" -type f |wc -l);
            ((cnt_total+=cnt))
            printf "$d:\t$cnt\n";
        fi;
    done;
    printf "total:\t$cnt_total\n";
}
function cnda() { find "$@"|wc; }
alias fcnd=cndf
alias dcnd=cndd

# "ag
function defag() { # find python definition
    ag '^ *def '"$1";
}
function sdefag() { # find python definition, use Gf_search() in .vimrc
        ag '^ *def '"$1" |sed 's/.*def \(.*\)(.*$/'"\0\\/def \1\\\\>\\/"'/';
}
function sbdefag() { # find python definition, search + word boundary, see sdefag.
    ag '^ *def '"$1"'\b' |sed 's/.*def \(.*\)(.*$/'"\0\\/def \1\\\\>\\/"'/';
}
alias agdef=defag
alias psd=sdefag
function psd() { sdefag "$@"; }     # for non-interactive shell

function llag() {
    ll|ag "$@";
}

function fag() {  # find then ag, ignore some directories and file.
    # find . -not \( -path r -prune \) -not \( -path code -prune \) -iname '*'"$*"'*';      # exclude directories, not work.
    find . -not \( -path ./r -prune \) -not \( -path ./code -prune \) -iname '*'"$*"'*';    # exclude directories.  see " find in lx.scp
    # find|ag "$*";
}
function fag2 {
    find . -maxdepth 2 -iname "$@";
}

function dag() {    # find directory that contain pattern
    find . -not \( -path ./r -prune \) -not \( -path ./code -prune \) -type d -iname '*'"$*"'*';
}

function bag() {
    # also lbag, rbag?
    if (( $# == 1 )) ; then
        ag "\b$1\b";
    elif (( $# < 1 )) ; then
        :
    else
        ag "$*";
    fi
}

function j {
if [[ "$@" == java ]]; then
    echo command is java.
    "$@" -help 2>&1 |v-;
    swapfile
else
    "$@" --help 2>&1 |v-;
fi
}

# "help, "man, see " info
alias ha='help -d' # hd conflict on ubuntu, change to ha.
alias w='whatis'
alias a='apropos'
alias less='less -Mi'
alias le='less'
alias lps='ps aux |less'
# alias info='info --vi-keys'   # use ~/.infokey rc/.infokey instead
alias cm='cppman'
alias f.='nautilus . &'

# "TODO
# make 'ld' -- 'ls -d' accept args.  use 'find path -maxdepth 1 -type d'?
# a better alternative of 'find something | grep [optional |v-]'
 
function h() {
    # bug: 'h grep' hangs and waiting for input. -- 'grep -help' hangs in non-interactive bash.
# "TODO, add --help option, add -option to not open vi or specify pager, add debug switch to silent or not-silent stderr. possibly use getopts?
# "caution: this function should only used interactively because there is security hole.
# eg, any command is run verbatim, which could be very dangerous when used
# non-interactively.
if (( $# == 0 )); then
    echo "error: too few arguments. which command's help file do you want to see?" &&
        return 1;   # or as default, invoke help of builtin, or man bash?
    # "$*" --help;
    # if "$*" --help; then
    # "$*" --help |v'+color peaksea';
    # seoul256
else
    # 1. space in argument(s)
    # for git, 'git commit -h' for usage and option,  'git commit --help' for man git-commit
    if [[ "$@" =~ " " ]]; then "$@" --help;
        return $?;
    fi
    # bash builtin, 'function case time select [ { [[' are keyword, 'builtin test' is builtin.
    # compgen -kb
    local TYPE="$(type -t $@)"; 
    if [ "$TYPE" = builtin -o "$TYPE" = keyword ]; then help "$@";
        return $?;
    fi
    local ERRNO="";   # a fix for unbound variable when 'set -euo pipefail'.
    outfile=~/.tmphelp
    # todo: some command display help and exit with exit code 1. eg, showkey, eject.
    if "$@" -help &> $outfile;  then       # for vim, 'vim -h' is prefered than 'vim --help'
        :   # null command
    elif "$@" --help &> $outfile;  then       # most case. eg, 'vim --help'
        # echo help file retrieved successfully. via suffix '--help';
        :
    elif "$@" -h &> $outfile;  then      # some rare case, eg, 'java -help'.
        # some command always return 1, even for valid -help option, eg, more, java, jdb.
        :
    else
        # echo else
        ERRNO=1;
    fi
    if [[ $- != *i* ]]; then
        { cat $outfile; return; }      # non-interactive shell, cat instead of vim.
    # elif [ "" != $ERRNO ]; then
    #     echo COMMAND FAILED. help file not found.;
    else
        # vi $outfile '+color peaksea' -c 'setlocal noswapfile' -c 'setlocal bt=nofile';
        vi $outfile -c 'setlocal noswapfile' -c 'setlocal bt=nofile';   # in case color peaksea not exist
    fi
    return $ERRNO;
    # echo "error: too many arguments. 1 is expected.";
fi
}

function hh() { help $1 | less ; }

function f {
    # ERRNO=1;
    if [[ -n $ERRNO ]]; then
        echo length nonzero.;
    else
        echo length zero.;
    fi
}

function v() {
# finished: add apt package search if not command, eg, libc6
if (( $# == 0 )); then
    echo "error: too few arguments. 1 is expected.";
    return 1;
elif (( $# == 1 )); then
    # if "$@" --version 2>/dev/null || "$@" -version 2>/dev/null; then
    if "$@" --version || "$@" -version; then        # eg, python
        # echo version info retrieved successfully.;
        :
    else
        apt-cache show "$@" | grep "^Package|^Version";
        # echo COMMAND FAILED. version info not found.;
        # return 2;
    fi
else
    echo "error: too many arguments. 1 is expected.";
    return 3;
fi
}

function hj {  "$@" --help  | less ; }

# "man
# alias man='\man -P vi\ +"color\ peaksea"\ -c\ "setf\ text"\ -c\ "setl\ bt=nofile"\ -'
# vi +"color peaksea" -c "setf text" -c "setl bt=nofile" -
if [[ $(uname -o) = Cygwin ]]; then
# alias R='/cygdrive/d/pkg/dt/R-3.4.3/bin/R.exe --no-save'
export MANPAGER='vim --cmd "let g:loaded_ctrlp = 1" -c "color default" -c "%! col -b" -c "sil file $MAN_PN" -c "set bt=nofile ft=man nomod nolist ignorecase" -c "sil! %s/\d\{1,2\}m//g" -c "sil! /^SYNOPSIS" -'   # https://murukesh.me/2015/08/28/vim-for-man.html

else
export MANPAGER='vim --cmd "let g:loaded_ctrlp = 1" -c "%! col -b" -c "sil file $MAN_PN" -c "set bt=nofile ft=man nomod nolist ignorecase" -'   # https://murukesh.me/2015/08/28/vim-for-man.html
export MANPAGER='bash -c " vim --cmd \"let g:loaded_ctrlp = 1\" -c \"sil file $MAN_PN\" -c \"set bt=nofile ft=man nomod nolist nospell\" </dev/tty <(col -b)"'     # http://vi.stackexchange.com/a/4687/10254
fi
# export MANPAGER='vim   </dev/tty <(col -b)'
function mg { man $1 | grep $2 | less ; } 

pe () {  # print env, convert to upper first.
    str=${1^^}
    printenv ${str}
}

function crun { make $1 && ./$1; }  # make and run for simple c program

# "ffld, "download
ffld="~/Dowloads/ffld/"

# note that effect of so could be different from source and .
so () { source $1 | less; }

# tmux has-session -t development ||
# tmux new -s dev
# tmux attach -t dev
tmux-new() {
  if [[ -n $TMUX ]]; then
    tmux switch-client -t "$(TMUX= tmux -S "${TMUX%,*,*}" new-session -dP "$@")"
  else
    tmux new-session -s "$@"
  fi
}
# tmux-new dev

# TMUX= tmux new-session -d -s dev
# tmux attach -t dev

# If not running interactively, do not do anything
# [[ $- != *i* ]] && return
# [[ -z "$TMUX" ]] && exec tmux
# [[ -z "$TMUX" ]] && source /home/qeatzy/notes/tmux_startup

# tmux start-server
# if [[ -z "$TMUX" ]]
# then
#   exec tmux attach -d -t default
# fi

# "platform dependent, http://stackoverflow.com/questions/394230/detect-the-os-from-a-bash-script
# https://gist.github.com/davejamesmiller/1965683
# elif [[ "$OSTYPE" == "darwin"* ]]; then
if [[ "$OSTYPE" == "cygwin" ]]; then
    alias firefox='/cygdrive/d/pkg/dt/firefox/firefox.exe'
    alias cmd='cygstart c:/windows/system32/cmd'
    alias cpy='/cygdrive/d/pkg/dt/Anaconda2/python'    # for plotting on windows, c for conda
    alias icpy='/cygdrive/d/pkg/dt/Anaconda2/Scripts/ipython'    # for plotting on windows, c for conda
# You can run a batch file from a Cygwin shell directly,... it might be simpler to run cmd /c 'foo.bat "quoted arguments"'.  https://superuser.com/a/189094/487198
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    alias em='emacsclient -nw -c "$@" -a " vim"'
fi

# "apt, "pkg
# alias ai='sudo pacman -S'
# alias sagi='sudo apt-get install'
if type -P apt-cyg &>/dev/null
then
    alias ai='apt-cyg install'
    alias ala='apt-cyg listall'
    alias al='apt-cyg list'
    # alias apt='apt-cyg'
    function apt-la { apt-cyg listall ".*${1}.*"; }
    function aptla { apt-cyg listall ".*${1}.*"; }
    function apt-l { apt-cyg list ".*${1}.*"; }
    function aptl { apt-cyg list ".*${1}.*"; }
    function apt { apt-cyg "$@"; }
    alias asa='apt-cyg searchall'
elif type -P pacman &>/dev/null; then
    alias ai='sudo pacman -S';
    alias pc=pacman
    alias apt=pacman
    alias s='pacman -Ss'
elif type -P apt-get &>/dev/null; then
    alias ai='sudo apt install';
    function s() { apt-cache search --names-only "$@" |v-- -c 'sort' -c 'nn <buffer> <F8> :!sudo apt-get install <cWORD><CR>' -; }
    function ss() { apt-cache search "$@" |v-- -c 'sort' -; }
    function show() {
        outfile=~/.tmphelp
        if apt-cache show "$@" > $outfile && [ $(wc -l $outfile |cut -d" " -f1) -gt 2 ] ; then     # second test for virtual package, eg ctags
            :;
        else
            apt-cache search --names-only "$@" > $outfile;
        fi
        if [[ $- != *i* ]]; then 
            cat $outfile;
        else
            cat $outfile | v-;
        fi
    }
fi

hash vim ps

#example of bashrc file
#https://github.com/hashrocket/dotmatrix/blob/master/.bashrc
# .bashrc, see also .bvimbrc, which is used within vim.

# .bashrc, see .zshrc .bvimbrc
