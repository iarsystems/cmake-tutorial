# The top-level CMakeLists.txt add this subdirectory
# This CMakeLists.txt builds the target "myMath" library
add_library(myMath
  add.c
  sub.c
  mul.c )

# Set the compiler flags for the "myMath" target
target_compile_options(myMath PUBLIC
  $<$<COMPILE_LANGUAGE:C>:-v0 -mt --code_model normal --lock_regs 0 --migration_preprocessor_extensions --dlib_config ${TOOLKIT_DIR}/lib/dl85nn0.h > )

# Define headers for the target
# PUBLIC headers are used for building the library
# PRIVATE sources, only used in this target
target_include_directories(myMath
  PUBLIC  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/.> )
