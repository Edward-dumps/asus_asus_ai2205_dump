#!/vendor/bin/sh

BATTERY=`cat /sys/class/asuslib/asus_get_fw_version`
setprop vendor.battery.version.driver "$BATTERY"

BATTID=`cat /sys/class/asuslib/asus_get_BattID`
if [ "115000" -ge "$BATTID" ] && [ "$BATTID" -ge "85000" ]; then
	BATTID="cos_100K"
elif [ "11500" -ge "$BATTID" ] && [ "$BATTID" -ge "8500" ]; then
	BATTID="cos_10K"
fi
setprop vendor.battery.id.driver "$BATTID"