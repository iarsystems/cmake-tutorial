cmake_minimum_required(VERSION 3.20)

project(Checksum LANGUAGES C)

add_executable(checksum)

target_sources(checksum PRIVATE
  crc32.c
  main.c
)

target_compile_options(checksum PRIVATE 
  --no_wrap_diagnostics
)

target_link_options(checksum PRIVATE
  --config ${CMAKE_CURRENT_SOURCE_DIR}/generic_cortex.icf
  --map $<TARGET_FILE_DIR:checksum>
  --cpu=cortex-m4
  --semihosting
)

# TODO 1: Add a post build command for placing a checksum
#         at the end of the application

# Enable CTest
enable_testing()

# Get the path to TOOLKIT_DIR
cmake_path(GET CMAKE_C_COMPILER PARENT_PATH BIN_DIR)
cmake_path(GET BIN_DIR PARENT_PATH TOOLKIT_DIR)
cmake_path(GET TOOLKIT_DIR FILENAME TOOLKIT)

# Add a test for CTest
add_test(NAME Checksum-test
  # IAR C-SPY Command-line interface
  COMMAND ${BIN_DIR}/../../common/bin/CSpyBat
  # Select drivers for Arm simulator via command line interface
  ${BIN_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}${TOOLKIT}PROC${CMAKE_SHARED_LIBRARY_SUFFIX}
  ${BIN_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}${TOOLKIT}SIM2${CMAKE_SHARED_LIBRARY_SUFFIX}
  --plugin=${BIN_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}${TOOLKIT}LibsupportUniversal${CMAKE_SHARED_LIBRARY_SUFFIX}
  # Executable target with debug information)
  --debug_file=$<TARGET_FILE:checksum>
  # Driver options
  --backend
    --cpu=cortex-m4
    --semihosting)

# When `checksum` is executed via CSpyBat, CTest will expect `Checksum-test PASS` on stdout
set_tests_properties(Checksum-test PROPERTIES PASS_REGULAR_EXPRESSION "Checksum-test: PASS")
