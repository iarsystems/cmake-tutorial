cmake_minimum_required(VERSION 3.22)

# Set the project name, [description] and [version],
# while enabling its required languages
project(Example1 
  DESCRIPTION "Mixing C and Assembly"
  VERSION 1.0.0
  LANGUAGES C ASM )

# Fallback option for generators other than `Ninja Multi-Config`
if (NOT DEFINED CMAKE_BUILD_TYPE)
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
  $<$<COMPILE_LANGUAGE:C>:--dlib_config normal>
  --cpu Cortex-M3 )

# Set the link options for the target
target_link_options(mixLanguages PRIVATE
  $<$<CONFIG:Debug>:--semihosting --redirect ___write=___write_buffered>
  --config ${TOOLKIT_DIR}/config/generic.icf )

# Optional: test the project with CTest and IAR C-SPY
include(../iar-cspy-arm.cmake)
iar_cspy_add_test(mixLanguages test_mynum 42)
