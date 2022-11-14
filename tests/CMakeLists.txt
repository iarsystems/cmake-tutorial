cmake_minimum_required(VERSION 3.22)

set(TOOLKIT_DIR $ENV{TOOLKIT_DIR})
set(CMAKE_GENERATOR "Ninja Multi-Config")
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
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
elseif(TARGET_ARCH STREQUAL 430)
  set(ASM_OPTS -D__IASM430__)
  set(LINKER_OPTS -D_STACK_SIZE=0x40 -D_DATA16_HEAP_SIZE=0x40 -D_DATA20_HEAP_SIZE=0x40)
  set(LINKER_OPTS ${LINKER_OPTS} "SHELL:-f ${TOOLKIT_DIR}/config/linker/lnk430f149.xcl -f ${TOOLKIT_DIR}/config/linker/multiplier.xcl")
  set(LINKER_OPTS ${LINKER_OPTS} -s __program_start -rt ${TOOLKIT_DIR}/lib/dlib/dl430fn.r43)
  set(LINKER_MAP -l $<CONFIG>/$<TARGET_PROPERTY:NAME>.map)
elseif(TARGET_ARCH STREQUAL 8051)
  set(ASM_OPTS -D__IASM8051__ -D__CORE__=1 -D__CODE_MODEL=1 -D__DATA_MODEL__=1 -D__CALLING_CONVENTION__=2)
  set(ICC_OPTS --core=plain --dptr=16,1 --data_model=large --code_model=near)
  set(ICC_OPTS ${ICC_OPTS} --calling_convention=xdata_reentrant --place_constants=data --nr_virtual_regs 8)
  set(ICC_OPTS ${ICC_OPTS} --dlib_config ${TOOLKIT_DIR}/lib/dlib/dl8051Normal.h)
  set(LINKER_OPTS -f ${TOOLKIT_DIR}/config/devices/_generic/lnk51ew_8052.xcl -rt -s __program_start ${TOOLKIT_DIR}/lib/dlib/dl-pli-nlxd-1e16x01n.r51)
  set(LINKER_OPTS ${LINKER_OPTS} -D_NR_OF_VIRTUAL_REGISTERS=8 -D?PBANK=0xA0 -D?CBANK=0xF0  )
  set(LINKER_OPTS ${LINKER_OPTS} -D?CBANK_MASK=0x30 -e?BCALL_30=?BCALL -e?BRET_30=?BRET -e?BDISPATCH_30=?BDISPATCH -D_CODEBANK_START=0x8000  )
  set(LINKER_OPTS ${LINKER_OPTS} -D_CODEBANK_END=0xFFFF -D_NR_OF_BANKS=0x03 )
  set(LINKER_OPTS ${LINKER_OPTS} -D_IDATA_STACK_SIZE=0x40 -D?ESP=0 -D?ESP_MASK=0 -D_EXTENDED_STACK_START=0 -D_EXTENDED_STACK_SIZE=0  )
  set(LINKER_OPTS ${LINKER_OPTS} -D_PDATA_STACK_SIZE=0x80 -D_XDATA_STACK_SIZE=0xEFF -D_XDATA_HEAP_SIZE=0xFF -D_FAR_HEAP_SIZE=0xFFF  )
  set(LINKER_OPTS ${LINKER_OPTS} -D_HUGE_HEAP_SIZE=0xFFF -D_FAR22_HEAP_SIZE=0xFFF )
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
target_compile_options(test-c PRIVATE $<$<CONFIG:Debug>:-Ol> -e ${ICC_OPTS})
target_compile_definitions(test-c PRIVATE CSYMBOL=32)
target_link_options(test-c PRIVATE
  ${LINKER_MAP}
  ${LINKER_OPTS}
)

# Test the IAR C++ Compiler
add_executable(test-cxx)
target_sources(test-cxx PRIVATE module.cxx)
target_compile_options(test-cxx PRIVATE $<$<CONFIG:Debug>:-Om> -e ${ICC_OPTS})
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

