#!/bin/bash

ros2_distro=eloquent

    # Install ROS 2
    sudo locale-gen en_US en_US.UTF-8
    sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
    export LANG=en_US.UTF-8
    sudo apt update && sudo apt install -y curl gnupg2 lsb-release
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'
    sudo apt update
    sudo apt install -y ros-$ros2_distro-desktop
    sudo apt install -y python3-argcomplete
    
    # Install ROS 2 RQT
    sudo apt install -y ros-$ros2_distro-rqt
    
    # Install turtlesim for verification
    sudo apt install -y ros-$ros2_distro-turtlesim
    
    # Install ROS 2 build tools
    sudo apt install -y python3-colcon-common-extensions python3-vcstool

    # RMW for ROS 2
    sudo apt install -y ros-$ros2_distro-rmw-cyclonedds-cpp ros-$ros2_distro-rmw-opensplice-cpp

    # ros1_bridge
    sudo apt install -y ros-$ros2_distro-ros1-bridge

echo "ROS 2 $ros2_distro installed successfully"
