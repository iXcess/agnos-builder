#!/bin/bash

/usr/kommu/sound/adsp-start.sh

insmod /usr/kommu/sound/snd-soc-wcd9xxx.ko
insmod /usr/kommu/sound/snd-soc-sdm845.ko

echo "waiting for sound card to come online"
while [ ! -d /proc/asound/sdm845tavilsndc ] || [ "$(cat /proc/asound/card0/state 2> /dev/null)" != "ONLINE" ] ; do
  sleep 0.01
done
echo "sound card online"

while ! /usr/kommu/sound/tinymix controls | grep -q "SEC_MI2S_RX Audio Mixer MultiMedia1"; do
  sleep 0.01
done
echo "tinymix controls ready"

/usr/kommu/sound/tinymix set "SEC_MI2S_RX Audio Mixer MultiMedia1" 1
/usr/kommu/sound/tinymix set "MultiMedia1 Mixer TERT_MI2S_TX" 1
/usr/kommu/sound/tinymix set "TERT_MI2S_TX Channels" Two

# setup the amplifier registers
/usr/local/venv/bin/python /usr/kommu/sound/amplifier.py
