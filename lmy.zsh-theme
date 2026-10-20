zmodload zsh/datetime
function lmy_theme_preexec() {
  timer=$EPOCHREALTIME
}
function lmy_theme_precmd() {
  if [ -n "$timer" ]; then
    local elapsed=$(( EPOCHREALTIME - timer ))
    if (( elapsed >= 1 )); then
      local s=$(printf "%.2f" $elapsed)
      export EXEC_TIME=" %F{yellow}󰔟 ${s}s%f"
    elif (( elapsed > 0.001 )); then
      local ms=$(printf "%.0f" $(( elapsed * 1000 )))
      export EXEC_TIME=" %F{yellow}󰔟 ${ms}ms%f"
    else
      export EXEC_TIME=""
    fi
    unset timer
  else
    export EXEC_TIME=""
  fi

  # LC_ALL=C: on a zh_CN locale the word "load average" is translated and the
  # awk split silently yields an empty block.
  local sys_load=$(LC_ALL=C uptime | awk -F'load average[s]*: ' '{print $2}' | sed 's/,//g' | xargs 2>/dev/null)
  if [ -n "$sys_load" ]; then
    export SYS_LOAD="%F{cyan}󰊚 ${sys_load}%f"
  else
    export SYS_LOAD=""
  fi

  # Remote session marker (macOS sshd and Linux sshd both set SSH_CONNECTION).
  if [ -n "$SSH_CONNECTION" ]; then
    export LMY_SSH="%F{red}(ssh)%f "
  else
    export LMY_SSH=""
  fi

  # toolbox/distrobox-style containers ship this helper; absent on bare hosts.
  if (( $+functions[toolbox_prompt_info] )); then
    export LMY_BOX="$(toolbox_prompt_info) "
  else
    export LMY_BOX=""
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook preexec lmy_theme_preexec
add-zsh-hook precmd lmy_theme_precmd

ZSH_THEME_GIT_PROMPT_PREFIX=" %F{242}on%f %F{magenta} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red} ✗%f"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{green} ✔%f"

# ---------- git: branch + upstream delta + working tree state ---------------
# Same information as the old amx theme, but shown on lmy's single info line:
#   ↑N / ↓N   commits ahead / behind the upstream
#   ●green    staged   ●red unstaged   ●grey untracked   ✕red unmerged
#   ✔         clean tree
# Uses git directly instead of oh-my-zsh's git_prompt_info(), so it still works
# when the git plugin is disabled, and costs one `git status` per prompt.
function lmy_git_prompt() {
  git rev-parse --git-dir >/dev/null 2>&1 || return

  local branch
  branch=$(git symbolic-ref --short -q HEAD 2>/dev/null) || \
    branch=$(git rev-parse --short HEAD 2>/dev/null)
  [[ -n $branch ]] || return

  local gitbits="" upstream
  if upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null); then
    local ahead behind
    ahead=$(git rev-list --count "$upstream..HEAD" 2>/dev/null) || ahead=0
    behind=$(git rev-list --count "HEAD..$upstream" 2>/dev/null) || behind=0
    (( ahead > 0 )) && gitbits+=" %F{magenta}↑${ahead}%f"
    (( behind > 0 )) && gitbits+=" %F{green}↓${behind}%f"
  fi

  local porcelain
  porcelain=$(git status --porcelain 2>/dev/null)

  if [[ -n $porcelain ]]; then
    print -r -- "$porcelain" | command grep -qE '^(D[ M]|[MARC][ MD]) ' && gitbits+=" %F{green}●%f"
    print -r -- "$porcelain" | command grep -qE '^[ MARC][MD] ' && gitbits+=" %F{red}●%f"
    print -r -- "$porcelain" | command grep -qE '^(A[AU]|D[DU]|U[ADU]) ' && gitbits+=" %F{red}✕%f"
    print -r -- "$porcelain" | command grep -q '^?? ' && gitbits+=" %F{242}●%f"
  else
    gitbits+="%F{green} ✔%f"
  fi

  print -r -- "$ZSH_THEME_GIT_PROMPT_PREFIX${branch}${gitbits}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# Clock icon (U+F43A) kept in a variable so the byte survives hand-editing.
LMY_CLOCK=$'\uf43a'

# ---------- exit status: [rc] colour + failure label -------------------------
# A signal death reports rc = 128+N, but N is PLATFORM DEPENDENT: SIGTSTP is 18
# on macOS/BSD (Ctrl-Z -> rc 146) and 20 on Linux (-> 148); SIGBUS is 10 vs 7,
# SIGUSR1 is 30 vs 10, SIGCONT 19 vs 18. Hard-coding either list is therefore
# wrong on the other OS. So the numbers are resolved at load time from zsh's own
# `signals` array, whose index IS the platform's signal number. One theme then
# works on macOS, Linux and WSL, and signals that do not exist on the current OS
# (SIGEMT on Linux, ...) are skipped automatically.
#
# Colours: yellow = user side / interruption, magenta = killed by the system
# (usually OOM), red = crash or plain failure.
typeset -A LMY_SIGCOL=(
  KILL 5
  QUIT 1 ILL 1 TRAP 1 ABRT 1 EMT 1 FPE 1 BUS 1 SEGV 1 SYS 1 XCPU 1 XFSZ 1
  HUP 3 INT 3 PIPE 3 ALRM 3 TERM 3 STOP 3 TSTP 3 CONT 3 TTIN 3 TTOU 3 USR1 3 USR2 3
)
# Non-signal codes as "rc:colour:label". Exit codes are NOT errno -- a program
# picks 1..255 itself -- so errno names are used only where the convention truly
# matches: 127 ENOENT (not found), 126 EACCES (not executable), 128 EINVAL (bad
# `exit` argument). Caveat: a plain 1 cannot be told apart from `grep`/`diff`
# exiting 1 for "no match" / "files differ".
typeset -a LMY_RCCOL=(
  '1:1:ERR' '2:3:USAGE' '124:3:TIMEOUT' '126:1:EACCES'
  '127:3:ENOENT' '128:1:EINVAL' '255:1:FAIL'
)

# NOTE: each `%(` needs its own `)`. A missing one makes the outer conditional
# swallow whatever follows it -- that is why the trailing space once vanished.
function lmy_build_rcprompt() {
  local sym_nest='%F{1}[%?]%f' sig_nest='%F{1}ERR%f'
  local off idx num col lab nm row
  # Calibrate against SIGHUP, which is signal 1 on every Unix: this absorbs the
  # pseudo-entry (EXIT) that zsh places in front of the array.
  idx=${signals[(i)HUP]}
  if [[ ${signals[$idx]} == HUP ]]; then off=$(( idx - 1 )); else off=0; fi
  for nm in ${(k)LMY_SIGCOL}; do
    idx=${signals[(i)$nm]}
    [[ ${signals[$idx]} == $nm ]] || continue       # signal absent on this OS
    num=$(( 128 + idx - off ))
    col=${LMY_SIGCOL[$nm]}
    sym_nest="%(${num}?.%F{${col}}[%?]%f.${sym_nest})"
    sig_nest="%(${num}?.%F{${col}}SIG${nm}%f.${sig_nest})"
  done
  for row in $LMY_RCCOL; do
    num=${row%%:*}; row=${row#*:}; col=${row%%:*}; lab=${row#*:}
    sym_nest="%(${num}?.%F{${col}}[%?]%f.${sym_nest})"
    sig_nest="%(${num}?.%F{${col}}${lab}%f.${sig_nest})"
  done
  # Line-2 symbol: magenta δ normally. It deliberately does NOT mean success --
  # zsh-syntax-highlighting already paints valid commands green. On failure it
  # becomes [rc], always in the same colour as the matching label below.
  LMY_SYM="%(?.%F{5}δ%f.${sym_nest})"
  # Monitor-block slot (immediately before the "xx ms"): green ✔ on success,
  # otherwise the signal name or the non-signal label.
  LMY_SIG="%(?.%F{2}✔%f.${sig_nest})"
}
lmy_build_rcprompt

# Line 1: container/ssh markers + identity + path + git, then the monitor block.
# The block used to be the RPROMPT, which sits on the typing line and gets
# clobbered by long commands.
PROMPT='${LMY_BOX}${LMY_SSH}%F{cyan}%n%f %F{242}@%f %F{blue}%m%f in %F{green}%~%f$(lmy_git_prompt) %F{242}[%f$LMY_SIG$EXEC_TIME %f %F{14}$LMY_CLOCK %D{%H:%M:%S}%f %F{242}|%f $SYS_LOAD %F{242}]%f
$LMY_SYM '

RPROMPT=""
