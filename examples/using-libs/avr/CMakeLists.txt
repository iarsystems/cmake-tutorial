cmake_minimum_required (VERSION 3.22)

project (Example2
  DESCRIPTION "Creating and using libraries"
  VERSION 1.0.0
  LANGUAGES C )

# Enable CTest
enable_testing()

# Recurse into the "lib" and "app" subdirectiories
add_subdirectory(lib)
add_subdirectory(app)
