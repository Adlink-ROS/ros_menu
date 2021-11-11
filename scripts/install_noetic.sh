#!/bin/bash

ros1_distro=noetic

    # Install ROS 1
    sudo apt update && sudo apt install -y curl gnupg2 lsb-release
    sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
    sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
    sudo apt update
    sudo apt install -y ros-$ros1_distro-desktop-full

    # Install ROS 1 build tools
    sudo apt install -y python3-rosdep python3-rosinstall-generator python3-vcstool build-essential

echo "ROS $ros1_distro installed successfully"
