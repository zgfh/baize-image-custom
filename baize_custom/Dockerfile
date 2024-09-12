FROM release.daocloud.io/baize/baize-notebook:v0.7.0
USER root
RUN apt update;apt install -y sudo
RUN echo "jovyan  ALL=(ALL:ALL) NOPASSWD: ALL" >>/etc/sudoers
RUN apt install -y tmux htop tree  
RUN apt install -y gcc g++
RUN apt install -y build-essential cmake 
RUN apt install -y net-tools iputils-ping iproute2 less lrzsz
RUN apt install -y make ;wget https://developer.download.nvidia.com/compute/cuda/12.2.0/local_installers/cuda_12.2.0_535.54.03_linux.run
RUN sh cuda_12.2.0_535.54.03_linux.run --toolkit --silent 
RUN echo "PATH=/usr/local/cuda-12.2/bin:$PATH" >>/etc/profile ;echo "LD_LIBRARY_PATH=/usr/local/cuda-12.2/lib64:$LD_LIBRARY_PATH" >>/etc/profile 
RUN echo "if [ -f ~/.bashrc ]; then source ~/.bashrc ;fi" >> /tmp_home/jovyan/.bash_profile
ENV TZ Asia/Shanghai
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME 300000
USER ${NB_UID} 