# Using $ZDOTDIR #

## Why? ##

The reasoning is that I want to be able to clone my zsh configuration on any OS that I use ZSH with and just have it work.

## How? ##

This does require a two liner `$HOME/.zshenv` file.

``` shell
ZDOTDIR="$HOME/.zsh.d"
source $ZDOTDIR/.zshenv
```

Then clone this repo into `$HOME/.zsh.d`

