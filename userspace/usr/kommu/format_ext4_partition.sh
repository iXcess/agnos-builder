#!/bin/bash

DEVICES=("/dev/mmcblk0p6" "/dev/mmcblk0p7" "/dev/mmcblk0p8" "/dev/mmcblk0p10")

# Check if the device is ext4
is_ext4() {
    local device=$1
    local fs_type
    fs_type=$(blkid -o value -s TYPE "$device" 2>/dev/null)
    if [[ "$fs_type" == "ext4" ]]; then
        return 0
    else
        return 1
    fi
}

# Unmount the device if mounted
unmount_device() {
    local device=$1
    if mount | grep -q "$device"; then
        umount "$device"
        if [[ $? -eq 0 ]]; then
            echo "Successfully unmounted $device"
        else
            echo "Failed to unmount $device"
            exit 1
        fi
    else
        echo "$device is not mounted"
    fi
}

# Format the device to ext4
format_to_ext4() {
    local device=$1
    echo "Formatting $device as ext4..."
    mkfs.ext4 "$device"
    if [[ $? -eq 0 ]]; then
        echo "Successfully formatted $device as ext4"
    else
        echo "Failed to format $device as ext4"
        exit 1
    fi
}

# Main script logic
for DEVICE in "${DEVICES[@]}"; do
    echo "Checking if $DEVICE is ext4..."
    if is_ext4 "$DEVICE"; then
        echo "$DEVICE is already formatted as ext4."
    else
        echo "$DEVICE is not formatted as ext4. Proceeding to unmount and format..."
        unmount_device "$DEVICE"
        format_to_ext4 "$DEVICE"
    fi
done
