#!/vendor/bin/sh
i2c_path="/sys/devices/platform/soc/ac0000.qcom,qupv3_1_geni_se/a90000.i2c/i2c-2/2-0038"

if [ -e "/sys/devices/platform/soc/ac0000.qcom,qupv3_1_geni_se/a90000.i2c/i2c-3/3-0038/fts_test" ] ;then
    i2c_path="/sys/devices/platform/soc/ac0000.qcom,qupv3_1_geni_se/a90000.i2c/i2c-3/3-0038"
fi

fw_err=234
sleep 1.5
TP1_VER_PACK=`cat ${i2c_path}/fts_fw_version`
echo "[FTS]FW version $TP1_VER_PACK" > /dev/kmsg
if [ "$((16#$TP1_VER_PACK))" == "${fw_err}" ]; then
sleep 7
TP1_VER_PACK=`cat ${i2c_path}/fts_fw_version`
echo "[FTS]get FW version $TP1_VER_PACK" > /dev/kmsg
setprop vendor.touch.version.driver "$((16#$TP1_VER_PACK))"
else
setprop vendor.touch.version.driver "$((16#$TP1_VER_PACK))"
fi
