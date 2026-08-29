
use std::env;
use std::path::PathBuf;

/**
 * Locate native library dependencies installed using vcpkg
 * Currently, this is just for qt installed using vcpkg
 */
fn find_vcpkg_libs(){
    // TARGET triplet not HOST triplet
    let vcpkg_triplet = env::var("VCPKG_DEFAULT_TRIPLET").expect("VCPKG_DEFAULT_TRIPLET is not set");

    // For build time
    for pkg in ["qtbase", "qtdeclarative", "qtsvg"]{
        vcpkg::Config::new()
            .target_triplet(&vcpkg_triplet)
            .emit_includes(true)
            .find_package(pkg)
            .unwrap();
    }

    // For cargo run to work, env vars need to be set so QT & its plugins can be found from vcpkg
    #[cfg(target_os = "windows")] 
    let lib_var = "PATH";               // Prepend lib folder to PATH on Windows
    #[cfg(target_os = "macos")] 
    let lib_var = "DYLD_LIBRARY_PATH";  // Prepend lib folder to DYLD_LIBRARY_PATH on macOS
    #[cfg(not(any(target_os = "windows", target_os = "macos")))]
    let lib_var = "LD_LIBRARY_PATH";    // Prepend lib folder to LD_LIBRARY_PATH on Linux, *BSD, etc

    // Construct path to vcpkg lib folder
    // Note that even though cargo run will not generally work if cross compiling,
    // VCPKG_DEFAULT_TRIPLET is still used here for the TARGET triplet. In some cases (eg Linux with
    // QEMU userspace emulation) running cross compiled binaries may be possible. So this should
    // configure everything correctly for that scenario too. If not cross compiling then
    // VCPKG_DEFAULT_TRIPLET will match VCPKG_DEFAULT_HOST_TRIPLET anyway
    let proj_dir = env::var("CARGO_MANIFEST_DIR").expect("CARGO_MANIFEST_DIR  is not set");
    let vcpkg_lib_path = PathBuf::from(&proj_dir).join("vcpkg_installed").join(&vcpkg_triplet).join("lib");

    // Prepend vcpkg QT library folder to correct env var for the OS
    let orig_str = env::var(lib_var).unwrap_or_else(|_| "".to_string());
    let mut components = env::split_paths(&orig_str).collect::<Vec<_>>();
    components.insert(0, vcpkg_lib_path);
    let new_str = env::join_paths(components).expect("Join paths failed");
    println!("cargo:rustc-env={0}={1}", lib_var, new_str.to_string_lossy());

    // Set vars for QT to know where its plugins are (maybe only striclty necessary on Windows?)
    let plugin_path = PathBuf::from(&proj_dir).join("vcpkg_installed").join(&vcpkg_triplet).join("Qt6").join("plugins");
    println!("cargo:rustc-env=QT_PLUGIN_PATH={}", plugin_path.to_string_lossy());
    let qml_path = PathBuf::from(&proj_dir).join("vcpkg_installed").join(&vcpkg_triplet).join("Qt6").join("qml");
    println!("cargo:rustc-env=QML_IMPORT_PATH={}", qml_path.to_string_lossy());
}


fn main() {
    println!("cargo::rerun-if-env-changed=NO_VCPKG");
    println!("cargo::rerun-if-changed=build.rs");

    let mut use_vcpkg = true;
    if let Ok(value) = env::var("NO_VCPKG"){
        if value == "1" {
            use_vcpkg = false;
        }
    }
    if use_vcpkg {
        find_vcpkg_libs();
    }
}
