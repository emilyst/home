########################################################################
# git (depends on oh-my-zsh git plugin)
########################################################################

# git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[white]%}[%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "

# parse_git_dirty()
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

# git_prompt_status()
ZSH_THEME_GIT_PROMPT_ADDED=" %{$fg[green]%}✚%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED=" %{$fg[blue]%}✹%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED=" %{$fg[red]%}✖%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED=" %{$fg[magenta]%}➼%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED=" %{$fg[yellow]%}═%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$fg[cyan]%}✭%{$reset_color%}"

# git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD=" %{$fg[red]%}!%{$reset_color%}"

# git_remote_status
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="⟶%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="⟵%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="⇄%{$reset_color%}"

# git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$fg_bold[white]%}]%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_NOCACHE=1

#local return_status="%{$fg[red]%}%(?..⏎)%{$reset_color%}"


# ########################################################################
# # vi-mode (depends on vi-mode oh-my-zsh plugin)
# ########################################################################

# # I just change the color of my prompt to indicate the mode
# MODE_INDICATOR="%{$fg_bold[cyan]%}"
# #MODE_INDICATOR="%{$fg_bold[red]%}<%{$fg[red]%}<<%{$reset_color%}"

# function vi_mode_prompt_info() {
#     echo "${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/}"
# }


########################################################################
# prompt
########################################################################

# left
PROMPT='%{$FG[226]%}%(!.#.⚡)%{$reset_color%} '

# right
RPROMPT='%{$fg_bold[blue]%}%m%{$fg_bold[white]%}:%{$fg_bold[cyan]%}%30<...<%~%<<%u%{$reset_color%}$(git_prompt_info)$(git_prompt_short_sha)$(git_prompt_status)'
