#!/bin/bash

# Platform detection
shell=`echo $SHELL | awk -F '/' '{print $NF}'`
if [[ $(grep 20.04 /etc/issue) ]]; then
    ros1_distro="noetic"
    ros2_distro="foxy"
    config_file=./yaml/ros_menu_20.04.yaml
else
    ros1_distro="melodic"
    ros2_distro="dashing"
    config_file=./yaml/ros_menu_18.04.yaml
fi

# ROS environment installation
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

# Install ROS menu and config file
rm -f ~/.ros_menu
ln -s `pwd` ~/.ros_menu
if [[ -n $1 ]]; then
    config_file=./yaml/$1
fi
cp $config_file config.yaml

if ! grep -q ros_menu ~/.${shell}rc; then
    cat <<EOF >> ~/.${shell}rc
# Neuron Startup Menu #
ros_bashrc_path=~/.ros_menu/ros_bashrc
if [ -f \$ros_bashrc_path ]; then
    source \$ros_bashrc_path
fi
# End of Neuron Startup Menu #
EOF
fi

echo "Neuron Startup Menu installed successfully"
