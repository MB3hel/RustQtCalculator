# RustQtCalcualtor

Experiments with using QT QML and rust


## Building

1. Install Rust
    ```sh
    # Windows using https://scoop.sh
    scoop install rustup

    # macOS w/ https://brew.sh
    brew install rustup

    # Ubuntu
    sudo apt install rustup

    # Fedora
    sudo dnf install rustup

    # All OSes after installing rustup
    # Make sure to install the OS's native toolchain as instructed
    rustup-init
    ```

2. Install other build dependencies
    ```sh
    # On windows, busybox is needed to run cargow script from cmd or powershell
    # Alternatively can use msys2 bash or git bash
    scoop install busybox-lean
    ```

2. Install required C++ libraries using `vcpkg`
    ```sh
    # On Linux, first, install required system packages. These lists may be incomplete
    # Ubuntu:
    sudo apt install build-essential git curl zip unzip tar pkg-config \
            libgl1-mesa-dev libglu1-mesa-dev \
            '^libxcb.*-dev' libx11-xcb-dev libxrender-dev libxi-dev \
            libxkbcommon-dev libxkbcommon-x11-dev


    # Fedora:
    sudo dnf install @development-tools
    sudo dnf install git curl zip unzip tar pkgconfig \
            mesa-libGL-devel mesa-libGLU-devel \
            libxcb-devel xcb-util-devel xcb-util-image-devel xcb-util-keysyms-devel \
            xcb-util-renderutil-devel xcb-util-wm-devel libX11-xcb \
            libXrender-devel libXi-devel libxkbcommon-devel libxkbcommon-x11-devel



    # All OSes (including Windows and macOS)
    ./cargow install cargo-vcpkg
    ./cargow vcpkg -v build
    ```

3. Build
    ```sh
    ./cargow build
    ```
