#!/bin/bash

sudo apt-key adv --keyserver keys.gnupg.net --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE
sudo add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u
sudo apt install -y librealsense2-dkms \
 librealsense2-utils \
 librealsense2-dev \
 librealsense2-dbg

echo "RealSense SDK installation complete"

wget https://apt.repos.intel.com/openvino/2021/GPG-PUB-KEY-INTEL-OPENVINO-2021
sudo apt-key add GPG-PUB-KEY-INTEL-OPENVINO-2021
echo "deb https://apt.repos.intel.com/openvino/2021 all main" | sudo tee /etc/apt/sources.list.d/intel-openvino-2021.list
sudo apt update

package_name=$(apt-cache search intel-openvino-runtime-ubuntu20-2021.3 | cut -d " " -f 1)

sudo apt install $package_name
rm ./GPG-PUB-KEY-INTEL-OPENVINO*
echo "OpenVINO installation successfully"
