# The following lines were added by compinstall

zstyle ':completion:*' auto-description 'Specify parameter: %d'
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' format 'Completing %d...'
zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*' ignore-parents parent pwd directory
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %l: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-()@]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' menu select=long
zstyle ':completion:*' original true
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %l%s
zstyle ':completion:*' substitute 1
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/djsissom/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=2500
SAVEHIST=2500
setopt appendhistory extendedglob nomatch notify
unsetopt autocd beep
bindkey -v
bindkey "^?" backward-delete-char # fix backspacing over newlines
bindkey '^R' history-incremental-pattern-search-backward # search
bindkey '^F' history-incremental-pattern-search-forward  # search
# End of lines configured by zsh-newuser-install


setopt HIST_IGNORE_DUPS
setopt RM_STAR_SILENT



#---------------
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi
#---------------


#---------------
#DIRSTACKFILE="$HOME/.cache/zsh/dirs"
#if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
#	dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
#	[[ -d $dirstack[1] ]] && cd $dirstack[1]
#fi
#chpwd() {
#	print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
#}
#
#DIRSTACKSIZE=20
#
#setopt autopushd pushdsilent pushdtohome
#
### Remove duplicate entries
#setopt pushdignoredups
#
### This reverts the +/- operators.
#setopt pushdminus
#---------------





#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# .zshrc
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# User-specific ~/.zshrc, generalized for GNU/Linux and Apple OS X
# Excecuted by bash(1) for non-login shells
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Source external definitions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[ -r ~/.colornames ] && . ~/.colornames     # Human-readable color variables


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Determine local environment
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

case $( uname ) in
	( *[Ll]inux*  )
		case "$HOSTNAME" in
			( vmp*    ) host='cluster';;  # Auto-detect whether we're running on the
			( vpac*   ) host='astro';;    # ACCRE cluster or the VPAC network at
			( *       ) host='linux';;    # Vanderbilt, and set options appropriately
		esac;;
	( *[Dd]arwin* ) host='osx';;
	( *           ) echo 'running on unknown host' && return;;
esac


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Import packages
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if [[ $host == cluster ]]; then
	setpkgs -a gcc_compiler
	setpkgs -a intel_compiler
	setpkgs -a fftw2-mpich2_gcc_ether
	setpkgs -a mpich2_gcc_ether
	setpkgs -a gsl_gcc
	setpkgs -a gsl_intel
	setpkgs -a hdf5
	setpkgs -a valgrind
	setpkgs -a python
	setpkgs -a scipy
	setpkgs -a perl
	setpkgs -a idl-8.0
	setpkgs -a matlab
	setpkgs -a octave
	setpkgs -a R
	setpkgs -a ImageMagick
fi


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Path definitions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

typeset -U path

case "$host" in
	( cluster )
		path=(/usr/local/supermongo/bin						# Supermongo path
		      /usr/local/cuda/bin:							# Nvidia CUDA path
		      /usr/lpp/mmfs/bin								# GPFS utilities path
		      ~/local/bin:									# User-specific path
		      $path)
		export -UT LD_LIBRARY_PATH=/usr/scheduler/torque/lib:$LD_LIBRARY_PATH ld_library_path
		export -UT LD_LIBRARY_PATH=/usr/local/supermongo/lib:$LD_LIBRARY_PATH ld_library_path
		export -UT LD_LIBRARY_PATH=/usr/local/python/lib:$LD_LIBRARY_PATH ld_library_path
		export -UT LD_LIBRARY_PATH=/usr/local/cuda/lib:$LD_LIBRARY_PATH ld_library_path
		export -UT PYTHONPATH=~/local/lib/python/site-packages:$PYTHONPATH pythonpath
		export -UT IDL_STARTUP=~/.idl/idl_startup.pro idl_starup
		export -UT IDL_PATH=+/home/sinham/utils/idl:$IDL_PATH idl_path
		export -UT IDL_PATH=.:+/usr/local/idl/idl/lib:+/usr/local/idl/idl/:$IDL_PATH idl_path
		;;
	( astro   )
		path=(/usr/local/python64/bin						# Python path (64 bit)
		      ~/local/bin									# User specific path
			  path)
		export -UT LD_LIBRARY_PATH=/usr/local/python64/lib:$LD_LIBRARY_PATH ld_library_path
		export -UT PYTHONPATH=~/local/lib/python/latest/site-packages:$PYTHONPATH pythonpath
		export -UT PYTHONPATH=/usr/local/python64/lib/python*/site-packages:$PYTHONPATH pythonpath
		source /usr/local/itt/idl80/idl/bin/idl_setup.bash
		export IDL_PATH=.:/home/sinham/psu/utils/idl/:+$IDL_DIR
		export IDL_STARTUP=~/.idl/idl_startup.pro
		;;
	( linux   )
		path=(~/Local/bin $path)							# User specific path
		export -UT PYTHONPATH=~/Local/lib/python/python-2.7/site-packages:$PYTHONPATH pythonpath
		export -UT PYTHONPATH=~/Local/lib/python/latest/site-packages:$PYTHONPATH pythonpath
		export -UT PYTHONPATH=~/Local/lib/python3/site-packages:$PYTHONPATH pythonpath
		export -UT TEXINPUTS=.:./style:$TEXINPUTS texinputs
		export -UT BSTINPUTS=.:./style:$BSTINPUTS bstinputs
		export -UT BIBINPUTS=.:./style:$BIBINPUTS bibinputs
		;;
	( osx     )
		path=(/opt/local/bin:/opt/local/sbin				# Macports path
		      ~/Local/bin									# User specific path
			  /usr/local/opt/coreutils/libexec/gnubin		# Gnu coreutils from Homebrew
			  /usr/local/opt/python/libexec/bin				# Unversioned python3
			  $path)
		export -UT PYTHONPATH=~/Local/lib/python/latest/site-packages:$PYTHONPATH pythonpath
		;;
esac

export path


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Bash behavior
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#[ -z "$PS1" ] && return         # If not running interactively, exit here

export EDITOR='vim -display none'      # Use vim as default text editor
export GPG_TTY=$(tty)           # Fix GPG pin prompt bug with git
#export HISTCONTROL=ignoreboth   # No duplicate or space-started lines in history
#shopt -s histappend             # Append to the history file, don't overwrite it
#shopt -s checkwinsize           # Update $LINES and $COLUMNS after each command
export SDL_VIDEO_FULLSCREEN_HEAD=3
setopt HIST_IGNORE_SPACE
#setopt extended_glob


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Enable advanced tab-completion
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
## Define file paths for tab-completion scripts
#case "$host" in 
#	( cluster | astro )
#		bash_completion_path=/usr/share/bash-completion/bash_completion
#		git_completion_path=/etc/bash_completion.d/git
#		;;
#	( linux )
#		bash_completion_path=/usr/share/bash-completion/bash_completion
#		git_completion_path=/usr/share/git/completion/git-prompt.sh
#		;;
#	( osx )
#		bash_completion_path=/opt/local/etc/bash_completion
#		git_completion_path=/opt/local/etc/bash_completion.d/git
#		;;
#esac
#
## Source bash_completion script if available; otherwise, set completion manually
#if [ -r "$bash_completion_path" ]; then
#	. "$bash_completion_path"     # Source global definition file
#elif [ -r ~/.bash_completion ]; then
#	. ~/.bash_completion          # Look in ~ if global file doesn't exist
#else
#	complete -cf sudo             # Bash auto-completion after sudo
#	complete -cf man              # Bash auto-completion after man
#fi
#
## Enable bash tab completion for git commands, if available
#if [ -r "$git_completion_path" ]; then
#	. "$git_completion_path"
#	git_prompt=yes                # This and the following enable the git prompt
#	export GIT_PS1_SHOWDIRTYSTATE=1
#	export GIT_PS1_SHOWSTASHSTATE=1
#	export GIT_PS1_SHOWUNTRACKEDFILES=1
#	export GIT_PS1_SHOWUPSTREAM="auto"
#fi
#
#
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Set up a fancy prompt and window title, if available
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
## Use a colored prompt, if available
#[ -t 1 ] && [ -n $(tput colors) ] && [ $(tput colors) -ge 8 ] && color_prompt=yes
#
## Choose username/hostname color based on whether or not we are the root user
#UserColor="$BCyan"
#[ $UID == "0" ] && UserColor="$BRed"
#
## Set prompt options based on capabilities
#if [[ "$color_prompt" == yes && "$git_prompt" == yes ]]; then
#	PS1='['${UserColor}'\u@\h'${Color_Off}':'${BBlue}'\w'${Green}'$(__git_ps1 " (git-%s) ")'${Color_Off}']\$ '
#elif [[ "$color_prompt" == yes ]]; then
#	PS1="[${UserColor}\u@\h${Color_Off}:${BBlue}\w${Color_Off}]\\$ "
#elif [[ "$git_prompt" == yes ]]; then
#	PS1='[\u@\h:\w$(__git_ps1 " (git-%s) ")]\$ '
#else
#	PS1='[\u@\h:\w]\$ '
#fi
#
## If this is an xterm, set the title to user@host:dir
#case "$TERM" in
#	( xterm* | rxvt*  ) xterm_title="\[\e]0;\u@\h : \w\a\]" ;;
#	( *               ) xterm_title= ;;
#esac
#PS1="${xterm_title}${PS1}"


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Alias definitions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# general usage
alias u='cd ..'
alias back='cd "$OLDPWD"'
#alias ls='ls --group-directories-first'
alias ls='ls --literal'
alias ll='ls -lh'
alias la='ls -A'
alias list='ls -lhA'
alias tree='tree -Chug'
alias mv='mv -i'
alias cp='cp -i'
alias ds='du -hsc * | sort -h'
#alias vim='vim -display none'  # keep from launching X11 on OS X over SSH sessions
alias truecrypt='truecrypt -t'
alias kp="kpcli --kdb ~/Local/key/KeePass/master.kdbx --key ~/Local/key/master.key --histfile /dev/null"
alias gamepad="xboxdrv --silent --detach-kernel-driver --mimic-xpad" # run as root
alias todo='vim ~/.todo.tp'

# random fun stuff
alias tclock='tty-clock -sctb -d 0 -a 100000000 -C 6 -f "%Y/%m/%d"'
alias blah='while true; do head -c8 /dev/urandom; sleep 0.01; done | hexdump -C'
alias engage='play -r 44100 -c2 -n synth whitenoise lowpass -1 120 lowpass -1 120 lowpass -1 120 gain +16'
#alias matrix='cmatrix -ab -u2'
alias matrix='unimatrix -afo -s 95 -l nssssSScCgGkkkkkkkk'
#alias mine='cgminer --scrypt -o stratum+tcp://middlecoin.com:3333 -u 1HoqBstSjv5kZrEyyHCGjReRpLf3TWTLPS -p asdfgqwert'
alias mine-intense='cudaminer --interactive=0 --algo=scrypt -o stratum+tcp://middlecoin.com:3333 -u 1HoqBstSjv5kZrEyyHCGjReRpLf3TWTLPS -p asdfgqwert'
alias mine='cudaminer --interactive=1 --algo=scrypt -o stratum+tcp://middlecoin.com:3333 -u 1HoqBstSjv5kZrEyyHCGjReRpLf3TWTLPS -p asdfgqwert'
alias balance='curl http://www.middlecoin.com/allusers.html | grep -B 3 -A 3 1HoqBstSjv5kZrEyyHCGjReRpLf3TWTLPS'
#alias balance='curl http://middlecoin2.s3-website-us-west-2.amazonaws.com/allusers.html | grep -B 3 -A 3 1HoqBstSjv5kZrEyyHCGjReRpLf3TWTLPS'
alias xtv='xrandr --output HDMI-0 --auto --same-as DVI-I-1'
alias chrome='google-chrome-stable'
alias batch-unzip='for i in *.zip; do newdir="$i:gs/.zip/"; mkdir "$newdir"; unzip -d "$newdir" "$i"; done'
#alias scanimage='scanimage --format=tiff --device pixma:04A91747_80650C --resolution 300'
alias scan-flatbed='scanimage --format=tiff --device "brother4:bus4;dev1"  --resolution 600 --source FlatBed'
alias scan-tray='scanimage --format=tiff --device "brother4:bus4;dev1"  --resolution 600'
alias merge_pdfs='gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=merged.pdf'
alias netmon="bmon -p eth1,eth0 -b -o curses:'nocolors;bgchar= '"
alias weather="curl http://wttr.in/Nashville"
alias fp='for i in *.flac; do ffprobe $i 2>&1; done'
alias fa='for i in *.flac; do ffprobe $i 2>&1 | grep -i artist; done'
alias fcomp='for i in *.flac; do ffprobe $i 2>&1 | grep -i composer; done'
alias mic="echo \"Starting jack mic input with 'alsa_in -d hw:0 -r 192000 -c 2 -p 64 -n 3'\" && alsa_in -d hw:0 -r 192000 -c 2 -p 64 -n 3"
make_thumbs() { vcsi -g 5x4 -w 1920 -t --grid-spacing 0 "$*"; }
make_thumbs_big() { vcsi -g 5x20 -w 1920 -t --grid-spacing 0 "$*"; }

# enable color support
if [ -x /usr/bin/dircolors ]; then
	eval "`dircolors -b`"
	#alias ls='ls --color=auto --group-directories-first'
	alias ls='ls --color=auto --literal'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
	export -UT LS_COLORS=$LS_COLORS'ow=34;7:' ls_colors
fi

# host-specific aliases
case "$host" in
	( cluster )
		alias open='gnome-open'
		alias freenodes="pbsnodes | grep 'opteron' -A3 -B3  | grep 'state = free' -A2 -B1 | less"
		alias qm="qstat -a | grep $USER"
		alias get_gpu_node="qsub -I -W group_list=nbody_gpu -l nodes=1:ppn=1:gpus=1 -l pmem=1000mb -l mem=1000mb -l walltime=3:00:00"
		alias checkrun="showq | grep $USER | tail -n 1 | awk '{print $1}' | xargs qcat"
		alias usage='mmlsquota --block-size auto'
		;;
	( astro   )
		alias open='kde-open'
		export VUSPACEHOST=`echo $USER | cut -b 1`
		alias mountvuspace="/sbin/mount.cifs //vuspace-$VUSPACEHOST/user ~/vuspace -o username=$USER"
		alias umountvuspace="/sbin/umount.cifs ~/vuspace"
		;;
	( linux   )
		alias open='kde-open5'
		alias ssh='eval $(/usr/bin/keychain --eval --agents ssh --quick --quiet --timeout 480 ~/.ssh/id_rsa) && ssh'
		alias scp='eval $(/usr/bin/keychain --eval --agents ssh --quick --quiet --timeout 480 ~/.ssh/id_rsa) && scp'
		my_git() {
			case $* in
				( push* ) shift; eval $(/usr/bin/keychain --eval --agents ssh --quick --quiet --timeout 480 ~/.ssh/id_rsa) && git push "$@" ;;
				( pull* ) shift; eval $(/usr/bin/keychain --eval --agents ssh --quick --quiet --timeout 480 ~/.ssh/id_rsa) && git pull "$@" ;;
				(     * ) git "$@" ;;
			esac
		}
		alias git='my_git'
		alias usage='/home/djsissom/Local/src/comcast-bw/comcastBandwidth.py'
		;;
	( osx     )
		#alias ls='ls -G'
		alias ls='ls --color --literal'
		alias top='top -o cpu'
		alias ssh='if [[ `ssh-add -l` == "The agent has no identities." ]]; then ssh-add -t 28800; fi  && ssh'
		alias rsync='if [[ `ssh-add -l` == "The agent has no identities." ]]; then ssh-add -t 28800; fi  && rsync'
		alias man='man -M /usr/local/opt/coreutils/libexec/gnuman:$MANPATH'
		;;
esac


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Program-specific settings and fixes
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# User-defined functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Enable user-passable growl notifications
growl() { echo -e $'\e]9;'${1}'\007' ; return ; }


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# End
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


autoload -U colors && colors
#source ~/.zsh/git-prompt/zshrc.sh
#PROMPT='|- %{$fg_no_bold[cyan]%}%n@%m%{$reset_color%} : %{$fg_no_bold[blue]%}%~%{$reset_color%} $(git_super_status)-> '
#PROMPT="|- %{$fg_no_bold[cyan]%}%n@%m%{$reset_color%} : %{$fg_no_bold[blue]%}%~%{$reset_color%} -> "

fpath=( "$HOME/.zsh/functions" $fpath )
#autoload -U promptinit && promptinit
autoload -Uz promptinit && promptinit
PURE_GIT_PULL=0
prompt pure




