

DATA=`ls /sys/devices/system/cpu/cpu*/on*`
dmesg -c >/dev/null
echo '' > cpu_hotplug.log && \
for a in $DATA
do 
	echo 0 > $a && \
	dmesg -T && \
	dmesg -T >> cpu_hotplug.log && \
	dmesg -c >/dev/null
	sleep 3
	echo 1 > $a && \
	dmesg -T && \
	dmesg -T >> cpu_hotplug.log && \
	dmesg -c >/dev/null
done
