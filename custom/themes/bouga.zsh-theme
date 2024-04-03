#!/bin/zsh

###
# Bouga theme for zsh
#
# - Requires oh-my-zsh to run : https://ohmyz.sh/
#
# - Probably requires a terminal with custom fonts installed
# - Check out some guides like this one (mac os based) : https://towardsdatascience.com/the-ultimate-guide-to-your-terminal-makeover-e11f9b87ac99
# - ... or i don't know, check out Wezterm, it's pretty cool : https://wezfurlong.org/wezterm/
#
# - Look for available colors by typing "spectrum_ls" in your terminal
###

###
# Note, as of 2024-04-03:
# I no longer use this theme as i switchted to Pure prompt : https://github.com/sindresorhus/pure
# That being said, this theme is still usable.
###

###
# Available themes
###

declare -A main=( \
# Status (first prompt part) color when last command succeeded/failed
[STATUS_COLOR_OK]=green \
[STATUS_COLOR_KO]=red \
# Dir prompt background and foreground
# (dir sepatator is optional, comment if not wanted)
[DIR_BACKGROUND]=blue \
[DIR_FOREGROUND]=black \
[DIR_SEPARATOR_COLOR]=yellow \
# Git prompt colors
# Clean and dirty for both background and foreground
# (foreground status dirty = git status indicators, aka "modified", "deleted", "new file" etc...)
[GIT_BACKGROUND_CLEAN]=green \
[GIT_FOREGROUND_CLEAN]=black \
[GIT_BACKGROUND_DIRTY]=yellow \
[GIT_FOREGROUND_DIRTY]=black \
[GIT_FOREGROUND_STATUS_DIRTY]=red \
# Git branch size (comment for long branch)
[GIT_SHORT_BRANCH]=1
# Node version
[NODE_VERSION_BACKGROUND]=028 \
[NODE_VERSION_FOREGROUND]=011 \
# Prompt arrow color (arrow right beside user prompt on next line)
[PROMPT_ARROW_COLOR]=green \
# Time background and foreground (right aligned prompt)
[TIME_BACKGROUND]=yellow \
[TIME_FOREGROUND]=black \
)

declare -A wack=( \
[STATUS_COLOR_OK]=015 \
[STATUS_COLOR_KO]=055 \
[DIR_BACKGROUND]=220 \
[DIR_FOREGROUND]=black \
[DIR_SEPARATOR_COLOR]=124 \
[GIT_BACKGROUND_CLEAN]=208 \
[GIT_FOREGROUND_CLEAN]=015 \
[GIT_BACKGROUND_DIRTY]=033 \
[GIT_FOREGROUND_DIRTY]=black \
[GIT_FOREGROUND_STATUS_DIRTY]=red \
[GIT_SHORT_BRANCH]=1 \
[NODE_VERSION_BACKGROUND]=013 \
[NODE_VERSION_FOREGROUND]=white \
[PROMPT_ARROW_COLOR]=green \
[TIME_BACKGROUND]=yellow \
[TIME_FOREGROUND]=black \
)

declare -A THEME

for key value in "${(@kv)main}"; do
  THEME["$key"]=$value
done

###
# Global var and function to help printing parts of prompt
###

# Separator between prompt parts (status, dir, git)
SEPARATOR='\ue0b0'
# Default background (no need to be changed)
CURRENT_BG='NONE'

STATUS_COLOR_OK=$THEME["STATUS_COLOR_OK"]
STATUS_COLOR_KO=$THEME["STATUS_COLOR_KO"]
DIR_BACKGROUND=$THEME["DIR_BACKGROUND"]
DIR_FOREGROUND=$THEME["DIR_FOREGROUND"]
DIR_SEPARATOR_COLOR=$THEME["DIR_SEPARATOR_COLOR"]
GIT_BACKGROUND_CLEAN=$THEME["GIT_BACKGROUND_CLEAN"]
GIT_FOREGROUND_CLEAN=$THEME["GIT_FOREGROUND_CLEAN"]
GIT_BACKGROUND_DIRTY=$THEME["GIT_BACKGROUND_DIRTY"]
GIT_FOREGROUND_DIRTY=$THEME["GIT_FOREGROUND_DIRTY"]
GIT_FOREGROUND_STATUS_DIRTY=$THEME["GIT_FOREGROUND_STATUS_DIRTY"]
GIT_SHORT_BRANCH=$THEME["GIT_SHORT_BRANCH"]
NODE_VERSION_FOREGROUND=$THEME["NODE_VERSION_FOREGROUND"]
NODE_VERSION_BACKGROUND=$THEME["NODE_VERSION_BACKGROUND"]
PROMPT_ARROW_COLOR=$THEME["PROMPT_ARROW_COLOR"]
TIME_BACKGROUND=$THEME["TIME_BACKGROUND"]
TIME_FOREGROUND=$THEME["TIME_FOREGROUND"]

###
# Actual theme
###

# Main segment printing function
# - Prints something with background color if needed
# - Prints a separator if background changes
prompt_segment() {
  local fg bg
  [[ -n $1 ]] && fg="%F{$1}" || fg="%f"
  [[ -n $2 ]] && bg="%K{$2}" || bg="%k"
  if [[ $CURRENT_BG != 'NONE' && $2 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEPARATOR %{$fg%}"
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  [[ -n $3 ]] && echo -n $3
  CURRENT_BG=$2
}

# Prompt end printing function
# - Prints a separator if needed
# - clears background and foreground color
prompt_end() {
  if [[ $CURRENT_BG != 'NONE' ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%} "
  CURRENT_BG=''
}

# Status prompt
# - red if last command output != 0
# - green otherwise
prompt_status() {
  prompt_segment default "%(?.$STATUS_COLOR_OK.$STATUS_COLOR_KO)" "%T"
}

# File prompt
# - colorized
# - background
# - icon
prompt_file() {
  local t separator_color
  separator_color=$DIR_FOREGROUND
  [[ -n $DIR_SEPARATOR_COLOR ]] && separator_color=$DIR_SEPARATOR_COLOR
  t=$(echo $(pwd) | sed -E "s/\/Users\/$(whoami)\/?/~\//g" | sed "s/\//%{%F{$DIR_SEPARATOR_COLOR}%}\/%{%F{$DIR_FOREGROUND}%}/g")
  prompt_segment $DIR_FOREGROUND $DIR_BACKGROUND "%{%F{$DIR_SEPARATOR_COLOR}%} %{%F{$DIR_FOREGROUND}%} $t"
}

prompt_git() {
  local dirty ref short_sha standard_branch cut_branch

  # ZSH git variables
  ZSH_THEME_GIT_PROMPT_ADDED=" ✚"
  ZSH_THEME_GIT_PROMPT_MODIFIED=" *"
  ZSH_THEME_GIT_PROMPT_DELETED=" ✖"
  ZSH_THEME_GIT_PROMPT_RENAMED=" ➜"
  ZSH_THEME_GIT_PROMPT_UNMERGED=" ═"
  ZSH_THEME_GIT_PROMPT_UNTRACKED=" ✭"
  ZSH_THEME_GIT_PROMPT_AHEAD=" !"

  ZSH_THEME_GIT_PROMPT_SHA_BEFORE="("
  ZSH_THEME_GIT_PROMPT_SHA_AFTER=")"

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
    short_sha=$(git rev-parse --short HEAD)
    if [[ -n $dirty ]]; then
      prompt_segment $GIT_FOREGROUND_DIRTY $GIT_BACKGROUND_DIRTY
    else
      prompt_segment $GIT_FOREGROUND_CLEAN $GIT_BACKGROUND_CLEAN
    fi
    standard_branch=$(echo $ref | sed -E 's/refs\/heads\// /')
    cut_branch=$(echo $standard_branch | cut -f1,2,3,4,5,6,7 -d'-')

    if [[ -n $GIT_SHORT_BRANCH ]] then
      echo -n "($short_sha) $cut_branch"
    else
      echo -n "($short_sha) $standard_branch"
    fi

    echo -n "%{%F{$GIT_FOREGROUND_STATUS_DIRTY}%}$(git_prompt_status)"
  fi
}

prompt_node () {
  local node_version
  local npm_version
  npm_version=$(npm -v)
  node_version=$(node -v)
  prompt_segment $NODE_VERSION_FOREGROUND $NODE_VERSION_BACKGROUND " $node_version 📦 $npm_version"
}

# Main function, calling all parts of prompt
build_prompt() {
  prompt_status
  prompt_file
  prompt_git
#  prompt_node
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt)'
PROMPT+="
%{%F{$PROMPT_ARROW_COLOR}%}➜%{%f%} "

