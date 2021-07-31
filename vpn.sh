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
sed -i 's|#set_var EASYRSA_REQ_PROVINCE\t"California"|set_var EASYRSA_REQ_PROVINCE\t"Kedah"|g' /etc/openvpn/easy-rsa/vars
sed -i 's|#set_var EASYRSA_REQ_CITY\t"San Francisco"|set_var EASYRSA_REQ_CITY\t"Bandar Baharu"|g' /etc/openvpn/easy-rsa/vars
sed -i 's|#set_var EASYRSA_REQ_ORG\t"Copyleft Certificate Co"|set_var EASYRSA_REQ_ORG\t\t"Void VPN"|g' /etc/openvpn/easy-rsa/vars
sed -i 's|#set_var EASYRSA_REQ_EMAIL\t"me@example.net"|set_var EASYRSA_REQ_EMAIL\t"aimanamir.work@outlook.com"|g' /etc/openvpn/easy-rsa/vars
sed -i 's|#set_var EASYRSA_REQ_OU\t\t"My Organizational Unit"|set_var EASYRSA_REQ_OU\t\t"Void VPN Premium"|g' /etc/openvpn/easy-rsa/vars
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
wget -qO /etc/openvpn/server-udp.conf "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/openvpn/server-udp.conf"
wget -qO /etc/openvpn/server-tcp.conf "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/openvpn/server-tcp.conf"
sed -i "s|#AUTOSTART="all"|AUTOSTART="all"|g" /etc/default/openvpn
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
systemctl start openvpn@server-udp
systemctl start openvpn@server-tcp
systemctl enable openvpn@server-udp
systemctl enable openvpn@server-tcp

# Configure OpenVPN client configuration
mkdir /root/ovpn-config
wget -qO /root/ovpn-config/client-udp.ovpn "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/openvpn/client-udp.ovpn"
wget -qO /root/ovpn-config/client-tcp.ovpn "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/openvpn/client-tcp.ovpn"
sed -i "s|xxx.xxx.xxx.xxx|$ipAddress|g" /root/ovpn-config/client-udp.ovpn
sed -i "s|xxx.xxx.xxx.xxx|$ipAddress|g" /root/ovpn-config/client-tcp.ovpn
echo "" >> /root/ovpn-config/client-tcp.ovpn
echo "<ca>" >> /root/ovpn-config/client-tcp.ovpn
cat "/etc/openvpn/key/ca.crt" >> /root/ovpn-config/client-tcp.ovpn
echo "</ca>" >> /root/ovpn-config/client-tcp.ovpn
echo "" >> /root/ovpn-config/client-udp.ovpn
echo "<ca>" >> /root/ovpn-config/client-udp.ovpn
cat "/etc/openvpn/key/ca.crt" >> /root/ovpn-config/client-udp.ovpn
echo "</ca>" >> /root/ovpn-config/client-udp.ovpn
cp /root/ovpn-config/client-tcp.ovpn /home/vps/public_html/client-tcp.ovpn
cp /root/ovpn-config/client-udp.ovpn /home/vps/public_html/client-udp.ovpn

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
