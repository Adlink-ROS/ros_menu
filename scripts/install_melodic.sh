#!/bin/bash

ros1_distro=melodic

    # Install ROS 1
    sudo apt update && sudo apt install -y curl gnupg2 lsb-release
    sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
    sudo apt update
    sudo apt install -y ros-$ros1_distro-desktop-full

    # Install ROS 1 build tools
    sudo apt install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential

echo "ROS $ros1_distro installed successfully"
