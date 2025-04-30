-- Utility per ottenere il triplet corretto
function get_triplet()
    if os.istarget("windows") then
        return "x64-windows"
    elseif os.istarget("linux") then
        return "x64-linux"
    elseif os.istarget("macosx") then
        return "x64-osx"
    else
        error("Unsupported target OS: " .. os.target())
    end
end

-- Percorso base di vcpkg
local vcpkg_path = path.getabsolute("external/vcpkg")
local triplet = get_triplet()
local vcpkg_include = path.join(vcpkg_path, "installed", triplet, "include")
local vcpkg_lib = path.join(vcpkg_path, "installed", triplet, "lib")

-- Workspace Configuration
workspace "MyWorkspace"
    configurations { "Debug", "Release" }
    location "build"
    architecture "x86_64"
    startproject "MyProject"

-- Project Configuration
project "MyProject"
    kind "ConsoleApp"
    language "C++"
    targetdir "bin/%{cfg.buildcfg}"
    files { "src/**.cpp" }

    includedirs { vcpkg_include }
    libdirs { vcpkg_lib }

    filter "system:windows"
        toolset "msc"
        buildoptions { "/std:c++17" }

    filter "system:linux"
        toolset "gcc"
        buildoptions { "-std=c++17" }

    filter "system:macosx"
        toolset "clang"
        buildoptions { "-std=c++17" }

    filter "configurations:Debug"
        symbols "On"

    filter "configurations:Release"
        optimize "On"
