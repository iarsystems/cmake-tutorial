cmake_minimum_required(VERSION 3.20)

# TODO 1: Enable Assembly (ASM) for the project
project(Mix LANGUAGES C)

add_executable(mix)

# TODO 2: Add `fun.s` source to the `mix` target
target_sources(mix PRIVATE main.c)

target_compile_options(mix PRIVATE --cpu=cortex-m4)

target_link_options(mix PRIVATE
  --cpu=cortex-m4
  --semihosting)

enable_testing()

cmake_path(GET CMAKE_C_COMPILER PARENT_PATH BIN_DIR)
cmake_path(GET BIN_DIR PARENT_PATH TOOLKIT_DIR)
cmake_path(GET TOOLKIT_DIR FILENAME TOOLKIT)
add_test(NAME mix-test
         COMMAND ${BIN_DIR}/../../common/bin/CSpyBat
         # C-SPY drivers for the Arm simulator via command line interface
         ${BIN_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}${TOOLKIT}PROC${CMAKE_SHARED_LIBRARY_SUFFIX}
         ${BIN_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}${TOOLKIT}SIM2${CMAKE_SHARED_LIBRARY_SUFFIX}
         --plugin=${BIN_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}${TOOLKIT}LibsupportUniversal${CMAKE_SHARED_LIBRARY_SUFFIX}
         # The target executable (built with debug information)
         --debug_file=$<TARGET_FILE:mix>
         # C-SPY driver options
         --backend
           --cpu=cortex-m4
           --semihosting)

set_tests_properties(mix-test PROPERTIES PASS_REGULAR_EXPRESSION "42")
