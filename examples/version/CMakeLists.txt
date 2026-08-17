cmake_minimum_required(VERSION 3.20)

project(Project LANGUAGES C)

add_executable(target)

target_sources(target PRIVATE main.c)

# TODO 1: Set the target's `VERSION` to 1.2.3




# TODO 2: Expose the target's `VERSION` to the application






# TODO 3: Configure `version.h` from `version.h.in`





# TODO 4: Add `build/include/` to target's include directories


target_compile_options(target PRIVATE
  --cpu=cortex-m4
  --no_wrap_diagnostics
)

target_link_options(target PRIVATE
  --cpu=cortex-m4
  --semihosting)

enable_testing()

cmake_path(GET CMAKE_C_COMPILER PARENT_PATH BIN_DIR)
cmake_path(GET BIN_DIR PARENT_PATH TOOLKIT_DIR)
cmake_path(GET TOOLKIT_DIR FILENAME TOOLKIT)

macro(iar_cspysim TESTNAME EXPECTED)
  add_test(NAME ${TESTNAME}-test
           COMMAND ${BIN_DIR}/../../common/bin/CSpyBat
           # C-SPY drivers for the Arm simulator via command line interface
           ${BIN_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}${TOOLKIT}PROC${CMAKE_SHARED_LIBRARY_SUFFIX}
           ${BIN_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}${TOOLKIT}SIM2${CMAKE_SHARED_LIBRARY_SUFFIX}
           --plugin=${BIN_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}${TOOLKIT}LibsupportUniversal${CMAKE_SHARED_LIBRARY_SUFFIX}
           # The target executable (built with debug information)
           --debug_file=$<TARGET_FILE:target>
           # C-SPY driver options
           --backend
             --cpu=cortex-m4
             --semihosting
  )
  set_tests_properties(${TESTNAME}-test PROPERTIES
    PASS_REGULAR_EXPRESSION ${EXPECTED}
  )
endmacro()

# Add tests for the string-formatted version and for the integer-formatted version
iar_cspysim("string-version"  "String version: $<TARGET_PROPERTY:target,VERSION>")
iar_cspysim("integer-version" "Integer version: $<TARGET_PROPERTY:target,VERSION>")

