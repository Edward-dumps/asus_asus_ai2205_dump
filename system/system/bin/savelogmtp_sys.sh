#!/system/bin/sh

# savelog
#echo $0 > /dev/kmsg

factory_version=`getprop ro.boot.ftm`
platform=`getprop ro.build.product`
build_type=`getprop ro.build.type`
SAVE_LOG_ROOT=/data/media/0/save_log
VENDOR_DATA_TMP=$SAVE_LOG_ROOT/vendor_log
BUGREPORT_PATH=/data/user_de/0/com.android.shell/files/bugreports
BUSYBOX=busybox

# check mount file
	umask 0;
	sync
############################################################################################	
	# create savelog folder (UTC)
	SAVE_LOG_PATH="$SAVE_LOG_ROOT/`date +%Y_%m_%d_%H_%M_%S`"
	mkdir -p $SAVE_LOG_PATH
	setprop persist.vendor.asus.savelogmtp.folder $SAVE_LOG_PATH
	SaveLogFolder=`getprop persist.vendor.asus.savelogmtp.folder`
	echo "$0: persist.vendor.asus.savelogmtp.folder=$SaveLogFolder"
	chmod -R 777 $SAVE_LOG_PATH
	chmod -R 777 $SAVE_LOG_ROOT
	echo "savelogmtp_sys.sh: mkdir -p $SAVE_LOG_PATH"
############################################################################################
	if [ "${factory_version}" != "1" ]; then
		bugreportz
		cp -r $BUGREPORT_PATH $SAVE_LOG_PATH/
		rm -r $BUGREPORT_PATH/
		echo "savelogmtp_sys.sh: copy BUGREPORT"
	fi
#############################################################################################
	# dump audio codec register
	echo dump >/proc/driver/audio_debug
	echo "savelogmtp_sys.sh: echo dump >/proc/driver/audio_debug"
############################################################################################
	# save property
	getprop > $SAVE_LOG_PATH/getprop.txt
	echo "savelogmtp_sys.sh: getprop > $SAVE_LOG_PATH/getprop.txt"
############################################################################################
	# save cmdline
	cat /proc/cmdline > $SAVE_LOG_PATH/cmdline.txt
	echo "savelogmtp_sys.sh: cat /proc/cmdline > $SAVE_LOG_PATH/cmdline.txt"
	# save bootconfig
	cat /proc/bootconfig > $SAVE_LOG_PATH/bootconfig.txt
	echo "savelogmtp_sys.sh: cat /proc/bootconfig > $SAVE_LOG_PATH/bootconfig.txt"
############################################################################################
	# save mount table
	cat /proc/mounts > $SAVE_LOG_PATH/mounts.txt
	echo "savelogmtp_sys.sh: cat /proc/mounts > $SAVE_LOG_PATH/mounts.txt"
############################################################################################
	#TODO	
	cat /sys/kernel/dload/dload_mode > $SAVE_LOG_PATH/dload_mode.txt
	cat /sys/module/qcom_dload_mode/parameters/download_mode > $SAVE_LOG_PATH/download_mode.txt
	cat /sys/kernel/dload/emmc_dload > $SAVE_LOG_PATH/emmc_dload.txt
	echo "savelogmtp_sys.sh: cat dload_mode"
############################################################################################
	# capture cnss ipc logs
	cat /sys/kernel/debug/ipc_logging/pcie0-long/log > $SAVE_LOG_PATH/pcie0-long_host.txt
	cat /sys/kernel/debug/ipc_logging/pcie0-short/log > $SAVE_LOG_PATH/pcie0-short_host.txt
	cat /sys/kernel/debug/ipc_logging/pcie0-dump/log > $SAVE_LOG_PATH/pcie0-dump_host.txt
	cat /sys/kernel/debug/ipc_logging/cnss/log > $SAVE_LOG_PATH/cnss_host.txt
	cat /sys/kernel/debug/ipc_logging/cnss-mhi/log > $SAVE_LOG_PATH/cnss_mhi_host.txt
	cat /sys/kernel/debug/ipc_logging/cnss-mhi-cntrl/log > $SAVE_LOG_PATH/cnss_mhi_host.txt
	cat /sys/kernel/debug/ipc_logging/cnss-long/log > $SAVE_LOG_PATH/cnss_long_host.txt
	echo "savelogmtp_sys.sh: capture cnss ipc logs"
######################################################################################
	# copy usb_debug
	mkdir $SAVE_LOG_PATH/usb_debug/
	cat /sys/kernel/tracing/instances/usb/trace > $SAVE_LOG_PATH/usb_debug/usb_trace.txt
	cat /d/ipc_logging/a600000.ssusb/log > $SAVE_LOG_PATH/usb_debug/log_dwc3_usb1.txt
	cat /d/ipc_logging/ucsi/log > $SAVE_LOG_PATH/usb_debug/ucsi.txt
	echo "savelogmtp_sys.sh: copy usb_debug"
######################################################################################
	# save charger information
	mkdir $SAVE_LOG_PATH/charger_debug/
	echo 256 > /d/regmap/0-07/count
	echo 0x2600 > /d/regmap/0-07/address
	cat /d/regmap/0-07/data > $SAVE_LOG_PATH/charger_debug/pm8550b_reg.txt
	echo 0x2700 > /d/regmap/0-07/address
	cat /d/regmap/0-07/data >> $SAVE_LOG_PATH/charger_debug/pm8550b_reg.txt
	echo 0x2800 > /d/regmap/0-07/address
	cat /d/regmap/0-07/data >> $SAVE_LOG_PATH/charger_debug/pm8550b_reg.txt
	echo 0x2900 > /d/regmap/0-07/address
	cat /d/regmap/0-07/data >> $SAVE_LOG_PATH/charger_debug/pm8550b_reg.txt
	echo 0x2B00 > /d/regmap/0-07/address
	cat /d/regmap/0-07/data >> $SAVE_LOG_PATH/charger_debug/pm8550b_reg.txt
	echo 0x2C00 > /d/regmap/0-07/address
	cat /d/regmap/0-07/data >> $SAVE_LOG_PATH/charger_debug/pm8550b_reg.txt
	echo 0x3C00 > /d/regmap/0-07/address
	cat /d/regmap/0-07/data >> $SAVE_LOG_PATH/charger_debug/pm8550b_reg.txt

	echo 768 > /d/regmap/3-09/count
	echo 0x2600 > /d/regmap/3-09/address
	cat /d/regmap/3-09/data > $SAVE_LOG_PATH/charger_debug/sbm1396_reg.txt
	cat /sys/class/power_supply/*/uevent > $SAVE_LOG_PATH/charger_debug/uevent.txt
	cat /sys/class/asuslib/get_ChgPD_FW_Ver > $SAVE_LOG_PATH/charger_debug/ChgPD_Ver.txt

	# save charger information for user
	cat /proc/driver/pm8350b_reg_dump > $SAVE_LOG_PATH/charger_debug/pm8350b_reg_user.txt
	cat /proc/driver/smb1396_reg_dump > $SAVE_LOG_PATH/charger_debug/smb1396_reg_user.txt
	cp /asdf/charger-logcat.txt* $SAVE_LOG_PATH/charger_debug/

	echo "savelogmtp_sys.sh: save charger information"
############################################################################################
	# save sleep information
	cat /sys/power/rpmh_stats/master_stats > $SAVE_LOG_PATH/charger_debug/master_stats.txt
	cat /sys/power/system_sleep/stats > $SAVE_LOG_PATH/charger_debug/system_sleep.txt
############################################################################################
	micropTest=`cat /sys/class/switch/pfs_pad_ec/state`
	if [ "${micropTest}" = "1" ]; then
	date > $SAVE_LOG_PATH/microp_dump.txt
	 cat /d/gpio >> $SAVE_LOG_PATH/microp_dump.txt                   
        echo "cat /d/gpio > $SAVE_LOG_PATH/microp_dump.txt"  
        cat /d/microp >> $SAVE_LOG_PATH/microp_dump.txt
        echo "savelogmtp_sys.sh: cat /d/microp > $SAVE_LOG_PATH/microp_dump.txt"
	fi
############################################################################################
	vmstat 1 5 > $SAVE_LOG_PATH/vmstat.txt
	mkdir $SAVE_LOG_PATH/Power_Err_log
	cp /asdf/ASUS_*.txt $SAVE_LOG_PATH/Power_Err_log
############################################################################################
	# save space used status
	df > $SAVE_LOG_PATH/df.txt
	echo "savelogmtp_sys.sh: df > $SAVE_LOG_PATH/df.txt"
############################################################################################
	# save load kernel modules
	lsmod > $SAVE_LOG_PATH/lsmod.txt
	echo "savelogmtp_sys.sh: lsmod > $SAVE_LOG_PATH/lsmod.txt"
############################################################################################
	# save process now
	ps > $SAVE_LOG_PATH/ps.txt
	echo "savelogmtp_sys.sh: ps > $SAVE_LOG_PATH/ps.txt"
############################################################################################
	# save network info
	ifconfig -a > $SAVE_LOG_PATH/ifconfig.txt
	echo "savelogmtp_sys.sh: ifconfig -a > $SAVE_LOG_PATH/ifconfig.txt"
############################################################################################
	# Capture fsck log
	cp /dev/fscklogs/f2fs_log $SAVE_LOG_PATH/f2fs_fsck.txt
	echo "savelogmtp_sys.sh: Capture fsck log"
############################################################################################
	# copy data/tombstones to data/media
	ls -R -l /data/tombstones/ > $SAVE_LOG_PATH/ls_data_tombstones.txt
	mkdir $SAVE_LOG_PATH/tombstones
	#mv /data/tombstones/* $SAVE_LOG_PATH/tombstones/
	cp -r /data/tombstones/* $SAVE_LOG_PATH/tombstones/
	rm  -r /data/tombstones/* 
	echo "savelogmtp_sys.sh: cp /data/tombstones $SAVE_LOG_PATH"
############################################################################################
	# copy data/tombstones to data/media
	#busybox ls -R -l /tombstones/mdm > $SAVE_LOG_PATH/ls_tombstones_mdm.txt
	mkdir -p /data/tombstones/dsps
	mkdir -p /data/tombstones/lpass
	mkdir -p /data/tombstones/mdm
	mkdir -p /data/tombstones/modem
	mkdir -p /data/tombstones/wcnss
	chown system.system /data/tombstones/*
	chmod 771 /data/tombstones/*
	echo "savelogmtp_sys.sh: copy data/tombstones to data/media"
############################################################################################
	mkdir $SAVE_LOG_PATH/FotaNetInfo
	cp -r /sdcard/FotaNetInfo/* $SAVE_LOG_PATH/FotaNetInfo/
	rm  -r /sdcard/FotaNetInfo/* 
############################################################################################
	# copy Debug Ion information to data/media
	mkdir $SAVE_LOG_PATH/ION_Debug
	cp /d/ion/* $SAVE_LOG_PATH/ION_Debug/
	echo "savelogmtp_sys.sh: copy Debug Ion information"
############################################################################################
# mount logfs & copy UefiLog/xbl_sc_logs
if [ "$build_type" = "userdebug" ]; then
	mkdir /data/logcat_log/logfs
	chmod 777 /data/logcat_log/logfs
	#chmod 777 /dev/block/bootdevice/by-name/logfs
	mount -t vfat /dev/block/bootdevice/by-name/logfs /data/logcat_log/logfs
	cp /dev/block/by-name/xbl_sc_logs /data/logcat_log/logfs
fi
#############################################################################################
	# copy data/logcat_log to data/media
	ls -R -l /data/logcat_log/ > $SAVE_LOG_PATH/ls_data_logcat_log.txt
	cp -r /data/logcat_log $SAVE_LOG_PATH
	echo "savelogmtp_sys.sh: cp -r /data/logcat_log $SAVE_LOG_PATH"

	# copy /data/misc/logd to data/media
	ls -R -l /data/misc/logd > $SAVE_LOG_PATH/ls_data_misc_logd.txt
	cp -r /data/misc/logd $SAVE_LOG_PATH
	echo "savelogmtp_sys.sh: cp -r /data/misc/logd $SAVE_LOG_PATH"
############################################################################################
	# copy /data/misc/bluetooth/logs/ to data/media
	ls -R -l /data/misc/bluetooth/logs/ > $SAVE_LOG_PATH/ls_data_btsnoop.txt
	mkdir $SAVE_LOG_PATH/btsnoop
	cp -r /data/misc/bluetooth/logs/ $SAVE_LOG_PATH/btsnoop/
	rm -r /data/misc/bluetooth/logs/*.*
	echo "savelogmtp_sys.sh: cp -r /data/misc/bluetooth/logs/ $SAVE_LOG_PATH/btsnoop/"
############################################################################################
	# copy recovery log to data/media
	if [ -d "/cache/recovery/" ]; then
		ls -R -l /cache/recovery > $SAVE_LOG_PATH/ls_cache_recovery.txt
		mkdir $SAVE_LOG_PATH/cache_recovery
		cp -r /cache/recovery/* $SAVE_LOG_PATH/cache_recovery/
		echo "savelogmtp_sys.sh: cp -r /cache/recovery/ $SAVE_LOG_PATH"
	fi
############################################################################################
	# copy /asdf/ASUSEvtlog.txt to ASDF	
	ls -R -l /asdf > $SAVE_LOG_PATH/ls_asdf.txt
	mkdir $SAVE_LOG_PATH/asdf_logcat
	cp -r /asdf/asdf-logcat.txt* $SAVE_LOG_PATH/asdf_logcat
	cp -r /asdf/logcat-crash.txt* $SAVE_LOG_PATH/asdf_logcat
	cp -r /asdf/ASUSEvtlog.txt $SAVE_LOG_PATH
	cp -r /asdf/ASUSEvtlog_old.txt $SAVE_LOG_PATH
	cp -r /asdf/ASUSEvtlog.tar.gz $SAVE_LOG_PATH
	cp -r /data/media/0/asus_log/tcpdump/ $SAVE_LOG_PATH
	#cp -r /asdf/ASDF $SAVE_LOG_PATH && rm -r /asdf/ASDF/ASDF.*
	echo "savelogmtp_sys.sh: cp -r /asdf/ASUSEvtlog.txt $SAVE_LOG_PATH"
############################################################################################
	# copy wlan configstore
	cp -r /data/misc/apexdata/com.android.wifi/WifiConfigStore.xml $SAVE_LOG_PATH
	echo "savelogmtp_sys.sh: cp -r /data/misc/apexdata/com.android.wifi/WifiConfigStore.xml $SAVE_LOG_PATH"

	# copy softap configstore
	cp -r /data/misc/apexdata/com.android.wifi/WifiConfigStoreSoftAp.xml $SAVE_LOG_PATH
	echo "savelogmtp_sys.sh: cp -r /data/misc/apexdata/com.android.wifi/WifiConfigStoreSoftAp.xml $SAVE_LOG_PATH"

	# copy wlan configstore
	cp -r /data/misc/wifi/WifiViceConfigStore.xml $SAVE_LOG_PATH
	echo "savelogmtp_sys.sh: cp -r /data/misc/wifi/WifiViceConfigStore.xml $SAVE_LOG_PATH"

############################################################################################
	# mv /data/anr to data/media
	ls -R -l /data/anr > $SAVE_LOG_PATH/ls_data_anr.txt
	mkdir $SAVE_LOG_PATH/anr
	#mv /data/anr/* $SAVE_LOG_PATH/anr/
	cp -r /data/anr/* $SAVE_LOG_PATH/anr/
	rm -r /data/anr/* 
	echo "savelogmtp_sys.sh: cp /data/anr $SAVE_LOG_PATH"
############################################################################################
	# save system information
	dumpsys SurfaceFlinger > $SAVE_LOG_PATH/surfaceflinger.dump.txt
	echo "savelogmtp_sys.sh: dumpsys SurfaceFlinger > $SAVE_LOG_PATH/surfaceflinger.dump.txt"
	dumpsys window > $SAVE_LOG_PATH/window.dump.txt
	echo "savelogmtp_sys.sh: dumpsys window > $SAVE_LOG_PATH/window.dump.txt"
	dumpsys activity > $SAVE_LOG_PATH/activity.dump.txt
	echo "savelogmtp_sys.sh: dumpsys activity > $SAVE_LOG_PATH/activity.dump.txt"
	dumpsys power > $SAVE_LOG_PATH/power.dump.txt
	echo "savelogmtp_sys.sh: dumpsys power > $SAVE_LOG_PATH/power.dump.txt"
	dumpsys input_method > $SAVE_LOG_PATH/input_method.dump.txt
	echo "savelogmtp_sys.sh: dumpsys input_method > $SAVE_LOG_PATH/input_method.dump.txt"
	dumpsys meminfo > $SAVE_LOG_PATH/meminfo.dump.txt
	date > $SAVE_LOG_PATH/date.txt
	echo "savelogmtp_sys.sh: date > $SAVE_LOG_PATH/date.txt"
############################################################################################
	# copy subsystem ramdumps
	cp -r /data/media/0/diag_logs/QXDM_logs/ $SAVE_LOG_PATH
	rm -r /data/media/0/diag_logs/QXDM_logs/ 
	ls -R -l /data/vendor/ramdump/ssr_ramdump > $SAVE_LOG_PATH/ls_ssr_ramdump.txt
############################################################################################
	cp -r /data/misc/update_engine_log $SAVE_LOG_PATH/
	echo "savelogmtp_sys.sh: cp -r /data/misc/update_engine_log $SAVE_LOG_PATH"
##############################################################################################
#copy vendor log
ls -R -l $VENDOR_DATA_TMP/ > $SAVE_LOG_PATH/ls_vendor_log.txt
cp -r $VENDOR_DATA_TMP/wifi_config $SAVE_LOG_PATH/
cp -r $VENDOR_DATA_TMP/wlan_logs $SAVE_LOG_PATH/
cp -r $VENDOR_DATA_TMP/btsnoop $SAVE_LOG_PATH/
cp -r $VENDOR_DATA_TMP/tz_logs $SAVE_LOG_PATH/
cp -r $VENDOR_DATA_TMP/gpu_logs $SAVE_LOG_PATH/
cp -r $VENDOR_DATA_TMP/minidump $SAVE_LOG_PATH/

# tar log
wait_cmd=`tar zcvf $SAVE_LOG_PATH.tar.gz $SAVE_LOG_PATH`
rm -rf $SAVE_LOG_PATH
mkdir $SAVE_LOG_PATH
mv $SAVE_LOG_PATH.tar.gz $SAVE_LOG_PATH
echo "savelogmtp_sys.sh: tar log"

#copy vendor log
cp -r $VENDOR_DATA_TMP/diag_logs $SAVE_LOG_PATH/
cp -r $VENDOR_DATA_TMP/ssr_ramdump $SAVE_LOG_PATH/
rm -rf $VENDOR_DATA_TMP
echo "savelogmtp_sys.sh: cp -r /data/media/0/save_log/vendor_log"

chmod -R 777 $SAVE_LOG_PATH
chmod -R 777 $SAVE_LOG_ROOT
sync
am broadcast -a android.intent.action.MEDIA_MOUNTED --ez read-only false -d file:///storage/emulated/0/ -p com.android.providers.media -f 0x01000000

echo "savelogmtp_sys.sh: DONE!!!"
