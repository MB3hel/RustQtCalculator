# NOTE: Maintain posix sh compatability in this script b/c windows
# builds may use it via busybox ash

usage(){
    echo "Usage: . activate.sh [--target cargo_triplet] [-h|--help]"
    return 1
}


# Parse arguments
while [ $# -gt 0 ]; do
    case "$1" in
        --target)
            export CARGO_BUILD_TARGET="$2"
            shift
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "ERROR: Unknown argument '$1'" >&2
            usage
            ;;
    esac
done
set --


# Check that activate.sh is being sourced from the same folder
# No reliable way to get path of sourced script in posix sh
# so have to enforce cwd being known
if [ -f .activate_check ] && [ "$(sha256sum .activate_check | cut -d' ' -f1)" = "d82990edb2f5c044fbd1348b93c6584102c9af0bf44eaa6a8ad9b1c97a95f14b" ]; then
    true
else
    echo "ERROR: You must cd into the same directory as activate.sh first!" >&2
    return 1
fi


# Make sure vcpkg is installed and VCPKG_ROOT is set (or vcpkg is in PATH)
if [ -z "$VCPKG_ROOT" ]; then
    type vcpkg > /dev/null 2>&1 && VCPKG_ROOT="$(dirname "$(realpath "$(which vcpkg)")")"
fi
if [ -z "$VCPKG_ROOT" ]; then
    echo "ERROR: Could not find vcpkg. Make sure VCPKG_ROOT is set." >&2
    return 1
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


# Determine vcpkg target triplet based on provided cargo target triplet
# If no cargo target triplet given via command line, assume building
# for host system
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


# Note: vcpkg will not read this varaible when invoked. This is just set for build.rs
export VCPKG_INSTALLED_ROOT="$PWD/vcpkg_installed"


# Need to make sure that, once installed, vcpkg's qt qmake for host is in path before
# any other qmake (such as distro provided package). So append the directory that it will
# exist under after vcpkg install to the PATH now
# This **must** be done before cargo is invoked. Cannot do it in build.rs as env vars from build.rs
# will not impact building of other crates such as qtbridge (which uses qmake to identify qt install)
export PATH="$VCPKG_INSTALLED_ROOT/$VCPKG_DEFAULT_HOST_TRIPLET/tools/Qt6/bin/:$PATH"


# Helper function to install build dependencies before vcpkg install on liunx distros
install-builddeps(){
    case "$(uname -o)" in
        GNU/Linux)
            ;;
        *)
            echo "No build deps on this OS"
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
                    libxkbcommon-x11-dev autoconf autoconf-archive automake libtool \
                    python3 python3-venv bison libxtst-dev libxrandr-dev flex \
                    libwayland-dev libsm-dev libice-dev libx11-dev
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
                    autoconf autoconf-archive automake libtool cmake \
                    ninja-build perl-open libXi-devel libXtst-devel \
                    libXrandr-devel perl-IPC-Cmd kernel-devel perl-Time-Piece \
                    wayland-devel libSM-devel libICE-devel 'xcb-util-*-devel' \
                    libxcb-devel libxkbcommon-x11-devel xcb-util-cursor-devel
            )
            ;;
    esac
}
