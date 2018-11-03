Home
====

This repository contains configuration meant for use on my Linux or
macOS computers.

If you're reading this on a file system, you're seeing the only
non-hidden portion of a source-controlled set of configuration files
designed for use on Linux and macOS. The canonical version is hosted at
[GitHub](https://github.com/emilyst/home). (See the [notes](#notes) on
how to hide this file, too.)

I have a few custom approaches regarding how I set up, use, and maintain
this repository, which I'll describe here. This is necessary because
turning your home directory into a giant Git repository is very weird
and not recommended under most circumstances. The techniques I describe
below help mitigate that weirdness.

Note that this repository contains _configuration_, not setup itself.
Nothing here is meant to take over and make decisions actively. It does
not install things. It does not change global system settings. That is
left for me, as a user, to do. It merely configures whatever exists, if
it exists.


Setup
-----

To set up, `git-clone(1)` is not recommended. The home directory already
exists, so we don't need to create a new working tree, as `git-clone(1)`
would do. An unqualified `git clone` would also set up the default Git
directory. I don't want either of those things to happen.

Instead, I treat my home directory as an existing working tree to
initialize with `git-init(1)` and add a remote to. I also use
a non-default Git directory which won't be found by Git automatically.
This will prevent most tooling from seeing my home directory as
a repository under most circumstances.

To do this, I explicitly set the Git directory and the Git working tree
for all Git commands which manipulate the home repository. I use an
alias which conveniently sets all these. I call it `home`, simply
enough.

    alias home="git --work-tree=$HOME --git-dir=$HOME/.home.git"

Note that this sets the Git directory under "`$HOME/.home.git`" instead
of "`$HOME/.git`." That effectively both hides the Git configuration
from both its own tooling (unless the `home` alias is used) and from
normal directory listings. Another very neat thing about this alias is
that it will refer to the home repository, even if I'm in another Git
repository at the time.

With this in mind, let's see how a first-time setup works using a recent
version of Git. Assume first that Git is installed and that SSH auth to
GitHub is established. Then, I run the following.

    alias home="git --work-tree=$HOME --git-dir=$HOME/.home.git"
    home init
    home remote add origin git@github.com:emilyst/home.git
    home fetch --all
    home reset --hard origin/master
    home submodule update --init --remote --rebase --jobs 8

Afterwards, always use the `home` alias to interact with the home
repository. (This alias is configured for Zsh by the current
configuration.) Local master tracks origin/master automatically during
this setup, thanks to recent versions of Git.


Layout and Editing
------------------

All files and directories are ignored by default. This is done via
a sneaky trick: a special "`.gitignore.home`" file which lives in my
home repository that doesn't get used unless the current Git directory
is the one for the home repository. I wanted to avoid having a file
named "`.gitignore`" in my home directory which excludes everything
because Git and certain other tools will look for it.

To pull this off, first, I added a configuration stanza to the _bottom_
of [my global Git configuration](.gitconfig) like the following.

    [includeIf "gitdir:~/.home.git"]
    	path = .gitconfig.home

That file [only gets included if the current Git directory
matches](https://www.git-scm.com/docs/git-config#_conditional_includes).
Then, [in that included configuration file](.gitconfig.home), I can set
a new `core.excludesFile` setting which overrides the original (which is
why it has to be at the bottom).

    [core]
    	excludesfile = ~/.gitignore.home

Finally, [.gitignore.home](.gitignore.home) is configured to exclude
everything by containing a single wildcard.

The reason for all this conditional inclusion rigmarole is for the same
reason I use a custom Git directory—so that no naive tooling goes
recursing up the directory tree looking for items to ignore and uses
that file by mistake.

Because the home repository ignores _everything_, any added file or
directory I want to track in my home repository needs to be added
forcefully: e.g., `home add -f <path/to/file>`. Any empty directory
needs to contain a `.gitignore` file to be added.

As a result, the repository can live directly in the home directory and
ignore everything by default. Because it uses a custom Git directory,
there's no need to use symbolic linking or copying. It can coexist
alongside anything else that lives in `$HOME`, and Git ignores anything
I haven't explicitly told it to track. The only updates it sees are
changes to the files which it does track, which can be committed
normally (e.g., using `home commit -av` or similar). If I want to track
something new, I can add it explicitly as I've described above.


### Submodules ###

Today, Vim packages are installed to
[`$HOME/.vim/pack/default`](.vim/pack/default), and at the same time,
I also add a relative symbolic link from the package directory to the
[`$HOME/.vim/pack/default/start`](.vim/pack/default/start) directory.

Other submodules go where appropriate, usually in a hidden place if
I can manage. See [submodules](#submodules-1) below for more information
on setup.


### Local Hierarchy ###

There is an entire local Unix-like hierarchy under
[`$HOME/.local`](.local). It is complete enough that I can install most
programs to that directory by running `./configure
--prefix="$HOME/.local"`, provided the program uses GNU [autoconf].

Most of those directories stay empty and stay in the home repository
only so that they will exist for this purpose. However, a couple are
populated with things I want to exist on any computer and which are
machine-independent. For example, there are some scripts in
[`$HOME/.local/bin`](.local/bin), and there is a Vim/Common Lisp
submodule under [`$HOME/.local/share`](.local/share).

For more about the Unix hierarchy, see the `hier(7)` manual page
(particularly the "`/usr`" section).


Updating
--------

Pushing up updates to GitHub is not difficult.

    home push

Pulling them down is somewhat more awkward because submodules will need
updates, and any Vim configuration changes will need to need to take
effect (and override any persisting configuration in saved views).

I use this command right now. It updates each submodule so that each
stays on the "`master`" branch.

    home pull && home submodule update --remote --rebase --init --jobs 8 \
      && rm -rf ~/.vim/local/view/*

In my [`$HOME/.gitconfig`](.gitconfig), there is an alias that sets
`supdate` to do that awkward submodule command, so the command actually
looks like this when I type it.

    home pull && home supdate && rm -rf ~/.vim/local/view/*


Submodules
----------

Several submodules are used to extend my home repository with
functionality from other repositories. Git submodules are crude, but
I've been using them a long time.

Adding a new submodule also has to be forced, due to the global ignore
rules. I always do this with relative paths.

    home submodule add -f <repository> <relative/path/to/destination>

If I have added a Vim package, I clone it into
[`$HOME/.vim/pack/default`](.vim/pack/default), and then from
[`$HOME/.vim/pack/default/start`](.vim/pack/default/start),
I symbolically link from the package directory to the current directory
(relatively). That allows adding and removing packages from the current
Vim configuration temporarily by moving the symbolic links only.

Occasionally (perhaps once or twice a week), I update all the submodules
to ensure I have the latest versions. When I do this, I also garbage
collect aggressively on them.

    home submodule foreach \
      'git fetch && git rebase origin/master && git gc --prune --aggressive'

After doing that, I need to commit whatever submodule pointers have been
updated.

    home commit -av

Usually I'll call this commit "Submodule updates" and list the
submodules which were updated in the description. This is all sort of
more manual than a plugin manager, but it allows me to bisect my
configuration, in case a submodule changes radically out from under me.

Removing a submodule is rather awkward. In theory, it's possible in
recent versions of Git merely to `rm` them.

    home rm <path/to/submodule>

Then that change can be committed.

    home commit -av

However, I also often make sure the actual files have themselves been
cleared out. This may also need to be repeated when the update which
commit which removes the submodule is applied on another computer.

This command also leaves the Git directory for the submodule behind, and
it can leave configuration behind as well. Sometimes I'll delete these
as well. Configuration for a submodule lives in `.home.git/config`,
_not_ under the submodule directory itself (which normally only contains
a text file called "`.git`" which contains the path to that
configuration). That means I use commands like these to clean up.

    rm -rf <path/to/submodule>
    rm -rf $HOME/.home.git/modules/<path/to/submodule>

This is just extra cleanup that's often not needed but sometimes can
help if you add another submodule with the same name or just want to
reclaim the space (or peace of mind).

When pulling down updates to a computer after deleting a submodule on
another one, I will do those latter steps because I'm not always
confident the `git-submodule(1)` update will clear out what needs to be
cleared.


Notes
-----

Below are a few additional notes on the process.


### Hiding the README on macOS ###

The README can be hidden, too, on macOS—from view in Finder, at least.
To do so, run a command to change its "hidden" flag.

    chflags hidden $HOME/README.md

This will tidy up your view of your home directory in Finder. The file
still exists, and it's visible in any directory listing (even one that
doesn't show hidden files, unfortunately), but it will otherwise be out
of the way.


License
-------

I hereby license any _original_ work in this repository into the public
domain under the Creative Commons CC0 license. To view a copy of this
license, visit https://creativecommons.org/publicdomain/zero/1.0/ or
send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042,
USA.

Note that I cannot relicense any anything which is not my own, original
work (including but not limited to submodules).


[autoconf]: https://www.gnu.org/software/autoconf/
