#!/vendor/bin/sh

if [ -e /batinfo/fg_soc_remap_scale ] ; then

scale=`cat /batinfo/fg_soc_remap_scale`

echo $scale > /sys/class/asuslib/fg_soc_remap_scale

echo "[BAT]fg_soc_remap_scale.bin: $scale" > /dev/kmsg

else

echo "[BAT]fg_soc_remap_scale.bin is not exist" > /dev/kmsg

fi
