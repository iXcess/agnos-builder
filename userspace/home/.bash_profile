export EDITOR='vim'
export VIMINIT='source $MYVIMRC'
export MYVIMRC="~/.vimrc"

source $HOME/.profile

if [ -d "/data/openpilot" ] && [ "$(tmux display-message -p '#{session_name}')" == "kommu" ] ; then
  cd /data/openpilot
fi
