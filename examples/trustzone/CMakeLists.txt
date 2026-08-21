# See: https://cmake.org/cmake/help/latest/prop_sf/GENERATED.html
cmake_minimum_required(VERSION 3.30)

project(TrustZone LANGUAGES C)

add_subdirectory(secure)
add_subdirectory(non-secure)

