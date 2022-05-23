# The top-level CMakeLists.txt add this subdirectory
# This CMakeLists.txt builds the target "myMath" library
add_library(myMath
  add.c
  sub.c
  mul.c )

# Set the compiler flags for the "myMath" target
target_compile_options(myMath PUBLIC
  $<$<COMPILE_LANGUAGE:C>:--core=plain --dptr=16,1 --data_model=large --code_model=near --calling_convention=xdata_reentrant --place_constants=data --nr_virtual_regs 8 --dlib --dlib_config ${TOOLKIT_DIR}/lib/dlib/dl8051Normal.h>
  $<$<COMPILE_LANGUAGE:ASM>:-v0 -D__CORE__=1 -D__CODE_MODEL__=1 -D__DATA_MODEL__=1 -D__CALLING_CONVENTION__=2 -D__NUMBER_OF_DPTRS__=1>)

# Define headers for the target
# PUBLIC headers are used for building the library
# PRIVATE sources, only used in this target
target_include_directories(myMath
  PUBLIC  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/.> )
