#!/bin/zsh

###
# This is a custom conf for Pure prompt
###

# Adding pure prompt to fpath

fpath+=($HOME/.zsh/pure)

# Load pure prompt
autoload -U promptinit; promptinit

# some options
zstyle :prompt:pure:prompt:success color green
zstyle :prompt:pure:git:stash show yes

PURE_GIT_PULL=false
PURE_GIT_UNTRACKED_DIRTY=false

prompt pure

