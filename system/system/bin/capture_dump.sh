#!/system/bin/sh

# check mount file
	umask 0;
	sync

rawdump_enable=`getprop ro.boot.rawdump_en`
SAVE_DUMP_PATH=/data/media/0/save_log/rawdump

###########################################################################################
# Error Code Table
# vendor.asus.capturedump_err: error log
# 0: Finished.
# 1: No rawdump partition. Please do repartition first.
# 2: There is no full ramdump in device.
setprop vendor.asus.capturedump_err ""

###########################################################################################
# Fulldump
if [ "${rawdump_enable}" = "1" ]; then
	dd if=/dev/block/bootdevice/by-name/rawdump of=/data/logcat_log/ramdump_header.txt bs=4 count=2
	var=$(cat /data/logcat_log/ramdump_header.txt)
	if test "$var" = "Raw_Dmp!"
	then
		echo "ASDF: Found Full Dump!" > /proc/asusevtlog
		mkdir -p $SAVE_DUMP_PATH
		chmod -R 777 $SAVE_DUMP_PATH

		dd if=/dev/block/bootdevice/by-name/rawdump of=/logbuf/RawRamDump.bin
		echo "ASDF: save rawdump done." > /dev/kmsg
		if [ -f  $SAVE_DUMP_PATH/RawRamDump.tgz ]; then
			rm $SAVE_DUMP_PATH/RawRamDump.tgz
		fi
		tar -czvf $SAVE_DUMP_PATH/RawRamDump.tgz /logbuf/RawRamDump.bin
		echo "ASDF: tar dump DONE." > /dev/kmsg

		rm /logbuf/RawRamDump.bin
		dd if=/dev/zero of=/dev/block/bootdevice/by-name/rawdump bs=4 count=2
		setprop vendor.asus.capturedump_err 0
	else
		setprop vendor.asus.capturedump_err 2
	fi
	rm /data/logcat_log/ramdump_header.txt
else
	setprop vendor.asus.capturedump_err 1
fi
###########################################################################################
setprop vendor.asus.capturedump 0

echo "$0: DONE!!!"
exit
