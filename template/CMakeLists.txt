# CMake 4.4.0 provides C++20 support for IAR
cmake_minimum_required(VERSION 4.4.0)

project(example LANGUAGES C CXX)

set(CMAKE_C_EXTENSIONS ON)
set(CMAKE_CXX_EXTENSIONS ON)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(hello)

target_sources(hello PRIVATE
  hello.cpp
  foo.c
)

target_compile_options(hello PRIVATE
  $<$<COMPILE_LANGUAGE:CXX>:--no_rtti --no_exceptions>
  --cpu=Cortex-M4
  --fpu=VFPv4_SP
)

target_link_options(hello PRIVATE
  --config "linker/ST/stm32f407xG.icf"
  --map $<TARGET_FILE_DIR:hello> # Generate a map file for debugging
  --semihosting  # Enable semihosting for printf() output
)

# Generate compiler internal macros for Clangd
execute_process(
  COMMAND ${CMAKE_C_COMPILER} . --silent --predef_macros=n c_macros.h
  COMMAND ${CMAKE_CXX_COMPILER} . --c++ --libc++ --silent --predef_macros=n cxx_macros.h
)
