cmake_minimum_required(VERSION 3.20)

project(Libs LANGUAGES C)

set(CMAKE_STATIC_LIBRARY_SUFFIX ".a" CACHE STRING "" FORCE)

add_executable(libs)

target_sources(libs PRIVATE main.c)
target_compile_options(libs PUBLIC --no_fragments)
include_directories(./lib)
target_link_libraries(libs "${CMAKE_SOURCE_DIR}/lib/my_crc_lib.a")
target_link_libraries(libs "${CMAKE_SOURCE_DIR}/lib/lib.a")

target_link_options(libs PRIVATE --semihosting)

