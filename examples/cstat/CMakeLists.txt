# Minimum CMake version is cmake-4.0.20250425-gd948dd6
cmake_minimum_required(VERSION 4.0)

set(This cstat_demo)

project(${This} C)


# TODO 1: Enable C-STAT Static Analysis


# TODO 2: Select the CERT C ruleset


# TODO 3: Select the MISRA C:2012 ruleset


add_executable(${This})

target_sources(${This} PRIVATE
  main.c
  caller.c
  callee.c
)

target_compile_options(${This} PRIVATE
  --no_wrap_diagnostics
)

target_link_options(${This} PRIVATE
  --vfe
  --map .
)

# TODO 4: Perform link-time analysis when using the MISRA C:2012 ruleset

