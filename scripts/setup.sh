#!/bin/sh

echo "Installing Neuron Startup Menu..."

if [ ! -d $HOME/ros_menu ]; then
    if [ -z $MENU_VERSION ]; then
        git clone https://github.com/Adlink-ROS/ros_menu.git $HOME/ros_menu
    else
        git clone https://github.com/Adlink-ROS/ros_menu.git -b $MENU_VERSION $HOME/ros_menu
    fi
fi
cd $HOME/ros_menu
USE_CONTAINER=$USE_CONTAINER ./install.sh $MENU_CONFIG
cd - > /dev/null
