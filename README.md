# Neuron Startup Menu

Setting ROS environment every time is an annoying job.
ADLINK provides Neuron Startup Menu to make your life easier.

# Install

* Get Git tools if you haven't installed yet

```sh
sudo apt update
sudo apt install -y git
```

* Clone the repository

```sh
cd ~
git clone https://github.com/Adlink-ROS/ros_menu.git
```

* Installation

```sh
cd ros_menu
./install.sh
```

* Next time you open the shell, the terminal will show the following menu.

```
************ Neuron Startup Menu for ROS ************
* Usage: To set ROS env to be auto-loaded,          *
*        please assign ros_option in config_bashrc  *
*****************************************************
1) ROS melodic
2) ROS 2 dashing
3) ROS 2 Bridge
4) Do nothing
Please choose an option:
```

* Here is what the menu does for us:

    - `ROS melodic`:
        * Setup ROS1 environment.
        * Setup your package environment which is in `~/catkin_ws`.
        * Set the ROS_IP and ROS_MASTER_IP, which is your host IP.
    - `ROS 2 dashing`:
        * Setup ROS2 environment.
        * Setup your package environment which is in `~/ros2_ws`.
        * Load DDS settings and select which DDS you want to use.
    - `ROS 2 Bridge`:
        * Do all the thing for ROS1 and ROS2.
        * Run ROS bridge automatically.
    - `Do nothing`:
        * Don't setup any environment.

# Configuration

You can configure the menu in a very easy way.
All you need to modify is in `~/.ros_menu/config_bashrc`.
The following is the config you can control.

* Enable Menu:
  - menu_enable: "y" to enable the menu, otherwise do nothing.
* ROS distribution:
  - Decide which ROS distribution you want to use.
  - ros1_distro: ROS 1 version
  - ros2_distro: ROS 2 version
* Plugins:
  - You can put your own plugin under `~/.ros_menu/plugins_bashrc/`. Neuron Startup Menu will load it automatically.
  - ros1_plugins: Plugin for ROS1
  - ros1_plugins: Plugin for ROS2
* ROS Environmental Variables:
  - ros_default_master_uri: Default config for ROS_MASTER_URI in ROS1.
  - ros_default_domain_id: Default config for ROS_DOMAIN_ID in ROS2. 

# Upgrade

It's very easy to upgrade the menu.

* Update the repository of ros_menu.

```sh
cd ros_menu
git pull
```

* Select the ros_menu version you want.

```sh
git checkout <new_version>
```

* Next time you open the terminal, it'll be new version.

# Uninstall

* If you don't want the ros_menu anymore, you can just remove these files.

```
rm -rf ~/ros_menu
rm -rf ~/.ros_menu
```

* Also remember to remove `source ~/.ros_bashrc` in your `~/.bashrc`.

# Issues Report

If you find any problems or have any suggestions, feel free to open issues on GitHub.

Issue URL: https://github.com/Adlink-ROS/ros_menu/issues
