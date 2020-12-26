# .zshenv should be used for environment variables etc
# echo "Loading internal $ZDOTDIR/.zshenv..."

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

typeset -U path
typeset -U manpath

case "$OSTYPE" in
    darwin*)
        # Coreutils overriding the MAC utils
	    path=($HOME/perl5/bin /usr/local/Cellar/gnu-getopt/2.33.2/bin /usr/local/opt/coreutils/libexec/gnubin $path)
	    manpath=(/usr/local/opt/coreutils/libexec/gnuman $manpath)
	    PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
	    PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
	    PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
	    PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;
        ;;
    linux*)
        if [[ -e ~/.nix-profile/etc/profile.d/nix.sh ]]; then
            source ~/.nix-profile/etc/profile.d/nix.sh
        fi
        ;;
esac

test -d "/cibo" && export PATH="/cibo/shared-scripts/local:/cibo/shared-scripts/local/aws_accounts:$HOME/.local/bin:$PATH"

# Setting the Go path
path+=$HOME/go/bin
path=($HOME/.pyenv/bin $path)
# Setting the krew for kubectl PATH
path+=${HOME}/.krew/bin

# export PATH=$(pathClean $PATH)

# Set up GOPATH
export GOPATH="$HOME/go"

case "$OSTYPE" in
    darwin*)
        # Set up JAVA_HOME
        export JAVA_HOME=$(/usr/libexec/java_home -v 11)
esac

# SSH SETTINGS.

export SSH_ENV="$HOME/.ssh/env"

# Default Editor
# export EDITOR="emacs -nw"
