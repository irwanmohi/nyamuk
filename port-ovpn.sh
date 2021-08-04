#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- ifconfig.me/ip);
echo "Checking VPS"
IZIN=$( curl https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/siap/beta/ipvps | grep $MYIP )
if [ $MYIP = $IZIN ]; then
echo -e "${green}Permission Accepted...${NC}"
else
echo -e "${red}Permission Denied!${NC}";
echo "Only For Premium Users"
exit 0
fi
clear
MYIP=$(wget -qO- ifconfig.me/ip);
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
echo -e "××××××××××××××××××××××××××××××××××××××"
echo -e ""
echo -e "     [1]  Change Port TCP $ovpn"
echo -e "     [2]  Change Port UDP $ovpn2"
echo -e "     [x]  Exit"
echo -e "××××××××××××××××××××××××××××××××××××××"
echo -e ""
read -p "     Select From Options [1-2 or x] :  " prot
echo -e ""
case $prot in
1)
read -p "New Port OpenVPN: " vpn
if [ -z $vpn ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $vpn)
if [[ -z $cek ]]; then
rm -f /etc/openvpn/server-tcp.conf
rm -f /root/ovpn-config/client-tcp.ovpn
rm -f /home/vps/public_html/client-tcp.ovpn
cat > /etc/openvpn/server-tcp.conf<<END
port $vpn
proto tcp
dev tun
ca key/ca.crt
cert key/server.crt
key key/server.key
dh key/dh.pem
verify-client-cert none
server 172.29.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1"
keepalive 10 120
persist-key
persist-tun
persist-remote-ip
ncp-disable
duplicate-cn
cipher none
auth none
status /var/log/openvpn/openvpn-status.log
log /var/log/openvpn/openvpn.log
verb 3
mute 10
plugin openvpn-plugin-auth-pam.so login
username-as-common-name
socket-flags TCP_NODELAY
push "socket-flags TCP_NODELAY"
END
cat > /root/ovpn-config/client-tcp.ovpn <<-END
# My Team VPN Premium Script
# Thanks for using this script, Enjoy Highspeed OpenVPN Service
client
dev tun
proto tcp
remote $MYIP $vpn
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher none
auth none
verb 3
auth-user-pass
http-proxy-retry
http-proxy $MYIP 8080
http-proxy-option CUSTOM-HEADER Protocol HTTP/1.1
http-proxy-option CUSTOM-HEADER Host HOST
http-proxy-option CUSTOM-HEADER X-Online-Host HOST
http-proxy-option CUSTOM-HEADER X-Forward-Host HOST
http-proxy-option CUSTOM-HEADER Connection Keep-Alive
dhcp-option DNS 8.8.8.8
dhcp-option DNS 8.8.4.4
END
echo '<ca>' >> /etc/openvpn/client-tcp.ovpn
cat /etc/openvpn/key/ca.crt >> /root/ovpn-config/client-tcp.ovpn
echo '</ca>' >> /root/ovpn-config/client-tcp.ovpn
cp /root/ovpn-config/client-tcp.ovpn /home/vps/public_html/client-tcp.ovpn
systemctl disable --now openvpn@server-tcp > /dev/null
systemctl enable --now openvpn@server-tcp > /dev/null
sed -i "s/   - OpenVPN                 : TCP $ovpn, UDP $ovpn2, SSL 442/   - OpenVPN                 : TCP $vpn, UDP $ovpn2, SSL 442/g" /root/log-install.txt
sed -i "s/$ovpn/$vpn/g" /etc/stunnel/stunnel.conf
echo -e "\e[032;1mPort $vpn modified successfully\e[0m"
else
echo "Port $vpn is used"
fi
;;
2)
read -p "New Port OpenVPN: " vpn
if [ -z $vpn ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $vpn)
if [[ -z $cek ]]; then
rm -f /root/ovpn-config/client-udp.ovpn
rm -f /etc/openvpn/server-udp.conf
rm -f /home/vps/public_html/client-udp.ovpn
cat > /etc/openvpn/server-udp.conf<<END
port $vpn
proto udp
dev tun
ca key/ca.crt
cert key/server.crt
key key/server.key
dh key/dh.pem
verify-client-cert none
server 172.29.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1"
keepalive 10 120
persist-key
persist-tun
persist-remote-ip
ncp-disable
duplicate-cn
cipher none
auth none
status /var/log/openvpn/openvpn-status.log
log /var/log/openvpn/openvpn.log
verb 3
mute 10
plugin openvpn-plugin-auth-pam.so login
username-as-common-name
socket-flags TCP_NODELAY
push "socket-flags TCP_NODELAY"
END
cat > /root/ovpn-config/client-udp.ovpn <<-END
# My Team VPN Premium Script
# Thanks for using this script, Enjoy Highspeed OpenVPN Service
client
dev tun
proto udp
remote $MYIP $vpn
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher none
auth none
verb 3
auth-user-pass
dhcp-option DNS 8.8.8.8
dhcp-option DNS 8.8.4.4
END
echo '<ca>' >> /root/ovpn-config/client-udp.ovpn
cat /etc/openvpn/key/ca.crt >> /root/ovpn-config/client-udp.ovpn
echo '</ca>' >> /root/ovpn-config/client-udp.ovpn
cp /root/ovpn-config/client-udp.ovpn /home/vps/public_html/client-udp.ovpn
systemctl disable --now openvpn@server-udp > /dev/null
systemctl enable --now openvpn@server-udp > /dev/null
sed -i "s/   - OpenVPN                 : TCP $ovpn, UDP $ovpn2, SSL 442/   - OpenVPN                 : TCP $vpn, UDP $ovpn2, SSL 442/g" /root/log-install.txt
sed -i "s/$ovpn/$vpn/g" /etc/stunnel/stunnel.conf
echo -e "\e[032;1mPort $vpn modified successfully\e[0m"
else
echo "Port $vpn is used"
fi
;;
x)
exit
menu
;;
*)
echo "Please enter an correct number"
;;
esac

