#!/bin/bash

shell=`echo $SHELL | awk -F '/' '{print $NF}'`
ros1_distro=melodic
ros2_distro=dashing

echo -n "Do you want to install ROS automatically? (y/N): "
read ros_install
if [ "$ros_install" '==' "y" ] || [ "$ros_install" '==' "Y" ];
then
    # Install ROS 1 melodic
    sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
    sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
    sudo apt update
    sudo apt install -y ros-$ros1_distro-desktop-full

    # Install ROS 1 build tools
    sudo apt install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential

    # Install ROS 2 dashing
    sudo locale-gen en_US en_US.UTF-8
    sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
    export LANG=en_US.UTF-8
    sudo apt update && sudo apt install -y curl gnupg2 lsb-release
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'
    sudo apt update
    sudo apt install -y ros-$ros2_distro-desktop
    sudo apt install -y python3-argcomplete
    # Install ROS 2 build tools
    sudo apt install -y python3-colcon-common-extensions python3-vcstool

    # RMW for ROS 2
    sudo apt install -y ros-$ros2_distro-rmw-cyclonedds-cpp ros-$ros2_distro-rmw-opensplice-cpp

    # ros1_bridge
    sudo apt install -y ros-$ros2_distro-ros1-bridge

    # Install ROS dependencies (for Dashing and Eloquent on Ubuntu 18.04)
    sudo apt install -y python-rosdep 

    # Install ROS dependencies (for Foxy on Ubuntu 20.04)
    # sudo apt install -y python3-rosdep

    # Install Common Linux Tools
    sudo apt install -y \
	    build-essential \
	    cmake \
	    git \
	    libbullet-dev \
	    python3-argcomplete \
	    python3-colcon-common-extensions \
	    python3-flake8 \
	    python3-pip \
	    python3-pytest-cov \
	    python3-setuptools \
	    python3-vcstool \
	    openssh-server \
	    byobu \
	    wget

fi

rm -f ~/.ros_menu
ln -s `pwd` ~/.ros_menu

if ! grep -q ros_menu ~/.${shell}rc; then
    echo "source ~/.ros_menu/ros_bashrc" >> ~/.${shell}rc
fi

echo "Installation done!"
