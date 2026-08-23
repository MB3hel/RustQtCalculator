# RustQtCalcualtor

Experiments with using QT QML and rust


## Building

Install Rust:

```sh
# Windows using https://scoop.sh
# Note that you will need to install Visual Studio w/ Desktop Build Tools and Windows SDK too
scoop install rustup
rustup-init


# macOS w/ https://brew.sh
brew install rustup
rustup-init


# Ubuntu
sudo apt install rustup
rustup-init


# Fedora
sudo dnf install rustup
rustup-init
```



Build using vcpkg provided QT (recommended):

```sh
cargo install cargo-vcpkg
cargo vcpkg -v build
cargo build
```



Alternatively, on Linux distros, to build without vcpkg (using system QT)

```sh
# Ubuntu
sudo apt install qt6-base-dev


# Fedora
sudo dnf install qt6-qtbase-devel


# Any distro
NO_VCPKG=1 cargo build
```
