import yaml
import os
import sys

# Common variables
host_sourcefilename = '/tmp/host_sourcefile.txt'
container_sourcefilename = '/tmp/container_sourcefile_%s.txt'

# Read YAML file.
f = open('%s' % sys.argv[1], 'r')
if yaml.__version__ >= '5.1.0':
    source_file = yaml.load(f, Loader=yaml.FullLoader)
else:
    source_file = yaml.load(f)
f.close()

if source_file["Config"]["menu_enable"] is not True:
    sys.exit(0)

# Generate Menu
keys = list(source_file['Menu'])
print('************ Neuron Startup Menu for ROS *************')
print('* Usage: Please select the following options to load *')
print('*        ROS environment automatically.              *')
print('******************************************************')
print('0) Do nothing')
choose_dict = {}
for key in keys:
    if str(source_file['Menu'][key]['option_num']) in list(choose_dict):
        raise SyntaxError(
            'Some option numbers(option_num) in the YAML file are duplicated.')
    print('%s) %s ' % (source_file['Menu'][key]['option_num'], key))
    choose_dict['%s' % source_file['Menu'][key]['option_num']] = key
print('h) Help')
# Choose Menu
if source_file['Config']['ros_option'] != 'menu':
    ros_option = str(source_file['Config']['ros_option'])
    print('Please choose an option: default=%s' % source_file['Config']['ros_option'])
    print('------------------------------------------------------')
else:
    try:
        ros_option = input('Please choose an option: ')
    except KeyboardInterrupt:
        ros_option = ''
        print('')
    print('------------------------------------------------------')
    if ros_option == 'H' or ros_option == 'h' or ros_option == 'help':
        print('Do nothing!')
        print('------------------------------------------------------')
        ros_source_file = open(host_sourcefilename, 'w')
        ros_source_file.write('ros_menu_help')
        ros_source_file.close()
        sys.exit(0)
    if len(ros_option) == 0 or ros_option == '0' or ros_option not in list(choose_dict):
        print('Do nothing!')
        sys.exit(0)

choose = choose_dict[ros_option]


def read_cmds():
    ret_cmds = ""
    if source_file['Menu'][choose]['cmds'] is not None:
        for cmds in source_file['Menu'][choose]['cmds']:
            ret_cmds += cmds + '\n'
    return ret_cmds


def source_ros1():
    current_ip = os.popen("hostname -I | awk '{print $1}'").read().split('\n')[0]
    if len(current_ip) == 0:
        current_ip = '127.0.0.1'
    ros_master_uri = source_file['Menu'][choose]['master_ip']
    if ros_master_uri is None:
        ros_master_uri = current_ip
    source_ros = 'source %s/setup.$shell' % source_file['Menu'][choose]['ros1_path']
    export_ip = 'export ROS_IP=%s' % current_ip
    export_ros_master_uri = 'export ROS_MASTER_URI=http://%s:11311' \
                                                     % ros_master_uri.rstrip("\n")
    print('* ROS_IP=%s' % current_ip.rstrip('\n'))
    print('* ROS_MASTER_URI %s' % ros_master_uri.rstrip('\n'))
    print('------------------------------------------------------')
    return source_ros + '\n' + export_ros_master_uri + '\n' + export_ip + '\n'


def source_ros2():
    ros_domain_id = source_file['Menu'][choose]['domain_id']
    if ros_domain_id is None:
        ros_domain_id = int(source_file['Config']['default_ros_domain_id'])
    source_ros = 'source %s/local_setup.$shell' \
                                    % source_file['Menu'][choose]['ros2_path']
    source_colcon = \
            'source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.$shell'
    export_domain_id = 'export ROS_DOMAIN_ID=%d' % ros_domain_id
    print('* ROS_DOMAIN_ID = %d' % ros_domain_id)
    print('------------------------------------------------------')
    return source_colcon + '\n' + source_ros + '\n' + export_domain_id + '\n'


def check_bridge():
    ret_string  = "if [ ! -d %s/lib/ros1_bridge ]; then\n" \
                                     % source_file['Menu'][choose]['ros2_path']
    ret_string += "  echo 'You need to install ros1_bridge first.'\n"
    ret_string += "  echo 'Installation command:" + \
                  " sudo apt install ros-%s-ros1-bridge'\n" \
                     % source_file['Menu'][choose]['ros2_version_name']
    ret_string += "fi\n"
    return ret_string


def create_ros_sourcefile(filename):
    ros_source_file = open(filename, 'w')
    ros_source_file.write(
        "shell=`echo $SHELL | awk -F '/' '{print $NF}' |  sed 's/\/bin\///g' `\n")
    ros_source_file.write("PS1=\"(%s) $PS1\"\n" % choose)
    if (source_file['Menu'][choose]['ROS_version'] == 1):
        ros_source_file.write(source_ros1()+read_cmds())
    if (source_file['Menu'][choose]['ROS_version'] == 2):
        ros_source_file.write(source_ros2()+read_cmds())
    if (source_file['Menu'][choose]['ROS_version'] == 'bridge'):
        ros_source_file.write(source_ros1()+source_ros2()+check_bridge()+read_cmds())
    ros_source_file.close()


if 'container' in source_file['Menu'][choose]:
    container_sourcefilename = container_sourcefilename % ros_option
    create_ros_sourcefile(container_sourcefilename)
    with open(host_sourcefilename, "w") as f:
        # Use $ROS_OPTION to select the environment in docker container
        # Use $CONTAINER to select which container to use
        f.write('ROS_OPTION=%s CONTAINER=%s ~/ros_menu/scripts/docker_run.sh'
                    % (ros_option, source_file['Menu'][choose]['container']))
else:
    create_ros_sourcefile(host_sourcefilename)
