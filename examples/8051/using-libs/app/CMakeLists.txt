# Add the executable for the "myProgram" target,
# specifying its source files
add_executable (myProgram
  # Source files
  main.c )

# Set the properties for the "myProgram" target
set_target_properties(myProgram PROPERTIES
  XCL           "${TOOLKIT_DIR}/config/devices/_generic/lnk51ew_8051.xcl"
  # C-SPY-related properties
  DDF           "${TOOLKIT_DIR}/config/devices/_generic/io8051.ddf" )

# Set the compiler flags for the "myProgram" target
target_compile_options(myProgram PRIVATE
  $<$<COMPILE_LANGUAGE:C>:--core=plain --dptr=16,1 --data_model=large --code_model=near --calling_convention=xdata_reentrant --place_constants=data --nr_virtual_regs 8 --dlib --dlib_config ${TOOLKIT_DIR}/lib/dlib/dl8051Normal.h> )

# Set the linker flags for the target
target_link_options(myProgram PRIVATE
  -rt
  # Set the linker script
  -f $<TARGET_PROPERTY:XCL>
  ${TOOLKIT_DIR}/lib/dlib/dl-pli-nlxd-1e16x01n.r51
  # Create a map file from the target's UBROF
  -l $<TARGET_PROPERTY:NAME>.map
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

# Link "myProgram" against the "myMath" library
target_link_libraries(myProgram LINK_PUBLIC myMath)

# Optional: test the project with CTest and IAR C-SPY
include(../../iar-cspy-8051.cmake)
iar_cspy_add_test(myProgram test_add 42)
iar_cspy_add_test(myProgram test_sub 38)
iar_cspy_add_test(myProgram test_mul 80)