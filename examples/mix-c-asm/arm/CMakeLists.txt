cmake_minimum_required(VERSION 3.22)

# Set the project name, [description] and [version],
# while enabling its required languages
project(Example1 
  DESCRIPTION "Mixing C and Assembly"
  VERSION 1.0.0
  LANGUAGES C ASM )

# Fallback option for generators other than `Ninja Multi-Config`
if (NOT DEFINED CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug)
endif()

# Add the executable for the "mixLanguages" target,
# specifying its source files
add_executable(mixLanguages
  # Source files
  ../sources/main.c
  ../sources/mynum-${CMAKE_SYSTEM_PROCESSOR}.asm )

# Set a preprocessor symbol, usable from "mixLanguages" target
target_compile_definitions(mixLanguages PUBLIC USE_ASM=1)

# Set the compiler flags for the "mixLanguages" target
target_compile_options(mixLanguages PRIVATE
  $<$<COMPILE_LANGUAGE:C>:--dlib_config normal>
  --cpu Cortex-M3 )

# Set the linker options for the "mixLanguages" target
target_link_options(mixLanguages PRIVATE
  $<$<CONFIG:Debug>:--semihosting --redirect ___write=___write_buffered>
  --config ${TOOLKIT_DIR}/config/generic.icf )

# Enable CTest
enable_testing()

# The macro `add_test_cspy()` is a wrapper
# To execute the `IAR C-SPY Debugger` (cspybat.exe) via `CTest`
macro(add_test_cspy TESTNAME EXPECTED)
  # IAR C-SPY drivers to be used for the selected architecture
  list(APPEND _CSPY_DRIVERS
    "${TOOLKIT_DIR}/bin/${CMAKE_SYSTEM_PROCESSOR}proc.dll"
    "${TOOLKIT_DIR}/bin/${CMAKE_SYSTEM_PROCESSOR}sim2.dll"
    "--plugin=${TOOLKIT_DIR}/bin/${CMAKE_SYSTEM_PROCESSOR}bat.dll" )

  # IAR C-SPY parameters for the "mixLanguages" target
  list(APPEND _CSPYBAT_PARAMETERS
    --debug_file=$<TARGET_FILE:mixLanguages> )

  # IAR C-SPY macros that integrates with CTest
  set (_CSPYBAT_TEST_MACRO
    "--macro=${CMAKE_CURRENT_SOURCE_DIR}/../sources/test.mac"
    "--macro_param=testName=\"${TESTNAME}\"" 
    "--macro_param=testExpected=${EXPECTED}" )

  # IAR C-SPY backend parameters for the "mixLanguages" target
  list(APPEND _CSPYBAT_PARAMETERS_BACKEND
    --endian=little
    --cpu=Cortex-M3
    --fpu=None
    --semihosting
    --multicore_nr_of_cores=1 )

  # This list concatenates the previous lists to execute `cspybat`
  list(APPEND _CSPYBAT_COMMAND
    ${TOOLKIT_DIR}/../common/bin/cspybat
    --silent
    ${_CSPY_DRIVERS}
    ${_CSPYBAT_PARAMETERS}
    ${_CSPYBAT_TEST_MACRO}
    --backend
    ${_CSPYBAT_PARAMETERS_BACKEND} )

  # This is the `CTest` function that adds test capabilities
  add_test(NAME ${TESTNAME} COMMAND ${_CSPYBAT_COMMAND})

  # Set the test to interpret a C-SPY's message containing `PASS`
  set_tests_properties(${TESTNAME} PROPERTIES PASS_REGULAR_EXPRESSION "PASS")

  # Cleanup
  unset(_CSPY_DRIVERS)
  unset(_CSPYBAT_COMMAND)
  unset(_CSPYBAT_PARAMETERS)
  unset(_CSPYBAT_PARAMETERS_BACKEND)
endmacro()

# Tests to be executed with `cspybat` directly from `CTest`
add_test_cspy(test_mynum 42)
