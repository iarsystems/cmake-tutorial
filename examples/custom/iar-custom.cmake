include_guard()

# Enable all CMake default build configurations
list(APPEND CMAKE_CONFIGURATION_TYPES MinSizeRel)

# Add IAR C/C++ Compiler custom configuration for High Speed
list(APPEND CMAKE_CONFIGURATION_TYPES HighSpeed)
set(CMAKE_C_FLAGS_HIGHSPEED " -Ohs" CACHE INTERNAL "")
set(CMAKE_CXX_FLAGS_HIGHSPEED " -Ohs" CACHE INTERNAL "")

# Add IAR C/C++ Compiler custom configuration for Maximum Speed
list(APPEND CMAKE_CONFIGURATION_TYPES MaxSpeed)
set(CMAKE_C_FLAGS_MAXSPEED " -Ohs --no_size_constraints" CACHE INTERNAL "")
set(CMAKE_CXX_FLAGS_MAXSPEED " -Ohs --no_size_constraints" CACHE INTERNAL "")
