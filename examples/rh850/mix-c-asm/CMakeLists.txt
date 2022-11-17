cmake_minimum_required(VERSION 3.22)

# Set the project name, [description] and [version],
# while enabling its required languages
project(Example1 
  DESCRIPTION "Mixing C and Assembly"
  VERSION 1.0.0
  LANGUAGES C ASM )

# Fallback option for generators other than `Ninja Multi-Config`
if (NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug)
endif()

# Enable CTest
enable_testing()

# Add the executable for the "mixLanguages" target
add_executable(mixLanguages
  # Source files
  main.c
  mynum.asm )

# Set a preprocessor symbol, usable from "mixLanguages" target
target_compile_definitions(mixLanguages PUBLIC USE_ASM=1)

# Set compile options for the target
target_compile_options(mixLanguages PRIVATE
  $<$<COMPILE_LANGUAGE:C>:--lock_global_pointer_regs=0 --dlib_config ${TOOLKIT_DIR}/lib/DLib_Config_Normal.h>
  --core g3m --fpu=double --double=64 --data_model medium )

# Set the link options for the target
target_link_options(mixLanguages PRIVATE
  $<$<CONFIG:Debug>:--debug_lib --redirect ___write=___write_buffered>
  --config ${TOOLKIT_DIR}/config/lnkr7f701401.icf
  # The `SHELL:` prefix prevents option de-duplication
  "SHELL:--config_def CSTACK_SIZE=0x1000"
  "SHELL:--config_def   HEAP_SIZE=0x1000"
  "SHELL:--config_def _SELF_SIZE=0x20000" )

# Optional: test the project with CTest and IAR C-SPY
include(../iar-cspy-rh850.cmake)
iar_cspy_add_test(mixLanguages test_mynum 42)
