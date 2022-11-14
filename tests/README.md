# Tests for the IAR toolchains on CMake

## Environment
The following GNU Bash environments were used:
- MINGW64 (e.g., https://gitforwindows.org)
- WSL2 (IAR Build Tools for Linux)

## Instructions
- Export the `$IAR_TOOL_ROOT` environment variable.
   - Point to the top-level location in which the IAR toolchains are installed.

| Example | Effect |
| ------- | ------ |
| `/c/IAR_Systems` | Perform tests on all toolchains found on the top-level directory. |
| `/c/IAR_Systems/EW/ARM` | Perform tests only using the toolchains found in the `ARM` directory. |
| `/c/IAR_Systems/EW/ARM/[7-9]*` | Perform tests on "Embedded Workbench for Arm" from V7 to V9. |
| `/c/IAR_Systems/EW/ARM/9.30.1` | Perform tests only using "Embedded Workbench 9.30.1". |

- Execute `run-tests.sh`.
