wifi_mac=`sed -n '1 p' /vendor/factory/wlan_mac.bin`
wifi_mac=${wifi_mac//Intf0MacAddress=/ }
setprop ro.vendor.wifimac $wifi_mac
wifi_mac=`sed -n '2 p' /vendor/factory/wlan_mac.bin`
wifi_mac=${wifi_mac//Intf1MacAddress=/ }
setprop ro.vendor.wifimac_2 $wifi_mac

#wigig_mac=`cat /vendor/factory/wigig_mac.bin`
#setprop ro.wigigmac $wigig_mac

setprop vendor.wifi.version.driver WLAN.HMT.1.0-03851-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.24156.10
#setprop wigig.version.driver 5.3.0.72
#setprop wigig.dock.version.driver v0.0.0.10

# BT
setprop vendor.bt.version.driver BTFW.HAMILTON.2.0.0-00516-PATCHZ-1
setprop ro.vendor.btmac `btnvtool -x 2>&1`
