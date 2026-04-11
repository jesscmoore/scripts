# Time-stamp: <Tuesday 2025-02-05 19:34:01 Jess Moore>
#
# User zsh aliases

# Update aliases
alias upaliases="cp ~/Documents/scripts/home/dot_omz_custom/aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh && sz && echo 'Copied scripts/home/dot_omz_custom/aliases.zsh to ~/.oh-my-zsh/custom/aliases.zsh'"

# Update macos custom settings
alias upaliases_macos="cp ~/Documents/scripts/home/dot_omz_custom/os/mac.zsh ~/.oh-my-zsh/custom/os/mac.zsh  && sz && echo 'Copied scripts/home/dot_omz_custom/os/mac.zsh to ~/.oh-my-zsh/custom/os/mac.zsh'"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Zsh related
alias sz='source ~/.zshrc'
alias zshconfig="cat ~/.zshrc | more"

# Disk space
alias large="du -sh * | sort -h && echo '\nAvailable disk space:' && df -h ."

# ls
alias ll='ls -la -G'
alias lh='ls -lah -G'
alias lt='ls -laht -G'

# Git (additional to git ohmyzsh package)
alias gs='git status'
alias glogac='git log --graph --abbrev-commit --decorate --oneline'

# Utilities
alias makepwd='openssl rand -base64 6'
alias grepnr='grep -nr'

# Locations
# List
# List - Desktop
alias ldesk="ls -lt ~/Desktop |head -n 7"
alias ldeskmore='ls -lt ~/Desktop |head -n 20'
alias ldeskall='ls -lt ~/Desktop |more'
alias sdesk='du -sh ~/Desktop/* | sort -h'
# List - Documents
alias ldocs="ls -lt ~/Documents"
alias ldocsmore='ls -lt ~/Documents |head -n 20'
alias ldocsall='ls -lt ~/Documents |more'
alias sdocs='du -sh ~/Documents/* | sort -h'
# List - Downloads
alias ldown='ls -lt ~/Downloads |head -n 7'
alias ldownmore='ls -lt ~/Downloads |head -n 20'
alias ldownall='ls -lt ~/Downloads |more'
alias sdown='du -sh ~/Downloads/* | sort -h'
# List - OhMyZsh
alias lomz="ls -l ~/.oh-my-zsh"
# List - Meetings
alias lmtgs="ls -lt ~/Documents/private/mtgs"
alias smtgs='du -sh ~/Documents/private/mtgs/* | sort -h'
# List - Notes
alias lnotes="ls -lt ~/Documents/private/notes"
# List - Website posts
alias lposts="ls ~/Documents/jesscmoore.github.io/_posts"
# List - Scripts
alias lscripts='ls $HOME/bin'

# Navigate
# Nav - Desktop
alias cdesk="cd ~/Desktop"
# Nav - Documents
alias cdocs='cd ~/Documents'
# Nav - Downloads
alias cdown="cd ~/Downloads"
# Nav - OhMyZsh
alias comz="cd ~/.oh-my-zsh"
# Nav - Meetings
alias cmtgs="cd ~/Documents/private/mtgs"
# Nav - Notes
alias cnotes="cd ~/Documents/private/notes"
# Nav - Talk notes
alias ctalks="cd ~/Documents/private/talks"
# Nav - Website posts
alias cposts="cd ~/Documents/jesscmoore.github.io/_posts"
# Nav - Private
alias cpriv='cd ~/Documents/private'
# Nav - Tmp
alias ctmp='mkdir -p tmp; cd tmp'

# Github - personal shorthand
# Eg. git log --graph --left-right --cherry-pick --oneline dev...jess/572_perm_history
alias glc="git log --graph --left-right --cherry-pick --oneline"
# Compressed git log with tags
alias glgt="git log --pretty=oneline --abbrev-commit"
