
add_library(lib)
target_sources(lib PRIVATE src/crc32.c)
target_include_directories(lib PUBLIC inc)
target_compile_options(lib PUBLIC --no_fragments)
