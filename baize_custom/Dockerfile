FROM release.daocloud.io/baize/baize-notebook:v0.7.0
USER root
RUN apt update;apt install sudo
RUN echo "jovyan  ALL=(ALL:ALL) NOPASSWD: ALL" >>/etc/sudoers
USER ${NB_UID} 