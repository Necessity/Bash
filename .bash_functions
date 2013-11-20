#!/bin/bash

#   termwide prompt
#      by Giles - created 2 November 98
#
#   The idea here is to have the upper line of this two line prompt 
#   always be the width of your term.  Do this by calculating the
#   width of the text elements, and putting in fill as appropriate
#   or left-truncating $PWD.
#

function prompt_command {

TERMWIDTH=${COLUMNS}

#   Calculate the width of the prompt:
hostnam=$(echo $HOSTNAME | sed -e "s/[\.].*//")
#hostnam=$(echo -n $HOSTNAME | sed -e "s/[\.].*//")

#   "whoami" and "pwd" include a trailing newline
#usernam=$(who am i| awk '{print $1}')
usernam=$LOGNAME


let usersize=$(echo -n $usernam | wc -c | tr -d " ")
newPWD="${PWD}"
let pwdsize=$(echo -n ${newPWD} | wc -c | tr -d " ")
#   Add all the accessories below ...
let promptsize=$(echo -n "--(${usernam}@${hostnam})---(${PWD})--" \
                 | wc -c | tr -d " ")
let fillsize=${TERMWIDTH}-${promptsize}
fill=""
while [ "$fillsize" -gt "0" ] 
do 
   fill="${fill}-"
   let fillsize=${fillsize}-1
done

if [ "$fillsize" -lt "0" ]
then
   let cut=3-${fillsize}
   newPWD="...$(echo -n $PWD | sed -e "s/\(^.\{$cut\}\)\(.*\)/\2/")"
fi
}


function prompt_color {
# System wide functions and aliases
# Environment stuff goes in /etc/profile

# For some unknown reason bash refuses to inherit
# PS1 in some circumstances that I can't figure out.
# Putting PS1 here ensures that it gets loaded every time.

# Set up prompts. Color code them for logins. Red for root, white for 
# user logins, green for ssh sessions, cyan for telnet,
# magenta with red "(ssh)" for ssh + su, magenta for telnet.
	local WHITE="\[\033[1;37m\]"
	local RED="\[\033[1;31m\]"
	local GREEN="\[\033[0;32m\]"
	local YELLOW="\[\033[0;33m\]"
	local BLUE="\[\033[0;34m\]"
	local PURPLE="\[\033[0;35m\]"
	local NO_COLOUR="\[\033[00m\]"

	PROMPT_COLOR="$WHITE"
	SEP_COLOR="$BLUE"
	TXT_COLOR="$YELLOW"

	if [ `uname` = "SunOS" ]; then
		THIS_TTY=`/usr/bin/who am i | awk '{print $2}'`
	else
		THIS_TTY=tty`ps aux | grep $$ | grep [b]ash | awk '{ print $7 }'`
	fi

	SESS_SRC=`who | grep $THIS_TTY | awk '{ print $6 }'`

	SSH_FLAG=0
	SSH_IP=`echo $SSH_CLIENT | awk '{ print $1 }'`
	if [ $SSH_IP ] ; then
  		SSH_FLAG=1
	fi
	SSH2_IP=`echo $SSH2_CLIENT | awk '{ print $1 }'`
	if [ $SSH2_IP ] ; then
  		SSH_FLAG=1
	fi
	if [ $SSH_FLAG -eq 1 ] ; then
  		CONN=ssh
	elif [ -z $SESS_SRC ] ; then
  		CONN=lcl
	elif [ $SESS_SRC = "(:0.0)" -o $SESS_SRC = "" ] ; then
  		CONN=lcl
	else
  		CONN=tel
	fi

	# Okay...Now who we be?
	#if [ `uname` = "SunOS" -a `/usr/bin/who am i | awk '{print $1}'` = "root" ] ; then
	if [ $LOGNAME = "root" ] ; then
  		USR=priv
	else
  		USR=nopriv
	fi

	#Set some prompts...
	if [ $CONN = lcl -a $USR = nopriv ] ; then
  #		PS1="[\u \W]\\$ "
		PROMPT_COLOR="$WHITE"
		SEP_COLOR="$BLUE"
		TXT_COLOR="$GREEN"
	elif [ $CONN = lcl -a $USR = priv ] ; then
  #		PS1="\[\033[01;31m\][\w]\\$\[\033[00m\] "
		PROMPT_COLOR=$RED
		SEP_COLOR=$BLUE
		TXT_COLOR=$RED
	elif [ $CONN = tel -a $USR = nopriv ] ; then
  #		PS1="\[\033[01;34m\][\u@\h \W]\\$\[\033[00m\] "
		PROMPT_COLOR=$WHITE
		SEP_COLOR=$YELLOW
		TXT_COLOR=$BLUE
	elif [ $CONN = tel -a $USR = priv ] ; then
  #		PS1="\[\033[01;30;45m\][\u@\h \W]\\$\[\033[00m\] "
		PROMPT_COLOR=$RED
		SEP_COLOR=$YELLOW
		TXT_COLOR=$PURPLE
	elif [ $CONN = ssh -a $USR = nopriv ] ; then
  #		PS1="\[\033[01;32m\][\u@\h \W]\\$\[\033[00m\] "
		PROMPT_COLOR=$WHITE
		SEP_COLOR=$BLUE
		TXT_COLOR=$YELLOW
	elif [ $CONN = ssh -a $USR = priv ] ; then
  #		PS1="\[\033[01;35m\][\u@\h \W]\\$\[\033[00m\] "
		PROMPT_COLOR=$RED
		SEP_COLOR=$YELLOW
		TXT_COLOR=$PURPLE
	fi
}



PROMPT_COMMAND=prompt_command

function termwide {

	local GRAY="\[\033[1;30m\]"
	local LIGHT_GRAY="\[\033[0;37m\]"
	local WHITE="\[\033[1;37m\]"
	local NO_COLOUR="\[\033[0m\]"

	local LIGHT_BLUE="\[\033[1;34m\]"
	local YELLOW="\[\033[1;33m\]"


	prompt_color

	#case $TERM in
	#    xterm*)
	#        TITLEBAR='\[\033]0;\u@\h:\w\007\]'
	#        ;;
	#    *)
	#        TITLEBAR=""
	#        ;;
	#esac

	#PS1="$TITLEBAR\
PS1="$TXT_COLOR-$SEP_COLOR-(\
$TXT_COLOR\${usernam}$SEP_COLOR@$TXT_COLOR\${hostnam}\
${SEP_COLOR})-${TXT_COLOR}-\${fill}${SEP_COLOR}-(\
$TXT_COLOR\${newPWD}\
$SEP_COLOR)-$TXT_COLOR-\
\n\
$TXT_COLOR-$SEP_COLOR-(\
$TXT_COLOR\$(date -u +%H:%M)$SEP_COLOR:$TXT_COLOR\$(date \"+%a,%d %b %y\")\
$SEP_COLOR:$PROMPT_COLOR\$$SEP_COLOR)-\
$TXT_COLOR-\
$NO_COLOUR " 

PS2="$SEP_COLOR-$TXT_COLOR-$TXT_COLOR-$NO_COLOUR "

}



function reachable {
    hname=`ssh -o ConnectTimeout=10 $1 hostname 2>/dev/null`
    ##if [ $? -ne 0 ]; then echo "$1 Unreachable"; fi
    return $?
}

function site_map {
    for x in a b c d e f g h i j k l m; do
        echo -n "$x:  "
        dig @${x}.gtld-servers.net com. ch null | grep site | awk '{print $5}'
    done
}

function nagsum {
    if [ -x ~nagios/bin/ov ]; then
        ~nagios/bin/ov | awk -F';' ' $1 ~ /HOST/ { if ( $3 != "OK" ) print $2, $1, $3, $22 } $1 ~ /SERVICE/ { if ( $4 != "OK" ) print $2,$1,$4,$3, $32 }'
    elif [ -e /tmp/ramdisk0/status.log ]; then
        cat /tmp/ramdisk0/status.log | awk -F';' ' $1 ~ /HOST/ { if ( $3 != "OK" ) print $2, $1, $3, $22 } $1 ~ /SERVICE/ { if ( $4 != "OK" ) print $2,$1,$4,$3, $32 }'
    fi
}


function do_dist {
    src=$1
    dst=$2

    rsync -a $src $dst
}
alias dist='set -f; do_dist'

alias resdb='ssh resdb1-brn'
alias cobbler='ssh sbocblr1-brn1'


function backup-relay {
    relay=$1
    rsync -avz $relay: $relay
}

function scan-hostkeys {
    site=$1
    hostre=$2

    if [ "$#" -lt "2" ]; then
        echo "USAGE: scan-hostkeys <site> <host-regex>"
        echo "   Ex: scan-hostkey0 par2 'gns.*'"
        return 1
    fi

    echo "Processing:"
    site-hostgrep.sh "$1" | egrep "$2"
    site-hostgrep.sh "$1" | egrep -v "$2" $HOME/.ssh/known_hosts > /tmp/steveo-foo
    mv /tmp/steveo-foo $HOME/.ssh/known_hosts
    site-hostgrep.sh "$1" | egrep "$2" | ssh-keyscan -t rsa,dsa -f - 2>/dev/null | \
        sort -u - > $HOME/.ssh/known_hosts

}

function argus-maint {
    host=$1

    for x in argussum{1,2,3}-{ilg1,brn1}; do
        rcmd $x root /app/atlas/bin/argus-maint.pl --host=$host
    done
}

function vip-maint {
    vip=$1
    echo "Maintifying $vip"
    for x in argussum{1,2,3}-{ilg1,brn1}; do
        rcmd $x root "touch /app/atlas/argus/am/maintenance/$vip"
    done
}

function vip-unmaint {
    vip=$1
    echo "Un-Maintifying $vip"
    for x in argussum{1,2,3}-{ilg1,brn1}; do
        rcmd $x root "rm /app/atlas/argus/am/maintenance/$vip"
    done
}
