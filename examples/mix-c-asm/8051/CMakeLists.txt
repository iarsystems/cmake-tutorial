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
  $<$<COMPILE_LANGUAGE:C>:--core=plain --dptr=16,1 --data_model=large --code_model=near --calling_convention=xdata_reentrant --place_constants=data --nr_virtual_regs 8 --dlib --dlib_config ${TOOLKIT_DIR}/lib/dlib/dl8051Normal.h>
  $<$<COMPILE_LANGUAGE:ASM>:-v0 -D__CORE__=1 -D__CODE_MODEL__=1 -D__DATA_MODEL__=1 -D__CALLING_CONVENTION__=2 -D__NUMBER_OF_DPTRS__=1> )

# Set the linker options for the "mixLanguages" target
target_link_options(mixLanguages PRIVATE
  -rt
  -f ${TOOLKIT_DIR}/config/devices/_generic/lnk51ew_8051.xcl
  ${TOOLKIT_DIR}/lib/dlib/dl-pli-nlxd-1e16x01n.r51
  # The `SHELL:` prefix prevents option de-duplication
  "SHELL:-D_NR_OF_BANKS=0"
  "SHELL:-D_CODEBANK_END=0"
  "SHELL:-D_CODEBANK_START=0"
  "SHELL:-D_NR_OF_VIRTUAL_REGISTERS=8"
  "SHELL:-D?PBANK=0xA0"
  "SHELL:-D_IDATA_STACK_SIZE=0x40"
  "SHELL:-D?ESP=0"
  "SHELL:-D?ESP_MASK=0"
  "SHELL:-D_EXTENDED_STACK_START=0"
  "SHELL:-D_EXTENDED_STACK_SIZE=0"
  "SHELL:-D_PDATA_STACK_SIZE=0x80"
  "SHELL:-D_XDATA_STACK_SIZE=0xEFF"
  "SHELL:-D_XDATA_HEAP_SIZE=0xFF"
  "SHELL:-D_FAR_HEAP_SIZE=0xFFF"
  "SHELL:-D_HUGE_HEAP_SIZE=0xFFF"
  "SHELL:-D_FAR22_HEAP_SIZE=0xFFF" )

# Enable CTest
enable_testing()

# The macro `add_test_cspy()` is a wrapper
# To execute the `IAR C-SPY Debugger` (cspybat.exe) via `CTest`
macro(add_test_cspy TESTNAME EXPECTED)
  # IAR C-SPY drivers to be used for the selected architecture
  list(APPEND _CSPY_DRIVERS
    "${TOOLKIT_DIR}/bin/${CMAKE_SYSTEM_PROCESSOR}proc.dll"
    "${TOOLKIT_DIR}/bin/${CMAKE_SYSTEM_PROCESSOR}sim.dll"
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
    -p ${TOOLKIT_DIR}/config/devices/_generic/io8051.ddf
    --proc_core=plain
    --proc_code_model=near
    --proc_nr_virtual_regs=8
    --proc_pdata_bank_reg_addr=0xA0
    --proc_dptr_nr_of=1
    --proc_data_model=small
    --proc_driver=sim )

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
