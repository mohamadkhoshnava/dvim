#!/bin/bash

# =============================================================================
# dvim Manager (dvim)
# A complete manager for the Dockerized Neovim Environment.
# =============================================================================

# Configuration
DOCKER_HUB_USER="seyeddev"
IMAGE_NAME="dvim"
FULL_IMAGE_NAME="$DOCKER_HUB_USER/$IMAGE_NAME:latest"
CONTAINER_NAME="dvim-session"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Helper Functions
print_info() { echo -e "${BLUE}[INFO] $1${NC}"; }
print_success() { echo -e "${GREEN}[SUCCESS] $1${NC}"; }
print_warn() { echo -e "${YELLOW}[WARN] $1${NC}"; }
print_error() { echo -e "${RED}[ERROR] $1${NC}"; }

show_help() {
    echo "Usage: dvim [COMMAND] [ARGS]"
    echo ""
    echo "Commands:"
    echo "  run [path]     Open a directory (default: current dir)"
    echo "  install        Make 'dvim' executable and globally accessible"
    echo "  update         Pull the latest image from Docker Hub"
    echo "  build          Build the image locally"
    echo "  remove         Remove the Docker image"
    echo "  help           Show this help message"
    echo ""
}

# 1. Run Command
do_run() {
    local TARGET_DIR="${1:-$(pwd)}"
    
    # Resolve absolute path
    TARGET_DIR=$(cd "$TARGET_DIR" && pwd)
    
    # Determine Image Source
    local IMAGE_TO_RUN=""
    
    # 1. Check for Local Build ('dvim')
    if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" != "" ]]; then
         IMAGE_TO_RUN=$IMAGE_NAME
    else
    # 2. Fallback to Remote Image
         IMAGE_TO_RUN=$FULL_IMAGE_NAME
         if [[ "$(docker images -q $IMAGE_TO_RUN 2> /dev/null)" == "" ]]; then
             print_info "Image $IMAGE_TO_RUN not found locally. Pulling from Docker Hub..."
             docker pull $IMAGE_TO_RUN || { print_error "Failed to pull image."; exit 1; }
         fi
    fi
    
    print_info "Starting Neovim in: $TARGET_DIR"
    
    # Persistence Setup
    # we use ~/.dvim-data on the host to store plugins and state
    HOST_DATA_HOME="$HOME/.dvim-data/share"
    HOST_STATE_HOME="$HOME/.dvim-data/state"
    HOST_CACHE_HOME="$HOME/.dvim-data/cache"
    
    mkdir -p "$HOST_DATA_HOME" "$HOST_STATE_HOME" "$HOST_CACHE_HOME"

    # Run Container
    # - Mounts:
    #   1. Target Dir -> /home/developer/workspace
    #   2. Persistence mounts for nvim data
    
    docker run --rm -it \
        -v "$TARGET_DIR":/home/developer/workspace \
        -v "$HOST_DATA_HOME":/home/developer/.local/share/nvim \
        -v "$HOST_STATE_HOME":/home/developer/.local/state/nvim \
        -v "$HOST_CACHE_HOME":/home/developer/.cache/nvim \
        -e TERM=xterm-256color \
        --name "$CONTAINER_NAME-$(date +%s)" \
        "$IMAGE_TO_RUN" \
        bash -c "nvim ."
}

# 2. Update Command
do_update() {
    print_info "Updating image from Docker Hub..."
    docker pull $FULL_IMAGE_NAME
    print_success "Update complete!"
}

# 3. Build Command
do_build() {
    print_info "Building image locally..."
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    docker build -t $IMAGE_NAME "$SCRIPT_DIR"
    print_success "Build complete!"
}

# 4. Remove Command
do_remove() {
    print_info "Removing images..."
    docker rmi $FULL_IMAGE_NAME $IMAGE_NAME 2>/dev/null
    print_success "Images removed."
}

# 5. Install Command
do_install() {
    if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "darwin"* ]]; then
        INSTALL_PATH="/usr/local/bin/dvim"
        
        # Check for root/sudo
        if [ "$EUID" -ne 0 ]; then
            print_warn "Installation requires root privileges."
            echo "Please run: sudo ./dvim.sh install"
            exit 1
        fi

        print_info "Installing dvim to $INSTALL_PATH..."
        cp "${BASH_SOURCE[0]}" "$INSTALL_PATH"
        chmod +x "$INSTALL_PATH"
        
        print_success "Successfully installed!"
        print_info "You can now type 'dvim' in any new terminal window."
    else
        print_error "OS not supported for auto-install. Please add to PATH manually."
    fi
}

# Main Logic
case "$1" in
    run|"")
        do_run "$2"
        ;;
    install)
        do_install
        ;;
    update)
        do_update
        ;;
    build)
        do_build
        ;;
    remove|delete)
        do_remove
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        # Treat first argument as path if not a command
        if [ -d "$1" ] || [ -f "$1" ]; then
            do_run "$1"
        else
            show_help
        fi
        ;;
esac
