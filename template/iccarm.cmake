# Toolchain File for the IAR C/C++ Compiler for Arm

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

find_program(CMAKE_C_COMPILER
  NAMES iccarm iccarm.exe
  PATHS /opt/iar/cxarm
        /opt/iar/ewarmc
        /iar/cxarm-10.10.2
        /iar/ewarmc-10.10.2
  PATH_SUFFIXES arm/bin
  NO_DEFAULT_PATH
  REQUIRED
)

set(CMAKE_CXX_COMPILER ${CMAKE_C_COMPILER})

find_program(CMAKE_ASM_COMPILER
  NAMES iasmarm iasmarm.exe
  PATHS /opt/iar/cxarm
        /opt/iar/ewarmc
        /iar/cxarm-10.10.2
        /iar/ewarmc-10.10.2
  PATH_SUFFIXES arm/bin
  NO_DEFAULT_PATH
  REQUIRED
)

# Set TOOLKIT directory
get_filename_component(BIN_DIR "${CMAKE_C_COMPILER}" DIRECTORY)
get_filename_component(TOOLKIT_DIR "${BIN_DIR}" DIRECTORY)
set(TOOLKIT_DIR "${TOOLKIT_DIR}" CACHE PATH "IAR Toolchain Directory" FORCE)

# Additional optimization levels
set(CMAKE_CONFIGURATION_TYPES "Debug;Release;RelWithDebInfo;MinSizeRel;Coverage;Medium;HighSpeed;MaxSpeed" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_COVERAGE "-On -r" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_COVERAGE "-On -r" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_MEDIUM "-Om -DNDEBUG" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_MEDIUM "-Om -DNDEBUG" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_HIGHSPEED "-Ohs -DNDEBUG" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_HIGHSPEED "-Ohs -DNDEBUG" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_MAXSPEED "-Ohs --no_size_constraints -DNDEBUG" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_MAXSPEED "-Ohs --no_size_constraints -DNDEBUG" CACHE STRING "" FORCE)

# Tell CMake we are cross-compiling
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
