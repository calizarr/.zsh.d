# echo "Loading internal ${ZDOTDIR}/.zshrc..."

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="clean"
# echo "Loading the themes..."
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

# echo "loading plugins"
plugins=(
    colored-man-pages
    colorize
    pip
    python
    kubectl
    kube-ps1
    # git: 210 aliases (gst, gco, ...) none of which appear in shell history, and it
    # forks `git version` on load (~120ms per shell in all). The prompt's git segment
    # comes from oh-my-zsh's lib/git.zsh, not this plugin.
    # git
    history-substring-search
    zsh-autosuggestions
    # zsh-completions
    zsh-syntax-highlighting
)
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

USER_SITEFUNCTIONS="$HOME/.local/share/zsh/site-functions/"
fpath=( $USER_SITEFUNCTIONS $fpath )

# Completions living in this repo, so they are version-controlled rather than
# stranded in ~/.local/share. Must be on fpath BEFORE compinit (see bottom of this
# file): compinit scans fpath for `_*` files whose first line is `#compdef <cmd>`
# and autoloads them lazily on first Tab.
fpath=( "$ZDOTDIR/site-functions" $fpath )

# Personal function collections. These are SOURCED, not autoloaded, on purpose:
# fpath/autoload is a one-function-per-file contract -- the filename must equal the
# function name and the file must hold only the body. These files are topical
# groups (a dozen-odd functions each), so autoloading `_kubernetes` would define a
# function called `_kubernetes` that you would have to call before k_watch_pods et
# al existed. Sourcing is the right tool for grouped helpers.
for f in $(find "$ZDOTDIR/personal_funcs" -type f -name "_*"); do
    # echo "$f"
    source "$f"
done
# source "$ZDOTDIR/personal_funcs/_personal"

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    # Agent still alive? `kill -0` only asks whether the PID exists (a builtin, no
    # fork); the live socket check guards against the PID having been reused by an
    # unrelated process. Replaces `ps -ef | grep`, which cost ~70ms per shell.
    kill -0 "$SSH_AGENT_PID" 2>/dev/null && [[ -S "$SSH_AUTH_SOCK" ]] || {
        start_agent;
    }
else
    start_agent;
fi

# Pyenv
# --no-rehash: the rehash `pyenv init` runs by default cost ~440ms per shell. It is
# only needed after installing a Python or a package with console scripts -- run
# `pyenv rehash` by hand then.
eval "$(pyenv init - --no-rehash)";
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
        # Homebrew's prefix without forking `brew --prefix` (~25ms each): it is two levels
        # up from the brew on PATH (/opt/homebrew/bin/brew -> /opt/homebrew; /usr/local on
        # Intel). Exported before oh-my-zsh loads, so the brew plugin skips its own fork.
        (( $+commands[brew] )) && export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-${commands[brew]:h:h}}"
        # export fpath=(/usr/local/share/zsh-completions /usr/local/share/zsh/site-functions $fpath)
        fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
        fpath+="$HOMEBREW_PREFIX/share/zsh/site-functions"
        # source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
        alias grep="ggrep "
        export CFLAGS="-I/opt/homebrew/include $CFLAGS"
        export LDFLAGS="-L/opt/homebrew/lib $LDFLAGS"
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
    linux*)
        alias "xcopy=xclip -selection clipboard"
        alias "xpaste=xclip -o -selection clipboard"
        ;;
esac


# Setting up NVM -- lazily. Sourcing nvm.sh and resolving the default version cost
# ~1.1s per shell. Instead:
#   1. put the default version's bin dir on PATH directly, so node/npm/npx work at once;
#   2. define `nvm` as a stub that loads the real nvm the first time it is called.
# The default is read from $NVM_DIR/alias/default: "24" resolves to the newest
# installed v24.*, "24.20.0" to exactly that. Anything else ("node", "lts/*") is
# resolved by nvm itself, so that case falls back to loading nvm up front.
if [[ -d "$NVM_DIR" ]]; then
    _nvm_load () {
        setopt local_options no_aliases
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" "$@"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    }
    () {
        local want
        local -a candidates
        [[ -r "$NVM_DIR/alias/default" ]] && want="$(<$NVM_DIR/alias/default)"
        want="${want#v}"
        if [[ "$want" == [0-9]* ]]; then
            candidates=( $NVM_DIR/versions/node/v${want}(N/) $NVM_DIR/versions/node/v${want}.*(N/n) )
        fi
        if (( $#candidates )); then
            path=( "${candidates[-1]}/bin" $path )
            export NVM_BIN="${candidates[-1]}/bin"
            nvm () {
                unfunction nvm
                _nvm_load --no-use
                nvm "$@"
            }
        else
            _nvm_load
        fi
    }
fi


# Apparently required to disable GUI gpg
GPG_TTY=$(tty)
export GPG_TTY

# Resolve symlinks on cd, so $PWD (and anything reading it, e.g. tools that key
# off cwd like Claude Code) always sees the physical path, not the symlinked one
# (e.g. /mavenagi -> /Users/clizarraga/code).
setopt CHASE_LINKS

# Some crazy autoloading
# autoload -U bashcompinit && bashcompinit
# autoload -U compinit && compinit





HELM_SF="$USER_SITEFUNCTIONS/_helm"
if [[ -a "$(which helm)" ]] && [ ! -f "$HELM_SF" ]; then
    helm completion zsh > "$HELM_SF"
fi

KUSTOMIZE_SF="$USER_SITEFUNCTIONS/_kustomize"
if [[ -a "$(which kustomize)" ]] && [ ! -f "$KUSTOMIZE_SF" ]; then
    kustomize completion zsh > "$KUSTOMIZE_SF"
fi

ARGOCD_SF="$USER_SITEFUNCTIONS/_argocd"
if [[ -a "$(which argocd)" ]] && [ ! -f "$ARGOCD_SF" ]; then
    argocd completion zsh > "$ARGOCD_SF"
fi

if [[ -a "$(which microk8s.kubectl)" ]]; then
    MK8S_SF="$USER_SITEFUNCTIONS/_microk8s.kubectl"
    microk8s.kubectl completion zsh | sed 's/kubectl/microk8s.kubectl/g' > "$MK8S_SF"
    alias mk="microk8s.kubectl "
    MKH_SF="$USER_SITEFUNCTIONS/_microk8s.helm"
    microk8s.helm completion zsh | sed 's/helm/microk8s.helm/g' > "$MKH_SF"
    alias mh="microk8s.helm "
fi

# 1Password CLI completion, cached. `op completion zsh` cost ~80ms per shell, so it is
# written to site-functions once and compinit autoloads it like helm/argocd above.
# The cache is keyed on the RESOLVED binary path: the Homebrew cask keeps one dir per
# version (.../Caskroom/1password-cli/<version>/op), so an `op` upgrade changes the
# path and the next shell regenerates. (The binary's mtime is the vendor's build date,
# not the install date, so a `-nt` check would miss upgrades.) `:A` and `$(<file)` are
# zsh builtins -- the check itself forks nothing.
if (( $+commands[op] )); then
    OP_SF="$USER_SITEFUNCTIONS/_op"
    OP_STAMP="$USER_SITEFUNCTIONS/.op-completion-source"
    OP_BIN="${commands[op]:A}"
    if [[ ! -s "$OP_SF" || ! -r "$OP_STAMP" || "$(<$OP_STAMP)" != "$OP_BIN" ]]; then
        op completion zsh > "$OP_SF" && print -r -- "$OP_BIN" > "$OP_STAMP"
    fi
    unset OP_BIN
fi


# bloop's own snippet ran a second `compinit` here; the one at the bottom of this file
# already picks up anything on fpath, so only the fpath entry is needed. Its installer
# puts completions in ~/.bloop/zsh (a Coursier install does not, so this is often a
# no-op). Testing the directory skips the `which` fork on every shell start.
[[ -d "$HOME/.bloop/zsh" ]] && fpath=("$HOME/.bloop/zsh" $fpath)

if eval ls $HOME | grep -iP "github[-_]repos" > /dev/null; then
    GITHUB_REPO_DIR_NAME=$(ls $HOME | grep -iP "github[-_]repos")
    export GITHUB_REPOS="$HOME/$GITHUB_REPO_DIR_NAME"
fi

if eval "gpg -k --keyid-format=long | rg 'Work key for signing' -B3" > /dev/null;then
    export GPG_DEFAULT_KEY=$(gpg -k --keyid-format=long | rg 'Work key for signing' -B3 | sed -n '2p' | xargs)
else
    export GPG_DEFAULT_KEY=$(gpg -k --keyid-format=long | rg 'Personal Key' -B3 | sed -n '2p' | xargs)
fi

# Presumably needs ALMOST everything
if [[ "$(sysctl -n machdep.cpu.brand_string)" == "Apple M4 Max" ]]; then
    export ADD_USE_SVE_FLAG=true
    export SERVERS_VAULT_ID="k7hgvv45o7ej2px5bqnd3kthq4"
    # echo "Retrieving NPM token"
fi


# oh-my-zsh runs the one compinit for this shell (oh-my-zsh.sh, with its own dump file),
# so there is no compinit here. Everything above only adds to fpath.
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh

# ---------------------------------------------------------------------------
# Completions that need compinit/bashcompinit to have run already.
#
# These used to sit above and only worked because sdkman-init.sh happened to run its
# own compinit + bashcompinit first -- three compinit calls per shell in all (sdkman,
# an explicit one here, and oh-my-zsh's). Placed after oh-my-zsh, `compdef` already
# exists, so sdkman skips its compinit and only loads the `sdk` completion.
# ---------------------------------------------------------------------------
autoload -U bashcompinit && bashcompinit

# Setting up SDKMAN
if [[ -d "$HOME/.sdkman/" ]]; then
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

if [[ -a "$(which pipx)" ]]; then
    eval $(register-python-argcomplete pipx)
fi

if [[ -a "$(which vault)" ]]; then
    # autoload bashcompinit && bashcompinit && complete -C '$(which vault)' vault
    complete -C '$(which vault)' vault
fi

if [[ -a "$(which terraform)" ]]; then
    # autoload bashcompinit && bashcompinit && complete -C '$(which terraform)' terraform
    complete -C '$(which terraform)' terraform
fi

if [[ -a "$(which aws)" ]]; then
    # AWS Completion
    # autoload bashcompinit && bashcompinit && complete -C '$(which aws_completer)' aws
    complete -C '$(which aws_completer)' aws
fi

if [[ -a "$(which unsloth)" ]]; then
    #compdef unsloth

    _unsloth_completion() {
        eval $(env _TYPER_COMPLETE_ARGS="${words[1,$CURRENT]}" _UNSLOTH_COMPLETE=complete_zsh unsloth)
    }

    compdef _unsloth_completion unsloth
fi

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

PROMPT='$(kube_ps1)'$PROMPT

