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
echo "Only For Premium User"
exit 0
fi
clear
source /var/lib/premium-script/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/v2ray/domain)
else
domain=$IP
fi
tls="$(cat ~/log-install.txt | grep -w "Vless TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "Vless None TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/v2ray/vless.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			exit 1
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/v2ray/vless.json
sed -i '/#none$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/v2ray/vnone.json
vlesslink1="vless://${uuid}@${domain}:$tls?path=/myteam&security=tls&encryption=none&type=ws#${user}"
vlesslink2="vless://${uuid}@${domain}:$none?path=/myteam&encryption=none&type=ws#${user}"
systemctl restart v2ray@vless
systemctl restart v2ray@vnone
clear
echo -e ""
echo -e "×××××××××××××××××××××××××××××××××"
echo -e "× PREMIUM VLESS ACCOUNT         ×"
echo -e "× INFO PREMIUM VLESS            ×"
echo -e "×××××××××××××××××××××××××××××××××"
echo -e "ᗚ Remarks       • ${user}"
echo -e "ᗚ Domain        • ${domain}"
echo -e "ᗚ port TLS      • $tls"
echo -e "ᗚ port none TLS • $none"
echo -e "ᗚ id            • ${uuid}"
echo -e "ᗚ Encryption    • none"
echo -e "ᗚ network       • ws"
echo -e "ᗚ path          • /myteam"
echo -e "×××××××××××××××××××××××××××××××××"
echo -e "ᗚ link TLS • ${vlesslink1}"
echo -e "×××××××××××××××××××××××××××××××××"
echo -e "ᗚ link none TLS • ${vlesslink2}"
echo -e "×××××××××××××××××××××××××××××××××"
echo -e "ᗚ Expired On • $exp"
echo -e "×××××××××××××××××××××××××××××××××"
echo -e ""
