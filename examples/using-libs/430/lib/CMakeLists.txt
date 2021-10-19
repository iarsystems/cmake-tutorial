# The top-level CMakeLists.txt add this subdirectory
# This CMakeLists.txt builds the target "myMath" library
add_library(myMath
  src/add.c
  src/sub.c
  src/mul.c )

# Set the compiler flags for the "myMath" target
target_compile_options(myMath PUBLIC
  $<$<COMPILE_LANGUAGE:C>:--multiplier=16 --double=32 --dlib_config ${TOOLKIT_DIR}/lib/dlib/dl430fn.h>
  -D__MSP430F149__  )

# Define headers for the target
# PUBLIC headers are used for building the library
# PRIVATE sources, only used in this target
target_include_directories(myMath
  PUBLIC  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  PRIVATE src )
