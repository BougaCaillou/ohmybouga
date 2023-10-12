#!/bin/zsh

# Commands related to git

# Copies the git currrent branch in your clipboard
gccb() {
  gcurb | pbcopy
}

# Copies the project name + current git branch in your clipboard
gccpb() {
  repo="$(pwd | sed -n -E 's/.*\/(.*)$/\1/p')"
  echo "$repo $(gcurb)" | pbcopy
}

# Deletes a tag (locally and remotly)
deltag () {
  git push origin :refs/tags/$1 && git tag -d $1
}
