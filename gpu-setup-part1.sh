#!/bin/bash 
#if [ "$EUID" -ne 0 ]; then
#	echo "Please run as root (with sudo)"
#	exit
#fi


#sudo apt-get -y update
#sudo apt-get -y install build-essential

if [ "$1$" == "-g" ]; then #if google cloud setup
	# Check for CUDA and try to install.
	if [ ! dpkg-query -W cuda-8-0 ]; then
		# The 16.04 installer works with 16.10.
		curl -O http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
		dpkg -i ./cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
		apt-get update
		apt-get install cuda-8-0 -y
	fi
else
	SETUP_DIR="$(pwd)/gpu-setup"
	mkdir -p $SETUP_DIR
	cd $SETUP_DIR
	
	# install cuda drivers
	if [ ! -f "cuda_8.0.61_375.26_linux-run" ]; then 
		wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run
	fi
	chmod +x cuda_8.0.61_375.26_linux-run
	sudo sh cuda_8.0.61_375.26_linux-run --silent --verbose --driver

fi

echo "Setup requires a reboot to continue."
echo "The VM will reboot now. Login after it restarts and continue installation from part2."
sudo reboot
