#!/bin/bash 
#if [ "$EUID" -ne 0 ]; then 
#	echo "Please run as root (use sudo)"
#	exit
#fi
SETUP_DIR="$(pwd)/gpu-setup"
if [ ! -d $SETUP_DIR ]; then
	echo "Setup directory not found. Did you run part 1?"
	exit
fi

cd $SETUP_DIR
# install cudnn
if [ ! -f "cudnn-8.0-linux-x64-v6.0.tgz" ]; then
    echo "You need to download cudnn-8.0 manually! Specifically, place it at: $SETUP_DIR/cudnn-8.0-linux-x64-v6.0.tgz"
    exit
fi
echo "Installing CUDA toolkit and samples"
# install cuda toolkit
if [ ! -f "cuda_8.0.61_375.26_linux-run" ]; then
	echo "CUDA installation file not found. Did you run part 1?"
	exit
fi

echo "Uncompressing cudnn"
tar xzvf cudnn-8.0-linux-x64-v6.0.tgz
sudo cp -P cuda/include/cudnn.h /usr/local/cuda/include/
sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda/lib64/
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
# update bashrc
echo "Updating bashrc"
echo >> $HOME/.bashrc '
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64"
export CUDA_HOME=/usr/local/cuda
'
source $HOME/.bashrc
# create bash_profie
echo "Creating bash_profile"
echo > $HOME/.bash_profile '
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
'
echo "Script done"
