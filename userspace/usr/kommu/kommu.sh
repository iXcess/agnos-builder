#/usr/bin/env bash

source /etc/profile

RESET="/usr/kommu/reset"
CONTINUE="/data/continue.sh"
INSTALLER="/tmp/installer.sh"
RESET_TRIGGER="/data/__system_reset__"

echo "waiting for weston"
for i in {1..200}; do
  if systemctl is-active --quiet weston-ready; then
    break
  fi
  sleep 0.1
done

if systemctl is-active --quiet weston-ready; then
  echo "weston ready after ${SECONDS}s"
else
  echo "timed out waiting for weston, ${SECONDS}s"
fi

sudo chown kommu: /data
sudo chown kommu: /data/media

handle_setup_keys () {
  # install default SSH key while still in setup
  if [[ ! -e /data/params/d/GithubSshKeys && ! -e /data/continue.sh ]]; then
    if [ ! -e /data/params/d ]; then
      mkdir -p /data/params/d_tmp
      ln -s /data/params/d_tmp /data/params/d
    fi

    echo -n 1 > /data/params/d/SshEnabled
    cp /usr/kommu/setup_keys /data/params/d/GithubSshKeys
  fi
}

# setup /data/tmp
rm -rf /data/tmp
mkdir -p /data/tmp

# symlink vscode to userdata
mkdir -p /data/tmp/vscode-server
ln -s /data/tmp/vscode-server ~/.vscode-server
ln -s /data/tmp/vscode-server ~/.cursor-server

while true; do
  handle_setup_keys

  if [ -f $CONTINUE ]; then
    exec "$CONTINUE"
  fi

  # cleanup installers from previous runs
  rm -f $INSTALLER
  pkill -f $INSTALLER

  # run setup and wait for installer
  cp /usr/kommu/installer.sh /tmp/installer.sh
  echo "waiting for installer"
  while [ ! -f $INSTALLER ]; do
    sleep 1
  done

  # run installer and wait for continue.sh
  chmod +x $INSTALLER
  $INSTALLER &
  echo "running installer"
  while [ ! -f $CONTINUE ] && ps -p $! > /dev/null; do
    sleep 1
  done
done
