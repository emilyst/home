########################################################################
# colors
########################################################################

local reset="%{[00m%}"


########################################################################
# powerline symbols (require powerline font or terminal)
########################################################################

local powerline_hard_left_divider='%{%G%}'
local powerline_soft_left_divider='%{%G%}'
local powerline_hard_right_divider='%{%G%}'
local powerline_soft_right_divider='%{%G%}'
local powerline_branch='%{%G%}'
local powerline_line_number='%{%G%}'
local powerline_lock='%{%G%}'


########################################################################
# vcs info (git)
########################################################################

type vcs_info > /dev/null 2>&1 || autoload -Uz vcs_info
vcs_info_precmd () { vcs_info }
add-zsh-hook precmd vcs_info_precmd

zstyle ':vcs_info:*' enable git  # disable other backends
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' use-prompt-escapes true

# %b is branch
# %i is revision
# %u is value of unstagedstr
# %c is value of stagedstr
# %a is action in progress (for autoformats)

zstyle ':vcs_info:*' formats '%b%i%c%u'
zstyle ':vcs_info:*' actionformats '%b%i%c%u%a'

type is-at-least > /dev/null 2>&1 || autoload -Uz is-at-least
if is-at-least 4.3.11; then
  zstyle ':vcs_info:git+set-message:*' hooks git-action         \
                                             git-branch         \
                                             git-revision       \
                                             git-staged-files   \
                                             git-unstaged-files
fi

function git-has-unstaged-files {
  git status --porcelain | grep -m 1 '^??\b' &> /dev/null
}

function git-has-staged-files {
  git status --porcelain | grep -m 1 '^A\b' &> /dev/null
}

function +vi-git-branch {
  hook_com[branch]="%{%K{1}%F{1}%}$powerline_hard_right_divider%{%f%k%}"
  hook_com[branch]+="%{%K{1}%F{0}%}${hook_com[branch_orig]} $powerline_branch %{%f%k%}"
}

function +vi-git-revision {
  hook_com[revision]="%{%K{1}%F{16}%}$powerline_hard_right_divider%{%f%k%}"
  hook_com[revision]+="%{%K{16}%F{0}%} ${hook_com[revision_orig][0,10]} %{%f%k%}"
}

function +vi-git-unstaged-files {
  if [[ -n "${hook_com[unstaged_orig]}" ]] || git-has-unstaged-files; then
    hook_com[unstaged]="%{%K{16}%F{0}%}$powerline_soft_right_divider%{%f%k%}"
    hook_com[unstaged]+='%{%K{16}%F{0}%} %{✸%G%} %{%f%k%}'
  fi
}

function +vi-git-staged-files {
  if [[ -n "${hook_com[staged_orig]}" ]] || git-has-staged-files; then
    hook_com[staged]="%{%K{16}%F{0}%}$powerline_soft_right_divider%{%f%k%}"
    hook_com[staged]+='%{%K{16}%F{0}%} %{✚%G%} %{%f%k%}'
  fi
}

function +vi-git-action {
  hook_com[action]="${hook_com[action_orig]}"
}


########################################################################
# prompt
########################################################################

# use single-quoted values to let interpolation happen at prompt-time;
# use double-quoted ones to let interpolation happen at assignment-time

PROMPT='%{%K{4}%F{0}%} %{%{%B%}%(!.#.ϟ)%{%b%}%G%} %{%f%k%}'
PROMPT+="%{%K{19}%F{4}%}$powerline_hard_left_divider%{%f%k%}"
PROMPT+="%{%K{18}%F{19}%}$powerline_hard_left_divider%{%f%k%}"
PROMPT+="%{%F{18}%}$powerline_hard_left_divider%{%f%} "

RPROMPT="%{%F{18}%}$powerline_hard_right_divider%{%f%}"
RPROMPT+="%{%K{18}%F{19}%}$powerline_hard_right_divider%{%f%k%}"
RPROMPT+='%{%K{19}%F{7}%} %{%B%}%m%{%b%} %{%f%k%}'
RPROMPT+="%{%K{19}%F{4}%}$powerline_hard_right_divider%{%f%k%}"
RPROMPT+='%{%K{4}%F{0}%} %{%B%}%30<…<%(5~|%-1~/…/%3~|%4~)%-0<<%{%b%} %{%f%k%}'
RPROMPT+="%{%K{4}%F{1}%}$powerline_hard_right_divider%{%f%k%}"
RPROMPT+='%{%K{1}%F{0}%}${vcs_info_msg_0_}%{%f%k%}'
