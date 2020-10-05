# Neuron Startup Menu

Setting ROS environment every time is an annoying job.
ADLINK provides Neuron Startup Menu to make your life easier.

# Support Platform

* Ubuntu 18.04
  - ROS 1 melodic / ROS 2 dashing
* Ubuntu 20.04
  - ROS 1 noetic / ROS 2 foxy

# Install

* Get Git tools if you haven't installed yet

```sh
sudo apt update
sudo apt install -y git curl
```

* Installation

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Adlink-ROS/ros_menu/master/scripts/setup.sh)"
```

* Optional: you can add variables while downloading ros_menu.

```
# Select which version you want.
sh -c "MENU_VERSION=<Your Version> $(curl -fsSL https://raw.githubusercontent.com/Adlink-ROS/ros_menu/master/scripts/setup.sh)"
# Select which config you want.
sh -c "MENU_CONFIG=<Config Name> $(curl -fsSL https://raw.githubusercontent.com/Adlink-ROS/ros_menu/master/scripts/setup.sh)"
```

* Next time you open the shell, the terminal will show the following menu.

```
************ Neuron Startup Menu for ROS *************
* Usage: To set ROS env to be auto-loaded, please    *
*        assign ros_option in ros_menu/config.yaml   *
******************************************************
0) Do nothing
1) ROS 1 melodic 
2) ROS 2 dashing 
3) ROS2/ROS1_bridge 
Please choose an option: 
```

* Here is what the menu does for us:

    - `Do nothing`:
        * Does not setup any environment.
    - `ROS melodic`:
        * Sets up the ROS 1 environment.
        * Sets the ROS_IP and ROS_MASTER_URI, which is your host IP.
    - `ROS 2 dashing`:
        * Sets up the ROS 2 environment.
        * Loads DDS settings and select the DDS you want to use.
    - `ROS2/ROS1_bridge`:
        * Sets up the ROS Bridge environment.
        * Runs ROS Bridge automatically.

# Configuration

You can configure the menu in a very easy way.
All you need to modify is in `~/.ros_menu/config.yaml`.
The following is the config you can control.

* Enable menu:
  - menu_enable: "true" to enable the menu. "false" to disable the menu.
* ROS option:
  - ros_option: 'menu' to open the menu, you could also set a number and the menu will automatically set to this every time you open the terminal. 
* Here are some parameters you need to set if you want to create a new option for your menu: 
  - ROS 1: 
    - ROS_version: 1
    - distro_name: the name of the ROS 1 you are using.
    - ros1_path: the path where the ROS 1 is.
    - master_ip: set the IP address of the master if master isn't on current computer.
    - cmds: source your ROS 1 workspace here.
  - ROS 2:
    - ROS_version: 2
    - distro_name: the name of the ROS 2 you are using.
    - ros2_path: the path where the ROS 2 is.
    - domain_id: set the Domain ID for DDS communication. Keep empty to use `$default_ros_domain_id(30)`
    - cmds: source your ROS 2 workspace here.  _Remarks: `source_plugin dds_bashrc` is necessary every time using ROS 2_
  - ROS2/ROS1_bridge:
    - ROS_version: bridge
    - ros1_version_name: the name of the ROS 1 you are using.
    - ros2_version_name: the name of the ROS 2 you are using.
    - ros1_path: the path where the ROS 1 is.
    - ros2_path: the path where the ROS 2 is.
    - master_ip: set the IP address of the master if master isn't on current computer.
    - domain_id: set the Domain ID for DDS communication. Keep empty to use `$default_ros_domain_id(30)`
    - cmds: any command you want to run every time using ROS bridge. _Remarks: `source_plugin dds_bashrc` and `ros2 run ros1_bridge dynamic_bridge --bridge-all-topics` is necessary every time using ROS bridge_
# Upgrade

* It's very easy to upgrade the menu by typing `ros_menu_upgrade`.
* Optional: You can also select which version you want.

```sh
ros_menu_upgrade <version>
```

* Next time you open the terminal, it'll be new version.

# Uninstall

* If you don't want the ros_menu anymore, you can just type `ros_menu_uninstall`.
* Also remember to remove `source ~/.ros_bashrc` in your `~/.bashrc`.

# Issues Report

If you find any problems or have any suggestions, feel free to open issues on GitHub.

Issue URL: https://github.com/Adlink-ROS/ros_menu/issues
