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
source /var/lib/premium-script/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/v2ray/domain)
else
domain=$IP
fi
tls="$(cat ~/log-install.txt | grep -w "Vmess TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "Vmess None TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/v2ray/config.json | wc -l)

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
},{"id": "'""$uuid""'","alterId": '"2"',"email": "'""$user""'"' /etc/v2ray/config.json
sed -i '/#none$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"2"',"email": "'""$user""'"' /etc/v2ray/none.json
cat>/etc/v2ray/$user-tls.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${tls}",
      "id": "${uuid}",
      "aid": "2",
      "net": "ws",
      "path": "/myteam",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF
cat>/etc/v2ray/$user-none.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${none}",
      "id": "${uuid}",
      "aid": "2",
      "net": "ws",
      "path": "/myteam",
      "type": "none",
      "host": "",
      "tls": "none"
}
EOF
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmesslink1="vmess://$(base64 -w 0 /etc/v2ray/$user-tls.json)"
vmesslink2="vmess://$(base64 -w 0 /etc/v2ray/$user-none.json)"
systemctl restart v2ray
systemctl restart v2ray@none
service cron restart
clear
echo -e ""
echo -e "×××××××××××××××××××××××××××××××××××"
echo -e "× PREMIUM VMESS-WS ACCOUNT        ×"
echo -e "× INFO PREMIUM VMESS-WS           ×"
echo -e "×××××××××××××××××××××××××××××××××××"
echo -e "ᗚ Remarks       • ${user}"
echo -e "ᗚ Domain        • ${domain}"
echo -e "ᗚ port TLS      • ${tls}"
echo -e "ᗚ port none TLS • ${none}"
echo -e "ᗚ id            • ${uuid}"
echo -e "ᗚ alterId       • 2"
echo -e "ᗚ Security      • auto"
echo -e "ᗚ network       • ws"
echo -e "ᗚ path          • /myteam"
echo -e "×××××××××××××××××××××××××××××××××××"
echo -e "ᗚ link TLS      • ${vmesslink1}"
echo -e "×××××××××××××××××××××××××××××××××××"
echo -e "ᗚ link none TLS • ${vmesslink2}"
echo -e "×××××××××××××××××××××××××××××××××××"
echo -e "ᗚ Expired On  • $exp"
echo -e "×××××××××××××××××××××××××××××××××××"
