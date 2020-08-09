#!/bin/bash

shell=`echo $SHELL | awk -F '/' '{print $NF}'`

rm -f ~/.ros_menu
ln -s `pwd` ~/.ros_menu

if ! grep -q ros_menu ~/.${shell}rc; then
    echo "source ~/.ros_menu/ros_bashrc" >> ~/.${shell}rc
fi

echo "Installation done!"
