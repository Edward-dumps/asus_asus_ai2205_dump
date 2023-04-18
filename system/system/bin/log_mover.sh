#!/system/bin/sh

# log_mover
#echo $0 > /dev/kmsg

VENDOR_DATA_TMP=/logbuf
SAVE_LOG_ROOT=/data/media/0/save_log
SAVE_LOG_FOLDER=$SAVE_LOG_ROOT/vendor_log
mkdir -p $SAVE_LOG_FOLDER
chmod -R 777 $SAVE_LOG_FOLDER
chmod -R 777 $SAVE_LOG_ROOT

ls -R -l $VENDOR_DATA_TMP > $VENDOR_DATA_TMP/ls_vendor_data_tmp.txt
wait_cmd=`cp -r $VENDOR_DATA_TMP/* $SAVE_LOG_FOLDER/`
sync
echo "log_mover.sh: cp -r $VENDOR_DATA_TMP --"

rm $VENDOR_DATA_TMP/ls_vendor_data_tmp.txt
wait_cmd=`rm -rf $VENDOR_DATA_TMP/*`
sync
echo "log_mover.sh: DONE!!!"
