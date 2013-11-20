[[ -f /etc/bash_completion ]] && . /etc/bash_completion

#export TZ=EST5EDT
export PAGER=less
export EDITOR=vi
#export MANPATH=/opt/local/share/man:$MANPATH

export CLASSPATH=$HOME/projects/vijava/vijava2120100824.jar:$HOME/projects/vijava/dom4j-1.6.1.jar

if [ -f $HOME/.bash_functions ]; then
	. $HOME/.bash_functions
	termwide
else
	export PS1='[(\@) (\j)] \u@\h:$($HOME/.prompt)\$ '
fi




if [ `uname` == "CYGWIN_NT-5.1" ]; then
	alias ls='ls --color'
	TERM=xterm
elif [ `uname` == 'Linux' ]; then
	alias ls='ls --color'
	TERM=xterm
elif [ `uname` == 'Darwin' ]; then
	alias ls='ls -G'
	TERM=xterm

else
	TERM=vt100
fi

export TERM

alias fixterm='resize > /tmp/blah ; . /tmp/blah ; rm /tmp/blah'
alias less='less -R'
alias xterm='xterm -bg black -fg green'

LS_COLORS='di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'
export LS_COLORS


########## Build up our path ############
grepcmd='egrep'

for testdir in                 \
    $HOME/bin           \
    /usr/sfw/bin		\
    /usr/sfw/sbin		\
    /sbin                      \
    /bin                       \
    /usr/sbin                  \
    /usr/bin                   \
    /usr/local/sbin            \
    /usr/local/bin             \
    /usr/ccs/bin		\
    /app/atlas/bin  \
  ; do
    ##echo -n "PATHADD ... "
    if [ -d "${testdir}" ]
      then
        if ! echo "${PATH}" | ${grepcmd} "^${testdir}:|^${testdir}$|:${testdir}$|:${testdir}:" > /dev/null
          then
            ##echo "adding: ${testdir} to path"
            # directory not already in path
            export PATH="${testdir}:${PATH}"
          ##else
            ##echo "skipping: ${testdir} (already in path)"
        fi
      ##else
        ##echo "skipping: ${testdir} (not present on system)"
    fi
  done
##echo

for testdir in .; do
        ##echo "adding: ${testdir} to path"
        # directory not already in path
        export PATH="${testdir}:${PATH}"
done

########## Build up our library path ############
grepcmd='egrep'

for testdir in                 \
    /lib                      \
    /usr/lib                  \
    /usr/local/lib             \
  ; do
    ##echo -n "LD PATHADD ... "
    if [ -d "${testdir}" ]
      then
        if ! echo "${LD_LIBRARY_PATH}" | ${grepcmd} "^${testdir}:|^${testdir}$|:${testdir}$|:${testdir}:" > /dev/null
          then
            ##echo "adding: ${testdir} to ld path"
            # directory not already in path
            export LD_LIBRARY_PATH="${testdir}:${LD_LIBRARY_PATH}"
          ##else
            ##echo "skipping: ${testdir} (already in ld path)"
        fi
      ##else
        ##echo "skipping: ${testdir} (not present on system)"
    fi
  done
##echo

for testdir in .; do
        ##echo "adding: ${testdir} to path"
        # directory not already in path
        export LD_LIBRARY_PATH="${testdir}:${LD_LIBRARY_PATH}"
done

