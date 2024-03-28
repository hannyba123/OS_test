#!/usr/bin/bash
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
echo 'Total:'$TOTAL'='$TOTAL'GB'
