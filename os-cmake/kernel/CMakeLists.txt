project(kernel C CXX)

message(STATUS "Build kernel.o")

set(TARGET kernel)

set(SOURCES
  kernel.c
  )

add_library(${TARGET} STATIC ${SOURCES})
set_target_properties(${TARGET} PROPERTIES PREFIX "")
set_target_properties(${TARGET} PROPERTIES SUFFIX ".o")

default_c_compile_options(${TARGET})
