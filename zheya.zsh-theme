ZSH_THEME_GIT_PROMPT_PREFIX="⟦ %{$fg_bold[green]%}%{$reset_color%}%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} ⟧"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%}⇡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%}⇣%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}⊕%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[yellow]%}⊖%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}⊙%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STASHED="(%{$fg_bold[blue]%}✹%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}"

_PATH="%{$fg_bold[white]%}%~%{$reset_color%}"

# Zenva.ttf
if [[ $EUID -eq 0 ]]; then
  _USERNAME="%{$fg_bold[red]%}%n"
  _LIBERTY="%{$fg[red]%}#"
else
  _USERNAME="%{$fg_bold[red]%}折鴉"
  _LIBERTY="%{$fg[green]%}$"
fi
_USERNAME="%{$_USERNAME%}@夜明け前%{$reset_color%}"
_LIBERTY="$_LIBERTY%{$reset_color%}"

typeset -g CMD_START_TIME=0
typeset -g LAST_EXIT_CODE=0
typeset -g CMD_DURATION=0

preexec() {
  CMD_START_TIME=$SECONDS
}

_format_cmd_duration() {
  CMD_DURATION=$((SECONDS - CMD_START_TIME))
  if (( CMD_DURATION >= 3600 )); then
    printf "%dh%02dm%02ds" $((CMD_DURATION/3600)) $((CMD_DURATION%3600/60)) $((CMD_DURATION%60))
  elif (( CMD_DURATION >= 60 )); then
    printf "%dm%02ds" $((CMD_DURATION/60)) $((CMD_DURATION%60))
  else
    printf "%.2fs" $CMD_DURATION
  fi
}

_get_last_exit_code() {
  if [[ $LAST_EXIT_CODE -eq 0 ]]; then
    echo "%{$fg_bold[green]%}${LAST_EXIT_CODE}%{$reset_color%}"
  else
    echo "%{$fg_bold[red]%}${LAST_EXIT_CODE}%{$reset_color%}"
  fi
}

get_space() {
  local left=$1
  local right=$2
  
  local zero='%([BSUbfksu]|([FB]|){*})'
  local clean_left=${${(S%%)left}//$~zero/}
  local clean_right=${${(S%%)right}//$~zero/}
  
  local left_width=$(echo -n $clean_left | LC_ALL=en_US.UTF-8 python3 -c 'import sys; print(len(sys.stdin.read().encode("utf-8"))//2)')
  local right_width=$(echo -n $clean_right | LC_ALL=en_US.UTF-8 python3 -c 'import sys; print(len(sys.stdin.read().encode("utf-8"))//2)')
  local total_width=$((left_width + right_width))
  
  local spaces=$(( COLUMNS - total_width - ${ZLE_RPROMPT_INDENT:-1} ))
  (( spaces > 0 )) || return
  printf ' %.0s' {1..$spaces}
}

_get_battery() {
  local battery=$(acpi -b | grep -o "[0-9]*%")
  local percent=${battery%\%}
  local color=$([[ $percent -ge 70 ]] && echo green || \
               [[ $percent -ge 50 ]] && echo cyan || \
               [[ $percent -ge 30 ]] && echo yellow || \
               echo red)
  echo "%F{$color}$battery%%f"
}

pre_prompt() {
  LAST_EXIT_CODE=$?

  _1LEFT="$_PATH ⟦%F{yellow}\$(_format_cmd_duration)%f⟧ $(_get_battery)"
  _1RIGHT="$_USERNAME ⟦%*⟧ ⟦\$(_get_last_exit_code)⟧ %F{yellow}[%(1j.%j jobs.)]%f"
 
  _1SPACES=$(get_space "$_1LEFT" "$_1RIGHT")
  print
  print -rP "$_1LEFT$_1SPACES$_1RIGHT"
}

setopt prompt_subst
PROMPT='> $_LIBERTY '
RPROMPT='$(nvm_prompt_info) $(git_prompt_info)'

autoload -U add-zsh-hook
add-zsh-hook preexec preexec
add-zsh-hook precmd pre_prompt
