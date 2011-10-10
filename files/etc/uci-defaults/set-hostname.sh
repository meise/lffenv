#!/bin/sh

MAC="`ip link show eth0 | grep "link/ether" | \
	sed "s/^[ ]*//" | cut -d' ' -f2 | sed "s/://g" | \
	tr 'a-z' 'A-Z'`"

# The MAC printed on the back of the router of the Dlink DIR-300
# is one smaller than on eth0
[ "`cat /etc/lff_profile`" = "lff-dlink-dir300" ] && \
	MAC="`printf "%012X\n" $((0x$MAC - 0x01))`"

uci set network.private.hostname="Freifunk-$MAC"
uci set network.mesh.hostname="Freifunk-$MAC"
uci set system.@system[0].hostname="Freifunk-$MAC"
uci set uhttpd.px5g.commonname="Freifunk-$MAC"
uci commit
