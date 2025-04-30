require "external/premake-ninja/ninja"

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

workspace "MyWorkspace"
    configurations { "Debug", "Release" }
    location "build"
    architecture "x86_64"
    startproject "MyProject"

project "MyProject"
    kind "ConsoleApp"
    language "C++"
    targetdir "build/%{cfg.buildcfg}/bin"
    objdir "build/%{cfg.buildcfg}/obj"

    files { "src/**.cpp", "src/**.h", "src/**.hpp" }


    includedirs {
        path.join(installedDir, "include"),
        -- facoltativo: 
        -- i sottodirectory di share/cmake che contengono i file *.cmake
        path.join(installedDir, "share")
    }


    libdirs {
        path.join(installedDir, "lib"),
        path.join(installedDir, "bin")
    }


    filter "system:windows"
        links( os.matchfiles(path.join(installedDir, "lib", "*.lib")) )
    filter "system:not windows"
        links( os.matchfiles(path.join(installedDir, "lib", "*.a")) )


    filter "system:windows"  toolset "msc"   buildoptions { "/std:c++17" }
    filter "system:linux"    toolset "gcc"   buildoptions { "-std=c++17" }
    filter "system:macosx"   toolset "clang" buildoptions { "-std=c++17" }
    filter "configurations:Debug"   symbols  "On"
    filter "configurations:Release" optimize "On"