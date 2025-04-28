
# Project Template - Premake5 + Ninja + Vcpkg

A modern, cross-platform, and automated template for C++ projects.
---


## Supported Platforms

- Windows with MSVC

- Linux with GCC

- macOS with Clang

---

## Requirements

- Git

- Premake

---

## 🛠️ Main Commands

| Command            | Description |
|:-------------------|:-----------|
| `premake5 ninja`   | Generates build files for Ninja |
| `ninja -C build`   | Builds the project |

---

## 📄 File Structure

```plaintext
.
├── .github/
│   └── workflows/
│       └── build.yml        # GitHub Actions automatic build
├── build/                   # Build output
├── external/
│   └── vcpkg/                # Auto-cloned C++ dependencies
├── src/
│   └── main.cpp              # Here goes the source code
├── premake5.lua              # Premake5 configuration
├── README.md                 
└── vcpkg.json			   # C++ dependencies definition
```

---

## 🚀 Architecture

- **Premake5**: Automatic generation of build files.
- **Ninja**: Ultra-fast build system based on generated build files.
- **Vcpkg**: Automatic C++ dependency management.

---

## 📚 Official Sources
- [Premake5](https://premake.github.io/)
- [Vcpkg](https://vcpkg.io)
- [Ninja](https://ninja-build.org/)

---
