#!/vendor/bin/sh

if [ -e /mnt/vendor/persist/mcu_close_cal ] ; then
	echo "[MSP430][Load_Cal_Data] Load /mnt/vendor/persist/mcu_close_cal" > /dev/kmsg
	mcu_close_cal=`cat /mnt/vendor/persist/mcu_close_cal`
fi

if [ -e /mnt/vendor/persist/mcu_open_cal ] ; then
	echo "[MSP430][Load_Cal_Data] Load /mnt/vendor/persist/mcu_open_cal" > /dev/kmsg
	mcu_open_cal=`cat /mnt/vendor/persist/mcu_open_cal`
fi

echo "[MSP430][Load_Cal_Data] Apply Cal data, mcu_open_cal = $mcu_open_cal, mcu_close_cal = $mcu_close_cal" > /dev/kmsg
echo "$mcu_open_cal $mcu_close_cal" > /proc/asus_motor/rog6_k

if [ -e /mnt/vendor/persist/mcu_close_cal ] ; then
	CloseX=$(echo $mcu_close_cal | cut -d " " -f 3)
	echo "[MSP430][Load_Cal_Data] CloseX = $CloseX" > /dev/kmsg

	let "INIT_X_BOPX = $CloseX + 664"
	let "INIT_X_BRPX = $CloseX + 600"

	#BOPX
	if [ $INIT_X_BOPX -ge 0 ]
	then
		#X>0  initial
		let "BOPX_15_8 = $INIT_X_BOPX / 256"
		let "BOPX_7_0 = $INIT_X_BOPX % 256"
	else
		#X<0  initial
		let "INIT_X_BOPX_NEG = $INIT_X_BOPX + 65536"

		let "BOPX_15_8 = $INIT_X_BOPX_NEG / 256"
		let "BOPX_7_0 = $INIT_X_BOPX_NEG % 256"
	fi

	#BRPX
	if [ $INIT_X_BRPX -ge 0 ]
	then
		#X>0  initial
		let "BRPX_15_8 = $INIT_X_BRPX / 256"
		let "BRPX_7_0 = $INIT_X_BRPX % 256"
	else
		#X<0  initial
		let "INIT_X_BRPX_NEG = $INIT_X_BRPX + 65536"

		let "BRPX_15_8 = $INIT_X_BRPX_NEG / 256"
		let "BRPX_7_0 = $INIT_X_BRPX_NEG % 256"
	fi

	#write X-thershold to AK9973

	echo "[MSP430][Load_Cal_Data] BOPX = ${BOPX_15_8},${BOPX_7_0}, BRPX = ${BRPX_15_8},${BRPX_7_0}" > /dev/kmsg
	echo "101 ${BOPX_15_8} ${BOPX_7_0} ${BRPX_15_8} ${BRPX_7_0} 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0" > /proc/asus_motor/motor_akm
	setprop vendor.asus.thermaldoor.load_cal_data 0

	echo "[MSP430][Load_Cal_Data] Update DoorStatus" > /dev/kmsg
	sleep 0.5
	echo 1 > proc/asus_motor/motor_door_state
else
	echo "[MSP430][Load_Cal_Data] echo default value." > /dev/kmsg
	echo "101 7 32 6 224 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0" > /proc/asus_motor/motor_akm
	setprop vendor.asus.thermaldoor.load_cal_data "default"
fi
