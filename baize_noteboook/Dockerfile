ARG BASE_IMG=docker.m.daocloud.io/kubeflownotebookswg/jupyter:v1.8.0

FROM $BASE_IMG

USER root

# install - useful linux packages
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get -yq update \
 && apt-get -yq install --no-install-recommends \
    openssh-server git git-lfs bash-completion \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# remove default s6 jupyterlab run script
RUN rm -rf /etc/services.d/jupyterlab

# install - useful jupyter plugins
RUN mamba install -n base -y jupyterlab-language-pack-zh-cn \
  && mamba clean --all -y

ARG CODESERVER_VERSION=4.89.1
ARG TARGETARCH

RUN curl -fsSL "https://github.com/coder/code-server/releases/download/v$CODESERVER_VERSION/code-server_${CODESERVER_VERSION}_$TARGETARCH.deb" -o /tmp/code-server.deb 
RUN dpkg -i /tmp/code-server.deb \
  && rm -f /tmp/code-server.deb

ARG CODESERVER_PYTHON_VERSION=2024.4.1
ARG CODESERVER_JUPYTER_VERSION=2024.3.1
ARG CODESERVER_LANGUAGE_PACK_ZH_CN=1.89.0
ARG CODESERVER_YAML=1.14.0
ARG CODESERVER_DOTENV=1.0.1
ARG CODESERVER_EDITORCONFIG=0.16.6
ARG CODESERVER_TOML=0.19.1
ARG CODESERVER_GITLENS=15.0.4

# configure for code-server extensions
# # https://github.com/kubeflow/kubeflow/blob/709254159986d2cc99e675d0fad5a128ddeb0917/components/example-notebook-servers/codeserver-python/Dockerfile
# # and
# # https://github.com/kubeflow/kubeflow/blob/709254159986d2cc99e675d0fad5a128ddeb0917/components/example-notebook-servers/codeserver/Dockerfile
RUN code-server --list-extensions --show-versions \
  && code-server --list-extensions --show-versions \
  && code-server \
    --install-extension MS-CEINTL.vscode-language-pack-zh-hans@$CODESERVER_LANGUAGE_PACK_ZH_CN \
    --install-extension ms-python.python@$CODESERVER_PYTHON_VERSION \
    --install-extension ms-toolsai.jupyter@$CODESERVER_JUPYTER_VERSION \
    --install-extension redhat.vscode-yaml@$CODESERVER_YAML \
    --install-extension mikestead.dotenv@$CODESERVER_DOTENV \
    --install-extension EditorConfig.EditorConfig@$CODESERVER_EDITORCONFIG \
    --install-extension tamasfe.even-better-toml@$CODESERVER_TOML \
    --install-extension eamodio.gitlens@$CODESERVER_GITLENS \
    --install-extension catppuccin.catppuccin-vsc-pack \
    --force \
  && code-server --list-extensions --show-versions

# configure for code-server
RUN mkdir -p /home/${NB_USER}/.local/share/code-server/User \
  && chown -R ${NB_USER}:users /home/${NB_USER} \
  && cat <<EOF > /home/${NB_USER}/.local/share/code-server/User/settings.json
{
  "gitlens.showWelcomeOnInstall": false,
  "workbench.colorTheme": "Catppuccin Mocha",
}
EOF

RUN mkdir -p /tmp_home/${NB_USER}/.local/share \
  && mv /home/${NB_USER}/.local/share/code-server /tmp_home/${NB_USER}/.local/share

# set ssh configuration
RUN mkdir -p /run/sshd \
 && chown -R ${NB_USER}:users /etc/ssh \
 && chown -R ${NB_USER}:users /run/sshd \
 && sed -i "/#\?Port/s/^.*$/Port 2222/g" /etc/ssh/sshd_config \
 && sed -i "/#\?PasswordAuthentication/s/^.*$/PasswordAuthentication no/g" /etc/ssh/sshd_config \
 && sed -i "/#\?PubkeyAuthentication/s/^.*$/PubkeyAuthentication yes/g" /etc/ssh/sshd_config \
 && rclone_version=v1.65.0 && \
       arch=$(uname -m | sed -E 's/x86_64/amd64/g;s/aarch64/arm64/g') && \
       filename=rclone-${rclone_version}-linux-${arch} && \
       curl -fsSL http://github.com/rclone/rclone/releases/download/${rclone_version}/${filename}.zip -o ${filename}.zip && \
       unzip ${filename}.zip && mv ${filename}/rclone /usr/local/bin && rm -rf ${filename} ${filename}.zip

# Init mamba
RUN mamba init --system

# init baize-base environment for essential python packages
RUN mv /opt/conda/pkgs /opt/conda/pkgs.back;mamba create -n baize-base -y python \
  && /opt/conda/envs/baize-base/bin/pip install tensorboard \
  && mamba clean --all -y \
  && ln -s /opt/conda/envs/baize-base/bin/tensorboard /usr/local/bin/tensorboard

# prepare baize-runtime-env directory
RUN mkdir -p /opt/baize-runtime-env \
  && chown -R ${NB_USER}:users /opt/baize-runtime-env

ARG APP
ARG PROD_NAME
ARG TARGETOS

COPY out/data-loader /usr/local/bin/
COPY out/baizectl /usr/local/bin/

RUN chmod +x /usr/local/bin/baizectl /usr/local/bin/data-loader && \
    echo "source /etc/bash_completion" >> /opt/conda/etc/profile.d/conda.sh && \
    echo "source <(baizectl completion bash)" >> /opt/conda/etc/profile.d/conda.sh && \
    echo "source <(kubectl completion bash)" >> /opt/conda/etc/profile.d/conda.sh && \
    echo '[ -f /run/baize-env ] && export $(cat /run/baize-env | xargs)' >> /opt/conda/etc/profile.d/conda.sh && \
    echo 'alias conda="mamba"' >> /opt/conda/etc/profile.d/conda.sh

USER ${NB_UID}
