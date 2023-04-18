#!/system/bin/sh

#echo $0 > /dev/kmsg

restorecon -FR /asdf
restorecon -FR /data/bootup
mkdir -p /data/logcat_log
restorecon -FR /data/logcat_log
is_datalog_exist=`ls /data | grep logcat_log`
if test "$is_datalog_exist"; then
	chown system.system /data/logcat_log
	chmod 0777 /data/logcat_log
fi

startlog_flag=`getprop persist.vendor.asus.startlog`
version_type=`getprop ro.build.type`
check_factory_version=`grep -c androidboot.pre-ftm\ =\ \"1\" /proc/bootconfig`
is_sb=`grep -c SB=Y /proc/cmdline`
logcat_filenum=`getprop persist.vendor.asus.logcat.filenum`
is_clear_logcat_logs=`getprop sys.asus.logcat.clear`
MAX_ROTATION_NUM=30
Caller=`getprop sys.asus.check-data.caller`
charger_mode=`getprop ro.bootmode`

if test "$Caller" != ""; then
	setprop sys.asus.check-data.caller ""
fi

for asusevtlog in /asdf/ASUSEvtlog*
do
	size=`stat -c%s $asusevtlog`
	if [ $size -gt 20971520  ]; then
		truncate -s 10485760 $asusevtlog
	fi
done

function start_logcat_services() {
    start logcat
    start logcat-kernel
    start logcat-radio
    start logcat-events
    start logcat-net
    startlog_flag=`getprop persist.vendor.asus.startlog`
    echo "[Debug] start_logcat_services flag: $startlog_flag" > /dev/kmsg
}

function stop_logcat_services() {
    stop logcat
    stop logcat-kernel
    stop logcat-radio
    stop logcat-events
    stop logcat-net
    startlog_flag=`getprop persist.vendor.asus.startlog`
    echo "[Debug] stop_logcat_services flag: $startlog_flag" > /dev/kmsg
}

######################################################################################
# For AsusLogTool logcat log rotation number setting
######################################################################################
if [ "$is_clear_logcat_logs" == "1" ]; then
	if [ "$logcat_filenum" != "3" ] && [ "$logcat_filenum" != "10" ] && [ "$logcat_filenum" != "20" ] && [ "$logcat_filenum" != "30" ]; then
		#if logcat_filenum get failed, sleep 1s and retry
		sleep 1
		logcat_filenum=`getprop persist.asus.logcat.filenum`

		if [ "$logcat_filenum" == "" ]; then
			logcat_filenum=20
		fi
	fi

	file_counter=$MAX_ROTATION_NUM
	while [ $file_counter -gt $logcat_filenum ]; do
		if [ $file_counter -lt 10 ]; then
			two_digit_file_counter=0$file_counter;
			
			if [ -e /data/logcat_log/logcat.txt.$two_digit_file_counter ]; then
				rm -f /data/logcat_log/logcat.txt.$two_digit_file_counter
			fi
		fi

		if [ -e /data/logcat_log/logcat.txt.$file_counter ]; then
			rm -f /data/logcat_log/logcat.txt.$file_counter
		fi

		file_counter=$(($file_counter-1))
	done

	setprop sys.asus.logcat.clear "0"
fi

######################################################################################
# For original logcat service startlog
######################################################################################
if test -e /data/bootup/everbootup; then
	echo 1 > /data/bootup/everbootup
	restorecon /data/bootup/everbootup
else
	# Check debug property
	setprop persist.asus.ramdump 1
	setprop persist.asus.autosavelogmtp 0
	if test "$version_type" = "eng"; then
		setprop persist.vendor.asus.startlog 1
		setprop persist.asus.kernelmessage 7
	elif test "$version_type" = "userdebug"; then
		if test "$check_factory_version" = "1"; then
			if test "$is_sb" = "1"; then
				setprop persist.vendor.asus.kernelmessage 0
			else
				setprop persist.vendor.asus.kernelmessage 7
			fi
			setprop persist.vendor.asus.enable_navbar 1
		else
			setprop persist.vendor.asus.kernelmessage 0	
		fi
		setprop persist.vendor.sys.downloadmode.enable 1
	fi

	if [ "$charger_mode" != "charger" ]; then
		echo "[Debug] The file everbootup doesn't exist, data partition might be erased(factory reset)" > /proc/asusevtlog
		echo 0 > /data/bootup/everbootup
	fi
fi

# Check debug service
#if [ "$version_type" == "userdebug" ] || [ "$version_type" == "eng" ]; then
	# For userdebug/eng build
#	setprop vendor.asus.startlog 1
#	start_logcat_services
#fi

# Check startlog flag
startlog_flag=`getprop persist.vendor.asus.startlog`
if test "$startlog_flag" -eq 1;then
	start_logcat_services
	#echo startlog > /proc/asusdebug
elif test "$startlog_flag" -eq 0;then
	stop_logcat_services
	#echo stoplog > /proc/asusdebug
fi

# start logcat-asdf for cmdline
force_logcat_asdf=`getprop ro.boot.force_logcat_asdf`
if [ "$force_logcat_asdf" == "1" ]; then
	echo "force_logcat_asdf = $force_logcat_asdf"
	stop_logcat_services
	start logcat-crash
	start logcat-asdf
fi

#echo "init.asus.checkdatalog.sh EXIT" > /dev/kmsg
