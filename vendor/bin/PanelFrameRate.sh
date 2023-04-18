#!/system/bin/sh

if [ $1 == 0 ];then
    cat /proc/driver/panel_fps
elif [ $1 == 60 ];then
    ret=`service call SurfaceFlinger 1035 i32 4`
    if [ "$ret" == "Result: Parcel(NULL)" ];then
    sleep 0.5
    echo "PASS"
    fi
elif [ $1 == 90 ];then
    ret=`service call SurfaceFlinger 1035 i32 3`
    if [ "$ret" == "Result: Parcel(NULL)" ];then
    sleep 0.5
    echo "PASS"
    fi
elif [ $1 == 120 ];then
    ret=`service call SurfaceFlinger 1035 i32 2`
    if [ "$ret" == "Result: Parcel(NULL)" ];then
    sleep 0.5
    echo "PASS"
    fi
elif [ $1 == 144 ];then
    ret=`service call SurfaceFlinger 1035 i32 1`
    if [ "$ret" == "Result: Parcel(NULL)" ];then
    sleep 0.5
    echo "PASS"
    fi
elif [ $1 == 165 ];then
    ret=`service call SurfaceFlinger 1035 i32 0`
    if [ "$ret" == "Result: Parcel(NULL)" ];then
    sleep 0.5
    echo "PASS"
    fi
else
    echo "Error Mode"
fi
