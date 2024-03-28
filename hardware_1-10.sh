#!/usr/bin/bash
#hardware message check
if [ ! -n "$1" ];then
	echo "please set KVM ISO , then input 'OK' as \$1"
	exit
fi
echo "*****************************************************************************************************************" && \
echo "test 1 2 3 CPU Version & core_count & cache" && \
echo "test 1" && \
echo "# lscpu" &&  lscpu && \
echo "" && \
echo "*****************" && \
echo "*check boot_mode*" && \
echo "*****************" && \
echo ".........................................................................................." && \
echo "check efi file exist , [ -e /sys/firmware/efi ] && echo UEFI || echo BIOS" &&  [ -e /sys/firmware/efi ] && echo UEFI || echo BIOS && \
echo "" && \
echo "# cat /proc/cpuinfo" && cat /proc/cpuinfo |grep -iE 'model name'|uniq && \
echo ".........................................................................................." && \
echo "compare lscpu(OS) & dmidecode(BIOS) CPU Version and cores" && \
echo && \
echo "lscpu CPU Version:" && lscpu |grep -m 1 'Model name'|awk -F ':' '{print $2}'|awk '{sub(/^[ \t]+/,"");print $0}' && \
OS_CPU=`lscpu |grep -m 1 'Model name'|awk -F ' ' '{print $6}'` && \
echo "dmidecode CPU Version:" && dmidecode -t 4|grep -m 1 'Version'|awk -F ':' '{print $2}'|awk '{sub(/^[ \t]+/,"");print $0}' && \
BIOS_CPU=`dmidecode -t 4|grep -m 1 'Version'|awk -F ' ' '{print $5}'` && \
if [ "$OS_CPU" == "$BIOS_CPU" ]; then echo "CPU Version message match success";else echo "CPU Version message match failure";fi && \
echo && \
echo ".........................................................................................." && \
echo "**************************************************" && \
echo "*>>> ./dmidecode.log , please copy to your report*" && \
echo "**************************************************" && \
dmidecode -t 4 > dmidecode.log && \
echo "test 2" && \
echo "# lscpu|grep -iE 'Core\(s\) per socket'" &&  lscpu|grep -iE 'Core\(s\) per socket'&& \
echo "# dmidecode -t 4" && \
dmidecode -t 4|grep -A 3 -E 'DMI\ type\ 4|Version|Core Count' && \
echo && echo && \
echo ".........................................................................................." && \
echo "lscpu CPU core count:" && lscpu |grep "Core(s) per socket"|awk -F ' ' '{print $4}' && \
OS_CORES=`lscpu |grep "Core(s) per socket"|awk -F ' ' '{print $4}'` && \
echo "dmidecode CPU core count:" && dmidecode -t 4|grep "Core Count"|uniq|awk -F ' ' '{print $3}' && \
BIOS_CORES=`dmidecode -t 4|grep "Core Count"|uniq|awk -F ' ' '{print $3}'` && \
if [ $OS_CORES == $BIOS_CORES ]; then echo "cores count message match success";else echo "cores count message match failure";fi && \
echo ".........................................................................................." && \
echo "test 3" && \
echo '# lscpu |grep L'&&  lscpu |grep L && \
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
echo "export 'dmidecode -t 7' >>> dmidecode7.log"  && dmidecode -t 7 > dmidecode7.log && \
echo "BIOS dmidecode L1 L2 L3 cache" && dmidecode -t 7|grep -iE 'Level|Size'|grep -vE "Max"|head -n 6 && \
echo && echo "warning : Please check OS and BIOS cache massage!" && \
echo "*****************************************************************************************************************" && \
echo "test 4 memory" && \
echo ".........................................................................................." && \
echo "OS memory total"
echo "# cat /proc/iomem  | grep -i "system ram"" && cat /proc/iomem  | grep -i "system ram" && \
echo ".........................................................................................." && \
WC=`cat /proc/iomem |grep  -i "system ram"|wc -l`+1
SUM=0
for ((i=1;i<$WC;i++))
do
echo 'Round:'$i
DATA1=`cat /proc/iomem |grep  -i "system ram"|awk -F ' ' '{print $1}'|awk -F '-' '{print $1}'|sed -n $i\\p`
DATA2=`cat /proc/iomem |grep  -i "system ram"|awk -F ' ' '{print $1}'|awk -F '-' '{print $2}'|sed -n $i\\p`
#echo $DATA1
#echo $DATA2
let DATA3=$((num=16#$DATA2))-$((num=16#$DATA1))+1
echo $DATA2'-'$DATA1'='$DATA3
let SUM=$((num=$SUM))+$((num=$DATA3))
done
echo && \
let TOTAL=$((num=SUM))/1024/1024/1024
echo 'Total:'$SUM'='$TOTAL'GB'
echo ".........................................................................................." && \
echo "BIOS memory total" && \
echo "# dmidecode -t 19 | grep "Range Size"" && dmidecode -t 19 | grep "Range Size" && \
echo && echo "warning : Please check OS and BIOS memory massage!" && \
echo "*****************************************************************************************************************" && \
echo "test 5 Raid card" && \
#echo "# dmidecode -t 41" && dmidecode -t 41|grep -A 4 -B 2 'Raid Card' && \
echo "# lspci | egrep -i "megaraid\|adaptec"" && lspci | egrep -i "megaraid|adaptec"
RAID=`lspci | egrep -i "megaraid|adaptec"|awk -F ' ' '{print $1}'` && \
echo "# lspci -v -s $RAID | grep "Kernel driver in use"" &&  lspci -v -s $RAID | grep "Kernel driver in use" && \
echo "*****************************************************************************************************************" && \
echo "test 6 onboard ethernet card" && \
echo "# dmidecode -t 41 | grep -A3 "Ethernet" | grep "Bus Address"" && dmidecode -t 41 | grep -A3 "Ethernet" | grep "Bus Address" && \
DATA=`dmidecode -t 41 | grep -A3 "Ethernet" | grep "Bus Address"|awk -F ' ' '{print $3}'` && \
#DATA=`dmidecode -t 9|grep "Bus Address"|awk -F ' ' '{print $3}'` && \
for i in $DATA;do echo "# lspci -s $i -vvv";lspci -s $i -vvv|head -n 3;lspci -s $i -vvv|grep -iE "Kernel driver in use";done && \
echo "*****************************************************************************************************************" && \
echo "test 7 PCIe ethernet card" && \
echo "************************************" && \
echo "**Not RAID,please check no RAID!!!**" && \
echo "************************************" && \
echo "# dmidecode -t 9| grep -A7 "Current Usage: In Use" | grep "Bus Address"" && dmidecode -t 9| grep -A7 "Current Usage: In Use" | grep "Bus Address" && \
DATA=`dmidecode -t 9| grep -A7 "Current Usage: In Use" | grep "Bus Address"|awk -F ' ' '{print $3}'` && \
for i in $DATA;do echo "# lspci -s $i -vvv";lspci -s $i -vvv|head -n 3;lspci -s $i -vvv|grep -iE "Kernel driver in use";done && \
echo "*****************************************************************************************************************" && \
echo "test 8 Virtual Keyboard/Mouse" && \
echo "# lsusb -v | grep "Keyboard/Mouse KVM"" && \
lsusb -v | grep "Keyboard/Mouse KVM" && \
echo "# cat /proc/bus/input/devices | egrep "Keyboard/Mouse KVM"" && \
cat /proc/bus/input/devices | egrep "Keyboard/Mouse KVM" && \
echo "*****************************************************************************************************************" && \
echo "test 9 Virtual CD-ROM" && \
#echo "warning Please set ISO on KVM" && \
echo "# lsusb -v | grep "DVD-ROM"" && lsusb -v | grep "DVD-ROM" && \
echo "# lsscsi | grep "DVD-ROM VM"" && lsscsi | grep "DVD-ROM VM" && \
echo "# ls /dev/sr*" && ls /dev/sr* && \
echo "*****************************************************************************************************************" && \
echo "test 10 Virtual CD-ROM dmesg" && \
echo '# dmesg|egrep -i "error|fail|warn|wrong|bug|respond|pending|call trace"' && \
#&& dmesg|egrep -i "error|fail|warn|wrong|bug|respond|pending|call trace" && \
echo "*****************************************************************************************************************"
