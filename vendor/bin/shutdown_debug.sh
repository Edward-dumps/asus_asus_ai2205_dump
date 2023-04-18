check_flag=`getprop persist.vendor.asus.startlog`


if [ "$check_flag" == "0" ] ; then
	rm -rf /asdf/shutdown_debug*
else
	if [ -e /asdf/shutdown_debug.txt ] ; then
		check_size=`ls -al /asdf/shutdown_debug.txt |cut -d " " -f 5`
		if [ $check_size -gt 10240000 ] ; then
			mv /asdf/shutdown_debug.txt /asdf/shutdown_debug1.txt
			touch /asdf/shutdown_debug.txt
		fi
	else
		touch /asdf/shutdown_debug.txt
	fi
fi
