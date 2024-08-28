FROM release.daocloud.io/baize/baize-notebook:v0.7.0
USER root
RUN apt update;apt install -y sudo
RUN echo "jovyan  ALL=(ALL:ALL) NOPASSWD: ALL" >>/etc/sudoers
RUN apt install -y tmux htop tree
USER ${NB_UID} 