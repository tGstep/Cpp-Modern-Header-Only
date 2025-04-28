-- premake5.lua

local vcpkg_bootstrap_done = false
local vcpkg_install_done = false

-- Funzione per determinare il sistema operativo host
function get_host_os()
    local os_name = os.host()
    if os_name == "windows" then return "windows"
    elseif os_name == "linux" then return "linux"
    elseif os_name == "macosx" then return "macosx"
    else error("Unsupported host OS: " .. os_name) end
end

-- Funzione per determinare il triplet del sistema
function get_triplet()
    if os.istarget("windows") then return "x64-windows"
    elseif os.istarget("linux") then return "x64-linux"
    elseif os.istarget("macosx") then return "x64-osx"
    else error("Unsupported target OS: " .. os.target()) end
end

-- Funzione per ottenere il percorso eseguibile di vcpkg
function get_vcpkg_executable()
    local vcpkg_path = path.getabsolute("./external/vcpkg")
    local exe = (get_host_os() == "windows") and "vcpkg.exe" or "vcpkg"
    return path.join(vcpkg_path, exe)
end

-- Funzione per scaricare vcpkg
function download_vcpkg()
    local vcpkg_path = path.getabsolute("./external/vcpkg")
    if not os.isdir(vcpkg_path) then
        print(">> Cloning vcpkg...")
        os.execute('git clone https://github.com/microsoft/vcpkg.git external/vcpkg')
    end
end

-- Funzione per effettuare il bootstrap di vcpkg
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

-- Funzione per installare le dipendenze vcpkg
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

-- Esegui bootstrap e installazione delle dipendenze
bootstrap_vcpkg()
install_vcpkg_dependencies()

-- Configurazione del progetto
workspace "MyWorkspace"
    configurations { "Debug", "Release" }
    location "build"
    architecture "x86_64"
    startproject "MyProject"

-- Imposta il progetto
project "MyProject"
    kind "ConsoleApp"
    language "C++"
    targetdir "bin/%{cfg.buildcfg}"
    files { "src/**.cpp" }
    includedirs { "external/vcpkg/installed/" .. get_triplet() .. "/include" }
    libdirs { "external/vcpkg/installed/" .. get_triplet() .. "/lib" }

    -- Aggiungi la configurazione dei compilatori
    filter "system:windows"
        toolset "msc"  -- Usa MSVC su Windows
        buildoptions { "/std:c++17" }

    filter "system:linux"
        toolset "gcc"  -- Usa GCC su Linux
        buildoptions { "-std=c++17" }

    filter "system:macosx"
        toolset "clang"  -- Usa Clang su macOS
        buildoptions { "-std=c++17" }

    -- Configurazioni per Debug e Release
    filter "configurations:Debug"
        symbols "On"

    filter "configurations:Release"
        optimize "On"
