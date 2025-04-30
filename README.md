# Project Template - Premake5 + Ninja + Vcpkg

A modern, cross-platform, and automated template for C++ projects.

---

## 📦 Requirements

To use this project, you must have the following tools installed and available in your system `PATH`:

- **Git**
- **GCC on Linux, Clang on MacOS and MSVC on Windows**

### 🧠 Minimum Compiler Versions
| Compiler | Version |
|----------|---------|
| GCC      | 7.0     |
| Clang    | 5.0     |
| MSVC     | 19.11 (Visual Studio 2017 version 15.3) |

---

## 🧪 How to Use This Template

### Step-by-Step Setup

1. **Clone this repository**  
   ```bash
   git clone https://github.com/tGstep/PremakeNinjaVcpkg-ModernCpp.git
   cd PremakeNinjaVcpkg-ModernCpp
   ```

2. **Install required tools**  
   From the root directory, run the platform-specific script:

   - On Linux/macOS:
     ```bash
     ./scripts/install_tools.sh
     ```
   - On Windows:
     ```powershell
     ./scripts/install_tools.ps1
     ```

3. **Install project dependencies**  
   This installs packages defined in `vcpkg.json`.

   - On Linux/macOS:
     ```bash
     ./scripts/fetch_dependencies.sh
     ```
   - On Windows:
     ```powershell
     ./scripts/fetch_dependencies.ps1
     ```

4. **Generate build files**
   ```bash
   premake5 ninja
   ```

5. **Build the project**
   ```bash
   ninja -C build
   ```

---

## 🗂️ File Structure

```plaintext
.
├── .github/
│   └── workflows/
│       └── build.yml        # GitHub Actions automatic build
├── build/                   # Build output
├── external/
│   └── vcpkg/               # Auto-cloned C++ dependencies
├── scripts/                 # Automation scripts
│   ├── install_tools.sh     # Install dev tools (Linux/macOS)
│   ├── install_tools.ps1    # Install dev tools (Windows)
│   ├── fetch_dependencies.sh  # Install vcpkg dependencies (Linux/macOS)
│   └── fetch_dependencies.ps1 # Install vcpkg dependencies (Windows)
├── src/
│   └── main.cpp             # Your source code
├── premake5.lua             # Premake5 configuration
├── vcpkg.json               # Dependency list
└── README.md                # This file
```

---

## 📚 Official References
- [Premake5](https://premake.github.io/)
- [Ninja](https://ninja-build.org/)
- [Vcpkg](https://vcpkg.io)
