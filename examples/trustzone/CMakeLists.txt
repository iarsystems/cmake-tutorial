cmake_minimum_required(VERSION 3.20)

project(TrustZone LANGUAGES C)

add_subdirectory(secure)
add_subdirectory(non-secure)

# TODO 1: Add `secure` as a dependency for `non-secure`
add_dependencies()

