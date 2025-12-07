FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:neovim-ppa/stable -y \
    && apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    unzip \
    tar \
    gzip \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    ripgrep \
    fd-find \
    locales \
    xclip \
    neovim \
    && rm -rf /var/lib/apt/lists/*

# Set up locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Create a user 'developer' to match the host user UID/GID (ideal for mapped volumes)
# We use a generic ID 1000 which is common for the first user.
ARG USER_ID=1000
ARG GROUP_ID=1000

RUN groupadd -g ${GROUP_ID} developer && \
    useradd -m -u ${USER_ID} -g developer -s /bin/bash developer

# Copy configuration into the image
COPY --chown=developer:developer config/nvim /home/developer/.config/nvim

USER developer
WORKDIR /home/developer/workspace

# Set XDG_CONFIG_HOME for Neovim to find config at ~/.config/nvim
ENV XDG_CONFIG_HOME=/home/developer/.config
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en

# Keep container running
CMD ["tail", "-f", "/dev/null"]
