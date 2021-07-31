#!/bin/bash
#
# By MYTEAM
# ==================================================

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ifconfig.me/ip);
MYIP2="s/xxxxxxxxx/$MYIP/g";
ANU=$(ip -o $ANU -4 route show to default | awk '{print $5}');

# Install OpenVPN dan Easy-RSA
apt install openvpn easy-rsa unzip -y
apt install openssl iptables iptables-persistent -y
mkdir -p /etc/openvpn/server/easy-rsa/
cd /etc/openvpn/
wget https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/vpn.zip
unzip vpn.zip
rm -f vpn.zip
chown -R root:root /etc/openvpn/server/easy-rsa/

cd
mkdir -p /usr/lib/openvpn/
cp /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so /usr/lib/openvpn/openvpn-plugin-auth-pam.so

# nano /etc/default/openvpn
sed -i 's/#AUTOSTART="all"/AUTOSTART="all"/g' /etc/default/openvpn

# restart openvpn dan cek status openvpn
systemctl enable --now openvpn-server@server-tcp-1194
systemctl enable --now openvpn-server@server-udp-2200
/etc/init.d/openvpn restart
/etc/init.d/openvpn status

# aktifkan ip4 forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf

# Removing all existing openvpn server files
rm -f /etc/openvpn/server/server-tcp-1194.conf
rm -f /etc/openvpn/client-tcp-1194.ovpn
rm -f /home/vps/public_html/client-tcp-1194.ovpn
cat > /etc/openvpn/server/server-tcp-1194.conf<<END
port 1194
proto tcp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh2048.pem
verify-client-cert none
username-as-common-name
key-direction 0
plugin /etc/openvpn/plugins/openvpn-plugin-auth-pam.so login
server 192.168.10.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "route-method exe"
push "route-delay 2"
keepalive 10 120
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
log tcp.log
verb 2
ncp-disable
cipher none
auth none
END
cat > /etc/openvpn/client-tcp-1194.ovpn <<-END
# My Team VPN Premium Script
# Thanks for using this script, Enjoy Highspeed OpenVPN Service
client
dev tun
proto tcp
setenv FRIENDLY_NAME "MyteamTcp"
remote $MYIP 1194
remote-cert-tls server
connect-retry infinite
resolv-retry infinite
nobind
persist-key
persist-tun
auth-user-pass
auth none
auth-nocache
cipher none
comp-lzo
redirect-gateway def1
setenv CLIENT_CERT 0
reneg-sec 0
verb 1
http-proxy $MYIP 8080
http-proxy-option VERSION 1.1
http-proxy-option AGENT Chrome/80.0.3987.87
http-proxy-option CUSTOM-HEADER Host bug.com
http-proxy-option CUSTOM-HEADER X-Forward-Host bug.com
http-proxy-option CUSTOM-HEADER X-Forwarded-For bug.com
http-proxy-option CUSTOM-HEADER Referrer bug.com
dhcp-option DNS 8.8.8.8
dhcp-option DNS 8.8.4.4
END
echo '<ca>' >> /etc/openvpn/client-tcp-1194.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/client-tcp-1194.ovpn
echo '</ca>' >> /etc/openvpn/client-tcp-1194.ovpn
cp /etc/openvpn/client-tcp-1194.ovpn /home/vps/public_html/client-tcp-1194.ovpn
systemctl disable --now openvpn-server@server-tcp-1194 > /dev/null
systemctl enable --now openvpn-server@server-tcp-1194 > /dev/null

rm -f /etc/openvpn/server/server-udp-2200.conf
rm -f /etc/openvpn/client-udp-2200.ovpn
rm -f /home/vps/public_html/client-tcp-2200.ovpn
cat > /etc/openvpn/server/server-udp-2200.conf<<END
port 2200
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh2048.pem
verify-client-cert none
username-as-common-name
key-direction 0
plugin /etc/openvpn/plugins/openvpn-plugin-auth-pam.so login
server 192.168.11.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "route-method exe"
push "route-delay 2"
keepalive 10 120
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
log udp.log
verb 2
ncp-disable
cipher none
auth none
END
cat > /etc/openvpn/client-udp-2200.ovpn <<-END
# My Team VPN Premium Script
# Thanks for using this script, Enjoy Highspeed OpenVPN Service
client
dev tun
proto udp
setenv FRIENDLY_NAME "MyTeamUdp"
remote $MYIP 2200
remote-cert-tls server
resolv-retry infinite
float
fast-io
nobind
persist-key
persist-remote-ip
persist-tun
auth-user-pass
auth none
auth-nocache
cipher none
comp-lzo
redirect-gateway def1
setenv CLIENT_CERT 0
reneg-sec 0
verb 1
END
echo '<ca>' >> /etc/openvpn/client-udp-2200.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/client-udp-2200.ovpn
echo '</ca>' >> /etc/openvpn/client-udp-2200.ovpn
cp /etc/openvpn/client-udp-2200.ovpn /home/vps/public_html/client-udp-2200.ovpn
systemctl disable --now openvpn-server@server-udp-2200 > /dev/null
systemctl enable --now openvpn-server@server-udp-2200 > /dev/null

# Copy config OpenVPN client ke home directory root agar mudah didownload ( TCP 1194 )
cp /etc/openvpn/client-tcp-1194.ovpn /home/vps/public_html/client-tcp-1194.ovpn

# Copy config OpenVPN client ke home directory root agar mudah didownload ( UDP 2200 )
cp /etc/openvpn/client-udp-2200.ovpn /home/vps/public_html/udp.ovpn

cd
wget https://github.com/LolLloLlLolLlLolL-rgb/nyamuk/blob/beta/plugin.tgz
tar -xzvf /root/plugin.tgz -C /etc/openvpn/
rm -f plugin.tgz

iptables -t nat -I POSTROUTING -s 192.168.10.0/24 -o $ANU -j MASQUERADE
iptables -t nat -I POSTROUTING -s 192.168.11.0/24 -o $ANU -j MASQUERADE
iptables-save > /etc/iptables.up.rules
chmod +x /etc/iptables.up.rules

iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# Restart service openvpn
systemctl enable openvpn
systemctl start openvpn
/etc/init.d/openvpn restart

# Delete script
history -c
rm -f /root/vpn.sh
