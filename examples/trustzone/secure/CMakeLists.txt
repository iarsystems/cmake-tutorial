add_executable(secure)

target_sources(secure PRIVATE secure-hello.c)

set_target_properties(secure PROPERTIES
  CPU    cortex-m33
)

target_compile_options(secure PRIVATE
  --cpu=$<TARGET_PROPERTY:CPU> 
# TODO 2: Enable the CMSE in the compiler flags
)

target_include_directories(secure PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
)

target_link_options(secure PRIVATE
  --semihosting
  --cpu=$<TARGET_PROPERTY:CPU>
  --config ${CMAKE_CURRENT_SOURCE_DIR}/v2m-mps2_s.icf
# TODO 3: Set the linker to produce an import library, consumed by the `non-secure` target
)
