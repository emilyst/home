Home
====

This repository contains configuration meant for use on my Linux or
macOS computers. Often, these are called "dot files" in casual use
because the filenames and directory names begin with a leading dot,
which hides them from view on those operating systems. That makes them
convenient for configuration.

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
Nothing here is meant to take over and act decisively of its own accord.
It does not install things. It does not change global system settings.
That is left for me, as a user, to do. It merely configures relevant
programs if they exist.


Setup
-----

To set up, `git-clone(1)` is not recommended. The home directory already
exists, so we don't need to create a new working tree, which
`git-clone(1)` would do. An unqualified `git clone` would also set up
the default Git directory. I don't want either of those things to
happen.

Instead, I treat my home directory as an existing working tree to
initialize with `git-init(1)`. I also use a non-default Git directory
which won't be found by Git automatically. This will prevent most
tooling from seeing my home directory as a repository under most
circumstances.

To do this, I explicitly set the Git directory and the Git working tree
for all Git commands which manipulate the home repository. I use an
alias which conveniently sets all these. I call it `home`, simply
enough. The `home` alias can be used in place of the `git` command to
manage my home directory configuration.

    alias home="git --work-tree=$HOME --git-dir=$HOME/.home.git"

Note that this sets the Git directory under "`$HOME/.home.git`" instead
of "`$HOME/.git`." That effectively both hides the Git configuration
from both its own tooling (unless the `home` alias is used) and from
normal directory listings. Another very neat thing about this alias is
that it will refer to the home repository, no matter which directory is
the current one, even if I'm in another Git repository at the time.

With this in mind, let's see how a first-time setup works using a recent
version of Git. Assume first that Git is installed and that SSH auth to
GitHub is established. Then, I run the following.

    alias home="git --work-tree=$HOME --git-dir=$HOME/.home.git"
    home init
    home remote add origin git@github.com:emilyst/home.git
    home fetch --all
    home reset --hard origin/master
    home submodule update --init --rebase

Afterwards, always use the `home` alias to interact with the home
repository. (This alias is configured for Zsh by my current
configuration.) Local "master" tracks "origin/master" automatically
during this setup, thanks to recent versions of Git.


Layout and Editing
------------------

All files and directories are ignored by default so that I only version
the few files which matter to me. This is done using a sneaky trick:
a special "`.gitignore.home`" file which lives in my home repository
that doesn't get used unless the current Git directory is the one for
the home repository. I wanted to avoid having a file named
"`.gitignore`" in my home directory which excludes everything because
Git and certain other tools will look for it.

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
forcefully: e.g., `home add -f <path/to/file>`. (Any empty directory
needs to contain a `.gitignore` file to be added, as usual.)

As a result, the repository can live directly in the home directory and
ignore everything by default. Because it uses a custom Git directory,
there's no need to use symbolic linking or copying. It can coexist
alongside anything else that lives in `$HOME`, and Git ignores anything
I haven't explicitly told it to track. The only updates it sees are
changes to the files which it does track, which can be committed
normally (e.g., using `home commit -av` or similar). If I want to track
something new, I can add it explicitly as I've described above.


### Submodules ###

See [submodules](#submodules-1) for more about submodules in general and
why I use them.

Most of my submodules are Vim plugins, and currently, I install them as
packages to [`$HOME/.vim/pack/default`](.vim/pack/default). At the same
time, I also add a relative symbolic link from the package directory to
the [`$HOME/.vim/pack/default/start`](.vim/pack/default/start)
directory.

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

When I pull them down, I also run a command which pulls down any
[submodule](#submodules-1) updates I've pushed up previously. The
command I use will discover which commit I've updated that submodule to,
and then it will rebase the submodule's current branch onto that commit.
(This prevents each submodule from being in a "detached HEAD" state at
all times so that I can work inside that submodule like a normal Git
repository more easily.)

    home pull && home submodule update --init --rebase

In my [`$HOME/.gitconfig`](.gitconfig), there is an alias that sets
`supdate` to do that awkward submodule command, so the command actually
looks like this when I type it.

    home pull && home supdate


Submodules
----------

In several cases, my home directory includes the entirety of a project
from elsewhere. Many of my Vim plugins are included this way since they
have their own Git repositories on GitHub. Therefore, I add them to the
home repository as [submodules], allowing me to incorporate those
repositories into my own, yet keeping them and their histories distinct.

There is a little complexity involved. I have to check the submodules
for updates and commit those updates to my home repository on a regular
basis. When updates have been added in one place, I need to pull down
the updates in another place.

At the same time, though, there are advantages. Updates aren't
automatic: I opt into them. I know what each update is, and
I incorporate it intentionally into the home repository. I can _undo_
any update. Finally, I can track down an update to a submodule which
affected my configuration deleteriously using `git-bisect(1)`.

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
to ensure I have the latest versions.

    home submodule update --init --remote --rebase

I have this sub-command aliased to `supgrade` for easier use.

    home supgrade

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
[submodules]: https://git-scm.com/book/en/v2/Git-Tools-Submodules
