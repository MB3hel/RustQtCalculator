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



Install QT using vcpkg & set path

```sh
cargo install cargo-vcpkg
cargo vcpkg -v build
```

Set PATH to include QT direcotry (qtbindings crate doesn't support a way to do this automaticaly
via build.rs at this time)

```sh
# Host triplet will be x64-windows, x64-linux, or arm64-osx in most cases
# Other platforms are not well supported by QT anymore

# Powershell syntax
$Env:PATH="$VCPKG_ROOT/installed/<host_triplet>/tools/Qt6/bin;$Env:PATH"

# Bash syntax
export PATH="$VCPKG_ROOT/installed/<host_triplet>/tools/Qt6/bin:$PATH"

# Test by checking for qmake executable

# Powershell
where.exe qmake

# Bash
which qmake
```

Build

```sh
cargo build
```

