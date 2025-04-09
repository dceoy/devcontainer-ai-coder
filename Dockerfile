# syntax=docker/dockerfile:1
ARG UBUNTU_VERSION=24.04
FROM public.ecr.aws/docker/library/ubuntu:${UBUNTU_VERSION} AS builder

ARG PYTHON_VERSION=3.13

ENV DEBIAN_FRONTEND noninteractive
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONIOENCODING=utf-8
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_NO_CACHE_DIR=1
ENV POETRY_HOME=/opt/poetry
ENV POETRY_VIRTUALENVS_CREATE=false
ENV POETRY_NO_INTERACTION=true

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

RUN \
      rm -f /etc/apt/apt.conf.d/docker-clean \
      && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' \
        > /etc/apt/apt.conf.d/keep-cache

# hadolint ignore=DL3008
RUN \
      --mount=type=cache,target=/var/cache/apt,sharing=locked \
      --mount=type=cache,target=/var/lib/apt,sharing=locked \
      apt-get -qy update \
      && apt-get -qy install --no-install-recommends --no-install-suggests \
        ca-certificates curl gnupg lsb-release software-properties-common \
      && add-apt-repository ppa:deadsnakes/ppa

RUN \
      curl -fsSL -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
        https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
      && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        | tee /etc/apt/sources.list.d/github-cli.list

# hadolint ignore=DL3008
RUN \
      --mount=type=cache,target=/var/cache/apt,sharing=locked \
      --mount=type=cache,target=/var/lib/apt,sharing=locked \
      apt-get -qy update \
      && apt-get -qy upgrade \
      && apt-get -qy install --no-install-recommends --no-install-suggests \
        gcc gh git libc6-dev libncurses-dev make nodejs npm "python${PYTHON_VERSION}-dev" unzip

RUN \
      --mount=type=cache,target=/root/.cache \
      ln -s "python${PYTHON_VERSION}" /usr/bin/python \
      && curl -SL -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py \
      && /usr/bin/python /tmp/get-pip.py \
      && /usr/bin/python -m pip install -U --no-cache-dir --prefix=/usr/local \
        aider-install pip pipx poetry uv \
      && rm -f /tmp/get-pip.py

# hadolint ignore=DL3016
RUN \
      --mount=type=cache,target=/root/.cache \
      npm update -g \
      && npm install -g \
        npx @anthropic-ai/claude-code

RUN \
      --mount=type=cache,target=/root/.cache \
      curl -fsSL -o /tmp/awscliv2.zip \
        "https://awscli.amazonaws.com/awscli-exe-linux-$([ "$(uname -m)" = 'x86_64' ] && echo 'x86_64' || echo 'aarch64').zip" \
      && unzip /tmp/awscliv2.zip -d /tmp \
      && /tmp/aws/install \
      && rm -rf /tmp/awscliv2.zip /tmp/aws

RUN \
      --mount=type=cache,target=/root/.cache \
      curl -SL -o /usr/local/bin/install_latest_vim.sh \
        https://raw.githubusercontent.com/dceoy/install-latest-vim/refs/heads/master/install_latest_vim.sh \
      && curl -SL -o /usr/local/bin/update_vim_plugins.sh \
        https://raw.githubusercontent.com/dceoy/install-latest-vim/refs/heads/master/update_vim_plugins.sh \
      && chmod +x /usr/local/bin/install_latest_vim.sh /usr/local/bin/update_vim_plugins.sh \
      && /usr/local/bin/install_latest_vim.sh --lua --python3="/usr/bin/python${PYTHON_VERSION}" --vim-plug /usr/local


FROM public.ecr.aws/docker/library/ubuntu:${UBUNTU_VERSION} AS cli

ARG PYTHON_VERSION=3.13
ARG USER_NAME=devcontainer
ARG USER_UID=1001
ARG USER_GID=1001

COPY --from=builder /usr/local /usr/local
COPY --from=builder /etc/apt/apt.conf.d/keep-cache /etc/apt/apt.conf.d/keep-cache

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONIOENCODING=utf-8

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

RUN \
      ln -s "python${PYTHON_VERSION}" /usr/bin/python \
      && rm -f /etc/apt/apt.conf.d/docker-clean

# hadolint ignore=DL3008
RUN \
      --mount=type=cache,target=/var/cache/apt,sharing=locked \
      --mount=type=cache,target=/var/lib/apt,sharing=locked \
      apt-get -qy update \
      && apt-get -qy install --no-install-recommends --no-install-suggests \
        software-properties-common \
      && add-apt-repository ppa:deadsnakes/ppa

COPY --from=builder /usr/share/keyrings/githubcli-archive-keyring.gpg /usr/share/keyrings/githubcli-archive-keyring.gpg
COPY --from=builder /etc/apt/sources.list.d/github-cli.list /etc/apt/sources.list.d/github-cli.list

# hadolint ignore=DL3008
RUN \
      --mount=type=cache,target=/var/cache/apt,sharing=locked \
      --mount=type=cache,target=/var/lib/apt,sharing=locked \
      apt-get -qy update \
      && apt-get -qy upgrade \
      && apt-get -qy install --no-install-recommends --no-install-suggests \
        build-essential ca-certificates colordiff curl gh git nodejs npm \
        "python${PYTHON_VERSION}" sudo time tree wget zsh

RUN \
      groupadd --gid "${USER_GID}" "${USER_NAME}" \
      && useradd --uid "${USER_UID}" --gid "${USER_GID}" --shell /usr/bin/zsh --create-home "${USER_NAME}"

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

RUN \
      curl -SL -o /tmp/install-ohmyzsh.sh \
        https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
      && chmod +x /tmp/install-ohmyzsh.sh \
      && /tmp/install-ohmyzsh.sh --unattended \
      && rm -f /tmp/install-ohmyzsh.sh

RUN \
      curl -fsSL -o "${HOME}/.oh-my-zsh/custom/themes/dceoy.zsh-theme" \
        https://raw.githubusercontent.com/dceoy/ansible-dev-server/refs/heads/master/roles/cli/files/dceoy.zsh-theme \
      && sed -ie 's/^ZSH_THEME=.*/ZSH_THEME="dceoy"/' "${HOME}/.zshrc"

RUN \
      curl -SL -o "${HOME}/.vimrc" \
        https://raw.githubusercontent.com/dceoy/ansible-dev-server/refs/heads/master/roles/vim/files/vimrc \
      && /usr/local/bin/update_vim_plugins.sh

HEALTHCHECK NONE

ENTRYPOINT ["/usr/bin/zsh"]
