Home
====

This repository contains configuration meant to be cloned to Linux or
macOS computers.

I have a few processes around how I set up and use this repository,
which I'll describe here. This is necessary because turning your home
directory into a giant Git repository is very weird and not recommended
under most circumstances. The processes I use help mitigate that
weirdness.

Note that this repository contains _configuration_, not setup itself.
Nothing here is meant to take over and make decisions actively. It does
not install things. It does not change global system settings. That is
left for me, as a user, to do. It merely configures whatever exists, if
it exists.


Setup
-----

Obviously, to use this, `git-clone(1)` is not recommended. The home
directory already exists, and a plain clone will set up the default Git
directory, in either case.

If I'm on a new computer and want to use these settings, I need to
initialize the current home directory directly, and I need to use
a non-default Git directory which won't be found by Git automatically
unless told explicitly. (This will prevent most tooling from seeing it.)

For this reason, I explicitly set the Git directory and the Git working
tree for all commands which manipulate the repository for these
settings. I use an alias which conveniently sets all these for every
command which pertains to the home repository, no matter what directory
I'm in.

    alias home="git --work-tree=$HOME --git-dir=$HOME/.home.git"

Note that the Git directory is under "`$HOME/.home.git`" instead of
"`$HOME/.git`." That effectively both hides the Git configuration from
both its own tooling (unless the `home` alias is used) and from normal
directory listings.

Assume first that a recent version of Git is installed and that SSH auth
to Git is established. Then, to set up, the following steps may be used.

    cd $HOME
    alias home="git --work-tree=$HOME --git-dir=$HOME/.home.git"
    home init
    home remote add origin git@github.com:emilyst/home.git
    home fetch --all
    home reset --hard origin/master
    home submodule update --init

Afterward, use the `home` alias to interact with the home repository.
(This alias is configured for Zsh.)


Layout and Editing
------------------

All files and directories are ignored by default. (See [.gitignore].)
Any added file needs to be added forcefully: e.g., `home add -f
<path/to/file>`. Any empty directory needs to contain a `.gitignore`
file to remain present, and that `.gitignore` file should also ignore
everything by default.

Because the repository sits on top of the home directory and ignores
everything by default, and because it uses a custom Git directory,
there's no need to use symbolic linking or other setup to use. It can
overlay whatever else and ignore it safely. The only updates it sees are
changes to the files which it does know about and tracks, which can be
committed normally (e.g., `home commit -avp` or similar).


Updating
--------

Pushing up updates to the GitHub repository is not difficult.

    home push

Pulling them down is somewhat more awkward because submodules will need
updates, and any Vim configuration changes will need to need to take
effect (and override any persisting configuration in saved views).

I use this command right now.

    home pull && home submodule update --init && rm -rf ~/.vim/local/view/*


Submodules
----------

Several submodules are used to extend my home repository with
functionality from other repositories. Git submodules are crude, but
I've been using them a long time.

Adding a new submodule also has to be forced, due to the global ignore
rules.

    home submodule add -f <repository> <path/to/destination>

Occasionally (perhaps once or twice a week), I update all the submodules
to ensure I have the latest versions. When I do this, I also garbage
collect aggressively on them.

    home submodule foreach 'git pull origin master && git gc --prune --aggressive'

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

    home commit -va

However, I also often make sure the actual files have themselves been
cleared out. This also leaves the Git directory for the submodule
behind, and it can leave configuration behind as well. Sometimes I'll
delete these as well. Configuration is in `.home.git/config`.

    rm -rf <path/to/submodule>
    rm -rf $HOME/.home.git/modules/<path/to/submodule>

This is just extra cleanup that's usually not needed, but sometimes can
help if you add another submodule with the same name or just want to
reclaim the space (or peace of mind).

When pulling down updates to a computer after deleting a submodule on
another one, I will do those latter steps because I'm not always
confident the `git-submodule(1)` update will clear out what needs to be
cleared.


License
-------

I hereby license any _original_ work in this repository into the public
domain under the Creative Commons CC0 license. To view a copy of this
license, visit https://creativecommons.org/publicdomain/zero/1.0/ or
send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042,
USA.

Note that I cannot relicense any anything which is not my own, original
work (including but not limited to submodules).
