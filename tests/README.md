# Tests for the IAR toolchains on CMake

## Environment
The following GNU Bash environments were used:
- MINGW64 (e.g., https://gitforwindows.org)
- WSL2 (IAR Build Tools for Linux)

## Instructions
- Set the `$IAR_TOOL_ROOT` environment variable.
   - Point to the top-level location in which the IAR toolchains are installed.
   - Examples: `/c/IAR_Systems/`, `/c/mnt/IAR_Systems`

- Execute `run-tests.hs`.
