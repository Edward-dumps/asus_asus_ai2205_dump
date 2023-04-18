#!/vendor/bin/sh
#waiting sepolicy
setprop vendor.vib.cali.state running...

rm -rf /mnt/vendor/persist/aw_cali.bin
rm -rf /mnt/vendor/persist/aw_rtp_cali.bin

cali_r=`cat /sys/class/leds/aw_vibrator/cali`
sleep 1

#echo 1:$cali_r
r=`echo $cali_r |grep fail`
#echo 2:$r
len=`expr ${#r}`
#echo len:$len

if [ $len -ne 0 ] ; then
  echo $cali_r
  setprop vendor.vib.cali.state Fail
  exit
fi

echo -n $cali_r > /mnt/vendor/persist/aw_cali.bin

osc_cali_r=`cat /sys/class/leds/aw_vibrator/osc_cali`

echo -n $osc_cali_r > /mnt/vendor/persist/aw_rtp_cali.bin 

echo PASS
setprop vendor.vib.cali.state PASS
