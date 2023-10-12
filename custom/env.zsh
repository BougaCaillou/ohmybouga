# PATH
PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin";

# Add `~/bin` to the `$PATH`
PATH="$HOME/bin:$PATH";

# Add python 3.8 bin folder to path
PATH="$HOME/Library/Python/3.8/bin:$PATH";

# ADD Ruby
PATH="/usr/local/opt/ruby/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"

# Preffered editor for broot
export EDITOR=nvim

# NVM
export NVM_DIR="$HOME/.nvm"

# This loads nvm
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"
# This loads nvm bash completion
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"

# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Widget demo page
export PUBLIC_SYNAPSE_WIDGET_URL=http://localhost:8080

# User management env var
export APP_STORE_ENVIRONMENT="sandbox"

# Android env var
export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT=$ANDROID_HOME
PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/build-tools:$ANDROID_HOME/platform-tools:$PATH";

# Java home
export JAVA_ROOT=/Library/Java/JavaVirtualMachines
export JAVA_HOME="$JAVA_ROOT/jdk-8.jdk/Contents/Home"
PATH="$JAVA_HOME:$PATH"

# libpq (postgre dump  and restore utilities)
PATH="/usr/local/opt/libpq/bin:$PATH"

# Postgresql env vars
export PGPWDL='mysecretpassword'

# Rust utilities (cargo etc)
PATH="$HOME/.cargo/bin:$PATH"

# Custom tools (one ofs, i.e. Mermerd...)
PATH="$HOME/custom-tools:$PATH"

# kubernetes-tooling bin
PATH="$HOME/Documents/kubernetes-tooling/bin:$PATH"

# Local bin directory
PATH="$HOME/.local/bin:$PATH"

export PATH;
