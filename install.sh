#!/bin/bash

shell=`echo $SHELL | awk -F '/' '{print $NF}'`

rm -f ~/.ros_dotfiles
ln -s `pwd` ~/.ros_dotfiles

if ! grep -q ros_dotfiles ~/.${shell}rc; then
    echo "source ~/.ros_dotfiles/ros_bashrc" >> ~/.${shell}rc
fi

echo "Installation done!"
