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
  $<$<COMPILE_LANGUAGE:C>:--code_model=near --data_model=near --calling_convention=v2 --near_const_location=rom0 --double=32 --dlib_config ${TOOLKIT_DIR}/lib/DLib_Config_Normal.h>
  $<$<COMPILE_LANGUAGE:ASM>:-D__NEAR_MODEL__ -D__NEAR_DATA_MODEL__>
  --core s3)

# Set the link options for the target
target_link_options(mixLanguages PRIVATE
  $<$<CONFIG:Debug>:--debug_lib --redirect ___write=___write_buffered>
  --config ${TOOLKIT_DIR}/config/lnkrl78_s3.icf
  # The `SHELL:` prefix prevents option de-duplication
  "SHELL:--config_def __RESERVE_OCD_ROM=1"
  "SHELL:--config_def _STACK_SIZE=256"
  "SHELL:--config_def _NEAR_HEAP_SIZE=1024"
  "SHELL:--config_def _FAR_HEAP_SIZE=4096"
  "SHELL:--config_def _HUGE_HEAP_SIZE=0"
  "SHELL:--define_symbol _NEAR_CONST_LOCATION=0"
  "SHELL:--config_def _NEAR_CONST_LOCATION_START=0x3000"
  "SHELL:--config_def _NEAR_CONST_LOCATION_SIZE=0x6F00" )

# Optional: test the project with CTest and IAR C-SPY
include(../iar-cspy-rl78.cmake)
iar_cspy_add_test(mixLanguages test_mynum 42)