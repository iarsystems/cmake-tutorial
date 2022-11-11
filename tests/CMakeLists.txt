cmake_minimum_required(VERSION 3.22)

project(AutoTest LANGUAGES ASM C CXX )
set(CMAKE_BUILD_TYPE Debug)
add_executable(test-program)
target_sources(test-program PRIVATE main.c)

