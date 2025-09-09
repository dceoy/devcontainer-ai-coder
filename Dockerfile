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
      apt-get -yqq update \
      && apt-get -yqq install --no-install-recommends --no-install-suggests \
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
      apt-get -yqq update \
      && apt-get -yqq upgrade \
      && apt-get -yqq install --no-install-recommends --no-install-suggests \
        gcc gh git libc6-dev libncurses-dev make nodejs npm "python${PYTHON_VERSION}-dev" unzip

RUN \
      curl -fsSL -o /usr/local/bin/print-github-tags \
        https://raw.githubusercontent.com/dceoy/print-github-tags/master/print-github-tags \
      && chmod +x /usr/local/bin/print-github-tags

RUN \
      --mount=type=cache,target=/root/.cache \
      ln -s "python${PYTHON_VERSION}" /usr/bin/python \
      && curl -fsSL -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py \
      && /usr/bin/python /tmp/get-pip.py \
      && /usr/bin/python -m pip install -U --no-cache-dir --prefix=/usr/local \
        pip pipx poetry uv \
      && rm -f /tmp/get-pip.py

RUN \
      --mount=type=cache,target=/root/.cache \
      curl -fsSL -o /tmp/awscliv2.zip \
        "https://awscli.amazonaws.com/awscli-exe-linux-$([ "$(uname -m)" = 'x86_64' ] && echo 'x86_64' || echo 'aarch64').zip" \
      && unzip /tmp/awscliv2.zip -d /tmp \
      && /tmp/aws/install \
      && rm -rf /tmp/awscliv2.zip /tmp/aws

RUN \
      curl -fsSL -o /usr/local/bin/oh-my-zsh \
        https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
      && chmod +x /usr/local/bin/oh-my-zsh

RUN \
      --mount=type=cache,target=/root/.cache \
      curl -fsSL -o /usr/local/bin/install_latest_vim.sh \
        https://raw.githubusercontent.com/dceoy/install-latest-vim/refs/heads/master/install_latest_vim.sh \
      && curl -fsSL -o /usr/local/bin/update_vim_plugins.sh \
        https://raw.githubusercontent.com/dceoy/install-latest-vim/refs/heads/master/update_vim_plugins.sh \
      && chmod +x /usr/local/bin/install_latest_vim.sh /usr/local/bin/update_vim_plugins.sh \
      && /usr/local/bin/install_latest_vim.sh --lua --python3="/usr/bin/python${PYTHON_VERSION}" --vim-plug /usr/local


FROM public.ecr.aws/docker/library/ubuntu:${UBUNTU_VERSION} AS base

ARG PYTHON_VERSION=3.13

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
      apt-get -yqq update \
      && apt-get -yqq install --no-install-recommends --no-install-suggests \
        software-properties-common \
      && add-apt-repository ppa:deadsnakes/ppa

COPY --from=builder /usr/share/keyrings/githubcli-archive-keyring.gpg /usr/share/keyrings/githubcli-archive-keyring.gpg
COPY --from=builder /etc/apt/sources.list.d/github-cli.list /etc/apt/sources.list.d/github-cli.list

# hadolint ignore=DL3008
RUN \
      --mount=type=cache,target=/var/cache/apt,sharing=locked \
      --mount=type=cache,target=/var/lib/apt,sharing=locked \
      apt-get -yqq update \
      && apt-get -yqq upgrade \
      && apt-get -yqq install --no-install-recommends --no-install-suggests \
        build-essential ca-certificates colordiff curl gh git nodejs npm \
        "python${PYTHON_VERSION}" sudo time tree wget zsh

HEALTHCHECK NONE

ENTRYPOINT ["/usr/bin/zsh"]


FROM base AS cli

ARG USER_NAME=cli
ARG USER_UID=1001
ARG USER_GID=1001

# hadolint ignore=DL3016
RUN \
      --mount=type=cache,target=/root/.cache \
      npm install -g \
        @anthropic-ai/claude-code @google/gemini-cli @openai/codex

RUN \
      groupadd --gid "${USER_GID}" "${USER_NAME}" \
      && useradd --uid "${USER_UID}" --gid "${USER_GID}" --shell /usr/bin/zsh --create-home "${USER_NAME}"

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

RUN \
      /usr/local/bin/oh-my-zsh --unattended \
      && curl -fsSL -o "${HOME}/.oh-my-zsh/custom/themes/dceoy.zsh-theme" \
        https://raw.githubusercontent.com/dceoy/ansible-dev-server/refs/heads/master/roles/cli/files/dceoy.zsh-theme \
      && sed -ie 's/^ZSH_THEME=.*/ZSH_THEME="dceoy"/' "${HOME}/.zshrc"

RUN \
      curl -fsSL -o "${HOME}/.vimrc" \
        https://raw.githubusercontent.com/dceoy/ansible-dev-server/refs/heads/master/roles/vim/files/vimrc \
      && /usr/local/bin/update_vim_plugins.sh

RUN \
      echo '.DS_Store' > "${HOME}/.gitignore" \
      && git config --global color.ui auto \
      && git config --global core.excludesfile "${HOME}/.gitignore" \
      && git config --global core.pager '' \
      && git config --global core.quatepath false \
      && git config --global core.precomposeunicode false \
      && git config --global gui.encoding utf-8 \
      && git config --global fetch.prune true \
      && git config --global push.default matching \
      && git config --global user.name "${USER_NAME}" \
      && git config --global user.email "${USER_NAME}@localhost"
