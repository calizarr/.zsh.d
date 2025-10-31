# .zshenv should be used for environment variables etc
echo "Loading internal $ZDOTDIR/.zshenv..."

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

typeset -U path
typeset -U manpath

# Always add $HOME/.local/bin
LOCAL_BIN="$HOME/.local/bin"
if [[ -d "$LOCAL_BIN" ]]; then
    mkdir -p "$LOCAL_BIN"
fi
path=($HOME/.local/bin $path)

case "$OSTYPE" in
    darwin*)
        # Coreutils overriding the MAC utils
        path=(/usr/local/opt/coreutils/libexec/gnubin $path)
        manpath=(/usr/local/opt/coreutils/libexec/gnuman $manpath)
        # Removing some issues with autofill, lagginess etc.
        defaults write -g NSAutoFillHeuristicControllerEnabled -bool false
        # Same thing but for chrome until Mac fixes it
        launchctl setenv CHROME_HEADLESS 1
        # export EDITOR="/Applications/Emacs.app/Contents/MacOS/Emacs -nw"
        # emacs_symlink_path="/Applications/Emacs.app"
        # emacs_app=$(readlink -f ${emacs_symlink_path})
        # emacs_path=$(echo "${emacs_app}" | cut -d'/' -f1-6)
        # path+=${emacs_path}/bin/
        alias grep="ggrep "
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

rd_path="$HOME/.rd"

if [[ -d "${rd_path}" ]]; then
    path+=${rd_path}/bin
fi

# # Set up GOPATH
# if [[ -d "$HOME/.goenv/" ]]; then
#     export GOENV_ROOT="$HOME/.goenv"
#     path=($GOENV_ROOT/bin $path)
# else
#     export GOROOT="$HOME/go"
#     export GOPATH="$HOME/go_workspace"
# fi

# Set up cargo
cargo_path="$HOME/.cargo"
if [[ -d "${cargo_path}" ]]; then
    source "${cargo_path}/env"
fi

krew_path="$HOME/.krew"
if [[ -d "${krew_path}" ]]; then
    path+=${krew_path}/bin
fi

if [[ -d "$HOME/.linkerd2" ]]; then
    path+=${HOME}/.linkerd2/bin
fi

# export PATH=$(pathClean $PATH)

# Setting default FZF ops
export FZF_DEFAULT_OPTS="--border --height=50%"
export FZF_DEFAULT_COMMAND='fd -HI --type f'

# SSH SETTINGS.
if [[ -d "$HOME/.ssh/" ]]; then
    mkdir -p "$HOME/.ssh/"
fi
export SSH_ENV="$HOME/.ssh/env"

# Default Editor
# NVM, Nodejs, NPM
export NVM_DIR="$HOME/.nvm"

export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:-/usr/local/lib}"

if eval ls $HOME | grep -iP "github[-_]repos" > /dev/null; then
    GITHUB_REPO_DIR_NAME=$(ls $HOME | grep -iP "github[-_]repos")
    export GITHUB_REPOS="$HOME/$GITHUB_REPO_DIR_NAME"
fi
