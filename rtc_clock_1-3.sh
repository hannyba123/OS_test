#!/usr/bin/bash
#rtc clock check
if [ ! -n "$1" ];then
	echo "please input 'OK' as \$1"
	exit
fi
echo "*****************************************************************************************************************" && \
timedatectl set-ntp false && \
echo "test 1 rtc" && \
echo "# date" && date && \
echo "# hwclock -r" && hwclock -r && \
echo "*****************************************************************************************************************" && \
echo "test 2 rtc" && \
echo "# date -s '08/19/2015 10:00:00'" && date -s '08/19/2015 10:00:00' && \
echo "# date" && date && \
echo "*****************************************************************************************************************" && \
echo "test 3 rtc" && \
sleep 5 && \
echo "# date" && date && \
echo "# date -s '08/19/2015 10:00:00'" && date -s '08/19/2015 10:00:00' && \
echo "# date" && date && \
echo "# hwclock -r" && hwclock -r && \
echo "# hwclock -w" && hwclock -w && \
echo "# hwclock -r" && hwclock -r && \
echo "*****************************************************************************************************************" && \
timedatectl set-ntp true && \
sleep 5 && \
hwclock -w
echo "*****************************************************************************************************************" && \
echo "test 4 rtc" && \
echo "# cat /sys/devices/system/clocksource/clocksource0/available_clocksource" && \
cat /sys/devices/system/clocksource/clocksource0/available_clocksource && \
echo "# /sys/devices/system/clocksource/clocksource0/current_clocksource" && \
cat /sys/devices/system/clocksource/clocksource0/current_clocksource && \
echo "*****************************************************************************************************************"
