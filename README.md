# Neuron Startup Menu

Setting ROS environment every time is an annoying job.
ADLINK provides Neuron Startup Menu to make your life easier.

# Install

* Clone the repository

```sh
cd ~
git clone https://github.com/Adlink-ROS/ros_dotfiles.git
```

* Installation

```sh
cd ros_dotfiles
git checkout v1.2.0
./install.sh
```

* Next time you open the shell, the terminal will show the following menu.

```
************ Neuron Startup Menu for ROS ************
* Usage: To set ROS env to be auto-loaded,          *
*        please assign ros_option in config_bashrc  *
*****************************************************
1) ROS1 melodic Python2
2) ROS2 dashing Python3
3) ROS2-1 Bridge
4) Do nothing
Please choose an option 1-4:
```

* Here is what the menu does for us:

    - `ROS1 melodic Python2`:
        * Setup ROS1 environment.
        * Setup your package environment which is in `~/catkin_ws`.
        * Set the ROS_IP and ROS_MASTER_IP, which is your host IP.
    - `ROS2 dashing Python3`:
        * Setup ROS2 environment.
        * Setup your package environment which is in `~/ros2_ws`.
        * Load DDS settings and select which DDS you want to use.
    - `ROS2-1 Bridge`:
        * Do all the thing for ROS1 and ROS2.
        * Run ROS bridge automatically.
    - `Do nothing`:
        * Don't setup any environment.

# Configuration

You can configure the menu in a very easy way.
All you need to modify is in `~/.ros_dotfiles/config_bashrc`.
The following is the config you can control.

* Enable Menu:
  - menu_enable: "y" to enable the menu, otherwise do nothing.
* ROS distribution:
  - Decide which ROS distribution you want to use.
  - ros1_distro: ROS 1 version
  - ros2_distro: ROS 2 version
* Plugins:
  - You can put your own plugin under `~/.ros_dotfiles/plugins_bashrc/`. Neuron Startup Menu will load it automatically.
  - ros1_plugins: Plugin for ROS1
  - ros1_plugins: Plugin for ROS2
* ROS Environmental Variables:
  - ros_default_master_uri: Default config for ROS_MASTER_URI in ROS1.
  - ros_default_domain_id: Default config for ROS_DOMAIN_ID in ROS2. 

# Upgrade

It's very easy to upgrade the dotfiles.

* Update the repository of ros_dotfiles.

```sh
cd ros_dotfiles
git pull
```

* Select the ros_dotfiles version you want.

```sh
git checkout <new_version>
```

* Next time you open the terminal, it'll be new version.

# Uninstall

* If you don't want the ros_dotfiles anymore, you can just remove these files.

```
rm -rf ~/ros_dotfiles
rm -rf ~/.ros_dotfiles
```

* Also remember to remove `source ~/.ros_bashrc` in your `~/.bashrc`.

# Issues Report

If you find any problems or have any suggestions, feel free to open issues on GitHub.

Issue URL: https://github.com/Adlink-ROS/ros_dotfiles/issues
