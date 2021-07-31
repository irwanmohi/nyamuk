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
read -p "Username : " Login
read -p "Password : " Pass
read -p "Expired (hari): " masaaktif

IP=$(wget -qO- icanhazip.com);
ssl="$(cat ~/log-install.txt | grep -w "Stunnel4" | cut -d: -f2)"
sqd="$(cat ~/log-install.txt | grep -w "Squid" | cut -d: -f2)"
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
sleep 1
echo Ping Host
echo Cek Hak Akses...
sleep 0.5
echo Permission Accepted
clear
sleep 0.5
echo Membuat Akun: $Login
sleep 0.5
echo Setting Password: $Pass
sleep 0.5
clear
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e ""
echo -e "×××××××××××××××××××××××××××××××××"
echo -e "× PREMIUM SSH & OPENVPN ACCOUNT ×"
echo -e "× INFO PREMIUM SSH & OPENVPN    ×"
echo -e "×××××××××××××××××××××××××××××××××"
echo -e " ᗚ Username • ๛ $Login"
echo -e " ᗚ Password • ๛ $Pass"
echo -e " ᗚ Expire • $exp"
echo -e "×××××××××××××××××××××××××××××××××"
echo -e " ᗚ IP • ๛ $IP"
echo -e " ࿂ SSH • 22"
echo -e " ࿂ Dropbear • 109, 143"
echo -e " ࿂ SSL/TLS • $ssl"
echo -e " ࿂ SQUID • $sqd"
echo -e " ࿂ MAGIC SSH PROXY • 8180"
echo -e " ࿂ MAGIC OVPN PROXY • 8000"
echo -e " ࿂ BADVPN • 7100-7300"
echo -e "×××××××××××××××××××××××××××××××××"
echo -e "PAYLOAD MAGIC PROXY"                                                          
echo -e "GET / HTTP/1.1[crlf]Host: $domain[crlf]Connection: Keep-Alive[crlf]User-Agent: [ua][crlf]Upgrade: websocket[crlf][crlf]"
echo -e "×××××××××××××××××××××××××××××××××"
echo -e "SETING HOST SSH"               
echo -e "bugisisendiri:8180@$Login:$Pass"
echo -e "×××××××××××××××××××××××××××××××××"
echo -e "××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××"
echo -e " ࿂ CONFIG DOWNLOAD OPENVPN DI BAWAH"
echo -e " ࿂ OPENVPN • TCP $ovpn http://$IP:81/client-tcp-$ovpn.ovpn"
echo -e " ࿂ OPENVPN • UDP $ovpn2 http://$IP:81/client-udp-$ovpn2.ovpn"
echo -e "××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××"
echo -e ""
