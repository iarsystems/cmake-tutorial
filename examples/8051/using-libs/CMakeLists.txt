cmake_minimum_required (VERSION 3.22)

project (Example2
  DESCRIPTION "Creating and using libraries"
  VERSION 1.0.0
  LANGUAGES C )

# Fallback option for generators other than `Ninja Multi-Config`
if (NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug)
endif()

# Enable CTest
enable_testing()

# Recurse into the "lib" and "app" subdirectiories
add_subdirectory(lib)
add_subdirectory(app)
