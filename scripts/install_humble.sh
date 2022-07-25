#!/bin/bash

ros2_distro=humble

    # Install ROS 2
    sudo locale-gen en_US en_US.UTF-8
    sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
    export LANG=en_US.UTF-8
    sudo apt update && sudo apt install -y curl gnupg2 lsb-release
    sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
    sudo bash -c 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null'
    sudo apt update
    sudo apt install -y ros-$ros2_distro-desktop
    sudo apt install -y python3-pip
    pip3 install -U argcomplete
    
    # Install ROS 2 RQT
    sudo apt install -y ros-$ros2_distro-rqt
    
    # Install turtlesim for verification
    sudo apt install -y ros-$ros2_distro-turtlesim
    
    # Install ROS 2 build tools
    sudo apt install -y python3-colcon-common-extensions python3-vcstool

    # RMW for ROS 2
    sudo apt install -y ros-$ros2_distro-rmw-cyclonedds-cpp

echo "ROS 2 $ros2_distro installed successfully"
