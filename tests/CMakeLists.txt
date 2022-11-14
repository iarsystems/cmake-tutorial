cmake_minimum_required(VERSION 3.22)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(TOOLKIT_DIR $ENV{TOOLKIT_DIR})
list(APPEND CMAKE_CONFIGURATION_TYPES Debug Release RelWithDebInfo MinSizeRel)

project(IAR-test LANGUAGES C CXX ASM)

set(LINKER_MAP --map $<CONFIG>/$<TARGET_PROPERTY:NAME>.map)

# arch-specific
if(TARGET_ARCH STREQUAL arm)
  set(LINKER_OPTS "SHELL:--config ${TOOLKIT_DIR}/config/generic.icf")
elseif(TARGET_ARCH STREQUAL avr)
  set(ICC_OPTS -v3 --enhanced_core -ms)
  set(ASM_OPTS -D__IASMAVR__)
  set(LINKER_OPTS -f ${TOOLKIT_DIR}/src/template/lnk3s.xcl -rt -s __program_start ${TOOLKIT_DIR}/lib/dlib/dlAVR-3s-ec_mul-n.r90)
  set(LINKER_MAP -l $<CONFIG>/$<TARGET_PROPERTY:NAME>.map)
elseif(TARGET_ARCH MATCHES "(riscv|rx)")
  set(LINKER_OPTS "SHELL:--config_def CSTACK_SIZE=0x1000 --config_def HEAP_SIZE=0x1000 --debug_lib")
elseif(TARGET_ARCH STREQUAL rh850)
  set(LINKER_OPTS "SHELL:--config_def CSTACK_SIZE=0x1000 --config_def HEAP_SIZE=0x1000 --config_def _SELF_SIZE=0x20000
  --config ${TOOLKIT_DIR}/config/lnkr7f701401.icf")
elseif(TARGET_ARCH STREQUAL rl78)
  set(LINKER_OPTS "SHELL:--config_def _STACK_SIZE=256 --config_def _NEAR_HEAP_SIZE=0x400 --config_def
  _FAR_HEAP_SIZE=4096 --config_def _HUGE_HEAP_SIZE=0 --config_def _NEAR_CONST_LOCATION_START=0x2000 --config_def
  _NEAR_CONST_LOCATION_SIZE=0x6F00 --define_symbol _NEAR_CONST_LOCATION=0 --debug_lib --config ${TOOLKIT_DIR}/config/lnkrl78_s3.icf")
elseif(TARGET_ARCH STREQUAL rx)
  set(LINKER_OPTS "SHELL:--config_def _USTACK_SIZE=0x1000 --config_def _ISTACK_SIZE=0x1000 _HEAP_SIZE=0x1000 --debug_lib")
elseif(TARGET_ARCH STREQUAL stm8)
  set(LINKER_OPTS "SHELL:--config_def _CSTACK_SIZE=0x100 --config_def _HEAP_SIZE=0x100")
endif()

# Test the IAR C Compiler
add_executable(test-c)
target_sources(test-c PRIVATE module.c)
target_compile_options(test-c PRIVATE $<$<CONFIG:Debug>:-Ol> ${ICC_OPTS})
target_compile_definitions(test-c PRIVATE CSYMBOL=32)
target_link_options(test-c PRIVATE
  ${LINKER_MAP}
  ${LINKER_OPTS}
)

# Test the IAR C++ Compiler
add_executable(test-cxx)
target_sources(test-cxx PRIVATE module.cxx)
target_compile_options(test-cxx PRIVATE $<$<CONFIG:Debug>:-Om> ${ICC_OPTS})
target_compile_definitions(test-cxx PRIVATE CXXSYM=64)
target_link_options(test-cxx PRIVATE
  ${LINKER_MAP}
  ${LINKER_OPTS}
)

# Test the IAR Assembler
add_executable(test-asm)
target_sources(test-asm PRIVATE module.asm)
target_compile_definitions(test-asm PRIVATE ASMSYM=16 ${ASM_OPTS})
target_link_options(test-asm PRIVATE
  ${LINKER_MAP}
  ${LINKER_OPTS}
)

