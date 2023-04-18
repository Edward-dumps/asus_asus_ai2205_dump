#!/vendor/bin/sh
VIB_NODE="/sys/class/leds/vibrator/asus_haptic_trig_control"
DISABLE_VIB_PROP=`getprop vendor.grip.disable.vib`

check_vib()
{
	echo 1 $1 > $VIB_NODE
	echo 2 $1 > $VIB_NODE
	VIB_STATUS=`cat $GRIP_VIB_NODE`
	setprop vendor.grip.vib.setting "$VIB_STATUS"
}

if [ "$DISABLE_VIB_PROP" == "1" ]; then
	check_vib 0
	setprop vendor.grip.vib_notify 1
else
	check_vib 1
	setprop vendor.grip.vib_notify 0
fi
