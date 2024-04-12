add_executable(non-secure)

target_sources(non-secure PRIVATE non-secure-hello.c)

target_compile_options(non-secure PRIVATE
  --cpu=$<TARGET_PROPERTY:secure,CPU>
  --no_wrap_diagnostics
)

target_include_directories(non-secure PRIVATE
  # TODO 4: Make use of the `secure` include directories
)

target_link_options(non-secure PRIVATE
  --cpu=$<TARGET_PROPERTY:secure,CPU>
  --config ${CMAKE_CURRENT_SOURCE_DIR}/v2m-mps2_ns.icf
  --semihosting
  # TODO 5: Link agains the import library generated from the `secure` target
  # TODO 6: Specify "no entry point" for the `non-secure` target
)
