registry="127.0.0.1/baize/"
base_image="103.237.29.138/cr.metax-tech.com/library/maca-c500:2.20.2.19-ubuntu22.04-amd64"

#podman_build_params="--env=all_proxy=http://xx:xx"  # 如果构建慢可以增加代理配置

build_base(){
  mkdir -p build
  rm -rf build/base ;cp -r base build/base ;cd build/base
  sed -i 's@dl.k8s.io@files.m.daocloud.io/dl.k8s.io@g' Dockerfile
  #TODO  加速不支持kubectl.sha256，临时删除
  sed -i '/kubectl.sha256/d' Dockerfile
  podman build $podman_build_params --build-arg BASE_IMG=${base_image} --build-arg TARGETARCH=amd64 --build-arg KUBECTL_VERSION=v1.29.5  -t ${registry}base .
  cd ../../
}

build_jupyter(){
  mkdir -p build
  rm -rf build/jupyter ;cp -r jupyter build/jupyter ;cd build/jupyter
  # for easy debug
  sed -i 's#curl -fsSL#curl -fL#g' Dockerfile

  sed -i 's#/tmp/Miniforge3.sh.sha256 \\#/tmp/Miniforge3.sh.sha256 #g' Dockerfile
  sed -i 's# && /bin/bash /tmp/Miniforge3.sh#RUN /bin/bash /tmp/Miniforge3.sh#g' Dockerfile
  #podman build $podman_build_params --build-arg BASE_IMG=${registry}base --build-arg TARGETARCH=amd64 -t ${registry}jupyter .
  cd ../../
}

build_baize_noteboook(){
  mkdir -p build
  rm -rf build/baize_noteboook ;cp -r baize_noteboook build/baize_noteboook ;cd build/baize_noteboook
  sed -i 's#curl -fsSL#curl -fL#g' Dockerfile
  podman build $podman_build_params --build-arg BASE_IMG=${registry}jupyter --build-arg TARGETARCH=amd64 -t ${registry}baize_noteboook .
  cd ../../
}

if [ "$1" == "" ];then
 echo "eg:"
elif [ "$1" == "all" ];then
#build_base
#build_jupyter
build_baize_noteboook
else
build_$1
fi
#build_base
#build_jupyter

