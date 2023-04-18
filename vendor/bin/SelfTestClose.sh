#!/vendor/bin/sh

echo 0 120 0 0 0 0 0 250 0 0 0 0 0 0 0 0 0 0 0 254 > /proc/asus_motor/motor_param
sleep 1
echo 102 > /proc/asus_motor/motor_akm
sleep 0.1

# save open z/y/x
OPEN_Z=`cat /proc/asus_motor/motor_akm_raw_z`
OPEN_Y=`cat /proc/asus_motor/motor_akm_raw_y`
OPEN_X=`cat /proc/asus_motor/motor_akm_raw_x`

echo 1 120 30 120 0 0 0 113 70 42 0 0 0 0 8 0 0 0 0 254 > /proc/asus_motor/motor_param
sleep 1
echo 102 > /proc/asus_motor/motor_akm
sleep 0.1
CLOSE_Z=`cat /proc/asus_motor/motor_akm_raw_z`
CLOSE_Y=`cat /proc/asus_motor/motor_akm_raw_y`
CLOSE_X=`cat /proc/asus_motor/motor_akm_raw_x`

#
# [OPEN_Z > -3500 && CLOSE_Z < -3500] || [OPEN_X - CLOSE_X >= 2200] : PASS
#
DELTA_X=`expr $OPEN_X - $CLOSE_X`

if [ "$OPEN_Z" -ge "-3500" -a "$CLOSE_Z" -le "-3500" ] || [ "$DELTA_X" -ge "2200" ]; then
	echo "[MSP430] User K Close pass, OPEN_Z $OPEN_Z, CLOSE_Z $CLOSE_Z, DELTA_X $DELTA_X" > /dev/kmsg
else
	echo "[MSP430] User K Close fail, OPEN_Z $OPEN_Z, CLOSE_Z $CLOSE_Z, DELTA_X $DELTA_X" > /dev/kmsg
	setprop vendor.asus.thermaldoor.close_k 2
	echo "100,-1" > /mnt/vendor/persist/user_cal_result
	setprop vendor.asus.thermaldoor.k_progess "100,-1"
	exit
fi

#Vaild Pass, Write to factory.
echo "${OPEN_Z} ${OPEN_Y} ${OPEN_X}" > /mnt/vendor/persist/mcu_open_cal_tmp
chmod 666 /mnt/vendor/persist/mcu_open_cal_tmp
echo "${OPEN_Z} ${OPEN_Y} ${OPEN_X} 65536 65536 65536" > /proc/asus_motor/rog6_k

setprop vendor.asus.thermaldoor.close_k 0
echo "100,0" > /mnt/vendor/persist/user_cal_result
setprop vendor.asus.thermaldoor.k_progess "100,0"
