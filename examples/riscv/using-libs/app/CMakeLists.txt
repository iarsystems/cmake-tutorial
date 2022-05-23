# Add the executable for the "myProgram" target,
# specifying its source files
add_executable (myProgram
  # Source files
  main.c )

# Set the properties for the "myProgram" target
set_target_properties(myProgram PROPERTIES
  CPU           RV32IMAFDC
  ICF           "${TOOLKIT_DIR}/config/linker/SiFive/hifive1.icf"
  # C-SPY-related properties
  DDF           "${TOOLKIT_DIR}/config/debugger/SiFive/hifive1.ddf" )

# Set the compiler flags for the "myProgram" target
target_compile_options(myProgram PRIVATE
  $<$<COMPILE_LANGUAGE:C,CXX>:--dlib_config normal>
  --core $<TARGET_PROPERTY:CPU> )

# Set the linker flags for the target
target_link_options(myProgram PRIVATE
  # Genex evaluates if we are using the `Debug` configuration
  $<$<CONFIG:Debug>:--debug_lib --redirect ___write=___write_buffered>
  # Create a map file from the target's ELF
  --map $<TARGET_PROPERTY:NAME>.map
  # The `SHELL:` prefix prevents option de-duplication
  "SHELL:--config_def CSTACK_SIZE=0x1000" 
  "SHELL:--config_def   HEAP_SIZE=0x1000" 
  # Set the linker script
  --config $<TARGET_PROPERTY:ICF> )

# Link "myProgram" against the "myMath" library
target_link_libraries(myProgram LINK_PUBLIC myMath)

# Optional: convert the output to .hex format
include(../../iar-functions.cmake)
iar_elf_tool_hex(myProgram)

# Optional: test the project with CTest and IAR C-SPY
include(../../iar-cspy-riscv.cmake)
iar_cspy_add_test(myProgram test_add 42)
iar_cspy_add_test(myProgram test_sub 38)
iar_cspy_add_test(myProgram test_mul 80)
