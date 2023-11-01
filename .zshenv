# .zshenv should be used for environment variables etc
# echo "Loading internal $ZDOTDIR/.zshenv..."

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

typeset -U path
typeset -U manpath

# Add pyenv options

case "$OSTYPE" in
    darwin*)
        # Coreutils overriding the MAC utils
        path=($HOME/perl5/bin /usr/local/Cellar/gnu-getopt/2.33.2/bin /usr/local/opt/coreutils/libexec/gnubin $path)
        manpath=(/usr/local/opt/coreutils/libexec/gnuman $manpath)
        PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
        PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
        PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
        PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;
        export EDITOR="/Applications/Emacs.app/Contents/MacOS/Emacs -nw"
        ;;
    linux*)
        if [[ -e ~/.nix-profile/etc/profile.d/nix.sh ]]; then
            source ~/.nix-profile/etc/profile.d/nix.sh
            # export LOCALE_ARCHIVE=$(nix-env --installed --no-name --out-path --query glibc-locales)/lib/locale/locale-archive
            export LOCALE_ARCHIVE="/usr/lib/locale/locale-archive"
        fi
        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init --path)"
        ;;
esac

if [[ -d "$HOME/.rd/" ]]; then
    path+=$HOME/.rd/bin
fi

if [[ -d "/cibo" ]];then
    path=(/cibo/shared-scripts/local /cibo/shared-scripts/local/aws_accounts $HOME/.local/bin $path)
    export ZENITY="no"
    export OSASCRIPT="no"
fi

# Set up GOPATH
if [[ -d "$HOME/.goenv/" ]]; then
    export GOENV_ROOT="$HOME/.goenv"
    path=($GOENV_ROOT/bin $path)
else
    export GOROOT="$HOME/go"
    export GOPATH="$HOME/go_workspace"
fi

# Always add $HOME/.local/bin
path+=$HOME/.local/bin
# Setting the Go path
path+=$HOME/$GOROOT/bin
path+=$HOME/$GOPATH/bin
# Setting the krew for kubectl PATH
path+=${HOME}/.krew/bin
# Adding linkerd to the PATH
path+=${HOME}/.linkerd2/bin

# export PATH=$(pathClean $PATH)

case "$OSTYPE" in
    darwin*)
        # Set up JAVA_HOME
        export JAVA_HOME=$(/usr/libexec/java_home -v 11)
esac

# Setting default FZF ops
export FZF_DEFAULT_OPTS="--border --height=50%"
export FZF_DEFAULT_COMMAND='fd -HI --type f'

# SSH SETTINGS.

export SSH_ENV="$HOME/.ssh/env"

# Default Editor

# NVM, Nodejs, NPM
export NVM_DIR="$HOME/.nvm"

# Set GPG Default Signing Key
