cmake_minimum_required(VERSION 3.20)

project(Libs LANGUAGES C)

add_executable(libs)

target_sources(libs PRIVATE main.c)

# TODO 4: Add the `lib` subdirectory (contains the `lib` target)
add_subdirectory()

# TODO 5: Link the `lib` against `libs`
target_link_libraries()

target_link_options(libs PRIVATE
  --cpu=cortex-m4
  --semihosting)

enable_testing()

cmake_path(GET CMAKE_C_COMPILER PARENT_PATH BIN_DIR)
cmake_path(GET BIN_DIR PARENT_PATH TOOLKIT_DIR)
cmake_path(GET TOOLKIT_DIR FILENAME TOOLKIT)
add_test(NAME libs-test
         COMMAND ${BIN_DIR}/../../common/bin/CSpyBat
         # C-SPY drivers for the Arm simulator via command line interface
         ${BIN_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}${TOOLKIT}PROC${CMAKE_SHARED_LIBRARY_SUFFIX}
         ${BIN_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}${TOOLKIT}SIM2${CMAKE_SHARED_LIBRARY_SUFFIX}
         --plugin=${BIN_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}${TOOLKIT}LibsupportUniversal${CMAKE_SHARED_LIBRARY_SUFFIX}
         # The target executable (built with debug information)
         --debug_file=$<TARGET_FILE:libs>
         # C-SPY driver options
         --backend
           --cpu=cortex-m4
           --semihosting)

set_tests_properties(libs-test PROPERTIES PASS_REGULAR_EXPRESSION "2843410253")
