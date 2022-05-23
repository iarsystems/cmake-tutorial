# Add the executable for the "myProgram" target,
# specifying its source files
add_executable (myProgram
  # Source files
  main.c )

# Set the properties for the "myProgram" target
set_target_properties(myProgram PROPERTIES
  XCL           "${TOOLKIT_DIR}/config/lnk85.xcl"
  DDF           "${TOOLKIT_DIR}/config/ddf/iov850.ddf" )

# Set compile options for the target
target_compile_options(myProgram PRIVATE
  $<$<COMPILE_LANGUAGE:C>:-v0 -mt --code_model normal --lock_regs 0 --migration_preprocessor_extensions --dlib_config ${TOOLKIT_DIR}/lib/dl85nn0.h >)

# Set the link options for the target
target_link_options(myProgram PRIVATE
  # Set the linker script
  -f $<TARGET_PROPERTY:XCL>
  -rt
  -s __program_start
  # Create a map file from the target's UBROF
  -l $<TARGET_PROPERTY:NAME>.map
  # The `SHELL:` prefix prevents option de-duplication
  "SHELL:-D_CSTACK_SIZE=1000"
  ${TOOLKIT_DIR}/lib/dl85nn0.r85
  "SHELL:-e_PrintfFull=_Printf"
  "SHELL:-e_ScanfFull=_Scanf"
  "SHELL:-D_HEAP_SIZE=1000" )

# Link "myProgram" against the "myMath" library
target_link_libraries(myProgram LINK_PUBLIC myMath)

# Optional: test the project with CTest and IAR C-SPY
include(../../iar-cspy-v850.cmake)
iar_cspy_add_test(myProgram test_add 42)
iar_cspy_add_test(myProgram test_sub 38)
iar_cspy_add_test(myProgram test_mul 80)