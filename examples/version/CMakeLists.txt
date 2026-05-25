cmake_minimum_required(VERSION 3.20)

# TODO 1: Add the `project()`'s `VERSION` and set it to `2.7.1`
project(Project LANGUAGES C)

add_executable(version)

target_sources(version PRIVATE main.c)

# TODO 2: Configure `version.h.in` to generate `version.h`
configure_file()

# TODO 3: Add the Project Binary Directory to the target's include directories
target_include_directories()

target_compile_options(version PRIVATE --cpu=cortex-m4)

target_link_options(version PRIVATE 
  --cpu=cortex-m4
  --semihosting)

enable_testing()

cmake_path(GET CMAKE_C_COMPILER PARENT_PATH BIN_DIR)
cmake_path(GET BIN_DIR PARENT_PATH TOOLKIT_DIR)
cmake_path(GET TOOLKIT_DIR FILENAME TOOLKIT)
add_test(NAME version-test
         COMMAND ${BIN_DIR}/../../common/bin/CSpyBat
         # C-SPY drivers for the Arm simulator via command line interface
         ${BIN_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}${TOOLKIT}PROC${CMAKE_SHARED_LIBRARY_SUFFIX}
         ${BIN_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}${TOOLKIT}SIM2${CMAKE_SHARED_LIBRARY_SUFFIX}
         --plugin=${BIN_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}${TOOLKIT}LibsupportUniversal${CMAKE_SHARED_LIBRARY_SUFFIX}
         # The target executable (built with debug information)
         --debug_file=$<TARGET_FILE:version>
         # C-SPY driver options
         --backend
           --cpu=cortex-m4
           --semihosting)

set_tests_properties(version-test PROPERTIES PASS_REGULAR_EXPRESSION "2.7.1")
