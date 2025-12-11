# Toolchain File for the IAR C/C++ Compiler (EW)

# Set CMake for cross-compiling
set(CMAKE_SYSTEM_NAME Generic)

# Set CMake to use the IAR C/C++ Compiler from the IAR Embedded Workbench for Arm
# Update the paths if using any different supported target/version
set(CMAKE_ASM_COMPILER "C:/iar/ewarm-9.70.2/arm/bin/iasmarm.exe")
set(CMAKE_C_COMPILER   "C:/iar/ewarm-9.70.2/arm/bin/iccarm.exe")
set(CMAKE_CXX_COMPILER "C:/iar/ewarm-9.70.2/arm/bin/iccarm.exe")

# Avoids running the linker during try_compile()
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Set the default build tool for Ninja gnerators
# Reasonably recent IAR products ships with ninja (https://ninja-build.org)
# The CMake code block below tries to find it. If not found, 
# manually install the desired build system in your operating system
# Alternatively: set(CMAKE_MAKE_PROGRAM "C:/path/to/ninja.exe")
if(CMAKE_GENERATOR MATCHES "^Ninja.*$")
  find_program(CMAKE_MAKE_PROGRAM
    NAMES ninja.exe
    PATHS $ENV{PATH}
          "C:/iar/ewarm-9.70.2/common/bin"
    REQUIRED)
endif()
