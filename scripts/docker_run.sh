#!/usr/bin/env bash

# TODO: The following variables should be arguments.
image_name=rosmenu_ubuntu2004
dockerfile_name=Dockerfile_ubuntu2004
container_name=rosmenu_ubuntu2004_container

# If the host is nvidia, use another container
if [[ ! $(grep Intel /proc/cpuinfo  | grep 'vendor_id'| uniq) ]]; then
    dockerfile_name=$dockerfile_name"_nvidia"
fi

if [ ! "$(docker images -q $image_name)" ]; then
    echo "The docker image doesn't exist. It'll take some time to build docker image."
    echo -n "Do you really want to build docker image? (y/N): "
    read build_docker
    if [ "$build_docker" '==' "y" ] || [ "$build_docker" '==' "Y" ];
    then
        pushd ~/ros_menu/scripts
        docker build -t $image_name -f ../Dockerfile/$dockerfile_name .
        popd
    else
        echo "Exit without creating docker image."
        exit 0
    fi
fi

xhost +local:docker
if [ ! "$(docker ps -aq -f name=$container_name)" ]; then
    echo "Run docker container since the container not exists"
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
               --volume /lib/modules:/lib/modules \
               --volume /tmp:/tmp:rw \
               --volume /etc/shadow:/etc/shadow:ro \
               --volume /etc/sudoers:/etc/sudoers:ro \
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

# TODO: We might have some conflicts since different menu options share the same container_sourcefile.txt name
docker cp /tmp/container_sourcefile.txt $container_name:/
docker exec -it $container_name bash