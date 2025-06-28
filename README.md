# Project Template - Premake5 + Ninja

A modern, cross-platform, and automated template for C++ projects.

Now with custom dependency management for header-only libraries via `deps.json`.

---

## 📦 Requirements

To use this project, you must have the following tools installed and available in your system `PATH`:

- **Git**
- **Premake5**
- **Ninja**
- **GCC on Linux, Clang on MacOS, and MSVC on Windows**

> 📝 On Windows, PowerShell is required (included by default on modern systems).

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
     .\scripts\install_tools.ps1
     ```

3. **Add dependencies**  
   Modify the `deps.json` file to include the header-only libraries you need. Example:

   ```json
   [
     {
       "name": "nameof",
       "repo": "https://github.com/Neargye/nameof",
       "includes": "include"
     }
   ]
   ```

4. **Fetch dependencies**  
   This will clone the GitHub repos into `external/`.

   - On Linux/macOS:
     ```bash
     ./scripts/fetch_dependencies.sh
     ```
   - On Windows:
     ```powershell
     .\scriptsetch_dependencies.ps1
     ```

5. **Generate build files using Premake and Ninja**
   ```bash
   premake5 ninja
   ```

6. **Build the project**
   ```bash
   ninja -C build
   ```

---

## 🔎 How to Search for Header-Only Libraries

A search helper is available that scans [awesome-header-only](https://github.com/pfultz2/awesome-header-only) to find matching libraries.

- On Linux/macOS:
  ```bash
  ./scripts/search.sh nameof
  ```
- On Windows:
  ```powershell
  .\scripts\search.ps1 nameof
  ```

You will be prompted to add the found library to `deps.json`.

---

## 🗂️ File Structure

```plaintext
.
├── .github/
│   └── workflows/
│       └── build.yml             # GitHub Actions build
├── build/                        # Ninja build output
├── external/                     # Cloned header-only libraries
├── scripts/                      # Automation scripts
│   ├── install_tools.sh          # Install premake/ninja/git (Linux/macOS)
│   ├── install_tools.ps1         # Install premake/ninja/git (Windows)
│   ├── fetch_dependencies.sh     # Clone from deps.json (Linux/macOS)
│   ├── fetch_dependencies.ps1    # Clone from deps.json (Windows)
│   ├── search.sh                 # Search helper (Linux/macOS)
│   └── search.ps1                # Search helper (Windows)
├── src/
│   └── main.cpp                  # Sample source
├── deps.json                     # Dependency list
├── premake5.lua                  # Project configuration
├── README.md                     # This file
└── premake-ninja/                # Cloned premake-ninja backend (must be cloned manually)
```

---

## 📚 Official References

- [Premake5](https://premake.github.io/)
- [Ninja](https://ninja-build.org/)
- [awesome-header-only](https://github.com/pfultz2/awesome-header-only)
