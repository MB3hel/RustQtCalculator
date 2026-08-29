# RustQtCalcualtor

Experiments with using QT QML and rust


## Building

1. [Install Rust](https://rust-lang.org/tools/install/). Make sure to install the toolchain for your system too as instructed.

2. [Install vcpkg](https://learn.microsoft.com/en-us/vcpkg/get_started/get-started?pivots=shell-powershell). Make sure the `VCPKG_ROOT` environment variable is set. Only the first two steps on the linked page are required (clone and env vars)

3. On windows, install busybox to provide a posix shell (all other commands should be run inside busybox sh on window). You can alternatively use msys2's bash or git bash.
    ```sh
    # Eg using https://https://scoop.sh/
    scoop install busybox-lean
    busybox sh
    ```

3. Setup environment vars for build
    ```sh
    . ./activate
    ```

3. Install required C++ libraries using `vcpkg`
    ```sh
    # All OSes
    install-builddeps
    vcpkg install
    ```

3. Build
    ```sh
    cargo build
    ```

4. Run
    ```sh
    cargo run RustQtCalcualtor
    ```
