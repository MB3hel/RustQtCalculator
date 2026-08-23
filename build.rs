/**
 * Locate native library dependencies installed using vcpkg
 * Currently, this is just for qt installed using vcpkg
 */
fn find_vcpkg_libs(){
    vcpkg::Config::new()
        .emit_includes(true)
        .find_package("qtbase")
        .unwrap();
}


fn main() {
    println!("cargo::rerun-if-env-changed=NO_VCPKG");
    println!("cargo::rerun-if-changed=build.rs");

    let mut use_vcpkg = true;
    if let Ok(value) = std::env::var("NO_VCPKG"){
        if value == "1" {
            use_vcpkg = false;
        }
    }
    if use_vcpkg {
        find_vcpkg_libs();
    }
}
