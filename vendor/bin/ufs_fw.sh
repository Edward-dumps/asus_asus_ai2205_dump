
vendor=`getprop vendor.asus.storage.primary.ufs_info | cut -d " " -f 1`

if [ "$vendor" == "SAMSUNG" ] ; then
getprop vendor.asus.storage.primary.ufs_info | cut -d " " -f 3 | cut -c 1-2
else
getprop vendor.asus.storage.primary.ufs_info | cut -d " " -f 3
fi
