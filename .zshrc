echo "Loading internal ${ZDOTDIR}/.zshrc..."
source ${ZDOTDIR}/.zshenv

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="clean"
echo "Loading the themes..."
ZSH_THEME="agnoster"
DEFAULT_USER=$(whoami)
prompt_context(){}

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" "powerlevel9k/powerlevel9k")

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(git)

echo "loading plugins"
plugins=(
    colored-man-pages
    colorize
    pip
    python
    docker
    kubectl
    git
    history-substring-search
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias -g Y="-o yaml"
alias -g YL="-o yaml | less -R"
alias -g PL="| less -R"
alias -g YPL="-o yaml | yq ea -C | less"
alias -g YPNL="-o yaml | kubectl neat | yq ea -C | less"
alias -g EPL="2>&1 | less -R"
alias -g YCL="| yq ea - -PC | less -R"
alias ll="ls -lah"
alias k=kubectl
alias emacsnw='emacs -nw'
alias watch='watch '
eval "$(hub alias -s)"
alias kname=kubectl_namespace_cluster
alias kctx=kubectx
alias kns=kubens
alias ram="env ZENITY=/dev/null refresh-aws-mfa"

# Add Functions from another file to fpath
# Figure out how to use $fpath for this
typeset -U fpath
source $ZDOTDIR/personal_funcs/_personal

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

# Pyenv
eval "$(pyenv init -)";
eval "$(pyenv virtualenv-init -)"

# Goenv
if [[ -d "$HOME/.goenv/" ]]; then
    eval "$(goenv init -)"
    path=($GOROOT $path)
    path+=($GOPATH/bin)
fi

# Brew specific sourcing
case "$OSTYPE" in
    # OSX Brew Specifics
    darwin*)
        plugins+=("macos" "brew")
        # export fpath=(/usr/local/share/zsh-completions /usr/local/share/zsh/site-functions $fpath)
        # source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        # source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
        # source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

        ;;
    # Linux Brew Specifics
    linux*)
        if type brew &>/dev/null; then
            fpath=($(brew --prefix)/share/zsh-completions $fpath)
            source $(brew --prefix)/opt/kube-ps1/share/kube-ps1.sh
            source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
            source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh
            source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
            autoload -Uz compinit
            compinit
        elif type nix-env &>/dev/null; then
            NIX_SHARE="$HOME/.nix-profile/share"
            fpath=("${NIX_SHARE}/zsh/site-functions/" $fpath)
            source "${NIX_SHARE}/zsh-autosuggestions/zsh-autosuggestions.zsh"
            source "${NIX_SHARE}/zsh-history-substring-search/zsh-history-substring-search.zsh"
            source "${NIX_SHARE}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        else
            fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
        fi
        ;;
esac

# Add in emacs keybindings
bindkey -e

# Sourcing completions etc.

ZSH_SETTINGS="$HOME/.zsh_settings"
if [ -d "$ZSH_SETTINGS" ]; then
    for PROFILE_SCRIPT in $( ls $ZSH_SETTINGS/*.zsh ); do
        # echo "Sourcing $PROFILE_SCRIPT"
        source $PROFILE_SCRIPT
    done
fi

TOKENS_FILE="$HOME/tokens/github_tokens.zsh"
test -e $TOKENS_FILE && source $TOKENS_FILE

case "$OSTYPE" in
    darwin*)
        source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
        PS1='$(kube_ps1)'$PS1
        ;;
    linux*)
        KUBEPS1="$HOME/.local/share/kube-ps1/kube-ps1.sh"
        if test -f "$KUBEPS1"; then
            source "$HOME/.local/share/kube-ps1/kube-ps1.sh"
            PS1='$(kube_ps1)'$PS1
        fi
        alias "xcopy=xclip -selection clipboard"
        alias "xpaste=xclip -o -selection clipboard"
        ;;
esac

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export EDITOR="emacs -nw"

setopt no_aliases

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

setopt aliases

if [[ -d "$HOME/.sdkman/" ]]; then
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Apparently required to disable GUI gpg
GPG_TTY=$(tty)
export GPG_TTY

# Some crazy autoloading
# autoload -U bashcompinit && bashcompinit
# autoload -U compinit && compinit
autoload -Uz compinit
compinit -z

if [[ -a "$(which pipx)" ]]; then
    eval $(register-python-argcomplete pipx)
fi

if [[ -a "$(which vault)" ]]; then
    autoload bashcompinit && bashcompinit && complete -C '$(which vault)' vault
fi

if [[ -a "$(which terraform)" ]]; then
    autoload bashcompinit && bashcompinit && complete -C '$(which terraform)' terraform
fi

if [[ -a "$(which aws)" ]]; then
    # AWS Completion
    autoload bashcompinit && bashcompinit && complete -C '$(which aws_completer)' aws
fi


if eval "gpg -k --keyid-format=long | rg 'Work key for signing' -B3" > /dev/null;then
    export GPG_DEFAULT_KEY=$(gpg -k --keyid-format=long | rg 'Work key for signing' -B3 | sed -n '2p' | xargs)
else
    export GPG_DEFAULT_KEY=$(gpg -k --keyid-format=long | rg 'Personal Key' -B3 | sed -n '2p' | xargs)
fi
