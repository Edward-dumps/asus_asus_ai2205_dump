#!/system/bin/sh

echo "boot_sound" > /dev/kmsg

if test -e "/asdf/boot_sound_enabled"; then
    echo "boot_sound: boot_sound_enabled exists" > /dev/kmsg
else
    echo 1 > /asdf/boot_sound_enabled
    chmod 0666 /asdf/boot_sound_enabled
fi

enabled=`cat /asdf/boot_sound_enabled`
echo "boot_sound: boot_sound_enabled = $enabled" > /dev/kmsg

boot_sound_next_disable=`cat /asdf/boot_sound_next_disable`
echo "boot_sound: boot_sound_next_disable = $boot_sound_next_disable" > /dev/kmsg
