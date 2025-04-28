
# Project Template - Premake5 + Ninja + Vcpkg

A modern, cross-platform, and automated template for C++ projects.

---

## 🚀 Architecture

- **Premake5**: Automatic generation of build files (Ninja, Makefiles, VS, Xcode).
- **Ninja**: Ultra-fast build system based on generated build files.
- **Vcpkg**: Automatic C++ dependency management.

---

## 🛠️ Technologies Used

| Tool      | Purpose | Installation |
|:----------|:-------|:-------------|
| Premake5  | Dynamic build generator | Automatically downloaded or installed via Winget/Brew |
| Ninja     | Fast build system | Preinstalled on GitHub Actions |
| Vcpkg     | C++ package management | Auto-cloned and bootstrap automatic |

---

## 🏗️ Automatic Setup

1. **Vcpkg**:
    - Auto-download from GitHub.
    - Automatic bootstrap (`bootstrap-vcpkg.bat/.sh`) without telemetry.
    - Installs dependencies from `vcpkg.json` file (if present).

2. **Premake5**:
    - Automatically installed:
      - Linux ➔ download the latest release from GitHub.
      - Windows ➔ installed via `winget`.
      - macOS ➔ installed via `brew`.

3. **Build**:
    - Premake5 generates build files (`premake5 ninja`).
    - Ninja performs the build (`ninja -C build`).

---

## 📄 File Structure

```plaintext
.
├── .github/
│   └── workflows/
│       └── build.yml        # GitHub Actions automatic build
├── build/                   # Build output
├── external/
│   └── vcpkg/                # Auto-clone of vcpkg
├── src/
│   └── main.cpp              # Sample source code
├── premake5.lua              # Premake5 configuration
├── README.md                 # This file
└── vcpkg.json (optional)     # C++ dependency definition (optional)
```

---

## 🛠️ Main Commands

| Command            | Description |
|:-------------------|:-----------|
| `premake5 ninja`   | Generates build files for Ninja |
| `ninja -C build`   | Builds the project |

---

## 🧰 Debugging and Tips

- **Vcpkg errors**:
  - Verify you have Git installed.
  - Check the presence of `vcpkg.json` file or specify dependencies manually.
  
- **Premake5 not found**:
  - Ensure `premake5` is in your `PATH`.
  - On Linux, the binary is moved to `/usr/local/bin/premake5`.

- **Build failed**:
  - Check the correct triplet setting (`x64-windows`, `x64-linux`, `x64-osx`).

---

## 🐛 Troubleshooting

| Issue                   | Solution |
|:------------------------|:---------|
| Vcpkg doesn't start     | Delete the `external/vcpkg` folder and regenerate |
| Ninja not found         | Install Ninja (`sudo apt install ninja-build` on Linux) |
| Incorrect Premake5 version | Force re-installation from GitHub |
| Missing libraries       | Verify the correct `vcpkg.json` is present |

---

## 🏆 Build Status

![Build](https://github.com/your_username/your_repo_name/actions/workflows/build.yml/badge.svg)

---

## 📚 Official Sources
- [Premake5 GitHub](https://github.com/premake/premake-core)
- [Vcpkg GitHub](https://github.com/microsoft/vcpkg)
- [Ninja Build System](https://ninja-build.org/)
- [Winget CLI](https://learn.microsoft.com/en-us/windows/package-manager/winget/)
- [Homebrew CLI](https://brew.sh/)

---
