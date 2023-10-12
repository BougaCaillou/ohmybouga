#!/bin/zsh

# Import other scripts/variables/aliases...
p="$(dirname "$0")"
. $p/utils.zsh 2> /dev/null
. $p/git.zsh 2> /dev/null

# Aliases to manage project (mostly make commands)
alias mc="make clean"
alias mi="make install"
alias mp="make prepare"
alias ml="make link"
alias mb="make build"
alias mbl="make build-local"
alias mbt="make build-test"
alias mr="make run"
alias mrl="make run-local"
alias mrt="make run-test"
alias mblmr="make build-local && make run"
alias mdv="make dev"
alias mw="make watch"
alias mpsh="make publish"
alias mpsht="make publish-test"
alias mtr="meteor"

cli() {
  make clean
  make install
}
clir() {
  make clean
  make install
  make run
}
clib() {
  make clean
  make install
  make build
}
clibt() {
  make clean
  make install
  make build-test
}
clp () {
  make clean
  make prepare
}
clpr () {
  make clean
  make prepare
  make run
}
clpb () {
  make clean
  make prepare
  make build
}
clpbt () {
  make clean
  make prepare
  make build-test
}

mir () {
  make install
  make run
}
mib () {
  make install
  make build
}
mibt () {
  make install
  make build-test
}
mpr () {
  make prepare
  make run
}
mpb () {
  make prepare
  make build
}
mpbt () {
  make prepare
  make build-test
}

# Kubectl get pods, greps something
greppod() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: greppod NAME"
    return 1
  fi

  kubectl get pods | grep $1
}

# Kubectl get deployments, jsonpath magic, and greps something (a docker image name)
# Useful to see exactly the running version of some project
grepimage () {
  if [[ $# -ne 1 ]]; then
    echo "Usage: grepimage NAME"
    return 1
  fi

  kubectl get deployments -o wide | awk '{ print $1" (running for "$5"): "$7 }' | grep $1
}

# Copies a chatops message to start a Synapse project build with branch and version number
# Exemple:
# "/gitlab ci run tag Synapse develop 1.22.4"
cimsg() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: cimsg VERSION"
    return 1
  fi

  # Checking if you're in a git repository
  if [[ -z $(gcurb) ]]; then
    echo "Not in a git repository"
    return 2
  fi

  # Usage of gccpb to copy project + branch in clipboard
  # (See ./git.zsh)
  gccpb

  # Copying actual chatops message using pbpaste command
  msg="/gitlab ci run tag $(pbpaste) $1"
  echo $msg | pbcopy

  echo "Copied to clipboard:"
  echo $msg
}
