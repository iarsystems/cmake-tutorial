# Add the executable for the "myProgram" target,
# specifying its source files
add_executable (myProgram
  # Source files
  main.c )

# Set the properties for the "myProgram" target
set_target_properties(myProgram PROPERTIES
  CPU           s3
  ICF           "${TOOLKIT_DIR}/config/lnkrl78_s3.icf"
  # C-SPY-related properties
  DDF           "${TOOLKIT_DIR}/config/debugger/iorl78_s3.ddf" )

# Set compile options for the target
target_compile_options(myProgram PRIVATE
  $<$<COMPILE_LANGUAGE:C>:--code_model=near --data_model=near --calling_convention=v2 --near_const_location=rom0 --double=32 --dlib_config ${TOOLKIT_DIR}/lib/DLib_Config_Normal.h>
  $<$<COMPILE_LANGUAGE:ASM>:-D__NEAR_MODEL__ -D__NEAR_DATA_MODEL__>
  --core $<TARGET_PROPERTY:CPU> )

# Set the link options for the target
target_link_options(myProgram PRIVATE
  $<$<CONFIG:Debug>:--debug_lib --redirect ___write=___write_buffered>
  # Create a map file from the target's ELF
  --map $<TARGET_PROPERTY:NAME>.map
  # The `SHELL:` prefix prevents option de-duplication
  "SHELL:--config_def __RESERVE_OCD_ROM=1"
  "SHELL:--config_def _STACK_SIZE=256"
  "SHELL:--config_def _NEAR_HEAP_SIZE=1024"
  "SHELL:--config_def _FAR_HEAP_SIZE=4096"
  "SHELL:--config_def _HUGE_HEAP_SIZE=0"
  "SHELL:--define_symbol _NEAR_CONST_LOCATION=0"
  "SHELL:--config_def _NEAR_CONST_LOCATION_START=0x3000"
  "SHELL:--config_def _NEAR_CONST_LOCATION_SIZE=0x6F00"
  # Set the linker script
  --config $<TARGET_PROPERTY:ICF> )

# Link "myProgram" against the "myMath" library
target_link_libraries(myProgram LINK_PUBLIC myMath)

# Optional: convert the output to .hex format
include(../../iar-functions.cmake)
iar_elf_tool_hex(myProgram)

# Optional: test the project with CTest and IAR C-SPY
include(../../iar-cspy-rl78.cmake)
iar_cspy_add_test(myProgram test_add 42)
iar_cspy_add_test(myProgram test_sub 38)
iar_cspy_add_test(myProgram test_mul 80)
