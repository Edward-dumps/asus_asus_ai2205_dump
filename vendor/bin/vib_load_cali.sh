#!/vendor/bin/sh

if [ -e /mnt/vendor/persist/aw_cali.bin ] ; then
cali=`cat /mnt/vendor/persist/aw_cali.bin`
echo $cali > /sys/class/leds/aw_vibrator/f0_save
##echo "[haptic] aw_cali.bin: $cali" > /dev/kmsg
else
echo "[haptic] aw_cali.bin is not exist" > /dev/kmsg
fi

if [ -e /mnt/vendor/persist/aw_rtp_cali.bin ] ; then
cali=`cat /mnt/vendor/persist/aw_rtp_cali.bin`
echo $cali > /sys/class/leds/aw_vibrator/osc_save
##echo "[haptic] aw_rtp_cali.bin: $cali" > /dev/kmsg
else
echo "[haptic] aw_rtp_cali.bin is not exist" > /dev/kmsg
fi
