#!/vendor/bin/sh

#initail position: close
echo 1 120 0 0 0 0 0 250 0 0 0 0 0 0 0 0 0 0 0 254 > /proc/asus_motor/motor_param
sleep 0.5
echo 102 > /proc/asus_motor/motor_akm
sleep 0.1
#record initial X axis position
INIT_X=`cat /proc/asus_motor/motor_akm_raw_x`

#check no obstacle outside the door
TOTAL_STEP=320
echo 0 120 0 0 0 0 0 80 0 0 0 0 0 0 0 0 0 0 0 254 > /proc/asus_motor/motor_param
sleep 0.5
echo 102 > /proc/asus_motor/motor_akm
sleep 0.1
PRE_Z=`cat /proc/asus_motor/motor_akm_raw_z`
PRE_X=`cat /proc/asus_motor/motor_akm_raw_x`
#echo "PRE_Z=$PRE_Z PRE_X=$PRE_X"

i=1;
while [ $i -le 2 ];
do
	echo 0 120 0 0 0 0 0 20 0 0 0 0 0 0 0 0 0 0 0 254 > /proc/asus_motor/motor_param
	sleep 0.5
	echo 102 > /proc/asus_motor/motor_akm
	sleep 0.1
	Z=`cat /proc/asus_motor/motor_akm_raw_z`
	X=`cat /proc/asus_motor/motor_akm_raw_x`
	#echo "Z=$Z X=$X"
	let "DELTA_Z = $Z - $PRE_Z"
	let "DELTA_X = $X - $PRE_X"
	#echo "DELTA_Z=$DELTA_Z DELTA_X=$DELTA_X"
	let "TEST = ($DELTA_Z*$DELTA_Z) + ($DELTA_X*$DELTA_X)"
	#echo "TEST=$TEST"
	if [ $TEST -lt 40000 ]
	then
		i=$(($i + 20)) #terminate while loop
	else
		i=$(($i + 1))
		TOTAL_STEP=$((TOTAL_STEP+80))
		PRE_Z=${Z}
		PRE_X=${X}
	fi
	#echo "TOTAL_STEP=$TOTAL_STEP"
done;

# save half raw z/y/x
RAW_STR1=`cat /proc/asus_motor/motor_akm_raw_z`
RAW_STR2=`cat /proc/asus_motor/motor_akm_raw_y`
RAW_STR3=`cat /proc/asus_motor/motor_akm_raw_x`
#echo "${RAW_STR1} ${RAW_STR2} ${RAW_STR3}" > /vendor/factory/mcu_half_cal

#Set X threshold
let "INIT_X_BOPX = $INIT_X + 664"
let "INIT_X_BRPX = $INIT_X + 600"

#echo $INIT_X_BOPX
#echo $INIT_X_BRPX

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


#write Z-thershold to AK9973
echo "101 ${BOPX_15_8} ${BOPX_7_0} ${BRPX_15_8} ${BRPX_7_0} 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0" > /proc/asus_motor/motor_akm

#close to initial
echo 1 120 0 0 0 0 0 250 0 0 0 0 0 0 0 0 0 0 0 254 > /proc/asus_motor/motor_param
sleep 0.5

#segment 1, interrupt 1 time
INT_COUNT_BEGIN=`cat /proc/asus_motor/motor_int`
#move 480 steps
echo 0 120 0 0 0 0 0 120 0 0 0 0 0 0 0 0 0 0 0 254 > /proc/asus_motor/motor_param
sleep 0.5
INT_COUNT_AFTER=`cat /proc/asus_motor/motor_int`
let "INT_COUNT_VARY= $INT_COUNT_AFTER - $INT_COUNT_BEGIN"
#echo "INT_COUNT_VARY=$INT_COUNT_VARY"
#echo "INT_COUNT_AFTER=$INT_COUNT_AFTER INT_COUNT_BEGIN=$INT_COUNT_BEGIN"


#interrupt trigger 1 times
if [ $INT_COUNT_VARY -eq 1 ]
then
	#Vaild Pass, Write to factory.
#	echo "${RAW_STR1} ${RAW_STR2} ${RAW_STR3}" > /vendor/factory/mcu_half_cal
	echo "${RAW_STR1} ${RAW_STR2} ${RAW_STR3}" > /mnt/vendor/persist/mcu_half_cal
	chmod 666 /mnt/vendor/persist/mcu_half_cal
	setprop vendor.asus.thermaldoor.openhalf_k 0
else
	TOTAL_STEP=1
	setprop vendor.asus.thermaldoor.openhalf_k 2
fi

echo $TOTAL_STEP

