# Add user@host if ssh connection
PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) %{$fg[cyan]%}%c%{$reset_color%}"
if [[ -n $SSH_CONNECTION ]]; then
PROMPT="%{$fg[white]%}%n@%{$fg[magenta]%}%m%{$reset_color%} ${PROMPT}"
fi
# Append virtual environment
PROMPT+=' $(virtualenv_prompt_info) $(git_prompt_info) '
# Add git
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
