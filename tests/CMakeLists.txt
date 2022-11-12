cmake_minimum_required(VERSION 3.22)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
list(APPEND CMAKE_CONFIGURATION_TYPES Debug Release RelWithDebInfo MinSizeRel)

project(IAR-test LANGUAGES C CXX ASM)

# arch-specific linker options
if(TARGET_ARCH STREQUAL arm)
  set(LINKER_OPTS "SHELL:--config_def CFGSYM=0x10")
elseif(TARGET_ARCH MATCHES "(rh850|riscv|stm8)")
  set(LINKER_OPTS "SHELL:--config_def CSTACK_SIZE=0x1000 --config_def HEAP_SIZE=0x1000 --debug_lib")
elseif(TARGET_ARCH STREQUAL rl78)
  set(LINKER_OPTS "SHELL:--config_def _STACK_SIZE=256 --debug_lib")
elseif(TARGET_ARCH STREQUAL rx)
  set(LINKER_OPTS "SHELL:--config_def _USTACK_SIZE=0x1000 --config_def _ISTACK_SIZE=0x1000 _HEAP_SIZE=0x1000 --debug_lib")
endif()

# Test the IAR C Compiler
add_executable(test-c)
target_sources(test-c PRIVATE module.c)
target_compile_options(test-c PRIVATE $<$<CONFIG:Debug>:-Ol>)
target_compile_definitions(test-c PRIVATE CSYMBOL=32)
target_link_options(test-c PRIVATE
  --map $<CONFIG>/$<TARGET_PROPERTY:NAME>.map
  ${LINKER_OPTS}
)

# Test the IAR C++ Compiler
add_executable(test-cxx)
target_sources(test-cxx PRIVATE module.cxx)
target_compile_options(test-cxx PRIVATE $<$<CONFIG:Debug>:-Om>)
target_compile_definitions(test-cxx PRIVATE CXXSYM=64)
target_link_options(test-cxx PRIVATE
  --map $<CONFIG>/$<TARGET_PROPERTY:NAME>.map
  ${LINKER_OPTS}
)

# Test the IAR Assembler
add_executable(test-asm)
target_sources(test-asm PRIVATE module.asm)
target_compile_definitions(test-asm PRIVATE ASMSYM=16)
target_link_options(test-asm PRIVATE
  --map $<CONFIG>/$<TARGET_PROPERTY:NAME>.map
)

