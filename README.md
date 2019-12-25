# ROS dotfiles

Setting ROS environment every time is an annoying job.
ADLINK provides ROS dotfiles to make your life easier.

# Install

* Clone the repository

```sh
cd ~
git clone https://github.com/Adlink-ROS/ros_dotfiles.git
```

* Install the dotfiles

```sh
cd ros_dotfiles
git checkout v1.0.0
./install.sh
```

* Next time you open the shell, the terminal will show the following menu.

```
**** Welcome to ADLINK Neuron ROS environment ****
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
        * Setup extra settings and select which DDS you want to use.
    - `ROS2-1 Bridge`:
        * Do all the thing for ROS1 and ROS2.
    - `Do nothing`:
        * Don't setup any environment.

* If you want to add your own settings, you can add it in extra_bashrc.

    - ADLINK provides a menu for choosing DDS in default, which shows the following menu.

```
**** Choose DDS you want to use ****
1) Neuron SDK + OpenSplice EE
2) OpenSplice CE
3) Cyclone DDS
4) FastRTPS
Please choose an option 1-4: 
```

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
rm -f ~/.ros_bashrc
rm -f ~/.extra_bashrc
```

* Also remember to remove `source ~/.ros_bashrc` in your `~/.bashrc`.

# Issues Report

If you find any problems or have any suggestions, feel free to open issues on GitHub.

Issue URL: https://github.com/Adlink-ROS/ros_dotfiles/issues
