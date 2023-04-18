#!/system/bin/sh

echo "Start clear system csc log"
LOG_LOGCAT_FOLDER='/data/logcat_log'

startLogProp=`getprop persist.vendor.asus.startlog`

if [ "${startLogProp}" = "1" ]; then
	setprop persist.vendor.asus.startlog 0
	sleep 3
fi

rm -rf $LOG_LOGCAT_FOLDER/*

if [ "${startLogProp}" = "1" ]; then
	setprop persist.vendor.asus.startlog 1
	sleep 3
fi

setprop vendor.asus.clearlog 0
