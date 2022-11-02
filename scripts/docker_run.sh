#!/usr/bin/env bash

container_name=rosmenu_${CONTAINER}_container
# Use different image based on your architecture
if [[ ! $(grep Intel /proc/cpuinfo  | grep 'vendor_id'| uniq) ]]; then
    image_name=ghcr.io/adlink-ros/rosmenu_${CONTAINER}_nv_r32.6
else
    image_name=ghcr.io/adlink-ros/rosmenu_${CONTAINER}_intel
fi

if [ ! "$(docker images -q $image_name)" ]; then
    echo "The docker image doesn't exist. It'll take some time to pull docker image."
    echo -n "Do you really want to pull docker image? (y/N): "
    read pull_docker
    if [ "$pull_docker" '==' "y" ] || [ "$pull_docker" '==' "Y" ];
    then
        docker pull $image_name
    else
        echo "Exit without getting docker image."
        exit 0
    fi
fi

xhost +local:docker
if [ ! "$(docker ps -aq -f name=$container_name)" ]; then
    echo "Run docker container since the container not exists"
    # Note:
    # * --group-add "video" is necessary: https://forums.developer.nvidia.com/t/nvidia-docker-seems-unable-to-use-gpu-as-non-root-user/80276/4
    # * Don't pass /tmp into container: tmux in host and container will conflict since they share /tmp/tmux-1000
    #   - Also note the limitation of tmux. Different options for the same container can't use tmux independently.
    DOCKER_PLATFORM_ARGS=()
    if [[ ! $(grep Intel /proc/cpuinfo  | grep 'vendor_id'| uniq) ]]; then
        DOCKER_PLATFORM_ARGS+=("--group-add video")
        DOCKER_PLATFORM_ARGS+=("--volume /opt/nvidia:/opt/nvidia")
        DOCKER_PLATFORM_ARGS+=("--volume /usr/bin/tegrastats:/usr/bin/tegrastats")
        DOCKER_PLATFORM_ARGS+=("--volume /usr/share/vpi1:/usr/share/vpi1")
        DOCKER_PLATFORM_ARGS+=("--volume /usr/lib/aarch64-linux-gnu/tegra:/usr/lib/aarch64-linux-gnu/tegra")
        DOCKER_PLATFORM_ARGS+=("--volume /usr/lib/aarch64-linux-gnu/tegra-egl:/usr/lib/aarch64-linux-gnu/tegra-egl")
        DOCKER_PLATFORM_ARGS+=("--volume /usr/lib/aarch64-linux-gnu/libcuda.so:/usr/lib/aarch64-linux-gnu/libcuda.so")
        DOCKER_PLATFORM_ARGS+=("--volume /usr/local/cuda-10.2:/usr/local/cuda-10.2")
        DOCKER_PLATFORM_ARGS+=("--volume /usr/local/cuda:/usr/local/cuda")
        DOCKER_PLATFORM_ARGS+=("--volume /usr/sbin/nvargus-daemon:/usr/sbin/nvargus-daemon")
        DOCKER_PLATFORM_ARGS+=("--volume /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstnvarguscamerasrc.so:/usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstnvarguscamerasrc.so")
        DOCKER_PLATFORM_ARGS+=("--volume /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstnvvidconv.so:/usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstnvvidconv.so")
	DOCKER_PLATFORM_ARGS+=("--volume /usr/src/jetson_multimedia_api:/usr/src/jetson_multimedia_api")
	DOCKER_PLATFORM_ARGS+=("--volume /var/nvidia:/var/nvidia")
    fi
    docker run --detach \
               --user "$(id --user):sudo" \
               --group-add "$(id --group)" \
               --hostname "$(hostname)" \
               --env "USER=$(whoami)" \
               --env "DISPLAY=$DISPLAY" \
               --env="QT_X11_NO_MITSHM=1" \
               --network=host \
               --security-opt apparmor:unconfined \
               --privileged \
               --volume /tmp/.X11-unix:/tmp/.X11-unix \
               --volume "${HOME}":/home/"$(whoami)":rw \
               --volume "${HOME}"/.cache:/.cache:rw \
               --volume /run/user:/run/user \
               --volume /var/run/nscd/socket:/var/run/nscd/socket:ro \
               --volume /etc/ssl/certs/:/etc/ssl/certs/:ro \
               --volume /usr/share/ca-certificates:/usr/share/ca-certificates:ro \
               --volume /etc/passwd:/etc/passwd:ro \
               --volume /etc/group:/etc/group:ro \
               --volume /usr/local/share/ca-certificates:/usr/local/share/ca-certificates:ro \
               --volume /dev:/dev \
               --volume /sys:/sys \
               --volume /lib/modules:/lib/modules \
               --volume /etc/shadow:/etc/shadow:ro \
               --volume /etc/sudoers:/etc/sudoers:ro \
               ${DOCKER_PLATFORM_ARGS[@]} \
               --workdir "${HOME}" \
               --name $container_name \
               $image_name \
               tail -f > /dev/null
else
    if [ "$(docker ps -aq -f status=exited -f name=$container_name)" ]; then
        echo "Start docker container which status is stop"
        docker start $container_name
    else
        echo "docker container already running"
    fi
fi

# Use $ROS_OPTION to select the environment in docker container
docker cp /tmp/container_sourcefile_$ROS_OPTION.txt $container_name:/
docker exec -it $container_name bash -c "export ROS_OPTION=$ROS_OPTION;bash"
