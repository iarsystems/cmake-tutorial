# Tests for the IAR toolchains on CMake
The tests in this directory are for the CMake Modules for the IAR Toolchains (e.g., `/path/to/share/cmake-x.xx/Modules/Compiler/IAR-*.cmake`).

The `run-tests.sh` script will...
- build one executable for each supported language (`C`, `CXX` and `ASM`) using...
- the default CMake build configurations (`Debug`, `Release`, `DebWithRelInfo` and `MinSizeRel`).

## Environment
The script was used with the following environments providing GNU Bash:

- Cygwin (https://cygwin.com)
  - IAR Embedded Workbench
  - CMake for Windows
  - Ninja for Windows
- MINGW64 (https://msys2.org)
  - IAR Embedded Workbench
  - CMake for Windows
  - Ninja for Windows
- Ubuntu 20.04 (/WSL2)
  - IAR Build Tools for Linux
  - Cmake for Linux
  - Ninja for Linux

## Environment variables
### IAR_TOOL_ROOT
Export the `$IAR_TOOL_ROOT` environment variable, pointing to the top-level location in which all the IAR toolchains are installed. (Default: `/opt/iarsystems`)

| Examples                       | Effect                                                                |
| :----------------------------  | :-------------------------------------------------------------------- |
| `/c/IAR_Systems`               | Perform tests on all toolchains found on the top-level directory.     |
| `/c/IAR_Systems/EW/ARM`        | Perform tests only using the toolchains found in the `ARM` directory. |
| `/c/IAR_Systems/EW/ARM/[7-9]*` | Perform tests on "Embedded Workbench for Arm" from V7 to V9.          |
| `/c/IAR_Systems/EW/ARM/9.30.1` | Perform tests only using "Embedded Workbench 9.30.1".                 |

### IAR_LMS2_SERVER_IP (optional)
Export the `IAR_LMS2_SERVER_IP` environment variable pointing to the license server, if the client's 1st-time license setup is required. Applies to the `-GL` and `-NW` products. (Default: not set)

### CMAKE_GENERATOR (optional)
Export the `CMAKE_GENERATOR` environment variable to specify which generator to use. (Default: `Ninja Multi-Config`)

### MSYSTEM
This environment variable is automatically set by MSYS2, MINGW64 and MINGW32. Cygwin users must set it manually.

Example: `export MSYSTEM=CYGWIN`

## Examples

### Using __MINGW64__
The example below will test every tool found in `C:\IAR_Systems\EW` using MINGW64:
```bash
export IAR_TOOL_ROOT=/c/IAR_Systems/EW
# Extracted from a zip archive
export PATH=/c/cmake-3.25.0-x86_64/bin:$PATH
git clone https://github.com/iarsystems/cmake-tutorial ~
cd ~/cmake-tutorial/tests
./run-tests.sh
```

### Using __Ubuntu (/WSL2)__
The example below will test every tool found in `/opt/iarsystems` using Ubuntu (WSL2):
```bash
git clone https://github.com/iarsystems/cmake-tutorial ~
cd ~/cmake-tutorial/tests
./run-tests.sh
```

### Using __Cygwin__
The example below will test every tool found in `C:\IAR_Systems\EW` using Cygwin:
```bash
export IAR_TOOL_ROOT=/cygdrive/c/IAR_Systems/EW
# Only required by Cygwin
export MSYSTEM=CYGWIN
# Extracted from a zip archive
export PATH=/cygdrive/c/cmake-3.25.0-x86_64/bin:$PATH
git clone https://github.com/iarsystems/cmake-tutorial ~
cd ~/cmake-tutorial/tests
./run-tests.sh
```
