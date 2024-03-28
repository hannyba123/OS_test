#!/usr/bin/bash
#P-State acpi_cpufreq
#P-State intel_pstate Passive Mode

CPU=$1
sum (){
SUM=0
AVG=0
let LINE=$(($1+1))
for ((i=1;i<$LINE;i++))
do
DATA1=`cat $2$3.log|sed -n $i\\p`
let SUM=$((num=$SUM))+$((num=$DATA1))
done
echo && echo '--------------------------------------------' && \
echo 'Now calculate CPU frequency'
let AVG=$SUM/$1
echo 'Average:'$AVG
}

stes (){
nohup stress -c $1 &
}

if [ ! -n "$1" ];then
	echo "please install stress and input your CPU(S) as \$1"
	exit
fi
main (){
for AAA in ${LIST[@]}
do
echo "**************************************************************************************************"
echo "test p-state freq $AAA" && echo && \
echo "# cat /proc/cmdline" && cat /proc/cmdline && \
#echo "# cat /proc/cpuinfo" && cat /proc/cpuinfo|grep -m 1 -A 26 "processor" && \
echo "# lscpu" && lscpu |head -n 17 && \
echo "# cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_driver" && \
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_driver|uniq && \
for i in $(find /sys -name scaling_governor);do echo $AAA > $i;done;
for i in $(find /sys/devices/system/cpu -name disable | grep -v 'state0' );do echo 1 > $i;done;
echo "# cat /sys/devices/system/cpu/cpufreq/policy*/scaling_governor" && \
cat /sys/devices/system/cpu/cpufreq/policy*/scaling_governor|uniq && \
echo "#  cat /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_min_freq" && \
cat /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_min_freq|uniq && \
echo "#  cat /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_max_freq" && \
cat /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_max_freq|uniq && \
echo '#  cpupower -c 1 frequency-info' && \
cpupower -c 1 frequency-info && \
WC=`cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq|wc -l` && \
sleep 10 && \
echo "export scaling_cur_freq >>> $AAA""1.log " && \
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq > $AAA'1.log' && \
sum $WC $AAA 1 && echo && \
echo "Now stress CPU!" && \
#nohup stress -c  $1 
stes $1
sleep 10 && \
echo "export scaling_cur_freq >>> $AAA""2.log " && \
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq > $AAA'2.log' && \
sleep 10 && \
killall stress && \
sum $WC $AAA 2
done
}

userspace (){
echo "**************************************************************************************************"
echo "test p-state freq userspace" && echo && \
echo "# cat /proc/cmdline" && cat /proc/cmdline && \
echo "# cat /proc/cpuinfo" && cat /proc/cpuinfo|grep -m 1 -A 26 "processor" && \
echo "# cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_driver" && \
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_driver|uniq && \
for i in $(find /sys -name scaling_governor);do echo userspace > $i;done;
for i in $(find /sys/devices/system/cpu -name disable | grep -v 'state0' );do echo 1 > $i;done;
echo "# cat /sys/devices/system/cpu/cpufreq/policy*/scaling_governor" && \
cat /sys/devices/system/cpu/cpufreq/policy*/scaling_governor|uniq && \
echo "#  cat /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_min_freq" && \
cat /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_min_freq|uniq && \
MIN=`cat /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_min_freq|uniq`
echo "#  cat /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_max_freq" && \
cat /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_max_freq|uniq && \
MAX=`cat /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_max_freq|uniq`
echo '#  cpupower -c 1 frequency-info' && \
cpupower -c 1 frequency-info && \
WC=`cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq|wc -l` && \
echo && echo '--------------------------------------------' && \
echo "Set CPU min_freq $MIN" && \
for i in $(find /sys/devices/system/cpu -name scaling_setspeed );do echo $MIN > $i;done;
sleep 5
echo "export scaling_cur_freq >>> userspace1.log" && \
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq > userspace1.log && \
sum $WC userspace 1 && \
echo && echo '--------------------------------------------' && \
echo "Set CPU max_freq $MAX" && \
for i in $(find /sys/devices/system/cpu -name scaling_setspeed );do echo $MAX > $i;done;
sleep 5
echo "export scaling_cur_freq >>> userspace2.log" && \
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq > userspace2.log && \
sum $WC userspace 2
echo && echo '--------------------------------------------' && \
let MID=($MIN+$MAX)/2
echo "Set CPU mid_freq $MID" && \
for i in $(find /sys/devices/system/cpu -name scaling_setspeed );do echo $MID > $i;done;
sleep 10
echo "export scaling_cur_freq >>> userspace3.log" && \
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq > userspace3.log && \
sum $WC userspace 3
}

systemctl stop tuned
LIST=(powersave performance)
#LIST=(powersave performance schedutil ondemand conservative)
main $1
#userspace
