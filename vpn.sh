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
apt-get install -y openvpn
wget -q https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/EasyRSA-3.0.8.tgz
tar xvf EasyRSA-3.0.8.tgz
rm EasyRSA-3.0.8.tgz
mv EasyRSA-3.0.8 /etc/openvpn/easy-rsa
cp /etc/openvpn/easy-rsa/vars.example /etc/openvpn/easy-rsa/vars
sed -i 's|#set_var EASYRSA_REQ_COUNTRY\t"US"|set_var EASYRSA_REQ_COUNTRY\t"MY"|g' /etc/openvpn/easy-rsa/vars
sed -i 's|#set_var EASYRSA_REQ_PROVINCE\t"California"|set_var EASYRSA_REQ_PROVINCE\t"Kelantan"|g' /etc/openvpn/easy-rsa/vars
sed -i 's|#set_var EASYRSA_REQ_CITY\t"San Francisco"|set_var EASYRSA_REQ_CITY\t"Kota Bharu"|g' /etc/openvpn/easy-rsa/vars
sed -i 's|#set_var EASYRSA_REQ_ORG\t"Copyleft Certificate Co"|set_var EASYRSA_REQ_ORG\t\t"My Team"|g' /etc/openvpn/easy-rsa/vars
sed -i 's|#set_var EASYRSA_REQ_EMAIL\t"me@example.net"|set_var EASYRSA_REQ_EMAIL\t"akuvps@gmail.com"|g' /etc/openvpn/easy-rsa/vars
sed -i 's|#set_var EASYRSA_REQ_OU\t\t"My Organizational Unit"|set_var EASYRSA_REQ_OU\t\t"My Team Premium Vpn"|g' /etc/openvpn/easy-rsa/vars
sed -i 's|#set_var EASYRSA_CA_EXPIRE\t3650|set_var EASYRSA_CA_EXPIRE\t3650|g' /etc/openvpn/easy-rsa/vars
sed -i 's|#set_var EASYRSA_CERT_EXPIRE\t825|set_var EASYRSA_CERT_EXPIRE\t3650|g' /etc/openvpn/easy-rsa/vars
cd /etc/openvpn/easy-rsa
./easyrsa --batch init-pki
./easyrsa --batch build-ca nopass
./easyrsa gen-dh
./easyrsa build-server-full server nopass
cd
mkdir /etc/openvpn/key
cp /etc/openvpn/easy-rsa/pki/issued/server.crt /etc/openvpn/key/
cp /etc/openvpn/easy-rsa/pki/ca.crt /etc/openvpn/key/
cp /etc/openvpn/easy-rsa/pki/dh.pem /etc/openvpn/key/
cp /etc/openvpn/easy-rsa/pki/private/server.key /etc/openvpn/key/
cat > /etc/openvpn/server/server-tcp-1194.conf<<END
port 1194
proto tcp
dev tun
ca key/ca.crt
cert key/server.crt
key key/server.key
dh key/dh.pem
verify-client-cert none
username-as-common-name
key-direction 0
status /var/log/openvpn/openvpn-status.log
log /var/log/openvpn/openvpn.log
plugin openvpn-plugin-auth-pam.so login
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
verb 3
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
cat /etc/openvpn/key/ca.crt >> /etc/openvpn/client-tcp-1194.ovpn
echo '</ca>' >> /etc/openvpn/client-tcp-1194.ovpn
cp /etc/openvpn/client-tcp-1194.ovpn /home/vps/public_html/client-tcp-1194.ovpn
systemctl start openvpn@server-tcp
systemctl enable openvpn@server-tcp

cat > /etc/openvpn/server/server-udp-2200.conf<<END
port 2200
proto udp
dev tun
ca key/ca.crt
cert key/server.crt
key key/server.key
dh key/dh.pem
verify-client-cert none
username-as-common-name
key-direction 0
status /var/log/openvpn/openvpn-status.log
log /var/log/openvpn/openvpn.log
plugin openvpn-plugin-auth-pam.so login
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
verb 3
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
cat /etc/openvpn/key/ca.crt >> /etc/openvpn/client-udp-2200.ovpn
echo '</ca>' >> /etc/openvpn/client-udp-2200.ovpn
cp /etc/openvpn/client-udp-2200.ovpn /home/vps/public_html/client-udp-2200.ovpn
systemctl start openvpn@server-udp
systemctl enable openvpn@server-udp

# Copy config OpenVPN client ke home directory root agar mudah didownload ( TCP 1194 )
cp /etc/openvpn/client-tcp-1194.ovpn /home/vps/public_html/client-tcp-1194.ovpn

# Copy config OpenVPN client ke home directory root agar mudah didownload ( UDP 2200 )
cp /etc/openvpn/client-udp-2200.ovpn /home/vps/public_html/udp.ovpn

sed -i "s|#AUTOSTART="all"|AUTOSTART="all"|g" /etc/default/openvpn

# restart openvpn dan cek status openvpn
systemctl enable --now openvpn-server@server-tcp-1194
systemctl enable --now openvpn-server@server-udp-2200
/etc/init.d/openvpn restart
/etc/init.d/openvpn status

# aktifkan ip4 forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf

# Configure UFW
apt-get install -y ufw
echo "" >> /etc/ufw/before.rules
echo "# START OPENVPN RULES" >> /etc/ufw/before.rules
echo "# NAT table rules" >> /etc/ufw/before.rules
echo "*nat" >> /etc/ufw/before.rules
echo ":POSTROUTING ACCEPT [0:0]" >> /etc/ufw/before.rules
echo "# Allow traffic from OpenVPN client to eth0" >> /etc/ufw/before.rules
echo "-I POSTROUTING -s 192.168.10.0/24 -o eth0 -j MASQUERADE" >> /etc/ufw/before.rules
echo "-I POSTROUTING -s 192.168.11.0/24 -o eth0 -j MASQUERADE" >> /etc/ufw/before.rules
echo "COMMIT" >> /etc/ufw/before.rules
echo "# END OPENVPN RULES" >> /etc/ufw/before.rules
sed -i 's|DEFAULT_FORWARD_POLICY="DROP"|DEFAULT_FORWARD_POLICY="ACCEPT"|g' /etc/default/ufw
sed -i "s|IPV6=yes|IPV6=no|g" /etc/default/ufw
ufw allow 22
ufw allow 143
ufw allow 109
ufw allow 8080
ufw allow 8181
ufw allow 8888
ufw allow 8180
ufw allow 8000
ufw allow 1194
ufw allow 2200
ufw allow 81
ufw allow 444
ufw allow 666
ufw allow 442
ufw allow 443
ufw allow 500
ufw allow 888
ufw allow 880
ufw allow 550
ufw allow 7070
ufw allow 1443:1543
ufw allow 2443:2543
ufw allow 3443:3543
ufw disable
echo "y" | ufw enable
ufw reload

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
