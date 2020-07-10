echo "Loading internal ${ZDOTDIR}/.zshrc..."
source ${ZDOTDIR}/.zshenv

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="clean"
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
plugins=(
    git
    colored-man-pages
    colorize
    pip
    python
    brew
    osx
    docker
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
alias k=kubectl
alias -g Y="-o yaml"
alias -g YL="-o yaml | less -R"
alias -g PL="| less -R"
alias -g YPL="-o yaml | yq r - -PC | less"
alias emacsnw='emacs -nw'
alias watch='watch '
eval "$(hub alias -s)"
alias kname=kubectl_namespace_cluster
alias kctx=kubectx
alias kns=kubens

### FUNCTIONS ###

# Function to clear all metals and bloop remnants
function clear_metals () {
    if [[ -a "build.sbt" ]]; then
        find . -name "*metals*" | xargs -I {} rm -rf {} \;
        find . -name "*bloop*" | xargs -I {} rm -rf {} \;
    else
        echo "Not at the root of an SBT project"
        return 1
    fi
}

# Get your current kubernetes everything
function kubectl_namespace_cluster () {
    namespace=`kubectl config view --minify --output 'jsonpath={..namespace}'`
    cluster=`kubectl config view --minify --output 'jsonpath={.clusters[0].name}'`
    context=`kubectl config view --minify --output 'jsonpath={.contexts[0].name}'`
    echo "Cluster: $cluster"
    echo "Context: $context"
    echo "Namespace: $namespace"
}

case "$OSTYPE" in
    darwin*)
        alias ll='exa -la'
        alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs'
        # Function to call IntelliJ Idea from command line at directory and passing all possible parameters
        function idea {
            open -a /Applications/IntelliJ\ Idea\ CE.app/Contents/MacOS/idea $@
        }
esac

# DGD Function for git page
function ghp () {
    repo="https://"`git config --get remote.origin.url | sed 's|git@||' | sed 's|\.git||' | sed 's|:|/|'`
    case "$OSTYPE" in
        darwin*)
            open "$repo/pulls"
            ;;
        linux*)
            xdg-open "$repo/pulls"
            ;;
    esac
}

function fpathClean() {
    # Cleans fpath of duplicated portions
    NEWPATH=$(echo $1 | sed -e 's/ /\'$'\n/g' | perl -ne 'print unless $seen{$_}++' | paste -s -d' ' -)
    echo $NEWPATH
}

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# AWS Functions
function aws_assume_role() {
    export AWS_PROFILE="$1"
    if [ -z "$2" ]; then
        KOPS_STATE_STORE="$KOPS_STATE_STORE"
    else
        echo "Storing previous KOPS_STATE_STORE: $KOPS_STATE_STORE"
        export PREV_KOPS_STATE_STORE="$KOPS_STATE_STORE"
        KOPS_STATE_STORE="$2"
    fi
    echo "Assuming into role..."
    ROLE_ARN=$(aws configure get role_arn --profile $AWS_PROFILE)
    ROLE_JSON=$(aws sts assume-role --role-arn $ROLE_ARN --role-session-name $(whoami)-$AWS_PROFILE)
    export AWS_ACCESS_KEY_ID="$(echo $ROLE_JSON | jq -r ".Credentials.AccessKeyId")"
    export AWS_SECRET_ACCESS_KEY="$(echo $ROLE_JSON | jq -r ".Credentials.SecretAccessKey")"
    export AWS_SESSION_TOKEN="$(echo $ROLE_JSON | jq -r ".Credentials.SessionToken")"
    export AWS_SDK_LOAD_CONFIG='true'
    export AWS_REGION="us-east-1"
    export KOPS_STATE_STORE="$KOPS_STATE_STORE"
}

function aws_assume_role_long() {
    export AWS_PROFILE="cibo-no-mfa"
    local MFA_CREDENTIALS_FILE="$HOME/.aws/mfa/serial"
    local MFA_SERIAL_NUMBER="$(jq -cr '.MFADevices[0].SerialNumber' $MFA_CREDENTIALS_FILE)"
    local AWS_PROD_ROLE="$1"
    echo "Allowing maximum time of 43200 seconds aka 12 hours"
    local DURATION_SECONDS=43200
    ROLE_ARN=$(aws configure get role_arn --profile $AWS_PROD_ROLE)
    printf "MFA Code: "
    read TOKEN_CODE
    ROLE_JSON=$(aws sts assume-role --role-arn $ROLE_ARN --role-session-name $(whoami)-$AWS_PROD_ROLE --duration-seconds $DURATION_SECONDS --serial-number $MFA_SERIAL_NUMBER --token-code $TOKEN_CODE)
    export AWS_ACCESS_KEY_ID="$(echo $ROLE_JSON | jq -r ".Credentials.AccessKeyId")"
    export AWS_SECRET_ACCESS_KEY="$(echo $ROLE_JSON | jq -r ".Credentials.SecretAccessKey")"
    export AWS_SESSION_TOKEN="$(echo $ROLE_JSON | jq -r ".Credentials.SessionToken")"
    EXPIRATION_DATE=$(echo $ROLE_JSON | jq -r ".Credentials.Expiration")
    echo "Verify expiration date in UTC time is 12 hours from now"
    echo "Expiration date: $EXPIRATION_DATE"
    echo "Current date   : $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    export AWS_SDK_LOAD_CONFIG="true"
    export AWS_REGION="us-east-1"
}

function aws_check_role() {
    echo "AWS_PROFILE: $AWS_PROFILE"
    echo "AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID"
    echo "AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY"
    echo "AWS_SESSION_TOKEN: $AWS_SESSION_TOKEN"
    echo "AWS_SDK_LOAD_CONFIG: $AWS_SDK_LOAD_CONFIG"
    echo "AWS_REGION: $AWS_REGION"
    echo "KOPS_STATE_STORE: $KOPS_STATE_STORE"
}

function aws_unassume_role_long() {
    unset AWS_PROFILE
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    unset AWS_SDK_LOAD_CONFIG
    unset AWS_REGION
}

function aws_unassume_role() {
    if [ -z "$PREV_KOPS_STATE_STORE" ]; then
        echo "It already is the same, don't do anything" >&2
    else
        echo "It exists, return to normal. Original: $PREV_KOPS_STATE_STORE" >&2
        export KOPS_STATE_STORE="$PREV_KOPS_STATE_STORE"
    fi    
    unset AWS_PROFILE
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    unset AWS_SDK_LOAD_CONFIG
    unset AWS_REGION
}

function aws_assume_sdk_load() {
    AWS_PROFILE="$1"
    if [ -z "$2" ]; then
        export KOPS_STATE_STORE="$KOPS_STATE_STORE"
    else
        echo "Storing previous KOPS_STATE_STORE: $KOPS_STATE_STORE"
        export PREV_KOPS_STATE_STORE="$KOPS_STATE_STORE"
        KOPS_STATE_STORE="$2"
    fi
    export AWS_PROFILE="$AWS_PROFILE"
    export AWS_SDK_LOAD_CONFIG='true'
    export AWS_REGION="us-east-1"
    export KOPS_STATE_STORE="$KOPS_STATE_STORE"
}

function aws_check_sdk() {
    echo "AWS_PROFILE: $AWS_PROFILE"
    echo "AWS_SDK_LOAD_CONFIG: $AWS_SDK_LOAD_CONFIG"
    echo "AWS_REGION: $AWS_REGION"
    echo "KOPS_STATE_STORE: $KOPS_STATE_STORE"
}

function aws_unassume_sdk_load() {
    if [ -z "$PREV_KOPS_STATE_STORE" ]; then
        echo "It already is the same, don't do anything"
    else
        export KOPS_STATE_STORE="$PREV_KOPS_STATE_STORE"
    fi
    unset AWS_PROFILE
    unset AWS_SDK_LOAD_CONFIG
    unset AWS_REGION
}


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
eval "$(pyenv init -)"
# Pyenv Virtualenv
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# OSX Brew Specifics
case "$OSTYPE" in
    darwin*)
        export fpath=(/usr/local/share/zsh-completions /usr/local/share/zsh/site-functions $fpath)
        source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
        source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ;;
esac

# Add in emacs keybindings
bindkey -e

# Sourcing completions etc.
for PROFILE_SCRIPT in $( ls $HOME/.zsh_settings/*.zsh ); do
    # echo "Sourcing $PROFILE_SCRIPT"
    source $PROFILE_SCRIPT
done

TOKENS_FILE="$HOME/tokens/github_tokens.zsh"
test -e $TOKENS_FILE && source $TOKENS_FILE

# Some crazy autoloading
# autoload -U bashcompinit && bashcompinit
# autoload -U compinit && compinit
autoload -Uz compinit
compinit -z

if [[ -a "$(which vault)" ]]; then
    autoload bashcompinit && bashcompinit && complete -C '$(which vault)' vault
fi

if [[ -a "$(which terraform)" ]]; then
    autoload bashcompinit && bashcompinit && complete -C '$(which terraform)' terraform
fi

source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
PS1='$(kube_ps1)'$PS1

# Tmux screws up my nice non-duplicated path
export PATH=$(pathClean $PATH)
