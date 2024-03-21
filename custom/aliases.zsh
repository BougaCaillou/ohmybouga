# Search for alias
function sfa () {
  # if no argument, search all aliases
  if [[ $# -eq 0 ]]; then
    compgen -a | alias | less
    return 0
  fi

  compgen -a | alias | rg "$1" | less
}

# Custom aliases (outside zsh plugin)
alias lks="links"
alias kx="kubectx"
alias wm="whatmake"
alias majd="gcd && gl && gco -"
alias chrome="open $1 -a \"Google Chrome\""
alias mtrmg="mtr mongo"
alias py="python3"
alias b="bastion"
alias k9s="k9s -n default"
alias vi="nvim"
alias v="vi ."
alias cheh="python3 -m webbrowser https://www.youtube.com/watch\?v\=9M2Ce50Hle8"
alias su="python3 -m webbrowser https://www.youtube.com/shorts/FiPDKHLdCyE"
alias hf="helmfile"
alias hfd="helmfile diff"
alias hfa="helmfile apply"
alias cl="curlie"
alias make="gmake"
alias ta="zsh $SESSIONS_PATH/ta.sh"

# conventional commits reminder
alias cc="echo \"feat: A new feature
fix: A bug fix
docs: Documentation only changes
style: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
refactor: A code change that neither fixes a bug nor adds a feature
perf: A code change that improves performance
test: Adding missing tests or correcting existing tests
chore: Changes to the build process or auxiliary tools and libraries such as documentation generation
ci: Changes to our CI configuration files and scripts
build: Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)\""

# Outputs the path variables in an line by line format
path() {
	echo $PATH | tr ':' '\n'
}

# Smart "yarn link"
yl () {
  if [ $# -eq 0 ]
  then
    yarn link
  else
    yarn link "@synapse-medicine/$1"
  fi
}

# "pgcli local", aka connect to local postgres
pgcl () {
  pgcli postgres://postgres:$PGPWDL@localhost:5432/postgres
}

# "psql local", aka execute a sql script on local postgres
psqll () {
  if [[ $# -ne 1 ]]; then
    echo "USAGE: psqll file.sql"
    return 1
  fi

  find $1 2>/dev/null
  if [[ $? -ne 0 ]]; then
    echo "Error while trying to read sql script '$1'"
    return 2
  fi

  PGPASSWORD=$PGPWDL psql -h localhost -p 5432 -U postgres postgres -f $1
}

# "pgcli test", aka connect to test postgres
pgct () {
  pgcli postgres://usermanagement:$PGPWDT@localhost:39021/usermanagement
}

# "psql test", aka execute a sql script on test postgres
psqlt () {
  if [[ $# -ne 1 ]]; then
    echo "USAGE: psqlt file.sql"
    return 1
  fi

  find $1 2>/dev/null
  if [[ $? -ne 0 ]]; then
    echo "Error while trying to read sql script '$1'"
    return 2
  fi

  PGPASSWORD=$PGPWDT psql -h localhost -p 39021 -U usermanagement usermanagement -f $1
}

# Out the curren week number
week () {
  date +%V
}

# Exa
alias ls='exa -lh --git --icons --no-user'

# TheFuck
#eval "$(thefuck --alias)"
alias fuck='fuck --yeah'

# Zoxide
eval "$(zoxide init zsh)"

# FZF
alias fzf="fzf --preview 'bat --style=numbers --color=always {}'"

# McFly
eval "$(mcfly init zsh)"

