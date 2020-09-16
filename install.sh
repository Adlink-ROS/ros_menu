#!/bin/bash

shell=`echo $SHELL | awk -F '/' '{print $NF}'`
ros1_distro=melodic
ros2_distro=dashing

echo -n "Do you want to install ROS automatically? (y/N): "
read ros_install
if [ "$ros_install" '==' "y" ] || [ "$ros_install" '==' "Y" ];
then
    # Install ROS 1 melodic
    ./scripts/install_melodic.sh

    # Install ROS 2 dashing
    ./scripts/install_dashing.sh

    # Install ROS dependencies and related packages
    ./scripts/install_dep.sh

else
    echo "Skip installing ROS"
fi

rm -f ~/.ros_menu
ln -s `pwd` ~/.ros_menu

if ! grep -q ros_menu ~/.${shell}rc; then
    cat <<EOF >> ~/.${shell}rc
# Neuron Startup Menu #
ros_menu_path=~/.ros_menu/ros_bashrc
if [ -f \$ros_menu_path ]; then
    source \$ros_menu_path
fi
# End of Neuron Startup Menu #
EOF
fi

echo "ROS Menu installed successfully"
