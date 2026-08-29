# RustQtCalcualtor

Experiments with using QT QML and rust


## Building

1. [Install Rust](https://rust-lang.org/tools/install/). Make sure to install the toolchain for your system too as instructed.

2. [Install vcpkg](https://learn.microsoft.com/en-us/vcpkg/get_started/get-started?pivots=shell-powershell). Make sure the `VCPKG_ROOT` environment variable is set. Only the first two steps on the linked page are required (clone and env vars)

3. Setup environment vars for build.
```sh
    # Optionally set CARGO_BUILD_TARGET env var first if you intend to cross compile
    
    # Windows (powershell not cmd)
    . .\activate.ps1

    # Everything else (including MSYS2 bash/zsh on windows)
    # Note: cargo build will probably not work in busybox on windows, if using this on windows must be MSYS2
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
