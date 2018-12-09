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

# branch is assumed to be first so no powerline divider transition is
# given below
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
  git status --porcelain | grep -m 1 '^\?\?\b' &> /dev/null
}

function git-has-staged-files {
  git status --porcelain | grep -m 1 '^A\b' &> /dev/null
}

function +vi-git-branch {
  # provide branch and sigil as black on orange (this is the first item
  # of vcs_info configured above, so no transition is needed, since that
  # is done before the vcs_info is included in the prompt)
  hook_com[branch]="%{%K{1}%F{0}%} ${hook_com[branch_orig]} $powerline_branch %{%f%k%}"
}

function +vi-git-revision {
  # transition from dark orange to light orange
  hook_com[revision]="%{%K{1}%F{16}%}$powerline_hard_right_divider%{%f%k%}"

  # provide truncated revision as black on light orange
  hook_com[revision]+="%{%K{16}%F{0}%} ${hook_com[revision_orig][0,10]} %{%f%k%}"
}

function +vi-git-unstaged-files {
  if [[ -n "${hook_com[unstaged_orig]}" ]] || git-has-unstaged-files; then
    # provide divider as black on light orange without transition
    hook_com[unstaged]="%{%K{16}%F{0}%}$powerline_soft_right_divider%{%f%k%}"

    # provide unstaged files sigil as bold black on light orange
    hook_com[unstaged]+='%{%K{16}%F{0}%B%} %{✸%G%} %{%b%f%k%}'
  fi
}

function +vi-git-staged-files {
  if [[ -n "${hook_com[staged_orig]}" ]] || git-has-staged-files; then
    # provide divider as black on light orange without transition
    hook_com[staged]="%{%K{16}%F{0}%B%}$powerline_soft_right_divider%{%f%k%}"

    # provide unstaged files sigil as bold black on light orange
    hook_com[staged]+='%{%K{16}%F{0}%B%} %{✚%G%} %{%b%f%k%}'
  fi
}

function +vi-git-action {
  # transition from light orange to light purple
  hook_com[action]="%{%K{16}%F{5}%}$powerline_hard_right_divider%{%f%k%}"

  # set bold black on light purple
  hook_com[action]+="%{%K{5}%F{0}%B%} "

  # provide action sigil
  case "${hook_com[action_orig]}" in
    "rebase")
      hook_com[action]+="⤵"
      ;;
    "am/rebase")
      hook_com[action]+="⤵✉"
      ;;
    "rebase-i")
      hook_com[action]+="⤵"
      ;;
    "rebase-m")
      hook_com[action]+="⤵⇓"
      ;;
    "merge")
      hook_com[action]+="⇓"
      ;;
    "am")
      hook_com[action]+="✉⇓"
      ;;
    "bisect")
      hook_com[action]+="⇅"
      ;;
    "cherry")
      hook_com[action]+="↩"
      ;;
    "cherry-seq")
      hook_com[action]+="↩"
      ;;
    "cherry-or-revert")
      hook_com[action]+="↩"
      ;;
    *)
      hook_com[action]+="${hook_com[action_orig]}"
      ;;
  esac

  # close formatting
  hook_com[action]+=" %{%b%f%k%}"
}


########################################################################
# prompt
########################################################################

# use single-quoted values to let interpolation happen at prompt-time;
# use double-quoted ones to let interpolation happen at assignment-time

# begin left prompt with light blue background and provide bold prompt
# sigil
PROMPT='%{%K{4}%F{0}%B%} %{%(!.#.ϟ)%G%} %{%b%f%k%}'

# transition light blue to darker blue
PROMPT+="%{%K{19}%F{4}%}$powerline_hard_left_divider%{%f%k%}"

# transition darker blue to darkest blue
PROMPT+="%{%K{18}%F{19}%}$powerline_hard_left_divider%{%f%k%}"

# transition darkest blue to normal background
PROMPT+="%{%F{18}%}$powerline_hard_left_divider%{%f%} "


# begin right prompt by transitioning out of normal background to
# darkest blue
RPROMPT="%{%F{18}%}$powerline_hard_right_divider%{%f%}"

# transition darkest blue to darker blue
RPROMPT+="%{%K{18}%F{19}%}$powerline_hard_right_divider%{%f%k%}"

# provide hostname in bold pale gray against darker blue background
RPROMPT+='%{%K{19}%F{7}%B%} %m %{%b%f%k%}'

# transition from darker blue to lighter blue
RPROMPT+="%{%K{19}%F{4}%}$powerline_hard_right_divider%{%f%k%}"

# provide bold, black, doubly-truncated path against light blue
# background
RPROMPT+='%{%K{4}%F{0}%B%} %30<…<%(5~|%-1~/…/%3~|%4~)%-0<< %{%b%f%k%}'

# transition from lighter blue to light orange
RPROMPT+="%{%K{4}%F{1}%}$powerline_hard_right_divider%{%f%k%}"

# provide VCS information if any as default black on light orange
RPROMPT+='%{%K{1}%F{0}%}${vcs_info_msg_0_}%{%f%k%}'
