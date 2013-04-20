# Settings
export SERVER_PORT=8080
export RTK_SUBSYSTEM=vod
export EDITOR=vim
export RENTASK_USER=est
export RENTRAK_EMAIL=emily.strickland@rentrakmail.com
#export CVSWORK=/home/estrickland/work/ondemand/perl_lib
#ssh-agent $SHELL
[ -e /usr/local/vod/perl_lib ] && export PERL5LIB=/usr/local/vod/perl_lib

# Helper functions

cdtr()
{
	pattern=$1
	WORKDIR=$HOME/work

	if [[ -n "$pattern" ]]; then
		if [[ -d "$WORKDIR/$pattern" ]]; then
			work_dir="$WORKDIR/$pattern"
			title $pattern
			cd $work_dir
			export CVSWORK=`pwd`/perl_lib
			export PERL5LIB=`pwd`/perl_lib:$PERL5LIB
			export DOCUMENT_ROOT=`pwd`/web_src/vod/htdocs
			if [[ $work_dir =~ "([0-9]{6})" ]]; then
				task=${BASH_REMATCH[1]}
				rentask_clock.pl in $task
			fi
		else
			for dir in `find $WORKDIR -follow -maxdepth 1 -type d`; do
				branch_name=$(basename "$dir")
				if [[ $branch_name =~ ".*$pattern.*" ]]; then
					work_dir="$WORKDIR/$branch_name"
					title $branch_name
					cd $work_dir
					export CVSWORK=`pwd`/perl_lib
					export PERL5LIB=`pwd`/perl_lib:$PERL5LIB
					export DOCUMENT_ROOT=`pwd`/web_src/vod/htdocs
					if [[ $work_dir =~ "([0-9]{6})" ]]; then
						task=${BASH_REMATCH[1]}
						rentask_clock.pl in $task
					fi
					break
				fi
			done
		fi
	fi
}

# adapted from version 0.8:
# http://wiki.pdx/it_e3dev/Git/Recipes#head-d1df93f8489285880f1737c41902262528469a1a
codereview()
{
	recipients="tvev_dev@rentrak.com"
	ticket_dir=$(pwd)
	branch_name=$(git symbolic-ref -q HEAD)
	branch_name=${branch_name##refs/heads/}
	ticket_no=$(echo $branch_name | sed -n 's/.*\([0-9]\{6\}\).*/\1/p')

	if [ -z "$ticket_no" ]; then
		echo "couldn't figure out the ticket number from the branch name '$branch_name'..."
		return
	fi

	if [ -f ~/.rtpass ]; then
		ticket_name=$(rentask_ticket.pl $ticket_no)
		rentask_status.pl $ticket_no code-review
	else
		ticket_name=$(echo $branch_name | sed 's/-/ /g')
	fi

	server=$(hostname)
	from=${RENTRAK_EMAIL-$USER@rentrak.com}
	subject="Code Review - Rentask $ticket_name"
	rentask=rentask2@rentrak.com

	cat <<EOF | /usr/sbin/sendmail $recipients
	From: $from
	To: $recipients
	Subject: $subject
	Cc: $rentask

	Code review please.

	$@

	diff: ssh -t $server "cd $ticket_dir && git log -p -w --reverse -M origin/master..$branch_name"
	repo: ssh://$server/$ticket_dir
	rentask: https://rentask.rentrak.com/tickets/detail.html?ticket_no=$ticket_no

	Thanks
	.
EOF
}
