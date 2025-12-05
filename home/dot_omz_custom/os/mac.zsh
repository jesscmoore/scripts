# Time-stamp: <Tuesday 2025-02-04 21:34:01 Jess Moore>
#
# Dev related zsh setup for macos
echo "Sourcing \$ZSH_CUSTOM/os/mac.zsh"

# Set PATH, MANPATH, etc., for Homebrew
export PATH=/opt/homebrew/sbin:/opt/homebrew/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin

# PYTHON
#eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"
#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#alias python="python3.11"
#alias pip="pip3.11"

# PYTHON SETUP
# disables prompt mangling in virtual_env/bin/activate
# export virtual_env_disable_prompt=1
# https://stackoverflow.com/questions/60212658/issues-with-pyenv-virtualenv-python-and-pip-not-changed-when-activating-deact
export PATH="$HOME/.pyenv/bin:$PATH"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

if command -v pyenv 1>/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi


# R SETUP
# R installed at: /opt/homebrew/bin/R


# FLUTTER
export PATH="$PATH:$HOME/lib/flutter/bin"
# dart/flutter pub installs executables into $HOME/.pub-cache/bin
export PATH="$PATH":"$HOME/.pub-cache/bin"


# R wattleclir package
export PATH=$PATH:~/bin
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"


# Python
export PATH=/Library/Frameworks/Python.framework/Versions/3.11/bin:$PATH

# Latex
eval "$(/usr/libexec/path_helper)"


## Ruby & Jekyll
# Ref: https://jekyllrb.com/docs/installation/macos/
# Specifies MacOS Ruby & Jekyll install method incl. # latest stable ruby supported by Jekyll
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-3.4.1
# Update ruby with `ruby-install` not `brew`
# ruby-install ruby [version_no]
# where version_no is latest ruby supported by Jekyll


## Radian and R
# https://github.com/randy3k/radian
alias r="radian"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"

# Created by `pipx` on 2024-03-07 22:34:37
export PATH="$PATH:$HOME/.local/bin"


# POETRY SETUP
# Configure poetry to save environment in project folder
# Reqs $HOME/.local/bin in path
poetry config virtualenvs.in-project true


# BASH
# GNU getopt
export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
