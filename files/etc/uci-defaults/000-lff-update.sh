#!/bin/sh

topdir() {
	echo $1 | sed "s/\/[^/]*$//"
}

update_config_file() {
	[ -f "/overlay$1" ] || return

	dir="`topdir $1`"
	[ ! -d "/usr/backups$dir" ] && mkdir -p /usr/backups$dir
	cp $1 /usr/backups$dir

	cp /rom$1 $1
}

update_3micc_intracity_v0_1() {
	[ -d /etc/tinc/3micc ] || return

	MAC="`ip link show eth0 | grep "link/ether" | \
		sed "s/^[ ]*//" | cut -d' ' -f2 | sed "s/://g"`"

	name="`grep 'Name[\t ]*=' /etc/tinc/3micc/tinc.conf | sed 's/^Name[^=]*=[\t ]*//'`"
	([ -z "$name" ] || [ ! -f "/etc/tinc/3micc/hosts/$name" ]) && return

	[ ! -d "/usr/backups/etc" ] && mkdir -p /usr/backups/etc
	cp -r /etc/tinc /usr/backups/etc/

	mkdir -p /etc/tinc/intracity/hosts
	[ ! -d /etc/tinc/intracity/hosts ] && return

	[ -f /etc/tinc/3micc/hosts/aftermath ] && [ -f /etc/tinc/intracity/hosts/aftermath ] && \
		rm /etc/tinc/3micc/hosts/aftermath

	cp /etc/tinc/3micc/rsa_key.priv /etc/tinc/intracity/
	cp /etc/tinc/3micc/hosts/* /etc/tinc/intracity/hosts/
	[ ! -f /etc/tinc/intracity/tinc-up ] && cp /etc/tinc/3micc/tinc-up /etc/tinc/intracity/
	rm -r /etc/tinc/3micc

	mv /etc/tinc/intracity/hosts/$name /etc/tinc/intracity/hosts/$MAC
	[ -f /etc/tinc/nets.boot ] && rm /etc/tinc/nets.boot
}

# v0.1 to v0.2
update_v0_1() {
	update_config_file "/etc/config/network"
	update_config_file "/etc/config/wireless"
	update_config_file "/etc/config/batman-adv"
	update_config_file "/etc/config/uhttpd"
	update_config_file "/etc/config/tinc"
	update_config_file "/etc/firewall.user"
	update_config_file "/etc/opkg.conf"
	update_3micc_intracity_v0_1
}

[ ! -f /etc/.lff_version_keep ] && update_v0_1
cp /etc/lff_version /etc/.lff_version_keep
