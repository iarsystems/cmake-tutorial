# set the minimum required version of CMake to be 3.20
cmake_minimum_required(VERSION 3.20)

# set the project name
project(Tutorial)

# add the executable target
add_executable(tutorial)

# target sources
target_sources(tutorial PRIVATE tutorial.c)

# compiler options
target_compile_options(tutorial PRIVATE
  --dlib_config=full
  --cpu=cortex-m4)

# linker options
target_link_options(tutorial PRIVATE
  --cpu=cortex-m4
  --semihosting)

# TODO 1: Enable testing in CMake

# TODO 2: Add a test named `tutorialTest` for `tutorial` (hint: use CSpyBat)

# TODO 3: Set the `tutorialTest` test passing condition

