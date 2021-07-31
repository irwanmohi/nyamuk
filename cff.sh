#!/bin/bash
clear
cd /root
CF_ID=${CF_ID}
CF_KEY=${CF_KEY}
read -e -p " Sila masukkan email Cloudflare anda:" CF_ID
read -e -p " Sila masukkan Api Key Cloudflare anda:" CF_KEY
echo -e "CF_ID=${CF_ID}" >> /root/mail.conf
echo -e "CF_KEY=${CF_KEY}" >> /root/mail.conf
cd
clear
echo "DONE...!"
echo "Your ID Cloudflare"
echo -e "×××××××××××××××××××××××××××××××××"
echo "Email          : ${CF_ID}"
echo "Api Key        : ${CF_KEY}"
echo -e "×××××××××××××××××××××××××××××××××"
