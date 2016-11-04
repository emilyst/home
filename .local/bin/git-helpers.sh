#!/bin/bash

# git aliases
alias gl='git lg --all'
alias glw='glp --word-diff'
alias gco='git co'
alias gcp='git co -p'
alias gs='git status'
alias g='git status'
alias gd='git diff'
alias gdw='git --no-pager diff --word-diff'
alias gds='gd --cached'
alias gdsw='gdw --cached'
alias gar='git reset HEAD'
alias garp='git reset -p HEAD'
alias gap='git add -p'
alias gau='git ls-files --other --exclude-standard -z | xargs -0 git add -Nv'
alias gaur="git ls-files --exclude-standard --modified -z | xargs -0 git ls-files --stage -z | awk 'BEGIN { RS=\"\0\"; FS=\"\t\"; ORS=\"\0\" } { if (\$1 ~ / e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 /) { sub(/^[^\t]+\t/, \"\", \$0); print } }' | xargs -0t -n 1 git reset -q -- 2>&1 | sed -e \"s/^git reset -q -- /reset '/\" -e \"s/ *$/'/\""
alias gc='git ci -v'
alias gca='gc --amend'
alias grt='git_current_tracking > /dev/null && git rebase -i $(git_current_tracking)'
alias gp='git push'

# helper for git aliases
function git_current_tracking()
{
  local BRANCH="$(git describe --contains --all HEAD)"
  local REMOTE="$(git config branch.$BRANCH.remote)"
  local MERGE="$(git config branch.$BRANCH.merge)"
  if [ -n "$REMOTE" -a -n "$MERGE" ]
  then
	echo "$REMOTE/$(echo "$MERGE" | sed 's#^refs/heads/##')"
  else
	echo "\"$BRANCH\" is not a tracking branch." >&2
	return 1
  fi
}

# git log patch
function glp()
{
  # don't use the pager if in word-diff mode
  local pager="$(echo "$*" | grep -q -- '--word-diff' && echo --no-pager)"

  # use reverse mode if we have a range
  local reverse="$(echo "$*" | grep -q '\.\.' && echo --reverse)"

  # if we have no non-option args then default to listing unpushed commits in reverse moode
  if ! (for ARG in "$@"; do echo "$ARG" | grep -v '^-'; done) | grep -q . && git_current_tracking > /dev/null 2>&1
  then
	local default_range="$(git_current_tracking)..HEAD"
	local reverse='--reverse'
  else
	local default_range=''
  fi

  git $pager log --patch $reverse "$@" $default_range
}

function git_is_inside_work_tree()
{
    git rev-parse --is-inside-work-tree &> /dev/null
    return $?
}

# git log file
function glf()
{
  git log --format=%H --follow -- "$@" | xargs --no-run-if-empty git show --stat
}

# # git log search
# function gls()
# {
#   local phrase="$1"
#   shift
#   if [[ $# == 0 ]]
#   then
# 	local default_range=HEAD
#   fi
#   glp --pickaxe-all -S"$phrase" "$@" $default_range
# }

function up()
{
    local cdup="$(git rev-parse --show-cdup)"
    cd "${cdup:-.}"
}

# git update
function gupdate
{
  # subshell for `set -e` and `trap`
  (
	set -e

	# use `git-up` if installed
	if type git-up > /dev/null 2>&1
	then
	  exec git-up
	fi

	# fetch upstream changes
	git fetch

	BRANCH=$(git describe --contains --all HEAD)
	if [ -z "$(git config branch.$BRANCH.remote)" -o -z "$(git config branch.$BRANCH.merge)" ]
	then
	  echo "\"$BRANCH\" is not a tracking branch." >&2
	  exit 1
	fi

	# create a temp file for capturing command output
	TEMPFILE="`mktemp -t gup.XXXXXX`"
	trap '{ rm -f "$TEMPFILE"; }' EXIT

	# if we're behind upstream, we need to update
	if git status | grep "# Your branch" > "$TEMPFILE"
	then

	  # extract tracking branch from message
	  UPSTREAM=$(cat "$TEMPFILE" | cut -d "'" -f 2)
	  if [ -z "$UPSTREAM" ]
	  then
		echo Could not detect upstream branch >&2
		exit 1
	  fi

	  # can we fast-forward?
	  CAN_FF=1
	  grep -q "can be fast-forwarded" "$TEMPFILE" || CAN_FF=0

	  # stash any uncommitted changes
	  git stash | tee "$TEMPFILE"
	  [ "${PIPESTATUS[0]}" -eq 0 ] || exit 1

	  # take note if anything was stashed
	  HAVE_STASH=0
	  grep -q "No local changes" "$TEMPFILE" || HAVE_STASH=1

	  if [ "$CAN_FF" -ne 0 ]
	  then
		# if nothing has changed locally, just fast foward.
		git merge --ff "$UPSTREAM"
	  else
		# rebase our changes on top of upstream, but keep any merges
		git rebase -p "$UPSTREAM"
	  fi

	  # restore any stashed changes
	  if [ "$HAVE_STASH" -ne 0 ]
	  then
		git stash pop
	  fi

	fi

  )
}
