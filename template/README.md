# Developing in Visual Studio Code with IAR

This template provides a ready-to-use configuration for developing and debugging with the IAR Build Tools for Arm inside Visual Studio Code.  
The sample application mixes C17 and C++20, prints short messages to the Debug Console, then enters an infinite loop so you can step through code and inspect variables.

## Requirements
The following software was used for creating this template:
- IAR Build Tools for Arm v10.10.2 (https://iar.com/cxarm)
  - with ST device support pack
- Microsoft Visual Studio Code v1.141.0 (https://code.visualstudio.com)
- CMake v4.4.0 (https://github.com/Kitware/CMake/releases)

Newer versions are expected to work with little or no change.

## Project outline
```
📁 template
 ┣ 📁 .vscode
 ┃  ┣ 📄 extensions.json   <-- Recommended extensions
 ┃  ┣ 📄 launch.json       <-- Debug launchers
 ┃  ┗ 📄 settings.json     <-- CMake and Clangd*
 ┣ 📄 .clangd              <-- Clangd configuration*
 ┣ 📄 CMakeLists.txt       <-- CMake project definition
 ┣ 📄 CMakePresets.json    <-- CMake Presets
 ...
 ┗ 📄 iccarm.cmake         <-- IAR Toolchain file*
```
> [!NOTE]
> Files marked with `*` contain absolute installation paths.  
> Adjust them if you are using a different IAR toolchain version, or a different installation location (e.g., on Windows).
>
> See [Building and Debugging from Visual Studio Code](https://github.com/iarsystems/cmake-tutorial/wiki/Building-and-Debugging-from-Visual-Studio-Code) for more information.

## How to use the template
1. Clone https://github.com/iarsystems/cmake-tutorial
2. Open the template folder in Visual Studio Code.
3. Install the [recommended extensions](.vscode/extensions).
4. In hello.cpp, click the gutter next to `foo();` near line 20 for setting a breakpoint.
5. Press <kbd>F5</kbd> or go to __Run__ → __Start Debugging__.

