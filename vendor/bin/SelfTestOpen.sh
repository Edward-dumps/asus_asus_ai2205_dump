#!/vendor/bin/sh

echo "0,0" > /mnt/vendor/persist/user_cal_result
setprop vendor.asus.thermaldoor.k_progess "0,0"

echo 1 120 0 0 0 0 0 250 0 0 0 0 0 0 0 0 0 0 0 254 > /proc/asus_motor/motor_param
sleep 1
echo 102 > /proc/asus_motor/motor_akm
sleep 0.1

# save close z/y/x
CLOSE_Z=`cat /proc/asus_motor/motor_akm_raw_z`
CLOSE_Y=`cat /proc/asus_motor/motor_akm_raw_y`
CLOSE_X=`cat /proc/asus_motor/motor_akm_raw_x`

echo 0 120 30 120 0 0 0 113 70 42 0 0 0 0 8 0 0 0 0 254 > /proc/asus_motor/motor_param
sleep 1
echo 102 > /proc/asus_motor/motor_akm
sleep 0.1
OPEN_Z=`cat /proc/asus_motor/motor_akm_raw_z`
OPEN_Y=`cat /proc/asus_motor/motor_akm_raw_y`
OPEN_X=`cat /proc/asus_motor/motor_akm_raw_x`

#
# [OPEN_Z > -3500 && CLOSE_Z < -3500] || [OPEN_X - CLOSE_X >= 2200] : PASS
#
DELTA_X=`expr $OPEN_X - $CLOSE_X`

if [ "$OPEN_Z" -ge "-3500" -a "$CLOSE_Z" -le "-3500" ] || [ "$DELTA_X" -ge "2200" ]; then
	echo "[MSP430] User K Open pass, OPEN_Z $OPEN_Z, CLOSE_Z $CLOSE_Z, DELTA_X $DELTA_X" > /dev/kmsg
else
	echo "[MSP430] User K Open fail, OPEN_Z $OPEN_Z, CLOSE_Z $CLOSE_Z, DELTA_X $DELTA_X" > /dev/kmsg
	setprop vendor.asus.thermaldoor.open_k 2
	echo "50,-1" > /mnt/vendor/persist/user_cal_result
	setprop vendor.asus.thermaldoor.k_progess "50,-1"
	exit
fi

#Vaild Pass, Write to factory.
echo "${CLOSE_Z} ${CLOSE_Y} ${CLOSE_X}" > /mnt/vendor/persist/mcu_close_cal_tmp
chmod 666 /mnt/vendor/persist/mcu_close_cal_tmp
echo "65536 65536 65536 ${CLOSE_Z} ${CLOSE_Y} ${CLOSE_X}" > /proc/asus_motor/rog6_k

setprop vendor.asus.thermaldoor.open_k 0
echo "50,0" > /mnt/vendor/persist/user_cal_result
setprop vendor.asus.thermaldoor.k_progess "50,0"
