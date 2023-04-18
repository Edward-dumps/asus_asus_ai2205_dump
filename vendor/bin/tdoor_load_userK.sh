#!/vendor/bin/sh

if [ -n "$1" ]; then
	export LOAD_TYPE=$1
	echo "[MSP430][Load_UserK] LOAD_TYPE $LOAD_TYPE" > /dev/kmsg
else
	echo "[MSP430][Load_UserK] miss parameter1" > /dev/kmsg
	exit
fi

MCU_CLOSE_TEMP_K="/mnt/vendor/persist/mcu_close_cal_tmp"
MCU_OPEN_TEMP_K="/mnt/vendor/persist/mcu_open_cal_tmp"

MCU_CLOSE_USER_K="/mnt/vendor/persist/mcu_close_cal"
MCU_OPEN_USER_K="/mnt/vendor/persist/mcu_open_cal"

if [ "$LOAD_TYPE" == "2" ]; then
	if [ -e $MCU_CLOSE_TEMP_K ] ; then
		echo "[MSP430][Load_UserK] Load $MCU_CLOSE_TEMP_K" > /dev/kmsg
		mcu_close_cal=`cat $MCU_CLOSE_TEMP_K`
	else
		echo "[MSP430][Load_UserK] Cab't load $MCU_CLOSE_TEMP_K" > /dev/kmsg
		exit
	fi

	if [ -e $MCU_OPEN_TEMP_K ] ; then
		echo "[MSP430][Load_UserK] Load $MCU_OPEN_TEMP_K" > /dev/kmsg
		mcu_open_cal=`cat $MCU_OPEN_TEMP_K`
	else
		echo "[MSP430][Load_UserK] Cab't load $MCU_OPEN_TEMP_K" > /dev/kmsg
		exit
	fi

	echo "[MSP430][Load_UserK] Apply Temp Cal data, mcu_open_cal = $mcu_open_cal, mcu_close_cal = $mcu_close_cal" > /dev/kmsg
	echo "$mcu_open_cal $mcu_close_cal" > /proc/asus_motor/rog6_k

	CloseX=$(echo $mcu_close_cal | cut -d " " -f 3)
	echo "[MSP430][Load_UserK] CloseX = $CloseX" > /dev/kmsg

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

	echo "[MSP430][Load_UserK] BOPX = ${BOPX_15_8},${BOPX_7_0}, BRPX = ${BRPX_15_8},${BRPX_7_0}" > /dev/kmsg
	echo "101 ${BOPX_15_8} ${BOPX_7_0} ${BRPX_15_8} ${BRPX_7_0} 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0" > /proc/asus_motor/motor_akm
	setprop vendor.asus.thermaldoor.load_cal_data 0
	exit
elif [ "$LOAD_TYPE" == "3" ]; then
	echo "[MSP430][Load_UserK] Copy Temp K to User K" > /dev/kmsg
	if [ -e $MCU_CLOSE_TEMP_K ] && [ -e $MCU_OPEN_TEMP_K ]; then
		mv $MCU_CLOSE_TEMP_K $MCU_CLOSE_USER_K
		mv $MCU_OPEN_TEMP_K $MCU_OPEN_USER_K
	else
		echo "[MSP430][Load_UserK] Cab't load MCU_CLOSE_TEMP_K or MCU_OPEN_TEMP_K" > /dev/kmsg
	fi
	setprop vendor.asus.thermaldoor.load_cal_data 0
	exit

elif [ "$LOAD_TYPE" == "4" ]; then
	echo "[MSP430][Load_UserK] Delete Temp K" > /dev/kmsg
	rm $MCU_CLOSE_TEMP_K
	rm $MCU_OPEN_TEMP_K

	setprop vendor.asus.thermaldoor.load_cal_data 1
	exit
else
	echo "[MSP430][Load_UserK] Wrong LOAD_TYPE, $LOAD_TYPE" > /dev/kmsg
	setprop vendor.asus.thermaldoor.load_cal_data 0
	exit
fi
