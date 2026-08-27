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
    # On Linux, install build deps using system package manager
    ./linuxdeps.sh

    # All OSes
    ./cargow install cargo-vcpkg
    ./cargow vcpkg -v build
    ```

3. Build
    ```sh
    ./cargow build
    ```
