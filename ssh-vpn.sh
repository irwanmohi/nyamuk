#!/bin/bash 

# initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

# install wget and curl and update
apt -y install wget curl
apt update
apt upgrade
apt-get update
apt-get upgrade -y

# Install Ssl & Certificates
apt install ssl-cert
apt install ca-certificates
sudo apt-get install apt-transport-https gnupg2 curl

# Removing some firewall tools that may affect other services
apt-get remove --purge ufw firewalld -y
 
# Installing some important machine essentials
apt-get install nano zip unzip tar gzip p7zip-full bc rc openssl cron net-tools dnsutils dos2unix screen bzip2 ccrypt -y
 
# Now installing all our wanted services
apt-get install dropbear stunnel4 ca-certificates nginx ruby apt-transport-https lsb-release squid3 -y

# Installing all required packages to install Webmin
apt-get install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python dbus libxml-parser-perl -y
apt-get install shared-mime-info jq fail2ban -y

 
# Installing a text colorizer
gem install lolcat

# Trying to remove obsolette packages after installation
apt-get autoremove -y

# simple password minimal
wget -q -O /etc/pam.d/common-password "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/password"
chmod +x /etc/pam.d/common-password

# Removing some duplicated sshd server configs
rm -f /etc/ssh/sshd_config*
 
# Creating a SSH server config using cat eof tricks
cat > /etc/ssh/sshd_config <<-END
# My OpenSSH Server config
Port 22
AddressFamily inet
ListenAddress 0.0.0.0
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
PermitRootLogin yes
MaxSessions 1024
PubkeyAuthentication yes
PasswordAuthentication yes
PermitEmptyPasswords no
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding yes
PrintMotd no
ClientAliveInterval 240
ClientAliveCountMax 2
UseDNS no
Banner no
AcceptEnv LANG LC_*
Subsystem   sftp  /usr/lib/openssh/sftp-server
END

# Restarting openssh service
systemctl restart ssh

# go to root
cd

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local

# set nameserver
rm -f /etc/resolv.conf
cat > /etc/resolv.conf <<-END
nameserver 8.8.8.8
nameserver 8.8.4.4
END

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# set time UMT +8
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# install
apt-get --reinstall --fix-missing install -y bzip2 gzip coreutils wget screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl neofetch git lsof
echo "clear" >> .profile
echo "neofetch" >> .profile
echo "echo BY MYTEAM SCRIPT" >> .profile
echo "echo PREMIUM VPS SCRIPT STABLE" >> .profile

# install webserver
apt -y install nginx
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -q -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/nginx.conf"
mkdir -p /home/vps/public_html
wget -q -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/vps.conf"
/etc/init.d/nginx restart

# install badvpn
cd
wget -q -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/badvpn-udpgw64"
chmod +x /usr/bin/badvpn-udpgw
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500

# setting port ssh
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config

# creating dropbear config using cat eof tricks
apt -y install dropbear
cat > /etc/default/dropbear <<-END
# My Dropbear Config
NO_START=0
DROPBEAR_PORT=109
DROPBEAR_EXTRA_ARGS="-p 143"
DROPBEAR_BANNER="/etc/banner"
DROPBEAR_RSAKEY="/etc/dropbear/dropbear_rsa_host_key"
DROPBEAR_DSSKEY="/etc/dropbear/dropbear_dss_host_key"
DROPBEAR_ECDSAKEY="/etc/dropbear/dropbear_ecdsa_host_key"
DROPBEAR_RECEIVE_WINDOW=65536
END
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart

# install squid
cd
wget -q -O /etc/squid/squid.conf "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf

# setting vnstat
apt -y install vnstat
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6

# Creating stunnel certifcate using openssl
openssl req -new -x509 -days 9999 -nodes -subj "/C=PH/ST=NCR/L=Kuala_Lumpur/O=Myteam/OU=Myteam/CN=Myteam" -out /etc/stunnel/stunnel.pem -keyout /etc/stunnel/stunnel.pem &> /dev/null
##  > /dev/null 2>&1

# Creating stunnel server config
cat > /etc/stunnel/stunnel.conf <<-END
pid = /var/run/stunnel.pid
cert = /etc/stunnel/stunnel.pem
client = no
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
TIMEOUTclose = 0
[ssh]
accept = 444
connect = 127.0.0.1:22
[dropbear]
accept = 666
connect = 127.0.0.1:143
END

# konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

#Ohp Tools
apt -y install python
apt -y install tmux
apt -y install figlet

#OpenVPN
wget -q https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/vpn.sh &&  chmod +x vpn.sh && ./vpn.sh

# Some workaround for OpenVZ machines for "Startup error" openvpn service
if [[ "$(hostnamectl | grep -i Virtualization | awk '{print $2}' | head -n1)" == 'openvz' ]]; then
sed -i 's|LimitNPROC|#LimitNPROC|g' /lib/systemd/system/openvpn*
systemctl daemon-reload
fi

# install fail2ban
apt -y install fail2ban

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'

# banner /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/issue.net"
echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

# blockir torrent
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# download script
cd
cd /usr/bin
wget -O add-host "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/add-host.sh"
wget -O about "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/about.sh"
wget -q -O menu "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/chknetLlLlLLLLllll/beta/menu.sh"
wget -O usernew "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/trial.sh"
wget -O hapus "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/hapus.sh"
wget -O member "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/member.sh"
wget -O delete "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/delete.sh"
wget -O cek "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/cek.sh"
wget -O restart "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/restart.sh"
wget -O speedtest "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/speedtest_cli.py"
wget -O info "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/info.sh"
wget -O ram "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/ram.sh"
wget -O renew "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/renew.sh"
wget -O autokill "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/autokill.sh"
wget -O ceklim "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/ceklim.sh"
wget -O tendang "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/tendang.sh"
wget -O clear-log "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/clear-log.sh"
wget -O change-port "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/change.sh"
wget -O port-ovpn "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/port-ovpn.sh"
wget -O port-ssl "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/port-ssl.sh"
wget -O port-wg "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/port-wg.sh"
wget -O port-tr "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/port-tr.sh"
wget -O port-squid "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/port-squid.sh"
wget -O port-ws "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/port-ws.sh"
wget -O port-vless "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/port-vless.sh"
wget -O wbmn "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/webmin.sh"
wget -O xp "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/xp.sh"
wget -O update "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/update.sh"
wget -O strt "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/strt.sh"
wget -O swap "https://raw.githubusercontent.com/LolLloLlLolLlLolL-rgb/nyamuk/beta/swapkvm.sh"
chmod +x add-host
chmod +x menu
chmod +x usernew
chmod +x trial
chmod +x hapus
chmod +x member
chmod +x delete
chmod +x cek
chmod +x restart
chmod +x speedtest
chmod +x info
chmod +x about
chmod +x autokill
chmod +x tendang
chmod +x ceklim
chmod +x ram
chmod +x renew
chmod +x clear-log
chmod +x change-port
chmod +x port-ovpn
chmod +x port-ssl
chmod +x port-wg
chmod +x port-tr
chmod +x port-squid
chmod +x port-ws
chmod +x port-vless
chmod +x wbmn
chmod +x xp
chmod +x update
chmod +x strt
chmod +x swap
echo "0 5 * * * root clear-log && reboot" >> /etc/crontab
echo "0 0 * * * root xp" >> /etc/crontab
# remove unnecessary files
cd
apt autoclean -y
apt -y remove --purge unscd
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove bind9*;
apt-get -y remove sendmail*
apt autoremove -y
# finishing
cd
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/nginx restart
/etc/init.d/openvpn restart
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/stunnel4 restart
/etc/init.d/vnstat restart
/etc/init.d/squid restart
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500
history -c
echo "unset HISTFILE" >> /etc/profile

cd
rm -f /root/key.pem
rm -f /root/cert.pem
rm -f /root/ssh-vpn.sh

# finihsing
clear
