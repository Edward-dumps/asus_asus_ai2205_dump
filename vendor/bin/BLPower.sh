#!/system/bin/sh
# $1 == 1 is ON, $1 == 0 is OFF

if [ "$1" == "0" ];then
	ret=`service call SurfaceFlinger 20000 i64 4630946655968710275 i32 0`
	if [ "$ret" == "Result: Parcel(NULL)" ];then
		echo "PASS"
	else
		echo "FAIL"
	fi
elif [ "$1" == "1" ];then
	ret=`service call SurfaceFlinger 20000 i64 4630946655968710275 i32 2`
	if [ "$ret" == "Result: Parcel(NULL)" ];then
		echo "PASS"
	else
		echo "FAIL"
	fi
else
	echo "Error Mode"
fi
