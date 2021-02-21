#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

export OS=Debian

echo "#########################################################                         "
echo "#::: EverQuest Emulator Modular Installer                                         "
echo "#########################################################                         "

export eqemu_server_directory=/home/eqemu
export apt_options="-y -qq" # Set autoconfirm and silent install

################################################################

if [ ! -f ./install_variables.txt ]; then

	read -n1 -r -p "Press any key to continue..." key

	cd $eqemu_server_directory

	#::: Setup MySQL root user PW
	read -p "Enter MySQL root (Database) password: " eqemu_db_root_password

	#::: Write install variables (later use)
	echo "mysql_root:$eqemu_db_root_password" > install_variables.txt

	#::: Setup MySQL server 
	read -p "Enter Database Name (single word, no special characters, lower case):" eqemu_db_name
	read -p "Enter (Database) MySQL EQEmu Server username: " eqemu_db_username
	read -p "Enter (Database) MySQL EQEmu Server password: " eqemu_db_password

	#::: Write install variables (later use)
	echo "mysql_eqemu_db_name:$eqemu_db_name" >> install_variables.txt
	echo "mysql_eqemu_user:$eqemu_db_username" >> install_variables.txt
	echo "mysql_eqemu_password:$eqemu_db_password" >> install_variables.txt
fi

#::: Create source and server directories
mkdir $eqemu_server_directory/source
mkdir $eqemu_server_directory/server
mkdir $eqemu_server_directory/server/export
mkdir $eqemu_server_directory/server/logs
mkdir $eqemu_server_directory/server/shared
mkdir $eqemu_server_directory/server/maps

#::: Grab loginserver dependencies
# cd $eqemu_server_directory/source/Server/dependencies
# if [[ "$OS" == "Debian" ]]; then
# 	wget http://eqemu.github.io/downloads/ubuntu_LoginServerCrypto_x64.zip
# 	unzip ubuntu_LoginServerCrypto_x64.zip
# 	rm ubuntu_LoginServerCrypto_x64.zip
# elif [[ "$OS" == "fedora_core" ]] || [[ "$OS" == "red_hat" ]]; then
# 	wget http://eqemu.github.io/downloads/fedora12_LoginServerCrypto_x64.zip
# 	unzip fedora12_LoginServerCrypto_x64.zip
# 	rm fedora12_LoginServerCrypto_x64.zip
# fi
# cd $eqemu_server_directory/source/Server/build

#::: Back to server directory
cd $eqemu_server_directory/server
wget https://raw.githubusercontent.com/bitspace/Server/master/utils/scripts/eqemu_server.pl

#::: Map lowercase to uppercase to avoid issues
ln -s maps Maps

#::: Notes

perl $eqemu_server_directory/server/eqemu_server.pl new_server

#::: Chown files
chown eqemu:eqemu $eqemu_server_directory/ -R 
chmod 755 $eqemu_server_directory/server/*.pl
chmod 755 $eqemu_server_directory/server/*.sh
