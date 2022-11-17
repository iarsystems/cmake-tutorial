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

# Set the compiler flags for the "mixLanguages" target
target_compile_options(mixLanguages PRIVATE
  $<$<COMPILE_LANGUAGE:C>:-v0 -mt --code_model normal --lock_regs 0 --migration_preprocessor_extensions --dlib_config ${TOOLKIT_DIR}/lib/dl85nn0.h >
  $<$<COMPILE_LANGUAGE:ASM>:-v0 -DCODE_MODEL_NORMAL -DDATA_MODEL_TINY -w+ -s+> )

# Set the linker options for the "mixLanguages" target
target_link_options(mixLanguages PRIVATE
  -f ${TOOLKIT_DIR}/config/lnk85.xcl
  -rt
  -s __program_start
  # The `SHELL:` prefix prevents option de-duplication
  "SHELL:-D_CSTACK_SIZE=1000"
  ${TOOLKIT_DIR}/lib/dl85nn0.r85
  "SHELL:-e_PrintfFull=_Printf"
  "SHELL:-e_ScanfFull=_Scanf"
  "SHELL:-D_HEAP_SIZE=1000" )

# Optional: test the project with CTest and IAR C-SPY
include(../iar-cspy-v850.cmake)
iar_cspy_add_test(mixLanguages test_mynum 42)