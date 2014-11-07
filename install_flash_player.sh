# 		WARNING: Unfinished script with su command			#
# Script to install Flash player in Ubuntu
if [ ! -f $PWD/install_flash_player*.tar.gz ]
	then echo "Place the downloaded Flash player tar.gz in the same dir as this script";
fi
rm -rf flash_player
mkdir flash_player
tar xf install_flash_player_11_linux.x86_64.tar.gz -C flash_player
#cd flash_player
sudo cp -r flash_player/usr/* /usr
#mkdir ~/.mozilla/plugins
sudo cp flash_player/libflashplayer.so ~/.mozilla/plugins/
