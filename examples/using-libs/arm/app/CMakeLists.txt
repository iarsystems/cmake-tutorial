# Add the executable for the "myProgram" target,
# specifying its source files
add_executable (myProgram
  # Source files
  src/main.c )

# Set the properties for the "myProgram" target
set_target_properties(myProgram PROPERTIES
  DEVICE        STM32F407VG
  CPU           Cortex-M4
  FPU           VFPv4_sp
  ARCHITECTURE  ${CMAKE_SYSTEM_PROCESSOR}
  DEVICE_ICF    "${TOOLKIT_DIR}/config/linker/ST/stm32f407xG.icf"
  # C-SPY-related properties
  DEVICE_DDF    "${TOOLKIT_DIR}/config/debugger/ST/STM32F407VG.ddf"
  DEVICE_DMAC   "${TOOLKIT_DIR}/config/debugger/ST/STM32F4xx.dmac" )

# Set the compiler flags for the "myProgram" target
target_compile_options(myProgram PRIVATE
  $<$<COMPILE_LANGUAGE:C,CXX>:--dlib_config normal>
  --cpu $<TARGET_PROPERTY:CPU> --fpu $<TARGET_PROPERTY:FPU> )

# Set the linker flags for the target
target_link_options(myProgram PRIVATE
  # Genex evaluates if we are using the `Debug` configuration
  $<$<CONFIG:Debug>:--semihosting --redirect ___write=___write_buffered>
  # Create a map file from the target's ELF
  --map $<TARGET_FILE:myProgram>.map
  # Set the linker script
  --config $<TARGET_PROPERTY:DEVICE_ICF> )

# Link "myProgram" against the "myMath" library
target_link_libraries(myProgram LINK_PUBLIC myMath)

# Add a custom target for `ielftool` to generate additional output
add_custom_target(ielftool DEPENDS $<TARGET_FILE:myProgram>
  COMMAND ${CMAKE_IAR_ELFTOOL}
  --silent
  # Genex evaluates FORMAT property to select the output format
  --$<TARGET_PROPERTY:ielftool,FORMAT>
  # Uses the target file as input
  $<TARGET_FILE:myProgram>
  # Name the output based on the selected format
  $<TARGET_FILE:myProgram>.$<TARGET_PROPERTY:ielftool,FORMAT> )

# Set the custom target FORMAT property
# to select the desired output format (ihex|srec|bin)
set_target_properties(ielftool PROPERTIES FORMAT ihex)

# The macro `add_test_cspy()` is a wrapper
# To execute the `IAR C-SPY Debugger` (cspybat.exe) via `CTest`
macro(add_test_cspy TESTNAME EXPECTED)
  # IAR C-SPY drivers to be used for the selected architecture
  list(APPEND _CSPY_DRIVERS
    "${TOOLKIT_DIR}/bin/${CMAKE_SYSTEM_PROCESSOR}proc.dll"
    "${TOOLKIT_DIR}/bin/${CMAKE_SYSTEM_PROCESSOR}sim2.dll"
    "--plugin=${TOOLKIT_DIR}/bin/${CMAKE_SYSTEM_PROCESSOR}bat.dll" )

  # IAR C-SPY parameters for the "myProgram" target
  list(APPEND _CSPYBAT_PARAMETERS
    --debug_file=$<TARGET_FILE:myProgram>
    --device_macro=$<TARGET_PROPERTY:myProgram,DEVICE_DMAC> )

  # IAR C-SPY macros that integrates with CTest
  set (_CSPYBAT_TEST_MACRO
    "--macro=${CMAKE_CURRENT_SOURCE_DIR}/src/test.mac"
    "--macro_param=testName=\"${TESTNAME}\""
    "--macro_param=testExpected=${EXPECTED}" )

  # IAR C-SPY backend parameters for the "myProgram" target
  list(APPEND _CSPYBAT_PARAMETERS_BACKEND
    --device=$<TARGET_PROPERTY:myProgram,DEVICE>
    --cpu=$<TARGET_PROPERTY:myProgram,CPU>
    --fpu=$<TARGET_PROPERTY:myProgram,FPU>
    --semihosting
    --endian=little
    -p $<TARGET_PROPERTY:myProgram,DEVICE_DDF> )

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
