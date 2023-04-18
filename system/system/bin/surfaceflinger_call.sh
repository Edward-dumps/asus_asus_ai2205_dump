#!/system/vendor/bin/sh
serviceid=`getprop vendor.asus.surfaceflingercall`
/system/bin/service call SurfaceFlinger "$serviceid"

