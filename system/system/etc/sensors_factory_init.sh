#!/vendor/bin/sh

PROXM_SPEC_FILE="/data/data/proximity_spec"
LIGHT_SPEC_FILE="/data/data/lightsensor_spec"

PROXM_INF_FILE="/vendor/factory/psensor_inf.nv"
PROXM_HI_FILE="/vendor/factory/psensor_hi.nv"
PROXM_LOW_FILE="/vendor/factory/psensor_low.nv"
PROXM_1CM_FILE="/vendor/factory/psensor_1cm.nv"
PROXM_2CM_FILE="/vendor/factory/psensor_2cm.nv"
PROXM_3CM_FILE="/vendor/factory/psensor_3cm.nv"
PROXM_4CM_FILE="/vendor/factory/psensor_4cm.nv"
PROXM_5CM_FILE="/vendor/factory/psensor_5cm.nv"
LIGHT_FILE="/vendor/factory/lsensor.nv"
LIGHT_100_FILE="/vendor/factory/lsensor_100ms.nv"
LIGHT_50_FILE="/vendor/factory/lsensor_50ms.nv"
LIGHT_200_FILE="/vendor/factory/lsensor_200ms.nv"
LIGHT_400_FILE="/vendor/factory/lsensor_400ms.nv"
GSENSOR_X_FILE="/vendor/factory/gsensor_x.nv"
GSENSOR_Y_FILE="/vendor/factory/gsensor_y.nv"
GSENSOR_Z_FILE="/vendor/factory/gsensor_z.nv"
GYROSENSOR_X_FILE="/vendor/factory/gyrosensor_x.nv"
GYROSENSOR_Y_FILE="/vendor/factory/gyrosensor_y.nv"
GYROSENSOR_Z_FILE="/vendor/factory/gyrosensor_z.nv"

sensor_chmod()
{
	if [ -f $1 ];
	then
		echo "File $FILE exists"
		chmod 660 $1
		chown system:shell $1
	else
		echo "File $FILE does not exists"
		echo 0 > $1
		chmod 660 $1
		chown system:shell $1
	fi
}

sensor_chmod $PROXM_SPEC_FILE
sensor_chmod $LIGHT_SPEC_FILE

sensor_chmod $PROXM_INF_FILE
sensor_chmod $PROXM_HI_FILE
sensor_chmod $PROXM_LOW_FILE
sensor_chmod $PROXM_1CM_FILE
sensor_chmod $PROXM_2CM_FILE
sensor_chmod $PROXM_3CM_FILE
sensor_chmod $PROXM_4CM_FILE
sensor_chmod $PROXM_5CM_FILE
sensor_chmod $LIGHT_FILE
sensor_chmod $LIGHT_100_FILE
sensor_chmod $LIGHT_50_FILE
sensor_chmod $LIGHT_200_FILE
sensor_chmod $LIGHT_400_FILE

sensor_chmod $GSENSOR_X_FILE
sensor_chmod $GSENSOR_Y_FILE
sensor_chmod $GSENSOR_Z_FILE

sensor_chmod $GYROSENSOR_X_FILE
sensor_chmod $GYROSENSOR_Y_FILE
sensor_chmod $GYROSENSOR_Z_FILE

file_check(){
	if [ -f /vendor/factory/$1 ]; then
		echo "$1 file is exist"
	else
		echo "copy $1 file"
		cp /vendor/etc/grip_cal/$1 /vendor/factory/
		chown shell:shell /vendor/factory/$1
		chmod 777 /vendor/factory/$1
	fi
}
file_check grip_frame_check_result.txt
file_check grip_bar0_test_result.txt
file_check grip_bar1_test_result.txt
file_check grip_fw_fail_count.txt

cp /vendor/etc/grip_cal/snt_configs.txt /vendor/factory/
cp /vendor/etc/grip_cal/refwv /vendor/factory/
cp /vendor/etc/grip_cal/snt_tchwv_configs.txt /vendor/factory/
cp /vendor/etc/grip_cal/snt_deco_configs.txt /vendor/factory/
cp /vendor/etc/grip_cal/snt_wfmcfg /vendor/factory/
cp /vendor/etc/grip_cal/conf.json /vendor/factory/
cp /vendor/etc/grip_cal/perbar_conf.json /vendor/factory/
chown shell:shell /vendor/factory/refwv
chmod 777 /vendor/factory/refwv
exit 0
