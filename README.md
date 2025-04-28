
# Project Template - Premake5 + Ninja + Vcpkg

A modern, cross-platform, and automated template for C++ projects.
It only requires git installed on your system (the auto-downloaded premake does the heavy lifting executing premake5.lua before generating build files).

---

## 🚀 Architecture

- **Premake5**: Automatic generation of build files.
- **Ninja**: Ultra-fast build system based on generated build files.
- **Vcpkg**: Automatic C++ dependency management.

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
├── README.md                 # The file you are reading rn :)
└── vcpkg.json			   # C++ dependencies definition
```

---

## 🛠️ Main Commands

| Command            | Description |
|:-------------------|:-----------|
| `premake5 ninja`   | Generates build files for Ninja |
| `ninja -C build`   | Builds the project |

---

## 🏆 Build Status

![Build](https://github.com/your_username/your_repo_name/actions/workflows/build.yml/badge.svg)

---

## 📚 Official Sources
- [Premake5](https://premake.github.io/)
- [Vcpkg](https://vcpkg.io)
- [Ninja](https://ninja-build.org/)

---
