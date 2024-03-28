#!/usr/bin/bash
IP=$1
USER=$2
PASSWD=$3
ACTION=$4
OUTLET=$5
for outlet in ${OUTLET}
do
/usr/bin/expect <<EOF
set timeout 10
spawn ssh $USER@$IP
expect {
	"*password*" {
			    send "$PASSWD\n"
		    }
	"*yes/no*" {
			    send "yes\n"
			    expect "*password*"
			    send "$PASSWD\n"
		    }
}
sleep 5
expect "apc>"
send "$ACTION $outlet\r"
sleep 5
expect "apc>"
send "exit\r"
EOF
done
