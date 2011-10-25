#!/system/bin/sh
# By Hashcode
# Version: 0.93
PATH=/system/bin:/system/xbin
INSTALLPATH=$1
PRIMARYSYS=/dev/block/mmcblk1p21
LOGFILE=$INSTALLPATH/action-uninstall.log

echo '' > $LOGFILE

chmod 755 $INSTALLPATH/busybox
CURRENTSYS=`$INSTALLPATH/busybox ls -l /dev/block/system | $INSTALLPATH/busybox tail -c 22`
# determine our active system, and mount/remount accordingly
if [ ! "$CURRENTSYS" = "$PRIMARYSYS" ]; then
	# alt-system, needs to mount original /system
	DESTMOUNT=/data/local/tmp/system
	if [ ! -d "$DESTMOUNT" ]; then
		$INSTALLPATH/busybox mkdir $DESTMOUNT
		$INSTALLPATH/busybox chmod 755 $DESTMOUNT
	fi
	$INSTALLPATH/busybox mount -t ext3 $PRIMARYSYS $DESTMOUNT >> $LOGFILE
else
	DESTMOUNT=/system
	sync
	$INSTALLPATH/busybox mount -o remount,rw $DESTMOUNT >> $LOGFILE
fi

if [ -f "$DESTMOUNT/bin/logwrapper.bin" ]; then
	$INSTALLPATH/busybox cp -f $DESTMOUNT/bin/logwrapper.bin $DESTMOUNT/bin/logwrapper >> $LOGFILE
	$INSTALLPATH/busybox chown 0.2000 $DESTMOUNT/bin/logwrapper >> $LOGFILE
	$INSTALLPATH/busybox chmod 755 $DESTMOUNT/bin/logwrapper >> $LOGFILE
fi
if [ -f "$DESTMOUNT/bin/loadpreinstalls.sh.bak" ]; then
	$INSTALLPATH/busybox cp -f $DESTMOUNT/bin/loadpreinstalls.sh.bak $DESTMOUNT/bin/loadpreinstalls.sh >> $LOGFILE
	$INSTALLPATH/busybox chown 0.2000 $DESTMOUNT/bin/loadpreinstalls.sh >> $LOGFILE
	$INSTALLPATH/busybox chmod 755 $DESTMOUNT/bin/loadpreinstalls.sh >> $LOGFILE
fi
if [ -d "$DESTMOUNT/etc/safestrap" ]; then
	$INSTALLPATH/busybox rm -r $DESTMOUNT/etc/safestrap >> $LOGFILE
fi
if [ -d "$DESTMOUNT/etc/recovery" ]; then
	$INSTALLPATH/busybox rm -r $DESTMOUNT/etc/recovery >> $LOGFILE
fi
if [ -d "$DESTMOUNT/etc/rootfs" ]; then
	$INSTALLPATH/busybox rm -r $DESTMOUNT/etc/rootfs >> $LOGFILE
fi

sync

# determine our active system, and umount/remount accordingly
if [ ! "$CURRENTSYS" = "$PRIMARYSYS" ]; then
	$INSTALLPATH/busybox umount $DESTMOUNT >> $LOGFILE
	$INSTALLPATH/busybox rmdir $DESTMOUNT
else
	$INSTALLPATH/busybox mount -o ro,remount $DESTMOUNT >> $LOGFILE
fi



