# Add the executable for the "myProgram" target,
# specifying its source files
add_executable (myProgram
  # Source files
  src/main.c )

# Set the properties for the "myProgram" target
set_target_properties(myProgram PROPERTIES
  ARCHITECTURE  ${CMAKE_SYSTEM_PROCESSOR}
  DEVICE_XCL    "${TOOLKIT_DIR}/config/linker/lnk430f149.xcl"
  # C-SPY-related properties
  DEVICE_DDF    "${TOOLKIT_DIR}/config/debugger/msp430f149.ddf" )

# Set the compiler flags for the "myProgram" target
target_compile_options(myProgram PRIVATE
  $<$<COMPILE_LANGUAGE:C>:--multiplier=16 --double=32 --dlib_config ${TOOLKIT_DIR}/lib/dlib/dl430fn.h>
  -D__MSP430F149__ )

# Set the linker flags for the target
target_link_options(myProgram PRIVATE
  -s __program_start
  # Create a map file from the target's UBROF
  -l $<TARGET_FILE:myProgram>.map
  # The `SHELL:` prefix prevents option de-duplication
  "SHELL:-D_DATA16_HEAP_SIZE=50"
  "SHELL:-D_STACK_SIZE=50"
  "SHELL:-D_DATA20_HEAP_SIZE=50"
  # Set the linker script
  -f $<TARGET_PROPERTY:DEVICE_XCL>
  # The `SHELL:` prefix prevents option de-duplication
  "SHELL:-f ${TOOLKIT_DIR}/config/linker/multiplier.xcl"
  -rt ${TOOLKIT_DIR}/lib/dlib/dl430fn.r43 )

# Link "myProgram" against the "myMath" library
target_link_libraries(myProgram LINK_PUBLIC myMath)

# The macro `add_test_cspy()` is a wrapper
# To execute the `IAR C-SPY Debugger` (cspybat.exe) via `CTest`
macro(add_test_cspy TESTNAME EXPECTED)
  # IAR C-SPY drivers to be used for the selected architecture
  list(APPEND _CSPY_DRIVERS
    "${TOOLKIT_DIR}/bin/${CMAKE_SYSTEM_PROCESSOR}proc.dll"
    "${TOOLKIT_DIR}/bin/${CMAKE_SYSTEM_PROCESSOR}sim.dll"
    "--plugin=${TOOLKIT_DIR}/bin/${CMAKE_SYSTEM_PROCESSOR}bat.dll" )

  # IAR C-SPY parameters for the "myProgram" target
  list(APPEND _CSPYBAT_PARAMETERS
    --debug_file=$<TARGET_FILE:myProgram> )

  # IAR C-SPY macros that integrates with CTest
  set (_CSPYBAT_TEST_MACRO
    "--macro=${CMAKE_CURRENT_SOURCE_DIR}/src/test.mac"
    "--macro_param=testName=\"${TESTNAME}\""
    "--macro_param=testExpected=${EXPECTED}" )

  # IAR C-SPY backend parameters for the "myProgram" target
  list(APPEND _CSPYBAT_PARAMETERS_BACKEND
    -p $<TARGET_PROPERTY:myProgram,DEVICE_DDF> 
    --hwmul_base=0x130
    --hardware_multiplier=16
    --hwmult_type=1
    --iv_base=0xFFE0
    --odd_word_check
    --derivativeSim=MSP430F149
    -d sim )

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
add_test_cspy(test_add 42)
add_test_cspy(test_sub 38)
add_test_cspy(test_mul 80)
