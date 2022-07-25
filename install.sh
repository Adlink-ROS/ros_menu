#!/bin/bash

# Platform detection
shell=`echo $SHELL | awk -F '/' '{print $NF}'`
ubuntu_version=`lsb_release -r | cut -f2`
if [[ $ubuntu_version == 18.04 ]]; then
    ros1_distro="melodic"
    ros2_distro="dashing"
    config_file=./yaml/ros_menu_18.04.yaml
elif [[ $ubuntu_version == 20.04 ]]; then
    ros1_distro="noetic"
    ros2_distro="foxy"
    config_file=./yaml/ros_menu_20.04.yaml
elif [[ $ubuntu_version == 22.04 ]]; then
    # no ros1 distro anymore
    ros1_distro="none"
    ros2_distro="humble"
    config_file=./yaml/ros_menu_22.04.yaml
else
    echo "Sorry, we don't support Ubuntu $ubuntu_version."
    exit
fi

if [ "$USE_CONTAINER" '==' "True" ] || [ "$USE_CONTAINER" '==' "TRUE" ]
then
    echo "We won't install ROS / ROS 2 in your host since you use container instead."
    echo "The container will be installed in the first time you run it."
else
    # ROS environment installation
    echo -n "Do you want to install ROS automatically? (y/N): "
    read ros_install
    if [ "$ros_install" '==' "y" ] || [ "$ros_install" '==' "Y" ];
    then
        # Install ROS 1
	if [[ -f ./scripts/install_${ros1_distro}.sh ]]; then
	        ./scripts/install_${ros1_distro}.sh
	fi

        # Install ROS 2
        ./scripts/install_${ros2_distro}.sh

        # Install ROS dependencies and related packages
        ./scripts/install_dep.sh
    else
        echo "Skip installing ROS"
    fi

    # OpenVINO environment installation (Only for Intel platform and ROS 2 foxy)
    if [ "$ros2_distro" '==' "foxy" ] && [[ $(grep Intel /proc/cpuinfo  | grep 'vendor_id'| uniq) ]];
    then
        echo -n -e "Do you want to install Intel RealSense SDK and OpenVINO automatically?\nNote that if you choose yes, it means you agree to the Intel software license.\nInstall or not? (y/N): "
        read openvino_install
        if [ "$openvino_install" '==' "y" ] || [ "$openvino_install" '==' "Y" ];
        then
            ./scripts/install_openvino.sh
        else
            echo "Skip installing OpenVINO"
        fi
    fi
fi

# Install ROS menu and config file
if [ -f ~/ros_menu/config.yaml ]; then
    echo  "The Neuron Startup Menu was already installed!"
    echo -n "Do you want to reinstall? (Your setting in the file config.yaml would be over written.) (y/N): "
    read over_write
else
    over_write="y"
fi
if [ ! "$over_write" '==' "y" ] && [ ! "$over_write" '==' "Y" ]; then
    echo "Skip installing Neuron Startup Menu!"
    exit
fi
rm -f ~/.ros_menu
ln -s `pwd` ~/.ros_menu
if [[ -n $1 ]]; then
    config_file=./yaml/$1
fi
cp $config_file config.yaml
if ! grep -q ros_menu ~/.${shell}rc; then
    cat <<EOF >> ~/.${shell}rc
# Neuron Startup Menu #
ros_bashrc_path=~/.ros_menu/ros_bashrc
if [ -f \$ros_bashrc_path ]; then
    source \$ros_bashrc_path
fi
# End of Neuron Startup Menu #
EOF
fi

echo "Neuron Startup Menu installed successfully"
