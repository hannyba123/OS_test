#!/bin/bash
#ipmi access shell script
#v0.1 20220608
if [ ! -n "$1" ];then
	echo "please input 'OK' as \$1 , can set \$2 \$3 \$4 as 17 18 19"
	exit
fi
echo "# systemctl restart openipmi" && systemctl restart openipmi
echo "# systemctl status openipmi" && systemctl status openipmi
echo "# systemctl restart ipmi" && systemctl restart ipmi
echo "# systemctl status ipmi" && systemctl status ipmi 
echo "*****************************************************************************************************************" && \
echo "ipmi test 4" && \
echo "# ipmitool sensor list" && ipmitool sensor list |head -n 10 && \
echo "*****************************************************************************************************************" && \
echo "ipmi test 5" && \
echo "# ipmitool event 1" && ipmitool event 1 && \
sleep 1 && \
echo "# ipmitool sel list | grep "Upper Critical going high"" && ipmitool sel list | grep "Upper Critical going high" && \
echo "*****************************************************************************************************************" && \
echo "ipmi test 6" && \
echo "# ipmitool power status" && ipmitool power status && \
echo "*****************************************************************************************************************" && \
echo "ipmi test 7" && \
echo "# ipmitool sdr type 0x01" && ipmitool sdr type 0x01 |head -n 10 && \
echo "*****************************************************************************************************************" && \
echo "ipmi test 8" && \
echo "# ipmitool sdr type 0x02" && ipmitool sdr type 0x02 |head -n 10 && \
echo "*****************************************************************************************************************" && \
echo "ipmi test 9" && \
echo "# ipmitool sdr type 0x04" && ipmitool sdr type 0x04 |head -n 10 && \
echo "*****************************************************************************************************************" && \
echo "ipmi test 10" && \
echo "# ipmitool sel clear" && ipmitool sel clear && \
sleep 1 && \
echo "# ipmitool raw 0x06 0x24 0x83 0x00 0x00 0x00 0x2c 0x01" && ipmitool raw 0x06 0x24 0x83 0x00 0x00 0x00 0x2c 0x01 && \
echo "# ipmitool raw 0x06 0x22" && ipmitool raw 0x06 0x22 && \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
echo "# ipmitool sel list" && ipmitool sel list && \
sleep 35 && \
echo "pass 35s" && \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
echo "# ipmitool sel list" && ipmitool sel list && \
echo "*****************************************************************************************************************" && \
echo "ipmi test 11" && \
echo "# ipmitool sel clear" && ipmitool sel clear && \
echo "# ipmitool raw 0x06 0x24 0x03 0x00 0x00 0x00 0x2c 0x01" && ipmitool raw 0x06 0x24 0x03 0x00 0x00 0x00 0x2c 0x01 && \
echo "# ipmitool raw 0x06 0x22" && ipmitool raw 0x06 0x22 && \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
sleep 35 && \
echo "pass 35s" && \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
echo "# ipmitool sel list" && ipmitool sel list && \
echo "*****************************************************************************************************************" && \
echo "ipmi test 12" && \
echo "# ipmitool raw 0x06 0x24 0x03 0x00 0x00 0x00 0xb8 0x0b" && ipmitool raw 0x06 0x24 0x03 0x00 0x00 0x00 0xb8 0x0b && \
echo "# ipmitool raw 0x06 0x22" && ipmitool raw 0x06 0x22 && \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
echo "# ipmitool raw 0x06 0x24 0x43 0x00 0x00 0x00 0x2c 0x01" && ipmitool raw 0x06 0x24 0x43 0x00 0x00 0x00 0x2c 0x01 && \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
echo "*****************************************************************************************************************" && \
echo "ipmi test 13" && \
echo "# ipmitool raw 0x06 0x24 0x03 0x00 0x00 0x00 0xb8 0x0b" && ipmitool raw 0x06 0x24 0x03 0x00 0x00 0x00 0xb8 0x0b && \
echo "# ipmitool raw 0x06 0x22" && ipmitool raw 0x06 0x22 && \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
echo "# ipmitool raw 0x06 0x24 0x03 0x00 0x00 0x00 0x2c 0x01" && ipmitool raw 0x06 0x24 0x03 0x00 0x00 0x00 0x2c 0x01 && \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
echo "*****************************************************************************************************************" && \
echo "ipmi test 14" && \
echo "# ipmitool raw 0x06 0x24 <opt> 0x00 0x00 0x00 0x2c 0x01 [<opt>：0x01 0x02 0x03 0x04 0x05]" && \
echo "# ipmitool raw 0x06 0x24 0x01 0x00 0x00 0x00 0x2c 0x01" && ipmitool raw 0x06 0x24 0x01 0x00 0x00 0x00 0x2c 0x01 && \
echo "# ipmitool mc watchdog get | grep "Watchdog Timer Use"" && ipmitool mc watchdog get | grep "Watchdog Timer Use" && \
echo "# ipmitool raw 0x06 0x24 0x02 0x00 0x00 0x00 0x2c 0x01" && ipmitool raw 0x06 0x24 0x02 0x00 0x00 0x00 0x2c 0x01&& \
echo "# ipmitool mc watchdog get | grep "Watchdog Timer Use"" && ipmitool mc watchdog get | grep "Watchdog Timer Use" && \
echo "# ipmitool raw 0x06 0x24 0x03 0x00 0x00 0x00 0x2c 0x01" && ipmitool raw 0x06 0x24 0x03 0x00 0x00 0x00 0x2c 0x01
echo "# ipmitool mc watchdog get | grep "Watchdog Timer Use"" && ipmitool mc watchdog get | grep "Watchdog Timer Use" && \
echo "# ipmitool raw 0x06 0x24 0x04 0x00 0x00 0x00 0x2c 0x01" && ipmitool raw 0x06 0x24 0x04 0x00 0x00 0x00 0x2c 0x01
echo "# ipmitool mc watchdog get | grep "Watchdog Timer Use"" && ipmitool mc watchdog get | grep "Watchdog Timer Use" && \
echo "# ipmitool raw 0x06 0x24 0x05 0x00 0x00 0x00 0x2c 0x01" && ipmitool raw 0x06 0x24 0x05 0x00 0x00 0x00 0x2c 0x01
echo "# ipmitool mc watchdog get | grep "Watchdog Timer Use"" && ipmitool mc watchdog get | grep "Watchdog Timer Use" && \
echo "*****************************************************************************************************************" && \
echo "ipmi test 15" && \
echo "# ipmitool raw 0x06 0x24 0x03 <opt> 0x00 0x00 0x2c 0x01 [<opt>：0x10 0x20 0x30]" && \
echo "# ipmitool raw 0x06 0x24 0x03 0x10 0x00 0x00 0x2c 0x01" && ipmitool raw 0x06 0x24 0x03 0x10 0x00 0x00 0x2c 0x01 && \
echo "# ipmitool raw 0x06 0x25" && ipmitool raw 0x06 0x25 && \
echo "# ipmitool raw 0x06 0x24 0x03 0x20 0x00 0x00 0x2c 0x01" && ipmitool raw 0x06 0x24 0x03 0x20 0x00 0x00 0x2c 0x01 && \
echo "# ipmitool raw 0x06 0x25" && ipmitool raw 0x06 0x25 && \
echo "# ipmitool raw 0x06 0x24 0x03 0x30 0x00 0x00 0x2c 0x01" && ipmitool raw 0x06 0x24 0x03 0x30 0x00 0x00 0x2c 0x01 && \
echo "# ipmitool raw 0x06 0x25" && ipmitool raw 0x06 0x25 && \
echo "*****************************************************************************************************************" && \
echo "ipmi test 16" && \
echo "# ipmitool raw 0x06 0x24 0x03 0x00 0x00 0x00 0x2c 0x01" && ipmitool raw 0x06 0x24 0x03 0x00 0x00 0x00 0x2c 0x01 && \
echo "# ipmitool raw 0x06 0x22" && ipmitool raw 0x06 0x22 &&  \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
if [[ $2 -eq 17 ]]
then
echo "*****************************************************************************************************************" && \
echo "ipmi test 17" && \
echo "# ipmitool raw 0x06 0x24 0x03 0x01 0x00 0x00 0x2c 0x01" && ipmitool raw 0x06 0x24 0x03 0x01 0x00 0x00 0x2c 0x01 && \
echo "# ipmitool raw 0x06 0x22" && ipmitool raw 0x06 0x22 && \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
echo && echo "----------------------------------------" && \
echo "*************************" && \
echo "*Please loss under order*" && \
echo "*************************" && \
echo "ipmitool mc watchdog off" && ipmitool mc watchdog off && \
echo "ipmitool mc watchdog get" && ipmitool mc watchdog get
fi
if [[ $3 -eq 18 ]]
then
echo "*****************************************************************************************************************" && \
echo "ipmi test 18" && \
echo "# ipmitool raw 0x06 0x24 0x03 0x02 0x00 0x00 0x2c 0x01" && ipmitool raw 0x06 0x24 0x03 0x02 0x00 0x00 0x2c 0x01 && \
echo "# ipmitool raw 0x06 0x22" && ipmitool raw 0x06 0x22 && \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
echo && echo "----------------------------------------" && \
echo "*************************" && \
echo "*Please loss under order*" && \
echo "*************************" && \
echo "ipmitool mc watchdog off" && ipmitool mc watchdog off && \
echo "ipmitool mc watchdog get" && ipmitool mc watchdog get
fi
if [[ $4 -eq 19 ]]
then
echo "*****************************************************************************************************************" && \
echo "ipmi test 19" && \
echo "# ipmitool raw 0x06 0x24 0x03 0x03 0x00 0x00 0x2c 0x01" && ipmitool raw 0x06 0x24 0x03 0x03 0x00 0x00 0x2c 0x01 && \
echo "# ipmitool raw 0x06 0x22" && ipmitool raw 0x06 0x22 && \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
echo && echo "----------------------------------------" && \
echo "*************************" && \
echo "*Please loss under order*" && \
echo "*************************" && \
echo "ipmitool mc watchdog off" && ipmitool mc watchdog off && \
echo "ipmitool mc watchdog get" && ipmitool mc watchdog get
fi
echo "*****************************************************************************************************************" && \
echo "ipmi test 20" && \
echo "# ipmitool raw 0x06 0x24 0x03 0x30 0x00 0x00 0xb8 0x0b" && ipmitool raw 0x06 0x24 0x03 0x30 0x00 0x00 0xb8 0x0b && \
echo "# ipmitool raw 0x06 0x22" && ipmitool raw 0x06 0x22 &&  \
echo "pass 0s" && \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
echo "# ipmitool mc watchdog reset" && ipmitool mc watchdog reset && \
echo "pass 4s" && sleep 4 && \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
echo "# ipmitool mc watchdog reset" && ipmitool mc watchdog reset && \
echo "pass 3s" && sleep 3 && \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
echo "# ipmitool mc watchdog reset" && ipmitool mc watchdog reset && \
echo "pass 2s" && sleep 2 && \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
echo "# ipmitool mc watchdog reset" && ipmitool mc watchdog reset && \
echo "pass 1s" && sleep 1 && \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
echo "# ipmitool mc watchdog reset" && ipmitool mc watchdog reset && \
echo "*****************************************************************************************************************" && \
echo "ipmi test 21" && \
echo "# ipmitool raw 0x06 0x24 0x03 0x31 0x22 0x00 0xb8 0x0b" && ipmitool raw 0x06 0x24 0x03 0x31 0x22 0x00 0xb8 0x0b && \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
echo "*****************************************************************************************************************" && \
echo "ipmi test 22" && \
echo "# ipmitool raw 0x06 0x24 0x03 0x30 0x00 0x00 0xb8 0x0b" && ipmitool raw 0x06 0x24 0x03 0x30 0x00 0x00 0xb8 0x0b && \
echo "# ipmitool raw 0x06 0x22" && ipmitool raw 0x06 0x22 &&  \
echo "pass 3s" && sleep 3 && \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
echo "# ipmitool mc watchdog reset" && ipmitool mc watchdog reset && \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
echo "*****************************************************************************************************************" && \
echo "ipmi test 23" && \
echo "# ipmitool raw 0x06 0x24 0x03 0x30 0x00 0x00 0xb8 0x0b" && ipmitool raw 0x06 0x24 0x03 0x30 0x00 0x00 0xb8 0x0b && \
echo "# ipmitool raw 0x06 0x22" && ipmitool raw 0x06 0x22 &&  \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
echo "# ipmitool mc watchdog off" && ipmitool mc watchdog off && \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && \
echo "*****************************************************************************************************************" && \
echo "ipmi test 24" && \
echo "# ipmitool raw 0x06 0x24 0x03 0x30 0x00 0x00 0xb8 0x0b" && ipmitool raw 0x06 0x24 0x03 0x30 0x00 0x00 0xb8 0x0b && \
echo "# ipmitool raw 0x06 0x22" && ipmitool raw 0x06 0x22 &&  \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && hwclock -r && \
echo "pass 2s" && sleep 2 && \
echo "# ipmitool mc watchdog get" && ipmitool mc watchdog get && hwclock -r && \
echo "*****************************************************************************************************************" && \
echo "ipmi test 25" && \
echo "# modprobe ipmi_poweroff" && modprobe ipmi_poweroff && \
echo "# lsmod |grep ipmi_poweroff" && lsmod |grep ipmi_poweroff && \
echo "# dmesg |grep 'IPMI poweroff: Found a ATCA style poweroff function'" && \
dmesg |grep 'IPMI poweroff: Found a ATCA style poweroff function' 
echo "*****************************************************************************************************************"
