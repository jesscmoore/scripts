# Time-stamp: <Tuesday 2025-02-05 19:34:01 Jess Moore>
#
# User zsh aliases

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Zsh related
alias sz='source ~/.zshrc'
alias zshconfig="cat ~/.zshrc | more"

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
alias ldocs="ls -lt ~/Documents"
alias ldown='ls -lt ~/Downloads |head -n 7'
alias lomz="ls -l ~/.oh-my-zsh"
alias lnotes="ls -lt ~/Documents/private/notes"
alias lposts="ls ~/Documents/jesscmoore.github.io/_posts"
alias lscripts='ls $HOME/bin'
# Navigate
alias cdocs='cd ~/Documents'
alias cdown="cd ~/Downloads"
alias cnotes="cd ~/Documents/private/notes"
alias comz="cd ~/.oh-my-zsh"
alias cposts="cd ~/Documents/jesscmoore.github.io/_posts"
alias cpriv='cd ~/Documents/private'

# Tmp
alias gotmp='mkdir -p tmp; cd tmp'
