#!/usr/bin/bash

set -e

DEFAULT_GITHUB_OWNER="iXcess"
DEFAULT_GITHUB_BRANCH="snapshot"

cd /data
rm -rf openpilot
time git clone https://github.com/${1:-$DEFAULT_GITHUB_OWNER}/openpilot.git openpilot -b ${2:-$DEFAULT_GITHUB_BRANCH} --recurse-submodules --depth 1

cd /data
echo $'#!/usr/bin/bash\n\ncd /data/openpilot\n./launch_openpilot.sh\n' > continue.sh
chmod +x continue.sh
echo "Install complete, rebooting..."
sudo reboot

