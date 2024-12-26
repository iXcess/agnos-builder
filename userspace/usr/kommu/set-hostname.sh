#!/bin/bash
set -e

SERIAL="$(grep 'Serial' /proc/cpuinfo | sed 's/.*: //')"

echo "serial: '$SERIAL'"
sysctl kernel.hostname="kommu-$SERIAL"
