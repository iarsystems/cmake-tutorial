# Tests for the IAR toolchains on CMake
The tests in this directory will exercise the CMake modules for one (or more) IAR toolchain(s). The script will...
- build one executable for each supported language (`C`, `CXX` and `ASM`) using...
- the the default CMake build configurations (`Debug`, `Release`, `DebWithRelInfo` and `MinSizeRel`).

## Environment
The following GNU Bash environments were used:
- MINGW64 (e.g., https://gitforwindows.org)
- WSL2 (IAR Build Tools for Linux)

## Instructions
- Export the `$IAR_TOOL_ROOT` environment variable.
```bash
export IAR_TOOL_ROOT=/path/to/IAR/tools/top/level
```
> __Note__ Make `$IAR_TOOL_ROOT` point to the top-level location in which all the IAR toolchains are installed.

| Examples                       | Effect                                                                |
| :----------------------------  | :-------------------------------------------------------------------- |
| `/c/IAR_Systems`               | Perform tests on all toolchains found on the top-level directory.     |
| `/c/IAR_Systems/EW/ARM`        | Perform tests only using the toolchains found in the `ARM` directory. |
| `/c/IAR_Systems/EW/ARM/[7-9]*` | Perform tests on "Embedded Workbench for Arm" from V7 to V9.          |
| `/c/IAR_Systems/EW/ARM/9.30.1` | Perform tests only using "Embedded Workbench 9.30.1".                 |

> __Note__ Optionally export `IAR_LMS2_SERVER_IP` if client's 1st-time license setup is required. (Applies to `-GL` and `-NW`).

- Execute `run-tests.sh`.
