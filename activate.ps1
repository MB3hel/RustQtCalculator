# WORK IN PROGRESS NOT FUNCTIONAL YET
# Powershell port of activate.sh


# Get path of activate.ps1
# No special steps here for powershell. Already in $PSScriptRoot








# Make sure VCPKG_ROOT is set and add vcpkg to path
if (-not $Env:VCPKG_ROOT) {
    Write-Error "ERROR: VCPKG_ROOT is not set"
    return 1
}
$Env:PATH="$Env:VCPKG_ROOT;$Env:PATH"







# Dtermine vcpkg host triplet
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


