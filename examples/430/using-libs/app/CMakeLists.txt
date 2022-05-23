# Add the executable for the "myProgram" target,
# specifying its source files
add_executable (myProgram
  # Source files
  main.c )

# Set the properties for the "myProgram" target
set_target_properties(myProgram PROPERTIES
  XCL    "${TOOLKIT_DIR}/config/linker/lnk430f149.xcl"
  # C-SPY-related properties
  DDF    "${TOOLKIT_DIR}/config/debugger/msp430f149.ddf" )

# Set the compiler flags for the target
target_compile_options(myProgram PRIVATE
  $<$<COMPILE_LANGUAGE:C>:--multiplier=16 --double=32 --dlib_config ${TOOLKIT_DIR}/lib/dlib/dl430fn.h>
  -D__MSP430F149__ )

# Set the linker flags for the target
target_link_options(myProgram PRIVATE
  -s __program_start
  # Create a map file from the target's UBROF
  -l $<TARGET_PROPERTY:NAME>.map
  # The `SHELL:` prefix prevents option de-duplication
  "SHELL:-D_DATA16_HEAP_SIZE=50"
  "SHELL:-D_STACK_SIZE=50"
  "SHELL:-D_DATA20_HEAP_SIZE=50"
  # Set the linker script
  -f $<TARGET_PROPERTY:XCL>
  # The `SHELL:` prefix prevents option de-duplication
  "SHELL:-f ${TOOLKIT_DIR}/config/linker/multiplier.xcl"
  -rt ${TOOLKIT_DIR}/lib/dlib/dl430fn.r43 )

# Link "myProgram" against the "myMath" library
target_link_libraries(myProgram LINK_PUBLIC myMath)

# Optional: test the project with C-SPY
include(../../iar-cspy-430.cmake)
iar_cspy_add_test(myProgram test_add 42)
iar_cspy_add_test(myProgram test_sub 38)
iar_cspy_add_test(myProgram test_mul 80)
