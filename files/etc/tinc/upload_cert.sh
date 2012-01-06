#!/bin/sh
UPLOAD_URL="http://212.201.68.130:8080/ff-serv/tincs.txt"
CURLC=`which curl`
TINC_NAME="`ip link show eth0 | grep "link/ether" | sed "s/^[ ]*//" | cut -d' ' -f2 | sed "s/://g"`"
CERT_FILE="/etc/tinc/intracity/hosts/$TINC_NAME"


for cnt in $(seq 1 100);
do
        $CURLC -k -F "cert=@$CERT_FILE" $UPLOAD_URL -u $TINC_NAME:$TINC_NAME && break
        sleep 10
done