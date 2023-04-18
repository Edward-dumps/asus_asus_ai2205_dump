#!/vendor/bin/sh

if [ "$1" == "0" ];then
	echo 0 > /proc/globalHbm
else
	echo 1 > /proc/globalHbm
fi

current_hbm=`cat /proc/globalHbm`
if [ "$current_hbm" == "$1" ];then
	echo "PASS"
else
	echo "FAIL"
fi
