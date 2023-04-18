#!/vendor/bin/sh

export PATH=/vendor/bin
GRIP_FRAME_RATE_PATH="/proc/driver/grip_frame_rate"
GRIP_FRAME_RATE_DATA=`cat $GRIP_FRAME_RATE_PATH`
if [ "FAIL" == "$GRIP_FRAME_RATE_DATA" ]; then
	echo "FAIL due to frame data: $GRIP_FRAME_RATE_DATA"
	setprop vendor.grip.chip.status $GRIP_FRAME_RATE_DATA
else
	echo "PASS due to frame data: $GRIP_FRAME_RATE_DATA"
	setprop vendor.grip.chip.status "PASS"
fi
