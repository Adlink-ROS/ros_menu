import yaml
import os 
import sys 

shell = os.popen("echo $SHELL | awk -F '/' '{print $NF}'").readlines()[0].rstrip("\n")
f = open('%s'%sys.argv[1],'r')
source_file = yaml.load(f)
if (source_file['Config']['menu_enable'] != True):
    ros_source_file = open('/tmp/ros_source_file.txt','w')
    ros_source_file.write('')
    sys.exit(0)
keys = list(source_file['Menu'])
print ('************ Neuron Startup Menu for ROS **************' )
print ('* Usage: To set ROS env to be auto-loaded.            *' )
print ('* Please assign ros_option in the YAML file at param/.*' )
print ('*******************************************************' )
i = 1 
for key in keys:
    print('%d) %s '%(i ,key))
    i += 1
print('%d) Do nothing.'%i)

if source_file['Config']['ros_option']!= 'menu':
    ros_option = int(source_file['Config']['ros_option'])
    print('Please choose an option: default=%s'%source_file['Config']['ros_option'])
    print('------------------------------------------------------')
else:
    ros_option = input('Please choose an option: ')
    print('------------------------------------------------------')
    if len(ros_option)==0 or int (ros_option)==i:
        print('Do nothing!')
        ros_source_file = open('/tmp/ros_source_file.txt','w')
        ros_source_file.write('')
        sys.exit(0)

choose = keys[int(ros_option)-1]

def source_ros1():
    current_ip = os.popen("hostname -I | awk '{print $1}'").readlines()[0]
    if (len(current_ip)==0):
        current_ip = '127.0.0.1'
    ros_master_uri = source_file['Menu'][choose]['master_ip']
    if (ros_master_uri is None):
        ros_master_uri = current_ip
    source_ros = 'source %s/setup.%s'%(source_file['Menu'][choose]['ros1_path'],shell)
    export_ip = 'export ROS_IP=%s' %current_ip
    export_ros_master_uri = 'export ROS_MASTER_URI=http://%s:11311' %ros_master_uri.rstrip("\n")
    print('* ROS_IP=%s'%current_ip.rstrip('\n'))
    print('* ROS_MASTER_URI %s'%ros_master_uri.rstrip('\n'))
    print('------------------------------------------------------')
    ros1_cmds = source_ros + '\n' + export_ros_master_uri + '\n' + export_ip +'\n'

    if (source_file['Menu'][choose]['ROS_version']=='bridge'):
        return ros1_cmds
    if (source_file['Menu'][choose]['ros1_cmds'] is None):
        return ros1_cmds
    for cmds in source_file['Menu'][choose]['ros1_cmds']:
        ros1_cmds = ros1_cmds + cmds + '\n'
    return ros1_cmds
    
def source_ros2():
    ros_domain_id = source_file['Menu'][choose]['domain_id']
    if (ros_domain_id is None):
        ros_domain_id = int(source_file['Config']['default_ros_domain_id'])
    source_ros = 'source %s/local_setup.%s'%(source_file['Menu'][choose]['ros2_path'],shell)
    source_colcon = 'source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.%s'%shell
    export_domain_id = 'export ROS_DOMAIN_ID=%d' %ros_domain_id
    print('* ROS_DOMAIN_ID = %d'%ros_domain_id)
    print('------------------------------------------------------')
    ros2_cmds = source_colcon + '\n' + source_ros + '\n' + export_domain_id + '\n'

    if (source_file['Menu'][choose]['ROS_version']=='bridge'):
        return ros2_cmds
    if (source_file['Menu'][choose]['ros2_cmds'] is None):
        return ros2_cmds
    for cmds in source_file['Menu'][choose]['ros2_cmds']:
        ros2_cmds = ros2_cmds + cmds + '\n'
    return ros2_cmds

def source_bridge():
    ros1_cmds = source_ros1()
    ros2_cmds = source_ros2()
    bridge_cmds = ros1_cmds + ros2_cmds
    if ((os.system('ls %s/lib/ | grep -q ros1_bridge'%source_file['Menu'][choose]['ros2_path'])>>8)==1):
        print('You need to install ros1_bridge first.')
        print('Installation command: sudo apt install ros-%s-ros1-bridge'%source_file['Menu'][choose]['ros2_version_name'])
        return ''
    for cmds in source_file['Menu'][choose]['bridge_cmds']:
        bridge_cmds = bridge_cmds + cmds + '\n'
    return bridge_cmds

if (source_file['Menu'][choose]['ROS_version']==1):
    ros_source_file = open('/tmp/ros_source_file.txt','w')
    ros_source_file.write(source_ros1())
if (source_file['Menu'][choose]['ROS_version']==2):
    ros_source_file = open('/tmp/ros_source_file.txt','w')
    ros_source_file.write(source_ros2())
if (source_file['Menu'][choose]['ROS_version']=='bridge'):
    ros_source_file = open('/tmp/ros_source_file.txt','w')
    ros_source_file.write(source_bridge())