FROM alpine:edge

ENV TERM=xterm-256color

# Install dependencies using apk (faster and lighter than apt)
RUN apk add --no-cache \
    curl \
    git \
    wget \
    unzip \
    tar \
    gzip \
    build-base \
    python3 \
    py3-pip \
    nodejs \
    npm \
    ripgrep \
    fd \
    xclip \
    neovim \
    bash \
    shadow \
    sudo

# Set up locale
ENV LANG=C.UTF-8

# Create a user 'developer' to match the host user UID/GID
ARG USER_ID=1000
ARG GROUP_ID=1000

# Create user using shadow tools (installed above)
RUN groupadd -g ${GROUP_ID} developer && \
    useradd -m -u ${USER_ID} -g developer -s /bin/bash developer

# Copy configuration into the image
COPY --chown=developer:developer config/nvim /home/developer/.config/nvim

USER developer
WORKDIR /home/developer/workspace

# Set XDG_CONFIG_HOME for Neovim
ENV XDG_CONFIG_HOME=/home/developer/.config

# Keep container running
CMD ["tail", "-f", "/dev/null"]
