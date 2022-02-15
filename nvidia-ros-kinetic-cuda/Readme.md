Docke ros cuda one useful blog: https://kusemanohar.wordpress.com/2018/10/03/docker-for-computer-vision-researchers/

To solve the error:

--gpus all has to be run while running docker 

--runtime=nvidia

For solving this error, 

Install these things on host PC :

nvidia-cua-tookit
nvidia-container-toolkit
nvidia-container-runtime 


distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker


Fixes when installing on ubuntu 18 local system:

1. ORB SLAM: http://20sep1995.blogspot.com/2019/06/error-usleep-is-not-declared-in-this.html
2. Sophus: https://github.com/uzh-rpg/rpg_svo/issues/237
3. rpg_svo - libvkit_common Undefined Reference : https://github.com/uzh-rpg/rpg_svo/issues/21
4. 
