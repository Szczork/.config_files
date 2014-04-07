#!/bin/zsh

#//// Clean tmp files
clean()
{
    SEARCH='.'
    if [ ${1} ]
    then
	SEARCH=${1}
    fi
    find ${SEARCH} \( -name "*~" -or -name ".*~" -or -name "*\#" -or -name "*.core" \) -exec rm -fv {} \;
}

#//// Untar / Unzip etc ...
extract () {
  if [ -f $1 ] ; then
      case $1 in
	  *.tar.bz2)   tar xvjf "$*"	;;
	  *.tar.gz)    tar xvzf "$*"	;;
	  *.bz2)       bunzip2 "$*"	;;
	  *.rar)       unrar x "$*"	;;
	  *.gz)	       gunzip "$*"	;;
	  *.tar)       tar xvf "$*"	;;
	  *.tbz2)      tar xvjf "$*"	;;
	  *.tgz)       tar xvzf "$*"	;;
	  *.zip)       unzip "$*"	;;
	  *.Z)	       uncompress "$*"	;;
	  *.7z)	       7z x "$*"	;;
	  *)	       echo "don't know how to extract '"$*"'..." ;;
      esac
  else
      echo "'$*' is not a valid file!"
  fi
}

#//// Search word in path argument
search ()
{
    SEARCH="."
    if [ $# = 0 ]
    then
	echo -e "Usage: search PATTERN [DIRECTORY]"
    else
	if [ $# = 2 ]
	then
	    SEARCH=${2}
	fi
	grep --color=always -nI ${1} `find ${SEARCH} -type f ` |\
	grep '\'${SEARCH} |\
	grep -v '/\.' |\
	awk -F: ' {print "\033[1m\033[7;33m"$2 "\033[0;34m" "\033[3m\033[1m " $1 "\033[0;31m \033[3m\n\t" $3"\033[0;39m"}'
    fi
}

#//// show newest files
#//// http://www.commandlinefu.com/commands/view/9015/find-the-most-recently-changed-files-recursively
newest () {find . -type f -printf '%TY-%Tm-%Td %TT %p\n' | grep -v cache | grep -v ".hg" | grep -v ".git" | sort -r | less }

#//// http://www.commandlinefu.com/commands/view/7294/backup-a-file-with-a-date-time-stamp
#//// Create a simple copy of the argument file (title with date)
buf () {
    oldname=$1;
    if [ "$oldname" != "" ]; then
        datepart=$(date +%Y-%m-%d);
        firstpart=`echo $oldname | cut -d "." -f 1`;
        newname=`echo $oldname | sed s/$firstpart/$firstpart.$datepart/`;
        cp -R ${oldname} ${newname};
    fi
}

#//// reloads all functions
#//// http://www.zsh.org/mla/users/2002/msg00232.html
r() {
    local f
    f=(~/.config/zsh/functions.d/*(.))
    unfunction $f:t 2> /dev/null
    autoload -U $f:t
}

#//// Put a console clock in top right corner
#//// http://www.commandlinefu.com/commands/view/7916/
function clock () {
    while sleep 1;
    do
        tput sc
        tput cup 0 $(($(tput cols)-29))
        date
        tput rc
    done &
}

#//// create a new script, automatically populating the shebang line, editing the
#//// script, and making it executable.
#//// http://www.commandlinefu.com/commands/view/8050/
shebang() {
    if i=$(which $1);
    then
        printf '#!/usr/bin/env %s\n\n' $1 > $2 && chmod 755 $2 && emacs $2 && chmod 755 $2;
    else
        echo "'which' could not find $1, is it in your \$PATH?";
    fi;
    # in case the new script is in path, this throw out the command hash table and
    # start over  (man zshbuiltins)
    rehash
}
