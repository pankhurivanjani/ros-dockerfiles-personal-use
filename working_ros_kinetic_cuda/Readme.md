Useful resource for display connection: https://github.com/henry2423/docker-ros-x11

Official ros tutorial: http://wiki.ros.org/docker/Tutorials/GUI

Working file after all the corrections:

Taken from https://github.com/craymichael/ros-kinetic-nvidia-docker and modified for my personal use
 
# build

sudo docker build .

# run

pankhuri@pankhuri-G5-5500:~/academics/Thesis_progress_work/ros-kinetic-cuda$ sudo docker run -it pankhurivanjani/roskineticslam:v1 bash

sudo docker run -it  --volume /tmp/.X11-unix:/tmp/.X11-unix:rw   --volume /tmp/.docker.xauth:/tmp/.docker.xauth:rw   --env "XAUTHORITY=/tmp/.docker.xauth"   --env "DISPLAY"   --volume /etc/passwd:/etc/passwd   --volume /etc/group:/etc/group   --user $(root):$(root) pankhurivanjani/roskineticslam:v1 bash


# for changing image name 
pankhuri@pankhuri-G5-5500:~/academics/Thesis_progress_work/ros-kinetic-cuda$ sudo docker image tag 09bcad0a6ad5 pankhurivanjani/roskineticslam:v1
