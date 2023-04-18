#!/system/bin/sh

ROOT_PATH=/data/media/0/Android/data/com.asus.loguploader/files/ASUS/LogUploader/
#MODEM_LOG
MODEM_LOG=/data/media/0/Android/data/com.asus.loguploader/files/ASUS/LogUploader/modem
#TCP_DUMP_LOG
TCP_DUMP_LOG=/data/media/0/Android/data/com.asus.loguploader/files/ASUS/LogUploader/TCPdump
#GENERAL_LOG
GENERAL_LOG=/data/media/0/Android/data/com.asus.loguploader/files/ASUS/LogUploader/general/sdcard
#Dumpsys folder
DUMPSYS_DIR=/data/media/0/Android/data/com.asus.loguploader/files/ASUS/LogUploader/dumpsys
BUGREPORT_PATH=/data/user_de/0/com.android.shell/files/bugreports

#Vendor data folder for swap
SAVE_LOG_ROOT=/data/media/0/save_log
VENDOR_DATA_TMP=$SAVE_LOG_ROOT/vendor_log

PATH=/system/bin/:$PATH

savelogs_prop=`getprop persist.vendor.asus.savelogs`
is_tcpdump_status=`getprop init.svc.tcpdump-warp`
isBetaUser=`getprop persist.vendor.asus.mupload.enable`

export_general_log() {
	mkdir -p $GENERAL_LOG
	echo "mkdir -p $GENERAL_LOG"
	############################################################################################
	bugreportz > $GENERAL_LOG/bugreportz_log.txt
	cp -r $BUGREPORT_PATH $GENERAL_LOG/
	rm -r $BUGREPORT_PATH/
	############################################################################################
	# save cmdline
	cat /proc/cmdline > $GENERAL_LOG/cmdline.txt
	echo "cat /proc/cmdline > $GENERAL_LOG/cmdline.txt"
	# save bootconfig
	cat /proc/bootconfig > $GENERAL_LOG/bootconfig.txt
	echo "cat /proc/bootconfig > $GENERAL_LOG/bootconfig.txt"
	############################################################################################
	cat /sys/kernel/dload/dload_mode > $GENERAL_LOG/dload_mode.txt
	cat /sys/module/qcom_dload_mode/parameters/download_mode > $GENERAL_LOG/download_mode.txt
	############################################################################################
	# save mount table
	cat /proc/mounts > $GENERAL_LOG/mounts.txt
	echo "cat /proc/mounts > $GENERAL_LOG/mounts.txt"
	############################################################################################
	getenforce > $GENERAL_LOG/getenforce.txt
	echo "getenforce > $GENERAL_LOG/getenforce.txt"
	############################################################################################
	# save property
	getprop > $GENERAL_LOG/getprop.txt
	echo "getprop > $GENERAL_LOG/getprop.txt"
	############################################################################################
	# save network info
	cat /proc/net/route > $GENERAL_LOG/route.txt
	echo "cat /proc/net/route > $GENERAL_LOG/route.txt"
	netcfg > $GENERAL_LOG/ifconfig.txt
	echo "ifconfig -a > $GENERAL_LOG/ifconfig.txt"
	netstat -anlp > $GENERAL_LOG/netstat.txt
	echo "netstat -anlp > $GENERAL_LOG/netstat.txt"
	date && ip rule > $GENERAL_LOG/iprule.txt
	echo "date && ip rule > $GENERAL_LOG/iprule.txt"
	############################################################################################
	# save software version
	echo "AP_VER: `getprop ro.build.display.id`" > $GENERAL_LOG/version.txt
	echo "CP_VER: `getprop gsm.version.baseband`" >> $GENERAL_LOG/version.txt
	echo "BT_VER: `getprop vendor.bt.version.driver`" >> $GENERAL_LOG/version.txt
	echo "WIFI_VER: `getprop vendor.wifi.version.driver`" >> $GENERAL_LOG/version.txt
	echo "WIFI_VER: `getprop wigig.version.driver`" >> $GENERAL_LOG/version.txt
	echo "WIFI_VER: `getprop wigig.dock.version.driver`" >> $GENERAL_LOG/version.txt
	echo "GPS_VER: `getprop vendor.gps.version.driver`" >> $GENERAL_LOG/version.txt
	echo "BUILD_DATE: `getprop ro.build.date`" >> $GENERAL_LOG/version.txt
	############################################################################################
	# save load kernel modules
	lsmod > $GENERAL_LOG/lsmod.txt
	echo "lsmod > $GENERAL_LOG/lsmod.txt"
	############################################################################################
	# save process now
	ps > $GENERAL_LOG/ps.txt
	echo "ps > $GENERAL_LOG/ps.txt"
	ps -eo f,s,uid,pid,ppid,c,pri,ni,bit,sz,%mem,%cpu,wchan,tty,time,cmd > $GENERAL_LOG/ps_all.txt
	echo "ps > $GENERAL_LOG/ps_all.txt"
	ps -A -T > $GENERAL_LOG/ps_thread.txt
	echo "ps > $GENERAL_LOG/ps_thread.txt"
	############################################################################################
	# save kernel message
	dmesg > $GENERAL_LOG/dmesg.txt
	echo "dmesg > $GENERAL_LOG/dmesg.txt"
	############################################################################################
	# copy data/tombstones to data/media
	ls -R -l /data/tombstones/ > $GENERAL_LOG/ls_data_tombstones.txt
	mkdir $GENERAL_LOG/tombstones
	cp /data/tombstones/* $GENERAL_LOG/tombstones/
	echo "cp /data/tombstones $GENERAL_LOG"	
	############################################################################################
	# copy data/logcat_log to data/media
	mkdir $GENERAL_LOG/logcat_log
	ls -R -lZ /data/logcat_log/ > $GENERAL_LOG/ls_data_logcat_log.txt
	cp -r /data/logcat_log/logcat* $GENERAL_LOG/logcat_log
	cp -r /data/logcat_log/kernel* $GENERAL_LOG/logcat_log
	cp -r /data/logcat_log/capture* $GENERAL_LOG/logcat_log
	echo "cp -r /data/logcat_log $GENERAL_LOG"
	#rm /data/logcat_log/*
	rm -r /data/logcat_log/logcat.txt.*
	rm -r /data/logcat_log/logcat-events.txt.*
	rm -r /data/logcat_log/logcat-radio.txt.*
	rm -r /data/logcat_log/kernel.log.*
	rm -r /data/logcat_log/capture.pcap*
	#echo "$BUSYBOX cp -r /data/logcat_log $GENERAL_LOG"
	############################################################################################
	ls -R -l /asdf > $GENERAL_LOG/ls_asdf.txt
	############################################################################################
	# copy /asdf/ASUSEvtlog.txt to ASDF
	mkdir $GENERAL_LOG/asdf_logcat
	cp -r /asdf/asdf-logcat.txt* $GENERAL_LOG/asdf_logcat
	cp -r /asdf/logcat-crash.txt* $GENERAL_LOG/asdf_logcat
	cp -r /asdf/ASUSEvtlog.txt $GENERAL_LOG
	cp -r /asdf/ASUSEvtlog_old.txt $GENERAL_LOG
	cp -r /asdf/ASUSEvtlog.tar.gz $GENERAL_LOG
	cp -r /asdf/ASDF $GENERAL_LOG
	echo "cp -r /asdf/ASUSEvtlog.txt $GENERAL_LOG"
	############################################################################################
	# save charger information
	mkdir $GENERAL_LOG/charger_debug/
	cat /sys/class/power_supply/*/uevent > $GENERAL_LOG/charger_debug/uevent.txt
	cat /sys/class/asuslib/get_ChgPD_FW_Ver > $GENERAL_LOG/charger_debug/ChgPD_Ver.txt

	# save charger information for user
	cat /proc/driver/pm8550b_reg_dump > $GENERAL_LOG/charger_debug/pm8550b_reg_user.txt
	cat /proc/driver/smb1396_reg_dump > $GENERAL_LOG/charger_debug/smb1396_reg_user.txt
	cp /asdf/charger-logcat.txt* $GENERAL_LOG/charger_debug/
	############################################################################################
	# save sleep information
	cat /sys/power/rpmh_stats/master_stats > $GENERAL_LOG/charger_debug/master_stats.txt
	cat /sys/power/system_sleep/stats > $GENERAL_LOG/charger_debug/system_sleep.txt
	##############################################################################################
	# backup wlan_logs
	WLAN_LOGS_BACKUP_PATH="/data/media/0/asus_log/wlan_logs_`date +%Y_%m_%d_%H_%M_%S`"
	mkdir -p $WLAN_LOGS_BACKUP_PATH
	echo "mkdir -p $WLAN_LOGS_BACKUP_PATH"
	chmod -R 777 $WLAN_LOGS_BACKUP_PATH
	#cp -r /data/vendor/wifi/wlan_logs/* $WLAN_LOGS_BACKUP_PATH
	cp -r $VENDOR_DATA_TMP/wlan_logs/* $WLAN_LOGS_BACKUP_PATH
	echo "cp -r /data/vendor/wifi/wlan_logs/* $WLAN_LOGS_BACKUP_PATH"
	sync
	echo "tar -czf $WLAN_LOGS_BACKUP_PATH.tar.gz . -C $WLAN_LOGS_BACKUP_PATH"
	wait_cmd=`tar -czf $WLAN_LOGS_BACKUP_PATH.tar.gz . -C $WLAN_LOGS_BACKUP_PATH`
	sync
	echo "rm -rf $WLAN_LOGS_BACKUP_PATH"
	rm -rf $WLAN_LOGS_BACKUP_PATH
	sync
	############################################################################################
	# capture cnss ipc logs
	cat /sys/kernel/debug/ipc_logging/pcie0-long/log > $GENERAL_LOG/pcie0-long_host.txt
	cat /sys/kernel/debug/ipc_logging/pcie0-short/log > $GENERAL_LOG/pcie0-short_host.txt
	cat /sys/kernel/debug/ipc_logging/pcie0-dump/log > $GENERAL_LOG/pcie0-dump_host.txt
	cat /sys/kernel/debug/ipc_logging/cnss/log > $GENERAL_LOG/cnss_host.txt
	cat /sys/kernel/debug/ipc_logging/cnss-mhi/log > $GENERAL_LOG/cnss_mhi_host.txt
	cat /sys/kernel/debug/ipc_logging/cnss-mhi-cntrl/log > $GENERAL_LOG/cnss_mhi_host.txt
	cat /sys/kernel/debug/ipc_logging/cnss-long/log > $GENERAL_LOG/cnss_long_host.txt
	# capture cnss ipc logs
	############################################################################################
	if [ ".$isBetaUser" == ".1" ]; then
		cp -r /data/misc/apexdata/com.android.wifi/WifiConfigStore.xml $GENERAL_LOG
		echo "cp -r /data/misc/apexdata/com.android.wifi/WifiConfigStore.xml $GENERAL_LOG"
		cp -r /data/misc/apexdata/com.android.wifi/WifiConfigStoreSoftAp.xml $GENERAL_LOG
		echo "cp -r /data/misc/apexdata/com.android.wifi/WifiConfigStoreSoftAp.xml $GENERAL_LOG"
		cp -r /data/misc/wifi/WifiViceConfigStore.xml $GENERAL_LOG
		echo "cp -r /data/misc/wifi/WifiViceConfigStore.xml $GENERAL_LOG"

		ls -R -l /data/vendor/wifi > $GENERAL_LOG/ls_wifi_asus_log.txt

		#cp -r /data/vendor/wifi/wpa/wpa_supplicant.conf $GENERAL_LOG
		echo "cp -r /data/vendor/wifi/wpa/wpa_supplicant.conf $GENERAL_LOG"
		#cp -r /data/vendor/wifi/wpa/p2p_supplicant.conf $GENERAL_LOG
		echo "cp -r /data/vendor/wifi/wpa/p2p_supplicant.conf $GENERAL_LOG"
		#cp -r /data/vendor/wifi/hostapd/hostapd_wlan1.conf $GENERAL_LOG
		echo "cp -r /data/vendor/wifi/hostapd/hostapd_wlan1.conf $GENERAL_LOG"
		#cp -r /data/vendor/wifi/hostapd/hostapd_wlan2.conf $GENERAL_LOG
		echo "cp -r /data/vendor/wifi/hostapd/hostapd_wlan2.conf $GENERAL_LOG"
		cp -r $VENDOR_DATA_TMP/wifi_config/* $GENERAL_LOG

		# copy /sdcard/wlan_logs/*_current.txt
		#cp -r /data/vendor/wifi/wlan_logs/cnss_fw_logs_current.txt $GENERAL_LOG
		cp -r $VENDOR_DATA_TMP/wlan_logs/cnss_fw_logs_current.txt $GENERAL_LOG
		echo "cp -r /data/vendor/wifi/wlan_logs/cnss_fw_logs_current.txt $GENERAL_LOG"
		#cp -r /data/vendor/wifi/wlan_logs/host_driver_logs_current.txt $GENERAL_LOG
		cp -r $VENDOR_DATA_TMP/wlan_logs/host_driver_logs_current.txt $GENERAL_LOG
		echo "cp -r /data/vendor/wifi/wlan_logs/host_driver_logs_current.txt $GENERAL_LOG"

		# copy wlan ramdump
		mkdir $GENERAL_LOG/ssr_ramdump
		cp -r /data/vendor/ramdump/ssr_ramdump/wlan* $GENERAL_LOG/ssr_ramdump/
		rm -r /data/vendor/ramdump/ssr_ramdump/wlan*
		echo "cp -r /data/vendor/ramdump/ssr_ramdump/wlan* $GENERAL_LOG/ssr_ramdump"
	else
		echo "cp -r $WLAN_LOGS_BACKUP_PATH.tar.gz $GENERAL_LOG"
		cp -r $WLAN_LOGS_BACKUP_PATH.tar.gz $GENERAL_LOG
		sync
		echo "rm -rf /data/vendor/wifi/wlan_logs/*"
		rm -rf /data/vendor/wifi/wlan_logs/*
		echo "rm -rf $WLAN_LOGS_BACKUP_PATH.tar.gz"
		rm -rf $WLAN_LOGS_BACKUP_PATH.tar.gz
		sync
	fi
	############################################################################################
	cp -r /data/misc/update_engine_log $GENERAL_LOG
	##############################################################################################
	# add for qfp debug
	mkdir $GENERAL_LOG/qti_fp
	mv /data/vendor/misc/qti_fp/ivv/* $GENERAL_LOG/qti_fp/
	echo "mv /data/vendor/misc/qti_fp/ivv/* $GENERAL_LOG/qti_fp/"
	############################################################################################
	# mv /data/anr to data/media
	ls -R -l /data/anr > $GENERAL_LOG/ls_data_anr.txt
	mkdir $GENERAL_LOG/anr
	cp /data/anr/* $GENERAL_LOG/anr/
	echo "cp /data/anr $GENERAL_LOG"
	############################################################################################
	# [BugReporter]Save ps.txt to Dumpsys folder
	mkdir $DUMPSYS_DIR
	ps -A  > $DUMPSYS_DIR/ps.txt
	############################################################################################
	date > $GENERAL_LOG/date.txt
	echo "date > $GENERAL_LOG/date.txt"
	############################################################################################
	df > $GENERAL_LOG/df.txt
	echo "df > $GENERAL_LOG/df.txt"
	###########################################################################################
	lsof > $GENERAL_LOG/lsof.txt
	mkdir  $GENERAL_LOG/ap_ramdump
	cp -r  /data/media/ap_ramdump/* $GENERAL_LOG/ap_ramdump/
	mkdir  $GENERAL_LOG/recovery
	cp -r  /cache/recovery/* $GENERAL_LOG/recovery
	vmstat 1 5 > $GENERAL_LOG/vmstat.txt
	#############################################################################################
	cp -r /data/media/0/ssr_ramdump/ $GENERAL_LOG
	#rm -r  /data/media/0/ssr_ramdump/
	echo "mv /data/media/0/ssr_ramdump $GENERAL_LOG"
	#############################################################################################
	echo "UTS: cp /data/media/0/save_log/vendor_log/tz_logs"
	cp -r $VENDOR_DATA_TMP/tz_logs $GENERAL_LOG/
	echo "UTS: cp /data/media/0/save_log/vendor_log/minidump"
	cp -r $VENDOR_DATA_TMP/minidump $GENERAL_LOG/

chmod -R 777 $GENERAL_LOG
}

export_ramdump_log(){
	if [ -e $ROOT_PATH/ramdump ]; then
		rm -r $ROOT_PATH/ramdump
	fi
	mkdir -p $ROOT_PATH/ramdump
	#cp -r /data/vendor/ramdump/diag_logs/QXDM_logs $ROOT_PATH/ramdump
	cp -r $VENDOR_DATA_TMP/diag_logs $ROOT_PATH/ramdump

	chmod -R 777 $ROOT_PATH/ramdump
	echo "/data/vendor/ramdump/diag_logs/QXDM_logs $ROOT_PATH/ramdump"
}

export_tombstones_log() {
	if [ -e $ROOT_PATH/tombstones ]; then
		rm -r $ROOT_PATH/tombstones
	fi
	mkdir -p $ROOT_PATH/tombstones
	#cp -r  /data/vendor/ramdump/ssr_ramdump/modem0 $ROOT_PATH/tombstones
	cp -r $VENDOR_DATA_TMP/ssr_ramdump $ROOT_PATH/tombstones

	chmod -R 777 $ROOT_PATH/tombstones
	echo "/data/vendor/ramdump/ssr_ramdump/modem0 $ROOT_PATH/tombstones"
}

export_tcpdump_log() {
	if [ -e $ROOT_PATH/tcpdump ]; then
		rm -r $ROOT_PATH/tcpdump
	fi
	mkdir -p $ROOT_PATH/tcpdump
	cp -r /data/media/0/asus_log/tcpdump/ $ROOT_PATH/tcpdump
	chmod -R 777 $ROOT_PATH/tcpdump
	echo "/data/media/0/asus_log/tcpdump/ $ROOT_PATH/modem"
}

export_bluetooth_log(){
	if [ -e $ROOT_PATH/bluetooth ]; then
		rm -r $ROOT_PATH/bluetooth
	fi
	mkdir -p $ROOT_PATH/bluetooth
	cp -r /data/misc/bluetooth/logs/ $ROOT_PATH/bluetooth
	chmod -R 777 $ROOT_PATH/bluetooth
	echo "mv /data/misc/bluetooth/logs/ $ROOT_PATH/bluetooth"
}

export_bluetooth_ramdump_log(){
	if [ -e $ROOT_PATH/bluetooth_ramdump ]; then
		rm -r $ROOT_PATH/bluetooth_ramdump
	fi
	mkdir -p $ROOT_PATH/bluetooth_ramdump
	#cp -r /data/vendor/ssrdump/ $ROOT_PATH/bluetooth_ramdump
	cp -r $VENDOR_DATA_TMP/btsnoop $ROOT_PATH/bluetooth_ramdump
	chmod -R 777 $ROOT_PATH/bluetooth_ramdump
	echo "mv /data/vendor/ssrdump/ $ROOT_PATH/bluetooth_ramdump"
}

send_movelog_complete(){
	rm -rf $VENDOR_DATA_TMP/
	am broadcast -a com.asus.savelogs.completed -n com.asus.loguploader/.logtool.LogtoolReceiver --ei logtype $savelogs_prop
	echo "send_movelog_complete Done"
}

remove_folder() {
	# remove folder
	if [ -e $GENERAL_LOG ]; then
		rm -r $GENERAL_LOG
	fi
	
	if [ -e $MODEM_LOG ]; then
		rm -r $MODEM_LOG
	fi
	
	if [ -e $TCP_DUMP_LOG ]; then
		rm -r $TCP_DUMP_LOG
	fi

	if [ -e $DUMPSYS_DIR ]; then
		rm -r $DUMPSYS_DIR
	fi
}

create_folder() {
	# create folder
	mkdir -p $GENERAL_LOG
	echo "mkdir -p $GENERAL_LOG"
	
	mkdir -p $MODEM_LOG
	echo "mkdir -p $MODEM_LOG"
	
	mkdir -p $TCP_DUMP_LOG
	echo "mkdir -p $GENERAL_LOG"
}

clean_internal_folder() {
	rm -rf /data/vendor/ramdump/diag_logs/QXDM_logs/*.*
	rm -rf /data/vendor/tombstones/SDX55M/*.*
	rm -rf /data/media/0/asus_log/tcpdump/*.*
	rm -rf /data/misc/bluetooth/logs/*.*
	rm -rf /data/vendor/ssrdump/*.*
	rm -r /data/vendor/ramdump/bluetooth/*.*
	setprop persist.vendor.asus.savelogs 0
}

if [ ".$savelogs_prop" == ".0" ]; then
	remove_folder
    setprop persist.vendor.asus.uts com.asus.removelogs.completed
    setprop persist.vendor.asus.savelogs.complete 0
    setprop persist.vendor.asus.savelogs.complete 1
#	am broadcast -a "com.asus.removelogs.completed"

elif [ ".$savelogs_prop" == ".5" ]; then
	# Phone, signal and mobile networks
	# check mount file
	umask 0;
	sync
	############################################################################################
	export_general_log

	export_ramdump_log

	export_tombstones_log

	export_tcpdump_log
	############################################################################################
	send_movelog_complete
elif [ ".$savelogs_prop" == ".6" ]; then
	# WIFI
	# check mount file
	umask 0;
	sync
	############################################################################################
	export_general_log

	export_ramdump_log

	export_tcpdump_log

	export_tombstones_log
	############################################################################################
	send_movelog_complete
elif [ ".$savelogs_prop" == ".7" ]; then
	# BT
	# check mount file
	umask 0;
	sync
	############################################################################################
	# remove folder
	export_general_log

	export_ramdump_log

	export_bluetooth_log

	export_bluetooth_ramdump_log
	############################################################################################
	send_movelog_complete
elif [ ".$savelogs_prop" == ".8" ]; then
	# Location services
	# check mount file
	umask 0;
	sync
	############################################################################################
	export_general_log

	export_ramdump_log
	############################################################################################
	send_movelog_complete
elif [ ".$savelogs_prop" == ".9" ]; then
	# Audio, scound recording, call audio
	# check mount file
	umask 0;
	sync
	############################################################################################
	# remove folder
	export_general_log

	export_ramdump_log
	############################################################################################
	send_movelog_complete
elif [ ".$savelogs_prop" == ".10" ]; then
	# check mount file
	umask 0;
	sync
	############################################################################################
	# remove folder
	remove_folder

	# create folder
	create_folder

	# save_general_log
	export_general_log

	export_bluetooth_ramdump_log
	############################################################################################
	# sync data to disk
	# 1015 sdcard_rw
	chmod -R 777 $ROOT_PATH
	sync
	send_movelog_complete
	echo "Done"
elif [ ".$savelogs_prop" == ".99" ]; then
	# check mount file
	umask 0;
	sync
	############################################################################################
	# clean internal folder
	clean_internal_folder
fi
