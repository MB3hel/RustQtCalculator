#!/usr/bin/env sh

case "$(uname -o)" in
    GNU/Linux)
        ;;
    *)
        echo "$(basename "$0") is only needed on Linux distros"
        exit 1
        ;;
esac


DISTRO="$(cat /etc/os-release | grep ^ID= | sed 's/^ID=//g')"
case "$DISTRO" in
    ubuntu|debian)
        (
            set -x
            sudo apt install build-essential git curl zip unzip tar \
                pkg-config libgl1-mesa-dev libglu1-mesa-dev '^libxcb.*-dev' \
                libx11-xcb-dev libxrender-dev libxi-dev libxkbcommon-dev \
                libxkbcommon-x11-dev
        )
        ;;
    fedora|rhel|almalinux|rocky)
        (
            set -x
            sudo dnf install @development-tools git curl zip unzip \
                tar pkgconfig mesa-libGL-devel mesa-libGLU-devel \
                libxcb-devel xcb-util-devel xcb-util-image-devel \
                xcb-util-keysyms-devel xcb-util-renderutil-devel \
                xcb-util-wm-devel libX11-xcb libXrender-devel libXi-devel \
                libxkbcommon-devel libxkbcommon-x11-devel gcc-c++ \
                autoconf autoconf-archive automake libtoolize cmake \
                ninja-build perl-open libXi-devel libXtst-devel \
                libXrandr-devel perl-IPC-Cmd kernel-devel perl-Time-Piece
        )
        ;;
esac

