# bash and zsh compatible


# Get path of activate.sh
if [ -n "$BASH_SOURCE" ]; then
    _PROJ_DIR="$(dirname "${BASH_SOURCE[0]}")"
elif [ -n "$ZSH_VERSION" ]; then
    _PROJ_DIR="$(dirname "${(%):-%x}")"
else
    _PROJ_DIR="$(dirname "$0")"
fi


# Make sure VCPKG_ROOT is set
if [ -z "$VCPKG_ROOT" ]; then
    echo "ERROR: VCPKG_ROOT is not set" >&2
    return 1
fi
if [ "$(uname -o)" = "Msys" ]; then
    # On windows under msys2, windows style paths here break things
    VCPKG_ROOT="$(cygpath -u "$VCPKG_ROOT")"
fi
export VCPKG_ROOT
export PATH="$VCPKG_ROOT:$PATH"


# Determine vcpkg host triplet
# Need to use dynamic b/c QT doesn't support static linking well
ARCH="unknown"
case "$(uname -m)" in
    x86_64)
        ARCH="x64"
        ;;
    i686|i586|i486|i386)
        ARCH="x86"
        ;;
    arm64|aarch64)
        ARCH="arm64"
        ;;
    *)
        echo "ERROR: Unkown host architecture" >&2
        return 1
        ;;
esac
OS="unknown"
case "$(uname -o)" in
    Msys|"MS/Windows")
        OS="windows"
        ;;
    Darwin)
        OS="osx-dynamic"
        ;;
    "GNU/Linux")
        OS="linux-dynamic"
        ;;
    *)
        echo "ERROR: Unkown host OS" >&2
        return 1
        ;;
esac
export VCPKG_DEFAULT_HOST_TRIPLET="$ARCH-$OS"


# Determine vcpkg target triplet based on cargo target triplet
# If no cargo target triplet given, assume building for host system
if [ -z "$CARGO_BUILD_TARGET" ]; then
    export VCPKG_DEFAULT_TRIPLET="$VCPKG_DEFAULT_HOST_TRIPLET"
else
    case "$CARGO_BUILD_TARGET" in
        "x86_64-pc-windows-msvc")
            export VCPKG_DEFAULT_TRIPLET="x64-windows"
            ;;
        "arm64-pc-windows-msvc")
            export VCPKG_DEFAULT_TRIPLET="arm64-windows"
            ;;
        "arm64-apple-darwin")
            export VCPKG_DEFAULT_TRIPLET="arm64-osx-dynamic"
            ;;
        "arm64-unknown-linux-gnu")
            export VCPKG_DEFAULT_TRIPLET="x64-linux-dynamic"
            ;;
        *)
            echo "ERROR: Unknown cargo target '$CARGO_BUILD_TARGET'" >&2
            return 1
            ;; 
    esac
fi
export VCPKGRS_DYNAMIC=1


# Prepend vcpkg installed qmake to the path so it is found first
export PATH="$_PROJ_DIR/vcpkg_installed/$VCPKG_DEFAULT_HOST_TRIPLET/tools/Qt6/bin/:$PATH"


# Helper function to install build dependencies before vcpkg install on liunx distros
install-builddeps(){
    case "$(uname -o)" in
        GNU/Linux)
            ;;
        *)
            echo "No build deps on this OS"
            return 1
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
                    libxkbcommon-x11-dev autoconf autoconf-archive automake libtool \
                    python3 python3-venv bison libxtst-dev libxrandr-dev flex \
                    libwayland-dev libsm-dev libice-dev libx11-dev
            )
            return $?
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
                    autoconf autoconf-archive automake libtool cmake \
                    ninja-build perl-open libXi-devel libXtst-devel \
                    libXrandr-devel perl-IPC-Cmd kernel-devel perl-Time-Piece \
                    wayland-devel libSM-devel libICE-devel 'xcb-util-*-devel' \
                    libxcb-devel libxkbcommon-x11-devel xcb-util-cursor-devel
            )
            return $?
            ;;
    esac
}

