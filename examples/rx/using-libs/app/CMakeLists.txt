# Add the executable for the "myProgram" target,
# specifying its source files
add_executable (myProgram
  # Source files
  main.c )

# Set the properties for the "myProgram" target
set_target_properties(myProgram PROPERTIES
  CPU           rxv1
  ICF           "${TOOLKIT_DIR}/config/lnkr5f563ne.icf"
  # C-SPY-related properties
  DDF           "${TOOLKIT_DIR}/config/debugger/ior5f563ne.ddf" )

# Set compile options for the target
target_compile_options(myProgram PRIVATE
  $<$<COMPILE_LANGUAGE:C,CXX>:--align_func=1 --dlib_config normal>
  --core $<TARGET_PROPERTY:CPU> --double=64 )

# Set the link options for the target
target_link_options(myProgram PRIVATE
  $<$<CONFIG:Debug>:--debug_lib --redirect ___write=___write_buffered>
  # Create a map file from the target's ELF
  --map $<TARGET_PROPERTY:NAME>.map
  # The `SHELL:` prefix prevents option de-duplication
  "SHELL:--config_def _USTACK_SIZE=0x800"
  "SHELL:--config_def _ISTACK_SIZE=0x800"
  "SHELL:--config_def   _HEAP_SIZE=0x800"
  # Set the linker script
  --config $<TARGET_PROPERTY:ICF> )

# Link "myProgram" against the "myMath" library
target_link_libraries(myProgram LINK_PUBLIC myMath)

# Optional: convert the output to .hex format
include(../../iar-functions.cmake)
iar_elf_tool_hex(myProgram)

# Optional: test the project with CTest and IAR C-SPY
include(../../iar-cspy-rx.cmake)
iar_cspy_add_test(myProgram test_add 42)
iar_cspy_add_test(myProgram test_sub 38)
iar_cspy_add_test(myProgram test_mul 80)