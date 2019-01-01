# I've copied this from oh-my-zsh/plugins/ssh-agent, with minor
# modifications.

typeset _agent_forwarding _ssh_env_cache

function _start_agent() {
	local lifetime
	local -a identities

	# start ssh-agent and setup environment
	zstyle -s :ssh-agent lifetime lifetime

	ssh-agent -s ${lifetime:+-t} ${lifetime} | sed 's/^echo/#echo/' >! $_ssh_env_cache
	chmod 600 $_ssh_env_cache
	. $_ssh_env_cache > /dev/null

	# load identities
	zstyle -a :ssh-agent identities identities

	echo starting ssh-agent...
	ssh-add $HOME/.ssh/${^identities}
}

# Get the filename to store/lookup the environment from
_ssh_env_cache="$HOME/.ssh/environment-$SHORT_HOST"

# test if agent-forwarding is enabled
zstyle -b :ssh-agent agent-forwarding _agent_forwarding

if [[ $_agent_forwarding == "yes" && -n "$SSH_AUTH_SOCK" ]]; then
	# Add a nifty symlink for screen/tmux if agent forwarding
	[[ -L $SSH_AUTH_SOCK ]] || ln -sf "$SSH_AUTH_SOCK" /tmp/ssh-agent-$USER-screen
elif [[ -f "$_ssh_env_cache" ]]; then
	# Source SSH settings, if applicable
	. $_ssh_env_cache > /dev/null
	if [[ $USER == "root" ]]; then
		FILTER="ax"
	else
		FILTER="x"
	fi
	ps $FILTER | grep ssh-agent | grep -q $SSH_AGENT_PID || {
		_start_agent
	}
else
	_start_agent
fi

# tidy up after ourselves
unset _agent_forwarding _ssh_env_cache
unfunction _start_agent
