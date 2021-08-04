#!/bin/bash
# Program: OHPServer Darknet
# Date: 03-08-2021
# Last Update: 04-08-2021

# installing ohpserver
if [[ -e /usr/bin/ohpserver  ]]; then
echo -e "ohpserver already install"
sleep 3;clear
else
echo -e "installing ohpserver"
sleep 3;clear
wget https://github.com/lfasmpao/open-http-puncher/releases/download/0.1/ohpserver-linux32.zip
unzip ohpserver-linux32.zip
rm *.zip
mv ohpserver /usr/bin/
chmod +x /usr/bin/ohpserver
fi

# adding darknet for ohpserver
if [[ -e /usr/bin/darknet  ]]; then
echo -e "darknet for ohpserver exist but will be update"
sleep 3;clear
rm /usr/bin/darknet
cat> /usr/bin/darknet << END
#!/bin/bash
screen -dmS dropbear ohpserver -port 8180 -proxy 127.0.0.1:8181 -tunnel 127.0.0.1:143
screen -dmS openvpn ohpserver -port 8188 -proxy 127.0.0.1:8181 -tunnel 127.0.0.1:1194
screen -dmS tls ohpserver -port 8844 -proxy 127.0.0.1:8181 -tunnel 127.0.0.1:444
END
chmod +x /usr/bin/darknet
else
echo -e "adding darknet for ohpserver"
sleep 3;clear
cat> /usr/bin/darknet << END
#!/bin/bash
screen -dmS dropbear ohpserver -port 8180 -proxy 127.0.0.1:8181 -tunnel 127.0.0.1:143
screen -dmS openvpn ohpserver -port 8188 -proxy 127.0.0.1:8181 -tunnel 127.0.0.1:1194
screen -dmS tls ohpserver -port 8844 -proxy 127.0.0.1:8181 -tunnel 127.0.0.1:444
END
chmod +x /usr/bin/darknet
fi

# adding darknet service for running
if [[ -e /etc/systemd/system/darknet.service  ]]; then
echo -e "maxis service already adding"
sleep 3;clear
else
echo -e "adding darknet service for running"
sleep 3;clear
cat> /etc/systemd/system/darknet.service << END
[Unit]
Description=OHP DARKNET

[Service]
Type=forking
ExecStart=/usr/bin/darknet

[Install]
WantedBy=multi-user.target
END
systemctl daemon-reload
systemctl enable darknet
fi

if [[ -e /root/log-ohp.txt  ]]; then
rm /root/log-ohp.txt
echo -e "Installation has been completed!!"
echo ""
echo ""
echo "DROPBEAR : 8180" | tee -a log-ohp.txt
echo "Openvpn Non : 8188" | tee -a log-ohp.txt
echo "STUNNEL : 8844" | tee -a log-ohp.txt
echo ""
echo ""
read -n 1 -r -s -p $'Press any key to reboot...\n';reboot
else
echo -e "Installation has been completed!!"
echo ""
echo ""
echo "DROPBEAR : 8180" | tee -a log-ohp.txt
echo "Openvpn Non : 8188" | tee -a log-ohp.txt
echo "STUNNEL : 8844" | tee -a log-ohp.txt
echo ""
echo ""
read -n 1 -r -s -p $'Press any key to reboot...\n';reboot
fi
