#!/bin/bash
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
echo "Start Update"
#cd /usr/bin
rm /usr/bin/menu
wget https://raw.githubusercontent.com/irwanmohi/nyamuk/beta/update/install.sh && chmod +x install.sh && sed -i -e 's/\r$//' install.sh && ./install.sh
rm install.sh
clear
echo " Update Successfull"
echo " Enjoyy"
