#!/bin/bash

rm ~/.ros_bashrc
rm ~/.extra_bashrc
ln -s `pwd`/ros_bashrc ~/.ros_bashrc
ln -s `pwd`/extra_bashrc ~/.extra_bashrc
echo "Remember to add 'source ~/.ros_bashrc' to your .bashrc"
