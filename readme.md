

## 构建
```
bash -x build.sh all
podman tag 127.0.0.1/baize/baize_noteboook 127.0.0.1/baize/baize_noteboook:gpu-maca-c500-2.20.2.19-ubuntu22.04-amd64
podman push --tls-verify=false 127.0.0.1/baize/baize_noteboook:gpu-maca-c500-2.20.2.19-ubuntu22.04-amd64

```

# 更新说明：
1. base 目录复制的（直接覆盖即可，请不要直接在这个目录进行修改，修改通过build.sh）: https://github.com/kubeflow/kubeflow/tree/master/components/example-notebook-servers/base
2. jupyter 目录复制的（直接覆盖即可，请不要直接在这个目录进行修改，修改通过build.sh）: https://github.com/kubeflow/kubeflow/tree/master/components/example-notebook-servers/jupyter
3. baize_notebook: 复制来自https://docs.daocloud.io/baize/best-practice/change-notebook-image/#baize-noteboook-dockerfile