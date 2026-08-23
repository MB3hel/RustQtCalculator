fn main() {
    println!("cargo::rerun-if-env-changed=NO_VCPKG");

    let mut use_vcpkg = true;
    if let Ok(value) = std::env::var("NO_VCPKG"){
        if value == "1" {
            use_vcpkg = false;
        }
    }
    if use_vcpkg {
        vcpkg::Config::new()
            .emit_includes(true)
            .find_package("qtbase")
            .unwrap();
    }
}
