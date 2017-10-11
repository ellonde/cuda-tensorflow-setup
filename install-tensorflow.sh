# Tensorflow dependencies
sudo apt-get -y install python-numpy python-dev python-wheel python-mock python-matplotlib python-pip
sudo apt-get -y install libcupti-dev
sudo apt-get -y install curl
# upgrade pip
sudo pip install --upgrade pip
# Tensorflow config variables
nxt="\n"
a1="/usr/bin/python2.7"
a2="/usr/lib/python2.7/dist-packages"
a3="n" #MKL
a4="-march=native" #Optflags
a5="y" #jemalloc
a6="n" #gcp support
a7="n" #hfs
a8="n" #XLA-jit complier
a9="n" #VERBS support
a10="n" #OpenCL supp
a11="y" #CUDA support
a12="n" #clang complier for CUDA
a13="8.0" #CUDA version
a14="/usr/local/cuda" #cuda location default is /usr/local/cuda
a15="/usr/bin/gcc" #path to gcc compiler used by nvcc
a16="6.0" #cuDNN version
a17="/usr/local/cuda" #path to cuDNN installation, default is /usr/local/cuda
a18="3.7" #comma-seperated list of compute capabilities to compile for. list found at https://developer.nvidia.com/cuda-gpus
a19="n" #MPI support
# install tensorflow 1.3
if [ "$1" == "-s" ]; then
	echo "Building Tensorflow from source"
	#################
	# Install bazel #
	#################
	#Dependencies
	sudo apt-get -y install openjdk-8-jdk
	echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
	curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -
	#Bazel install
	sudo apt-get update && sudo apt-get -y install bazel
	sudo apt-get upgrade bazel
	
	##################################
	# Install tensorflow from source #
	##################################
	#Clone and configure
	git clone https://github.com/tensorflow/tensorflow
	cd tensorflow
	#Choose branch
	git checkout r1.3
	#Run config script with config variables
	if [ "$2$" == "-gpu"]; then
		$a11="n"
		printf "$a1$nxt$a2$nxt$a3$nxt$a4$nxt$a5$nxt$a6$nxt$a7$nxt$a8$nxt$a9$nxt$a10$nxt$a11$nxt$a19$nxt" | ./configure
		bazel build --config=opt --config=cuda //tensorflow/tools/pip_package:build_pip_package
	else
		printf "$a1$nxt$a2$nxt$a3$nxt$a4$nxt$a5$nxt$a6$nxt$a7$nxt$a8$nxt$a9$nxt$a10$nxt$a11$nxt$a12$nxt$a13$nxt$a14$nxt$a15$nxt$a16$nxt$a17$nxt$a19$nxt" | ./configure
		bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package
	fi
./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
sudo pip install /tmp/tensorflow_pkg/tensorflow-1.3.0-py2-none-any.whl
else
	echo "Building Tensorflow from binaries"
	export TF_BINARY_URL=https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.3.0-#cp27-none-linux_x86_64.whl
	sudo pip install --upgrade $TF_BINARY_URL
fi
