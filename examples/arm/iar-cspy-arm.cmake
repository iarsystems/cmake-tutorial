# Example for creating a test for CTest 
# to execute the `IAR C-SPY Command-line Utility (cspybat.exe)`

function(iar_cspy_add_test TARGET TEST_NAME EXPECTED_OUTPUT)
  find_program(CSPY_BAT
    NAMES cspybat CSpyBat
    PATHS ${TOOLKIT_DIR}/../common
    PATH_SUFFIXES bin )

  # Check if C-SPY is being run from BX
  if(WIN32)
    set(libPREFIX "")
    set(libPROCsuffix proc.dll)
    set(libSIM2suffix sim2.dll)
    set(libBATsuffix bat.dll)
  else()
    set(libPREFIX lib)
    set(libPROCsuffix PROC.so)
    set(libSIM2suffix SIM2.so)
    set(libBATsuffix Bat.so)
  endif()

  # Add a test for CTest
  add_test(NAME ${TEST_NAME}
           COMMAND ${CSPY_BAT} --silent
           # C-SPY drivers
           "${TOOLKIT_DIR}/bin/${libPREFIX}${CMAKE_SYSTEM_PROCESSOR}${libPROCsuffix}"
           "${TOOLKIT_DIR}/bin/${libPREFIX}${CMAKE_SYSTEM_PROCESSOR}${libSIM2suffix}"
           "--plugin=${TOOLKIT_DIR}/bin/${libPREFIX}${CMAKE_SYSTEM_PROCESSOR}${libBATsuffix}"
           --debug_file=$<TARGET_FILE:${TARGET}>
           $<IF:$<BOOL:$<TARGET_PROPERTY:${TARGET},DMAC>>,--device_macro=$<TARGET_PROPERTY:${TARGET},DMAC>,>
           # C-SPY macros settings
           "--macro=${CMAKE_CURRENT_SOURCE_DIR}/${TARGET}.mac"
           "--macro_param=testName=\"${TEST_NAME}\""
           "--macro_param=testExpected=${EXPECTED_OUTPUT}"
           # C-SPY backend setup
           --backend
           --cpu=$<IF:$<BOOL:$<TARGET_PROPERTY:${TARGET},CPU>>,$<TARGET_PROPERTY:${TARGET},CPU>,Cortex-M3>
           --fpu=$<IF:$<BOOL:$<TARGET_PROPERTY:${TARGET},FPU>>,$<TARGET_PROPERTY:${TARGET},FPU>,None>
           $<IF:$<BOOL:$<TARGET_PROPERTY:${TARGET},DEVICE>>,--device=$<TARGET_PROPERTY:${TARGET},DEVICE>,>
           --semihosting
           --endian=little
           $<IF:$<BOOL:$<TARGET_PROPERTY:${TARGET},DDF>>,-p,>
           $<IF:$<BOOL:$<TARGET_PROPERTY:${TARGET},DDF>>,$<TARGET_PROPERTY:${TARGET},DDF>,> )

  # Set the test to interpret a C-SPY's message containing `PASS`
  set_tests_properties(${TEST_NAME} PROPERTIES PASS_REGULAR_EXPRESSION "PASS")
endfunction()
