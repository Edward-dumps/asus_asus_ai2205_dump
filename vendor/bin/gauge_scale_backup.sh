#!/vendor/bin/sh

scale=`cat /sys/class/asuslib/fg_soc_remap_scale`

echo -n $scale > /batinfo/fg_soc_remap_scale

setprop persist.vendor.battery.scale "$scale"

setprop vendor.battery.scale.update "0"

echo "gauge_scale_backup.sh persist.vendor.battery.scale $scale" > /dev/kmsg