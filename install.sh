#!/bin/bash

shell=`echo $SHELL | awk -F '/' '{print $NF}'`
if [[ $(grep 20.04 /etc/issue) ]]; then
    ros1_distro="noetic"
    ros2_distro="foxy"
else
    ros1_distro="melodic"
    ros2_distro="dashing"
fi

echo -n "Do you want to install ROS automatically? (y/N): "
read ros_install
if [ "$ros_install" '==' "y" ] || [ "$ros_install" '==' "Y" ];
then
    # Install ROS 1
    ./scripts/install_${ros1_distro}.sh

    # Install ROS 2
    ./scripts/install_${ros2_distro}.sh

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

echo "Neuron Startup Menu installed successfully"
