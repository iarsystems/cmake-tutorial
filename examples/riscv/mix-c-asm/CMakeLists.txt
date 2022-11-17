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

# Set a preprocessor symbol, usable from the "mixLanguages" target
target_compile_definitions(mixLanguages PUBLIC USE_ASM=1)

# Set compile options for the target
target_compile_options(mixLanguages PRIVATE
  $<$<COMPILE_LANGUAGE:C>:--dlib_config normal>
  --core=RV32IMAFDC )

# Set the link options for the target
target_link_options(mixLanguages PRIVATE
  $<$<CONFIG:Debug>:--debug_lib --redirect ___write=___write_buffered>
  # The `SHELL:` prefix prevents option de-duplication
  "SHELL:--config_def CSTACK_SIZE=0x1000" 
  "SHELL:--config_def   HEAP_SIZE=0x1000" )

# Optional: test the project with CTest and IAR C-SPY
include(../iar-cspy-riscv.cmake)
iar_cspy_add_test(mixLanguages test_mynum 42)