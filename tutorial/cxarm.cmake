# Toolchain File for the IAR C/C++ Compiler (CX)

# Set CMake for cross-compiling
set(CMAKE_SYSTEM_NAME Generic)

# Set CMake to use the IAR C/C++ Compiler from the IAR Build Tools for Arm
# Update if using a different supported target or operating system
set(CMAKE_ASM_COMPILER /opt/iar/cxarm/arm/bin/iasmarm)
set(CMAKE_C_COMPILER   /opt/iar/cxarm/arm/bin/iccarm)
set(CMAKE_CXX_COMPILER /opt/iar/cxarm/arm/bin/iccarm)

# Avoids running the linker during try_compile()
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Set the default build tool for Ninja gnerators
# Reasonably recent IAR products ships with ninja (https://ninja-build.org)
# The CMake code block below tries to find it. If not found, 
# manually install the desired build system in your operating system
# Alternatively: set(CMAKE_MAKE_PROGRAM "/usr/bin/ninja")
if(CMAKE_GENERATOR MATCHES "^Ninja.*$")
  find_program(CMAKE_MAKE_PROGRAM
    NAMES ninja
    PATHS $ENV{PATH}
          /opt/iar/cxarm/common/bin
    REQUIRED)
endif()
