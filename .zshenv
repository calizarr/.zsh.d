# .zshenv should be used for environment variables etc

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

case "$OSTYPE" in
    darwin*)
        # Coreutils overriding the MAC utils
        export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
        export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
        export PATH="/usr/local/Cellar/gnu-getopt/2.33.2/bin:$PATH"
        ;;
esac

# Path Manipulation
function pathClean() {
    # Cleans path of duplicated portions.
    NEWPATH=$(echo $1 | sed 's/:/\'$'\n/g' | perl -ne 'print unless $seen{$_}++' | paste -s -d':' -)
    echo "$NEWPATH"
}

if [ "$(file /cibo)" = "/cibo: directory" ]; then
    export PATH=/cibo/shared-scripts:$HOME/.local/bin:/usr/local/opt/swagger-codegen@2/bin:$PATH
fi

# Setting the Go path
export PATH="$PATH":$HOME/go/bin

export PATH=$(pathClean $PATH)

PATH="$HOME/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;

# Set up GOPATH
export GOPATH="$HOME/go"

# SSH SETTINGS.

SSH_ENV="$HOME/.ssh/env"
