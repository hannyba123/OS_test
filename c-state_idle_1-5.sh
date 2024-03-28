#!/usr/bin/bash
#c state idle
MWAIT=$1
CPU=$2

if [ ! -n "$1" ] && [ ! -n "$2" ];then
	echo "please install stress and input C1/C6/C1E as \$1 , input CPU cores as \$2"
	exit
fi
stes (){
nohup stress -c $1 &
}

subtract (){
SUM=0
A=$1
for i in $(find /sys/devices/system/cpu -name state$A);do cat $i/usage >> state$A.$2'.log.1';done && \
sleep 5 && \
for i in $(find /sys/devices/system/cpu -name state$A);do cat $i/usage >> state$A.$2'.log.2';done
WC=`cat state$A.$2.log.1|wc -l`
let LINE=$WC+1
for ((i=1;i<$LINE;i++))
do
DATA1=`cat state$A.$2.log.1|sed -n $i\\p`
DATA2=`cat state$A.$2.log.2|sed -n $i\\p`
let SUB=$DATA2-$DATA1
let SUM=$SUM+${SUB#-}
done
let AVG=$SUM/$WC
echo $AVG
}

systemctl stop tuned
echo "*************************************************" && \
echo "# cat /sys/devices/system/cpu/cpuidle/current_driver" && \
cat /sys/devices/system/cpu/cpuidle/current_driver && \
DRIVER=`cat /sys/devices/system/cpu/cpuidle/current_driver` && \
echo "# cat /sys/devices/system/cpu/cpuidle/current_governor_ro" && \
cat /sys/devices/system/cpu/cpuidle/current_governor_ro && \

A=`grep . -rn /sys/devices/system/cpu/cpu0/cpuidle/state*/ | grep -i "MWAIT 0x0" | grep -v "0x01"|head -n 1` && \
B=${A#*state} && \
C1=${B%/*} && \
A=`grep . -rn /sys/devices/system/cpu/cpu0/cpuidle/state*/ | grep -i "MWAIT 0x01" |head -n 1` && \
B=${A#*state} && \
C1E=${B%/*} && \
A=`grep . -rn /sys/devices/system/cpu/cpu0/cpuidle/state*/ | grep -i "MWAIT 0x20" |head -n 1` && \
B=${A#*state} && \
C6=${B%/*} &&\
echo "----------------------------------------" && \
echo "C1:state < $C1 > | C1E:state < $C1E > | C6:state < $C6 >" && \

if [[ $C1 -eq "" ]]
then
echo "Can't set C1 state."
exit
fi

if [[ $C6 -eq "" ]]
then
echo "Can't set C6 state."
exit
fi

<<'content'
if [[ $MWAIT -eq 'C1E' ]]
then
rm -rf state$C1E*
for i in $(find /sys/devices/system/cpu -name state$C6|grep -v "hotplug");do echo 1 > $i/disable;done;
echo "value>5:in state$C1E,before stress" && \
subtract $C1E before && \
echo "# stress -c $CPU" && \
stes $CPU && \
sleep 5 && \
echo "value<5:out of the state$C1E,after stress" && \
subtract $C1E after && \
sleep 1 && \
killall stress && \
echo "Copy state$C1E.log to report"
fi
content

if [[ $MWAIT -eq 'C6' ]]
then
rm -rf state$C6*
for i in $(find /sys/devices/system/cpu -name state$C1E|grep -v "hotplug");do echo 0 > $i/disable;done;
for i in $(find /sys/devices/system/cpu -name state$C6|grep -v "hotplug");do echo 0 > $i/disable;done;
echo "value>5:in state$C6,before stress" && \
subtract $C6 before && \
echo "# stress -c $CPU" && \
stes $CPU && \
sleep 5 && \
echo "value<5:out of the state$C6,after stress" && \
subtract $C6 after && \
sleep 1 && \
killall stress && \
echo "# grep . -rn /sys/devices/system/cpu/cpu0/cpuidle/state*" && grep . -rn /sys/devices/system/cpu/cpu0/cpuidle/state* && \
echo "Copy state$C6.log to report" && \
zip $DRIVER\_state$C6.zip state$C6* && \
rm -rf state$C6* 
fi

if [[ $MWAIT -eq 'C1' ]]
then
rm -rf state$C1*
for i in $(find /sys/devices/system/cpu -name state$C1E|grep -v "hotplug");do echo 1 > $i/disable;done;
for i in $(find /sys/devices/system/cpu -name state$C6|grep -v "hotplug");do echo 1 > $i/disable;done;
echo "value>5:in state$C1,before stress" && \
subtract $C1 before && \
echo "# stress -c $CPU" && \
stes $CPU && \
sleep 5 && \
echo "value<5:out of the state$C1,after stress" && \
subtract $C1 after && \
sleep 1 && \
killall stress && \
echo "# grep . -rn /sys/devices/system/cpu/cpu0/cpuidle/state*" && grep . -rn /sys/devices/system/cpu/cpu0/cpuidle/state* && \
echo "Copy *.zip to report" && \
zip $DRIVER\_state$C1.zip state$C1* && \
rm -rf state$C1* 
fi



