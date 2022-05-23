# Add the executable for the "myProgram" target,
# specifying its source files
add_executable (myProgram
  # Source files
  main.c )

# Set the properties for the "myProgram" target
set_target_properties(myProgram PROPERTIES
  ARCHITECTURE  ${CMAKE_SYSTEM_PROCESSOR}
  ICF           "${TOOLKIT_DIR}/config/lnkstm8.icf"
  # C-SPY-related properties
  DDF           "${TOOLKIT_DIR}/config/ddf/iostm8.ddf" )

# Set compile options for the target
target_compile_options(myProgram PRIVATE
  $<$<COMPILE_LANGUAGE:C,CXX>:--vregs 16 --dlib_config ${TOOLKIT_DIR}/lib/dlstm8smn.h>
  --data_model medium --code_model small )

# Set the link options for the target
target_link_options(myProgram PRIVATE
  $<$<CONFIG:Debug>:--debug_lib --redirect ___write=___write_buffered>
  # Create a map file from the target's ELF
  --map $<TARGET_PROPERTY:NAME>.map
  # The `SHELL:` prefix prevents option de-duplication
  "SHELL:--config_def _CSTACK_SIZE=0x100"
  "SHELL:--config_def   _HEAP_SIZE=0x100"
  # Set the linker script
  --config $<TARGET_PROPERTY:ICF> )

# Link "myProgram" against the "myMath" library
target_link_libraries(myProgram LINK_PUBLIC myMath)

# Optional: convert the output to .hex format
include(../../iar-functions.cmake)
iar_elf_tool_hex(myProgram)

# Optional: test the project with CTest and IAR C-SPY
include(../../iar-cspy-stm8.cmake)
iar_cspy_add_test(myProgram test_add 42)
iar_cspy_add_test(myProgram test_sub 38)
iar_cspy_add_test(myProgram test_mul 80)