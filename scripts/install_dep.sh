#!/bin/bash

ubuntu_version=`lsb_release -r | cut -f2`
is_after_ubuntu18=`echo "$ubuntu_version > 18.04" | bc`
if [[ $is_after_ubuntu18 -eq 1 ]]; then
    # Install ROS dependencies (for ROS 2 on Ubuntu 20.04 and later)
    sudo apt install -y python3-rosdep
else
    # Install ROS dependencies (for Dashing and Eloquent on Ubuntu 18.04)
    sudo apt install -y python-rosdep
fi

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

    # Initialize and update rosdep
    sudo rosdep init
    rosdep update

echo "ROS-related packages installed successfully"
