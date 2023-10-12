#!/bin/zsh

# This file contains functions that are not really deployment helpers, but useful nontheless

# Prints the currently linked Synapse package
links() {
  packages=$(\ls -Gl node_modules/@synapse-medicine) 2> /dev/null

  # Handling "not found" error by using $?
  # File not found would return non 0 code
  if [[ $? -ne 0 ]]; then
    echo "Error: node_modules/@synapse-medicine not found."
    echo "Either install packages by running npm install or you are not currently in a Synapse project"
    return 1
  fi

  # Filtering strings that do not have "->" (sign of an active link)
  linked="$(echo $packages | grep "\->" | xargs)"
  if [[ "$(echo $linked | wc -c)" -eq 1 ]]; then
    echo "No packages are linked right now"
    return 0
  fi

  echo "Linked packages:"
  for i in $(\ls -G node_modules/@synapse-medicine)
  do
    if [[ $linked == *"$i"* ]]; then
      echo "- $i"
    fi
  done
}

# Helps quickly see make commands
# Takes 1 argument
# If no argument is given, it will output every command in the Makefile
# Also probably broken, due to the way Makefiles can be formatted
whatmake() {
  # No arguments means we want all command in the Makefile, we just need to output every first word of lines starting like "something:"
  if [[ ! -n $1 ]]; then
    cat Makefile | \
    grep -E -i "^([a-zA-Z_0-9\-]*):.*" | \
    cut -d ':' -f 1
    return 0
  fi

  # Checking if command exists in the current Makefile
  no=$(cat Makefile | grep "$1:" | wc -l | xargs)
  if [[ $no == "0" ]]; then
    echo "Command \"$1\" does not exist in current project's Makefile."
    return 1
  fi

  # Output variable will be echo-ed at the end
  output=""
  # Variable to enable printing the current line
  doPrint=0

  # Looping through all Makefile's lines
  cat Makefile | while read line; do
    # Encountering a line like "something:" indicates a new Make command
    # We want to stop print ...
    if [[ "$line" =~ .*"[a-zA-Z_0-9\-]*:.*".* ]]; then
      doPrint=0
    fi
    # ... UNLESS this is the command we're looking for
    if [[ "$line" =~ .*"$1:".* ]]; then
      doPrint=1
    fi

    # If doPrint = 1, this line belongs to our command ...
    if [[ $doPrint -eq 1 ]]; then
      # ... but we want to skip empty lines
      if [ ! -z "$line" ]; then
        output="$output\n$line"
      fi
    fi
  done

  # Output is our command's content
  echo "$output\n"
  return 0
}
