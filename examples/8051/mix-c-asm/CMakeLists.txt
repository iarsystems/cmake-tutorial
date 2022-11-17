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
  $<$<COMPILE_LANGUAGE:C>:--core=plain --dptr=16,1 --data_model=large --code_model=near --calling_convention=xdata_reentrant --place_constants=data --nr_virtual_regs 8 --dlib --dlib_config ${TOOLKIT_DIR}/lib/dlib/dl8051Normal.h>
  $<$<COMPILE_LANGUAGE:ASM>:-v0 -D__CORE__=1 -D__CODE_MODEL__=1 -D__DATA_MODEL__=1 -D__CALLING_CONVENTION__=2 -D__NUMBER_OF_DPTRS__=1> )

# Set the link options for the target
target_link_options(mixLanguages PRIVATE
  -rt
  -f ${TOOLKIT_DIR}/config/devices/_generic/lnk51ew_8051.xcl
  ${TOOLKIT_DIR}/lib/dlib/dl-pli-nlxd-1e16x01n.r51
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

# Optional: test the project with CTest and IAR C-SPY
include(../iar-cspy-8051.cmake)
iar_cspy_add_test(mixLanguages test_mynum 42)
