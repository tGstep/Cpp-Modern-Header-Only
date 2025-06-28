# Project Template - Premake5 + Ninja (Header Only Deps)

A modern and cross-platform template for C++ projects using only header-only dependencies.

---

## 📦 Requirements

To use this project, you must have the following tools installed and available in your system `PATH`:

- **Git**
- **GCC on Linux, Clang on MacOS, and MSVC on Windows**


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
   git clone https://github.com/tGstep/Cpp-Modern-Header-Only.git
   cd Cpp-Modern-Header-Only
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
       "name": "example_dep",
       "repo": "https://github.com/user/example_dep",
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
     .\scripts\fetch_dependencies.ps1
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
  ./scripts/fetch_dependencies.sh example_dep
  ```
- On Windows:
  ```powershell
  .\scripts\fetch_dependencies.ps1 example_dep
  ```

You will be prompted to add the found library to `deps.json` automatically.

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
│   ├── install_tools.sh          # Install premake, ninja and premake-ninja module (Linux/macOS)
│   ├── install_tools.ps1         # Install premake, ninja and premake-ninja module (Windows)
│   ├── fetch_dependencies.sh     # Search and install helper (Linux/macOS)
│   └── fetch_dependencies.ps1    # Search and install helper (Windows)
├── src/
│   └── main.cpp                  # Sample source
├── deps.json                     # Dependency list
├── premake5.lua                  # Project configuration
├── README.md                     # This file
└── premake-ninja/                # Cloned premake-ninja backend
```

---

## 📚 Official References

- [Premake5](https://premake.github.io/)
- [Ninja](https://ninja-build.org/)
- [premake-ninja](https://github.com/jimon/premake-ninja)
- [awesome-header-only](https://github.com/pfultz2/awesome-header-only)
