# Powershell port of activate.sh (only tested on windows with powershell 7.x)

# path seperator (: or ;) for this OS
$psep = [IO.Path]::PathSeparator


# Get path of activate.ps1
# No special steps here for powershell. Already in $PSScriptRoot


# Make sure VCPKG_ROOT is set and add vcpkg to path
if (-not $Env:VCPKG_ROOT) {
    Write-Error "ERROR: VCPKG_ROOT is not set"
    return 1
}
$Env:PATH="$Env:VCPKG_ROOT$psep$Env:PATH"


# Determine vcpkg host triplet
# Need to use dynamic b/c QT doesn't support static linking well
$ARCH = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture
switch($ARCH){
    'X64' { 
        $ARCH="x64" 
    }
    'X86' { 
        $ARCH="x86" 
    }
    'Arm64' { 
        $ARCH="arm64" 
    }
    default {
        Write-Error "ERROR: Unknown host architecture"
        return 1
    }
}
if ($IsWindows) {
    $OS = "windows"
} elseif ($IsMacOS) {
    $OS = "osx-dynamic"
} elseif ($IsLinux) {
    $OS = "linux-dynamic"
}
$Env:VCPKG_DEFAULT_HOST_TRIPLET="$ARCH-$OS"


# Determine vcpkg target triplet based on cargo target triplet
# If no cargo triplet given, assume building for host system
if (-not $Env:CARGO_BUILD_TARGET) {
    $Env:VCPKG_DEFAULT_TRIPLET = "$Env:VCPKG_DEFAULT_HOST_TRIPLET"
} else {
    switch($Env:CARGO_BUILD_TARGET) {
        'x86_64-pc-windows-msvc' {
            $Env:VCPKG_DEFAULT_TRIPLET = "x64-windows"
        }
        'arm64-pc-windows-msvc' {
            $Env:VCPKG_DEFAULT_TRIPLET = "arm64-windows"
        }
        'arm64-apple-darwin' {
            $Env:VCPKG_DEFAULT_TRIPLET = "arm64-osx-dynamic"
        }
        'arm64-unknown-linux-gnu' {
            $Env:VCPKG_DEFAULT_TRIPLET = "x64-linux-dynamic"
        }
        default {
            Write-Error "ERROR: Unknown cargo target '$Env:CARGO_BUILD_TARGET'"
            return 1
        }
    }
}
$Env:VCPKGRS_DYNAMIC=1


# Prepend vcpkg installed qmake to the path so it is found first
$Env:PATH = "$PSScriptRoot/vcpkg_installed/$Env:VCPKG_DEFAULT_HOST_TRIPLET/tools/Qt6/bin/$psep$Env:PATH"

