cmake_minimum_required(VERSION 4.3.2)

project(Standards C CXX)

add_executable(app-cpp20 main.cpp)
# TODO 1: Enable strict-conformance for the app-cpp20 application
set_target_properties(app-cpp20 PROPERTIES
  CXX_STANDARD 20
  CXX_STANDARD_REQUIRED OFF
  CXX_EXTENSIONS ON)


add_executable(app-cpp17 main.cpp)
set_target_properties(app-cpp17 PROPERTIES
  CXX_STANDARD 17
  CXX_STANDARD_REQUIRED OFF
  CXX_EXTENSIONS ON)


add_executable(app-cpp14 main.cpp)
set_target_properties(app-cpp14 PROPERTIES
  CXX_STANDARD 14
  CXX_STANDARD_REQUIRED OFF
  CXX_EXTENSIONS ON)


add_executable(app-cpp11 main.cpp)
set_target_properties(app-cpp11 PROPERTIES
  CXX_STANDARD 11
  CXX_STANDARD_REQUIRED ON
  CXX_EXTENSIONS ON)


add_executable(app-c17 main.c)
set_target_properties(app-c17 PROPERTIES
  C_STANDARD 17
  C_STANDARD_REQUIRED OFF
  C_EXTENSIONS ON)


add_executable(app-c11 main.c)
set_target_properties(app-c11 PROPERTIES
  C_STANDARD 11
  C_STANDARD_REQUIRED OFF
  C_EXTENSIONS ON)


add_executable(app-c99 main.c)
set_target_properties(app-c99 PROPERTIES
  C_STANDARD 99
  C_STANDARD_REQUIRED OFF
  C_EXTENSIONS ON)


add_executable(app-c90 main.c)
# TODO 2: Enable strict-conformance for the app-c90 application
set_target_properties(app-c90 PROPERTIES
  C_STANDARD 90
  C_STANDARD_REQUIRED OFF
  C_EXTENSIONS ON)

