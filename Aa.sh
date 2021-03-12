#!/bin/bash

echo -e "nameserver 2a09:11c0:f1:bbf0::70\nnameserver 2a01:4f8:c2c:123f::1" > /etc/resolv.conf
apt update && apt install curl sudo lsb-release iptables -y
if [ -f "/etc/apt/sources.list.d/backports.list" ]; then
	apt update
	else
	echo "deb http://deb.debian.org/debian $(lsb_release -sc)-backports main" | sudo tee /etc/apt/sources.list.d/backports.list
	apt update
fi
curl -fsSL git.io/wireguard-go.sh | sudo bash
curl -fsSL git.io/wgcf.sh | sudo bash
echo | wgcf register
wgcf generate
sed -i "s/engage.cloudflareclient.com/2606:4700:d0::a29f:c001/g" wgcf-profile.conf
sed -i 's/2620:fe::10,2001:4860:4860::8888,2606:4700:4700::1111/g' wgcf-profile.conf
sed -i '/\:\:\/0/d' wgcf-profile.conf
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
echo 'precedence  ::ffff:0:0/96   100' | sudo tee -a /etc/gai.conf
