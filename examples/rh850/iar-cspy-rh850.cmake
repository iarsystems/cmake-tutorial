# Example for creating a test for CTest 
# to execute the `IAR C-SPY Command-line Utility (cspybat.exe)`

function(iar_cspy_add_test TARGET TEST_NAME EXPECTED_OUTPUT)
  # Add a test for CTest
  add_test(NAME ${TEST_NAME}
           COMMAND ${TOOLKIT_DIR}/../common/bin/cspybat --silent
           # C-SPY drivers
           "${TOOLKIT_DIR}/bin/${CMAKE_SYSTEM_PROCESSOR}proc.dll"
           "${TOOLKIT_DIR}/bin/${CMAKE_SYSTEM_PROCESSOR}sim.dll"
           "--plugin=${TOOLKIT_DIR}/bin/${CMAKE_SYSTEM_PROCESSOR}bat.dll"
           --debug_file=$<TARGET_FILE:${TARGET}>
           # C-SPY macros settings
           "--macro=${CMAKE_CURRENT_SOURCE_DIR}/${TARGET}.mac"
           "--macro_param=testName=\"${TEST_NAME}\""
           "--macro_param=testExpected=${EXPECTED_OUTPUT}"
           # C-SPY backend setup
           --backend
           -p $<IF:$<BOOL:$<TARGET_PROPERTY:${TARGET},DDF>>,$<TARGET_PROPERTY:${TARGET},DDF>,${TOOLKIT_DIR}/config/debugger/ior7f701401.ddf>
           --core=$<IF:$<BOOL:$<TARGET_PROPERTY:${TARGET},CPU>>,$<TARGET_PROPERTY:${TARGET},CPU>,g3m>
           --fpu double
           --double=64
           -d sim
           --multicore_nr_of_cores=1 )

  # Set the test to interpret a C-SPY's message containing `PASS`
  set_tests_properties(${TEST_NAME} PROPERTIES PASS_REGULAR_EXPRESSION "PASS")
endfunction()
