#!/bin/bash

log_file=mem_hot_plug.log
set_value=$1
if [ ! -n "$1" ];then
	echo "please input 0 (offline mem) or 1 (online mem) as \$1"
	exit
fi
ErrorCount=0
MemRemovable=0
mems=`ls -d /sys/devices/system/node/node*/memory*`
for temp in ${mems} ; do
    is_normal=$(cat ${temp}/valid_zones | grep Normal)
    if [ "${is_normal}" != ""  ] ; then
        MemRemovable=$(( MemRemovable +1 ))
        echo ${set_value} > ${temp}/online 2> ${log_file}
        if [ $? -eq 0 ] ; then
            result=`cat ${temp}/online`
            if [ ${result} != ${set_value} ] ; then
                echo "Cmd 'echo ${set_value} > ${temp}/online' failed, online is still equal ${result}."
                ErrorCount=$(( ErrorCount +1 ))
            fi
        else
            result=$(cat ${log_file})
            echo "result: ${result}"
            tmp=$( echo ${result} | grep "write error: Device or resource busy" )
            if [ "${tmp}" = "" ] ; then
                echo "Cmd 'echo ${set_value} > ${temp}/online' exec failed, ErrorCount++"
                ErrorCount=$(( ErrorCount +1 ))
            else
                echo "Cmd 'echo ${set_value} > ${temp}/online' exec failed, Device or resource busy, return $?"
            fi
        fi
    fi
done
rm ${log_file}
echo "************************"
echo "ErrorCount: ${ErrorCount}"
echo "MemRemovable: ${MemRemovable}"
result=$(echo "scale=2;${ErrorCount}*100/${MemRemovable}"|bc)
echo "Error rate: ${result}%"
