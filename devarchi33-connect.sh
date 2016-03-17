#!/bin/bash

IP={user.ip}
PEM={user.pem}
USER=ec2-user
CONNECT_HOME=`pwd`

echo
if [ $# -ne 1 ]
then
        echo "Usage: $0 { ssh | sftp }"
        exit 1
fi

case "$1" in
'ssh')
        echo 'connect by ssh'
	PROTOCOL=$1
	$PROTOCOL -i "$CONNECT_HOME/$PEM" $USER@$IP;;
'sftp')
        echo 'connect by sftp'
	PROTOCOL=$1
	$PROTOCOL -i "$CONNECT_HOME/$PEM" $USER@$IP;;
*)
	echo "Usage: $0 { ssh | sftp }"
        exit 1
        ;;
esac
