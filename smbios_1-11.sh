#!/usr/bin/bash
#smbios message check
if [ ! -n "$1" ];then
	echo "please input 'OK' as \$1"
	exit
fi
echo "*****************************************************************************************************************" && \
echo "test 1 SMBIOS CPU Version" && \
echo "# dmidecode -t 4" && dmidecode -t 4|grep -A 5 -E 'DMI\ type\ 4|Version' && \
echo "*****************************************************************************************************************" && \
echo "test 2 SMBIOS memory" && \
echo "# dmidecode -t 19" && dmidecode -t 19 && \
echo "*****************************************************************************************************************" && \
echo "test 3 PCIe ethernet card" && \
echo "************************************" && \
echo "**Not RAID,please check no RAID!!!**" && \
echo "************************************" && \
echo "# dmidecode -t 9" && dmidecode -t 9|grep -A 5 -B 3 -iE "In Use" && \
DATA=`dmidecode -t 9|grep -A 5 -B 3 -iE "In Use"|grep "Bus Address"|awk -F ' ' '{print $3}'` && \
#DATA=`dmidecode -t 9|grep "Bus Address"|awk -F ' ' '{print $3}'` && \
for i in $DATA;do echo "# lspci -s $i -vvv";lspci -s $i -vvv|head -n 3;done && \
echo "*****************************************************************************************************************" && \
echo "test 4 onboard ethernet card" && \
echo "# dmidecode -t 41" && dmidecode -t 41|grep -B 2 -A 4 -iE 'OCP' 
echo "*****************************************************************************************************************" && \
echo "test 5 6 7 CPU core_count core_enabled thread_count" && \
echo "# dmidecode -t 4" && dmidecode -t 4|grep -A 3 -E 'DMI type 4|Core Count' && \
echo "*****************************************************************************************************************" && \
echo "test 8 CPU cache" && \
<< 'content'
echo "# lscpu" && lscpu|head -n 26 && echo "" && \
echo "*********************************" && \
echo "**cpu0 L1d L1i L2 L3 cache size*" && \
echo "*********************************" && \
echo "# cat /sys/devices/system/cpu/cpu0/cache/index*/size" && cat /sys/devices/system/cpu/cpu0/cache/index*/size && echo "" && \
echo "***************************" && \
echo "**cpu0 L1d L1i L2 L3 list**" && \
echo "***************************" && \
echo "# cat /sys/devices/system/cpu/cpu0/cache/index*/shared_cpu_list" && cat /sys/devices/system/cpu/cpu0/cache/index*/shared_cpu_list && echo && \
echo "***************************************************************************" && \
echo "**cache=cache size x Thread(s) per core x Core(s) per socket / shared_cpu**" && \
echo "***************************************************************************" && \
lscpu | grep -iE 'core' && echo "" && \
echo "# dmidecode -t 7" && dmidecode -t 7 |grep -A 7 -iE "Handle" -m 3 && \
content
echo && echo && \
echo "*************************" && \
echo "*cpu0 L1d L1i L2 L3 list*" && \
echo "*************************" && \
echo "# cat /sys/devices/system/cpu/cpu0/cache/index*/shared_cpu_list" && cat /sys/devices/system/cpu/cpu0/cache/index*/shared_cpu_list && \
echo "*******************************" && \
echo "*cpu0 L1d L1i L2 L3 cache size*" && \
echo "*******************************" && \
echo "# cat /sys/devices/system/cpu/cpu0/cache/index*/size" && cat /sys/devices/system/cpu/cpu0/cache/index*/size && \
cat /sys/devices/system/cpu/cpu0/cache/index*/size > cache_size.log
echo ".........................................................................................." && \
echo "OS L1 L2 L3" && \
L1d=`cat cache_size.log|sed -n '1p'|sed 's/K//g'` && \
L1i=`cat cache_size.log|sed -n '2p'|sed 's/K//g'` && \
L2=`cat cache_size.log|sed -n '3p'|sed 's/K//g'` && \
L3=`cat cache_size.log|sed -n '4p'|sed 's/K//g'` && \
CORES=`lscpu|grep "Core(s) per socket:"|awk -F ':' '{print $2}'|sed 's/^[ \t]*//g'` && \
let L1=$L1d+$L1i && echo L1=$L1d\KB+$L1i\KB=$L1\KB && \
let L1SUM=$L1*$CORES && echo L1_sum:$L1SUM\ KB && \
let L2SUM=$L2*$CORES && echo L2_sum:$L2SUM\ KB && \
let L3SUM=$L3 && echo L3_sum:$L3SUM\ KB && \
echo ".........................................................................................." && \
#echo "export 'dmidecode -t 7' >>> dmidecode7.log"  && dmidecode -t 7 > dmidecode7.log && \
echo "BIOS dmidecode L1 L2 L3 cache" && dmidecode -t 7|grep -iE 'Level|Size'|grep -vE "Max"|head -n 6 && \
echo && echo "warning : Please check OS and BIOS cache massage!" && \
echo "*****************************************************************************************************************" && \
echo "test 9 Raid card" && \
echo "# dmidecode -t 9" && dmidecode -t 9|grep -A 9 -B 2 'SLOT' && \
DATA=`dmidecode -t 9|grep -A 9 -B 2 'SLOT'|grep "Bus Address"|awk -F ' ' '{print $3}'` && \ 
for i in $DATA;do echo "# lspci -s $i -vvv";lspci -s $i -vvv|head -n 3;done && \
echo "*****************************************************************************************************************" && \
echo "test 10 BIOS Version" && \
echo "# dmidecode -t 0" && dmidecode -t 0 && \
echo "*****************************************************************************************************************" && \
echo "test 11 PCB message" && \
echo "# dmidecode -t 1" && dmidecode -t 1 
echo "*****************************************************************************************************************" 
