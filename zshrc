# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt noincappendhistory sharehistory appendhistory autocd extendedglob
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install

# Use local history for up and down keys, while preserving a global one
bindkey "^[OA" up-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search

# Load zmv - a clever mv
autoload -U zmv
alias mmv='noglob zmv -W'

# Speed up switching to vim mode
export KEYTIMEOUT=1

# Use some of emacs' shortcuts to move around
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char

# The following lines were added by oh-my-zsh
# Path to your oh-my-zsh installation
if [[ -d /usr/share/oh-my-zsh/ ]]; then
	ZSH=/usr/share/oh-my-zsh/
else
	ZSH=~/.oh-my-zsh/
fi

# ZSH theme to load
# Use a different theme for ssh sessions, containers and local
if [[ -n "${SSH_CLIENT}" || -n "${SSH_TTY}" ]]; then
	ZSH_THEME="agnoster" # Fancy and colorful
elif systemd-detect-virt &>/dev/null; then
	ZSH_THEME="agnoster" # Fancy and colorful
else
	ZSH_THEME="robbyrussell" # Plain and simple
fi

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
#HYPHEN_INSENSITIVE="true"

# Disable bi-weekly auto-update checks of oh-my-zsh
DISABLE_AUTO_UPDATE="true"

## Uncomment the following line to enable command auto-correction.
#ENABLE_CORRECTION="true"s

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Change the command execution time stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
#HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(vi-mode git dirhistory zsh-completions)

# Oh-my-zsh caching
ZSH_CACHE_DIR=$HOME/.oh-my-zsh-cache
if [[ ! -d "$ZSH_CACHE_DIR" ]]; then
	mkdir "$ZSH_CACHE_DIR"
fi

# Initiate oh-my-zsh
source $ZSH/oh-my-zsh.sh
# End of lines added by oh-my-zsh

# Syntax highlighting
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
	source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
	source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Ingore duplicates
HISTCONTROL=erasedups
HISTIGNORE='&:exit:logout:clear:history'

# 'Command not found' completion
command_not_found_handler() {
	local cmd=$1
	local FUNCNEST=10

	set +o verbose

	pkgs=(${(f)"$(pkgfile -b -v -- "$cmd" 2>/dev/null)"})
	if [[ -n "${pkgs[*]}" ]]; then
		printf '%s may be found in the following packages:\n' "$cmd"
		printf '  %s\n' "${pkgs[@]}"
		return 0
	else
		>&2 printf "${SHELL}: command not found: %s\n" "$cmd"
		return 127
	fi
}

# Extending the PATH
[[ -d /usr/lib/ccache/bin ]] && export PATH="/usr/lib/ccache/bin/:$PATH"
[[ -d "$HOME/c" ]] && export PATH="$HOME/c:$PATH"
[[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"
export PATH="$PATH:."

# Export the default ditor
if which vim &>/dev/null; then
	export EDITOR="vim"
elif which vi &>/dev/null; then
	export EDITOR="vi"
elif which emacs &>/dev/null; then
	export EDITOR="emacs -nw"
else
	export EDITOR="nano"
fi

# Colorful less
export LESS='-R'

# Enable GPG support for various command line tools
export GPG_TTY=$(tty)

# Enable autocolor for various commands through alias
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'

# Aliasing ls commands
alias l='ls -hF --color=auto'
alias lr='ls -R'  # recursive ls
alias ll='ls -AlhFv'
alias lh='ls -Ahrlt'
alias la='ls -Ah'

# Standard aliases
alias ..='cd ..'
alias ...='cd ../..'
alias -- +='pushd .'
alias -- -='popd'
alias li='less -i'
alias p='ps -u `/usr/bin/whoami` -o uid,pid,ppid,class,c,nice,stime,tty,cputime,comm'
alias r='echo $?'
alias c='clear'
alias v='vim'
alias cmount='mount | column -t'
alias meminfo='free -m -l -t'
alias intercept='sudo strace -ff -e trace=write -e write=1,2 -p'
alias listen='lsof -P -i -n'
alias port='ss -tulanp'
alias genpasswd="strings /dev/urandom | head -n 30 | tr -d '\n' | tr -d '[[:space:]]'; echo"

# Create sudo aliases for various commands
if [[ $UID -ne 0 ]]; then
	alias scat='sudo cat'
	alias svi='sudo vi'
	alias svim='sudo vim'
	alias sv='sudo vim'
	alias sll='sudo ls -AlhFv'
	alias sli='sudo less'
	alias sport='sudo ss -tulanp'
	alias snano='sudo nano'
	alias root='sudo su'
	alias reboot='sudo reboot'
fi

# Create shortcuts and sudo aliases for systemd
if which systemctl &>/dev/null; then
	if [[ $UID -ne 0 ]]; then
		alias start='sudo systemctl start'
		alias restart='sudo systemctl restart'
		alias stop='sudo systemctl stop'
		alias enable='sudo systemctl enable'
		alias disable='sudo systemctl disable'
		alias daemon-reload='sudo systemctl daemon-reload'
	else
		alias start='systemctl start'
		alias restart='systemctl restart'
		alias stop='systemctl stop'
		alias enable='systemctl enable'
		alias disable='systemctl disable'
		alias daemon-reload='systemctl daemon-reload'
	fi

	alias status='systemctl status'
	alias list-timers='systemctl list-timers'
	alias list-units='systemctl list-units'
	alias list-unit-files='systemctl list-unit-files'
fi

# Pacman support
if which pacman &>/dev/null; then
	if [[ $UID -ne 0 ]]; then
		alias pacman='sudo pacman'
		alias mkinitcpio='sudo mkinitcpio'
		# A custom cache location can be specified with '-c'; consider this a TODO for you to adjust
		alias paccache='sudo paccache -v -c /var/cache/pacman/pkg -c /var/cache/aur'
		# Finding libraries which where renewed in an update but where the old version is still used
		alias outlib="sudo lsof +c 0 | grep 'DEL.*lib' | awk '{ print \$NF }' | sort -u"
		alias outpac="sudo lsof +c 0 | grep 'DEL.*lib' | awk '{ print \$NF }' | sed -e 's/.so.*/.so/g' | pacman -Qoq - 2>/dev/null | sort -u"
	else
		# A custom cache location can be specified with '-c'; consider this a TODO for you to adjust
		alias paccache='paccache -v -c /var/cache/pacman/pkg -c /var/cache/aur'
		# Finding libraries which where renewed in an update but where the old version is still used
		alias outlib="lsof +c 0 | grep 'DEL.*lib' | awk '{ print \$NF }' | sort -u"
		alias outpac="lsof +c 0 | grep 'DEL.*lib' | awk '{ print \$NF }' | sed -e 's/.so.*/.so/g' | pacman -Qoq - 2>/dev/null | sort -u"
	fi
fi

# Arch Build System (abs) sudo alias
which abs &>/dev/null && [[ $UID -ne 0 ]] && alias abs='sudo abs'

# Support netctl commands if available
if which netctl &>/dev/null; then
	if [[ $UID -ne 0 ]]; then
		alias netctl='sudo netctl'
		alias netctl-auto='sudo netctl-auto'
		alias wifi-menu='sudo wifi-menu'
	fi
fi

# Specialized find alias
alias fibs='find . -not -path "/proc/*" -not -path "/run/*" -type l -! -exec test -e {} \; -print'
alias fl='find . -type l -exec ls --color=auto -lh {} \;'

# Metasploit Framework
# Quiet disables ASCII banner and -x ... auto-connects to msf postgresql database owned by ${USER}
if which msfconsole systemctl &>/dev/null; then
	alias msfconsole="start postgresql && msfconsole --quiet -x \"db_connect ${USER}@msf\""
elif which msfconsole &>/dev/null; then
	alias msfconsole="msfconsole --quiet -x \"db_connect ${USER}@msf\""
fi

# Enable fuck support if present
which thefuck &>/dev/null && eval "$(thefuck --alias)"

# Disable R's verbose startup message
which R &>/dev/null && alias R="R --quiet"

# Sort By Size
sbs() {
	du -h --max-depth=1 "${@:-"."}" | sort -h
}

# Create directory and cd into it
mcd() { mkdir -p "$1" && cd "$1"; }

# Comparing the md5sum of a file "$1" with a given one "$2"
md5check() { md5sum "$1" | grep "$2";}

# Top 10 cammands
top10() { history | awk '{a[$4]++ } END{for(i in a){print a[i] " " i}}' | sort -rn | head; }

# Fetching outwards facing IP-adress
ipinfo() {
	[[ -z "$*" ]] && curl ipinfo.io || curl ipinfo.io/"$*"; echo
}

# Remind me later
# usage: remindme <time> <text>
# e.g.: remindme 10m "omg, the pizza"
remindme() { sleep "$1" && zenity --info --text "$2" & }

# Simple calculator
calc() {
	if which bc &>/dev/null; then
		echo "scale=3; $*" | bc -l
	else
		awk "BEGIN { print $* }"
	fi
}

# Swap two files
swap() {
	local TMPFILE=tmp.$$

	[[ $# -ne 2 ]] && echo "swap: 2 arguments needed" && return 1
	[[ ! -e "$1" ]] && echo "swap: $1 does not exist" && return 1
	[[ ! -e "$2" ]] && echo "swap: $2 does not exist" && return 1

	mv "$1" "$TMPFILE"
	mv "$2" "$1"
	mv "$TMPFILE" "$2"
}
