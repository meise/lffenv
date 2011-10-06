#!/bin/sh

KEY="`pwgen -c -n -s 63 1`"
MAC="`ip link show eth0 | grep "link/ether" | \
	sed "s/^[ ]*//" | cut -d' ' -f2 | sed "s/://g" | \
	tr 'a-z' 'A-Z'`"

uci set wireless.wifi_private.key="$KEY"
uci set wireless.wifi_private.ssid="private-$MAC"
uci commit
