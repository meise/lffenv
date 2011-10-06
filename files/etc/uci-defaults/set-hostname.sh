#!/bin/sh

MAC="`ip link show eth0 | grep "link/ether" | \
	sed "s/^[ ]*//" | cut -d' ' -f2 | sed "s/://g" | \
	tr 'a-z' 'A-Z'`"

uci set network.private.hostname="Freifunk-$MAC"
uci set network.mesh.hostname="Freifunk-$MAC"
uci set system.@system[0].hostname="Freifunk-$MAC"
uci set uhttpd.px5g.commonname="Freifunk-$MAC"
uci commit
