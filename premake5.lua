-- Helper routines

function command_exists(cmd)
    local f = io.popen("which " .. cmd)
    if f then f:close() end
    return f ~= nil
end


function install_ninja()
    if not command_exists("ninja") then
        print("Ninja not found, attempting to install...")

        -- On Linux, use apt
        if os.istarget("linux") then
            print("Installing Ninja on Linux...")
            os.execute("sudo apt update && sudo apt install ninja-build -y")

        -- On macOS, use Homebrew
        elseif os.istarget("macosx") then
            print("Installing Ninja on macOS...")
            os.execute("brew install ninja")

        -- On Windows, use Scoop
        elseif os.istarget("windows") then
            print("Installing Ninja on Windows via Scoop...")
            os.execute("scoop install ninja")

        else
            error("Unsupported OS for Ninja installation")
        end
    else
        print("Ninja is already installed.")
    end
end


local vcpkg_bootstrap_done = false
local vcpkg_install_done = false


function get_host_os()
    local os_name = os.host()
    if os_name == "windows" then return "windows"
    elseif os_name == "linux" then return "linux"
    elseif os_name == "macosx" then return "macosx"
    else error("Unsupported host OS: " .. os_name) end
end


function get_triplet()
    if os.istarget("windows") then return "x64-windows"
    elseif os.istarget("linux") then return "x64-linux"
    elseif os.istarget("macosx") then return "x64-osx"
    else error("Unsupported target OS: " .. os.target()) end
end


function get_vcpkg_executable()
    local vcpkg_path = path.getabsolute("./external/vcpkg")
    local exe = (get_host_os() == "windows") and "vcpkg.exe" or "vcpkg"
    return path.join(vcpkg_path, exe)
end


function download_vcpkg()
    local vcpkg_path = path.getabsolute("./external/vcpkg")
    if not os.isdir(vcpkg_path) then
        print(">> Cloning vcpkg...")
        os.execute('git clone https://github.com/microsoft/vcpkg.git external/vcpkg')
    end
end

function bootstrap_vcpkg()
    if vcpkg_bootstrap_done then return end
    download_vcpkg()
    local exe = get_vcpkg_executable()
    if not os.isfile(exe) then
        print(">> Bootstrapping vcpkg...")
        if get_host_os() == "windows" then
            os.execute("cd external/vcpkg && set VCPKG_DISABLE_METRICS=1 && .\\bootstrap-vcpkg.bat")
        else
            os.execute("cd external/vcpkg && VCPKG_DISABLE_METRICS=1 ./bootstrap-vcpkg.sh")
        end
    end
    vcpkg_bootstrap_done = true
end


function install_vcpkg_dependencies()
    if vcpkg_install_done then return end
    print(">> Installing vcpkg dependencies...")
    local exe = get_vcpkg_executable()
    local triplet = get_triplet()
    local cmd = string.format('"%s" install --triplet %s', exe, triplet)
    if get_host_os() == "windows" then cmd = "set VCPKG_DISABLE_METRICS=1 && " .. cmd
    else cmd = "VCPKG_DISABLE_METRICS=1 " .. cmd end
    os.execute(cmd)
    vcpkg_install_done = true
end








-- Bootstrap

install_ninja()
bootstrap_vcpkg()
install_vcpkg_dependencies()








-- Workspace Config

workspace "MyWorkspace"
    configurations { "Debug", "Release" }
    location "build"
    architecture "x86_64"
    startproject "MyProject"




-- Project Config

project "MyProject"
    kind "ConsoleApp"
    language "C++"
    targetdir "bin/%{cfg.buildcfg}"
    files { "src/**.cpp" }
    includedirs { "external/vcpkg/installed/" .. get_triplet() .. "/include" }
    libdirs { "external/vcpkg/installed/" .. get_triplet() .. "/lib" }


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
