FROM osrf/ros:kinetic-desktop-full

RUN rm -rf /var/lib/apt/lists/*

ENV NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=all

# ==================
# below sourced from https://gitlab.com/nvidia/opengl/blob/ubuntu16.04/base/Dockerfile

RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y --no-install-recommends \
        libxau6 libxau6:i386 \
        libxdmcp6 libxdmcp6:i386 \
        libxcb1 libxcb1:i386 \
        libxext6 libxext6:i386 \
        libx11-6 libx11-6:i386 && \
    rm -rf /var/lib/apt/lists/*

ENV LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:/usr/lib/i386-linux-gnu${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# ==================
# below sourced from https://gitlab.com/nvidia/opengl/blob/ubuntu14.04/1.0-glvnd/runtime/Dockerfile

RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-utils && \
    apt-get install -y --no-install-recommends \
        git \
        ca-certificates \
        make \
        automake \
        autoconf \
        libtool \
        pkg-config \
        python \
        libxext-dev \
        libx11-dev \
        x11proto-gl-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/libglvnd

RUN git clone --branch=v1.0.0 https://github.com/NVIDIA/libglvnd.git . && \
    ./autogen.sh && \
    ./configure --prefix=/usr/local --libdir=/usr/local/lib/x86_64-linux-gnu && \
    make -j"$(nproc)" install-strip && \
    find /usr/local/lib/x86_64-linux-gnu -type f -name 'lib*.la' -delete

RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y --no-install-recommends \
        gcc-multilib \
        libxext-dev:i386 \
        libx11-dev:i386 && \
    rm -rf /var/lib/apt/lists/*

# 32-bit libraries
RUN make distclean && \
    ./autogen.sh && \
    ./configure --prefix=/usr/local --libdir=/usr/local/lib/i386-linux-gnu --host=i386-linux-gnu "CFLAGS=-m32" "CXXFLAGS=-m32" "LDFLAGS=-m32" && \
    make -j"$(nproc)" install-strip && \
    find /usr/local/lib/i386-linux-gnu -type f -name 'lib*.la' -delete

COPY 10_nvidia.json /usr/local/share/glvnd/egl_vendor.d/10_nvidia.json

RUN echo '/usr/local/lib/x86_64-linux-gnu' >> /etc/ld.so.conf.d/glvnd.conf && \
    echo '/usr/local/lib/i386-linux-gnu' >> /etc/ld.so.conf.d/glvnd.conf && \
    ldconfig

ENV LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu:/usr/local/lib/i386-linux-gnu${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# ==================
# below sourced from https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/8.0/runtime/Dockerfile

RUN apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub && \
    echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

ENV CUDA_VERSION_MAJOR=8.0 \
    CUDA_VERSION_MINOR=61 \
    CUDA_PKG_EXT=8-0
ENV CUDA_VERSION=$CUDA_VERSION_MAJOR.$CUDA_VERSION_MINOR
RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-nvrtc-dev-$CUDA_PKG_EXT=$CUDA_VERSION-1 \
        cuda-nvgraph-dev-$CUDA_PKG_EXT=$CUDA_VERSION-1 \
        cuda-cusolver-dev-$CUDA_PKG_EXT=$CUDA_VERSION-1 \
        cuda-cublas-dev-$CUDA_PKG_EXT=$CUDA_VERSION.2-1 \
        cuda-cufft-dev-$CUDA_PKG_EXT=$CUDA_VERSION-1 \
        cuda-curand-dev-$CUDA_PKG_EXT=$CUDA_VERSION-1 \
        cuda-cusparse-dev-$CUDA_PKG_EXT=$CUDA_VERSION-1 \
        cuda-npp-dev-$CUDA_PKG_EXT=$CUDA_VERSION-1 \
        cuda-cudart-dev-$CUDA_PKG_EXT=$CUDA_VERSION-1 \
        cuda-misc-headers-$CUDA_PKG_EXT=$CUDA_VERSION-1 && \
    ln -s cuda-$CUDA_VERSION_MAJOR /usr/local/cuda && \
    ln -s /usr/local/cuda-8.0/targets/x86_64-linux/include /usr/local/cuda/include && \
    rm -rf /var/lib/apt/lists/*

# nvidia-docker 1.0
LABEL com.nvidia.volumes.needed="nvidia_driver"
LABEL com.nvidia.cuda.version="${CUDA_VERSION}"

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# nvidia-container-runtime
ENV NVIDIA_REQUIRE_CUDA="cuda>=$CUDA_VERSION_MAJOR"

# ROS Stuff
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list && \
    #apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    apt-get update

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
