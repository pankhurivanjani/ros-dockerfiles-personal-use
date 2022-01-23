FROM nvidia/cudagl:9.0-base-ubuntu16.04

ENV UBUNTU_RELEASE=xenial
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $UBUNTU_RELEASE main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN apt-get update && apt-get install -y \
    ros-kinetic-desktop-full \
 && rm -rf /var/lib/apt/lists/*


RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool build-essential \
    && sudo rm -rf /vr/lib/apt/lists/*

RUN sudo apt-get install -y ros-kinetic-catkin 

RUN apt-get update && apt-get install gcc g++

# Install ROS packages
#RUN apt-get update && apt-get install -y \
#        ros-kinetic-xxx
#    rm -rf /var/lib/apt/lists/*

# Add new sudo user
#ENV USERNAME=username
#RUN useradd -m $USERNAME && \
#        echo "$USERNAME:$USERNAME" | chpasswd && \
#        usermod --shell /bin/bash $USERNAME && \
#        usermod -aG sudo $USERNAME && \
#        echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
#        chmod 0440 /etc/sudoers.d/$USERNAME && \
#        usermod  --uid 1000 $USERNAME && \
#        groupmod --gid 1000 $USERNAME

# Uncomment to change default user and working directory
#USER rosmaster
#WORKDIR /home/rosmaster/
# Opencv 3.2
RUN apt-get update && apt-get install wget && apt-get install unzip 

RUN wget https://github.com/opencv/opencv/archive/3.2.0.zip -O OpenCV320.zip \
    && unzip OpenCV320.zip -d OpenCV320 \
    && rm OpenCV320.zip \
    && cd OpenCV320/opencv-3.2.0 \    
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j4 \
    && sudo make install 

RUN sudo apt-get install -y \
    libglew-dev \
    libopencv-dev \
    libboost-dev libboost-thread-dev libboost-filesystem-dev \
    cmake   \
    libeigen3-dev \
    libblas-dev \
    liblapack-dev 
RUN sudo apt-get install libopencv-dev 
RUN sudo apt-get install ros-kinetic-opencv3

# build + install pangolin
RUN git clone https://github.com/stevenlovegrove/Pangolin.git \
    && cd Pangolin \
    && git checkout v0.5 \
    && mkdir build \
    && cd build \
    && cmake .. \
    && cmake --build . \
    && make && \
    make install \
    && cd ../.. \
    && rm -rf Pangolin 

RUN git clone https://github.com/ayushgaud/ORB_SLAM2 \
    && cd ORB_SLAM2 \
    && chmod +x build.sh \
    && ./build.sh 

# build rpg-SVO and REMODE

#Install dependencies

# build + install Sophus
RUN git clone https://github.com/strasdat/Sophus.git \
    && cd Sophus \
    && git checkout a621ff \
    && mkdir build \
    && cd build \
    && cmake .. \
    && cmake --build . \
    && make \
    && sudo make install 

# build + install FAST
RUN git clone https://github.com/uzh-rpg/fast.git \
    && cd fast \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && sudo make install 

# build + install g20
RUN wget https://github.com/RainerKuemmerle/g2o/archive/20160424_git.tar.gz -O g2o-20160424_git.tar.gz \
    && tar  xvzf g2o-20160424_git.tar.gz \
    && cd g2o-20160424_git \
    && mkdir build \
    && cd build \
    && cmake .. \
    && cmake --build . \
    && make \
    && sudo make install 

#vikit, SVO
#RUN mkdir catkin_ws \
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash'
RUN mkdir catkin_ws && cd catkin_ws \
    && mkdir src \
    && cd src \
    && git clone https://github.com/uzh-rpg/rpg_vikit.git \
    && git clone https://github.com/uzh-rpg/rpg_svo.git \
    #&& ./opt/ros/kinetic/setup.bash \
    && sudo apt-get install  ros-kinetic-catkin python-catkin-tools  \
    && cd .. \
    #&&  /bin/bash -c  /opt/ros/kinetic/setup.sh \
    CMD catkin_make

# build REMODE
RUN git clone https://github.com/google/googletest.git \
    && cd googletest \
    && git checkout release-1.7.0 \
    && mkdir build \
    && cd build \
    && cmake .. \
    && sudo make \
    && sudo cp *.a /usr/lib \
    && cd .. && mkdir install \
    && cp -r include install \
    && cp build/*.a install 
RUN sudo apt install cmake libgtest-dev

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yq nvidia-cuda-toolkit

RUN find / -name cuda

#RUN set(CUDA_INCLUDE_DIRS /usr/local/cuda/include/ ${CUDA_INCLUDE_DIRS}) 

RUN cd catkin_ws \
    && sudo ln -s /usr/cuda-8.0 /usr/cuda \
    && git clone https://github.com/ayushgaud/rpg_open_remode.git \
    && cd rpg_open_remode \
    && mkdir build && cd build \
    #&& cmake -DGTEST_ROOT=$catkin_ws/googletest/install -DBUILD_ROS_NODE=OFF .. \
    && cmake -DCUDA_NVCC_FLAGS="-D_FORCE_INLINES" -DGTEST_ROOT=$catkin_ws/googletest/install -DBUILD_ROS_NODE=OFF ..  \
    && make

RUN apt-get update && apt-get install -y xauth


RUN apt-get install x11-xserver-utils
RUN apt-get install -qqy x11-apps

RUN apt-get install dbus-x11 
RUN sudo service dbus start

ENV NVIDIA_VISIBLE_DEVICES all 
ENV NVIDIA_DRIVER_CAPABILITIES graphics,display

RUN curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | \
    apt-key add -

RUN curl -s -L https://nvidia.github.io/nvidia-container-runtime/ubuntu16.04/amd64/nvidia-container-runtime.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list

RUN apt-get update

RUN apt-get install -y nvidia-container-runtime

RUN curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | \
    apt-key add - 

RUN curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add - 
    
RUN curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu16.04/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list 
    
RUN apt-get update 

RUN apt-get install -y nvidia-container-toolkit 
    


#RUN xrandr

LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}
