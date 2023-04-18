#!/vendor/bin/sh

sleep 15

setprop vendor.atd.keybox.ready false

ret=$(/vendor/bin/hdcp2p2prov -verify)
if [ "${ret}" = "Verification succeeded. Device is provisioned." ]; then
	setprop "vendor.atd.hdcp2p2.ready" TRUE
else
	setprop "vendor.atd.hdcp2p2.ready" FALSE
fi

ret=$(/vendor/bin/hdcp1prov -verify)
if [ "${ret}" = "Verification succeeded. Device is provisioned." ]; then
	setprop "vendor.atd.hdcp1.ready" TRUE
else
	setprop "vendor.atd.hdcp1.ready" FALSE
fi


/vendor/bin/is_keybox_valid
/vendor/bin/is_keymaster_valid
/vendor/bin/is_hdcp_valid

# Work around for debug purpose..
HDCP_READY=$(getprop vendor.atd.hdcp.ready)
HDCP1_READY=$(getprop vendor.atd.hdcp1.ready)
HDCP2P2_READY=$(getprop vendor.atd.hdcp2p2.ready)
KEYBOX_READY=$(getprop vendor.atd.keybox.ready)
KEYMASTER_READY=$(getprop vendor.atd.keymaster.ready)

# Log result.
log "vendor.atd.hdcp.ready = ${HDCP_READY}"
log "vendor.atd.hdcp1.ready = ${HDCP1_READY}"
log "vendor.atd.hdcp2p2.ready = ${HDCP2P2_READY}"
log "vendor.atd.keybox.ready = ${KEYBOX_READY}"
log "vendor.atd.keymaster.ready = ${KEYMASTER_READY}"

i=0
while [ ${KEYBOX_READY} != "TRUE" -a $i -lt 30 ]
do
	log "[keybox] check key retry $i"
	/vendor/bin/is_keybox_valid
	i=$(($i+1))
	sleep 5
	KEYBOX_READY=$(getprop vendor.atd.keybox.ready)
done
