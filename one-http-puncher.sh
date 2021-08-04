#!/bin/bash
cd
#Install system auto run
wget -O /etc/systemd/system/ohpserver.service https://github.com/lfasmpao/open-http-puncher/releases/download/0.1/ohpserver-linux32.zip && unzip ohpserver-linux32.zip && chmod +x ohpserver /etc/systemd/system/ohpserver.service
#Install Ohp Ovpn Ssh
./ohpserver -port 8188 -proxy 127.0.0.1:8080 -tunnel 127.0.0.1:1194
./ohpserver -port 8180 -proxy 127.0.0.1:8080 -tunnel 127.0.0.1:143

#Enable & Start Ohp service
systemctl enable ohpserver.service
systemctl start ohpserver.service

