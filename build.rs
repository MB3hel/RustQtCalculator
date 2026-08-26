
/**
 * Read Cargo.toml to get vcpkg dependencies list
 */
fn get_vcpkg_deps_list() -> Vec<String>{
    let triplet = std::env::var("TARGET").unwrap();
    let manifest_dir = std::env::var("CARGO_MANIFEST_DIR").unwrap();
    let manifest_path = std::path::Path::new(&manifest_dir).join("Cargo.toml");
    let cargo_toml_str = std::fs::read_to_string(manifest_path).expect("Failed to read cargo.toml");
    let cargo_toml: toml::Value = toml::from_str(&cargo_toml_str).expect("Failed to parse Cargo.toml");
    let deparray = cargo_toml.get("package")
        .and_then(|pkg| pkg.get("metadata"))
        .and_then(|metadata| metadata.get("vcpkg"))
        .and_then(|vcpkg| vcpkg.get("target"))
        .and_then(|target| target.get(triplet))
        .and_then(|tplsec| tplsec.get("dependencies"))
        .and_then(|dependencies| dependencies.as_array())
        .expect("Failed to load dependencies from Cargo.toml");
    return deparray.iter()
        .filter_map(|v| v.as_str().map(|s| s.split('[').next().unwrap_or(s).to_string()))
        .collect();
}

/**
 * Locate native library dependencies installed using vcpkg
 * Currently, this is just for qt installed using vcpkg
 */
fn find_vcpkg_libs(){
    for package in get_vcpkg_deps_list(){
        vcpkg::Config::new()
            .emit_includes(true)
            .find_package(package.as_str())
           .unwrap();
    }
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
