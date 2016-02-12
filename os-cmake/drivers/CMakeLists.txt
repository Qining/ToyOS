project(drivers C CXX)

message(STATUS "Build drivers.o")

set(TARGET drivers)

set(SOURCES
  basic_io_ports.c
  basic_screen.c
  )

add_library(${TARGET} STATIC ${SOURCES})
set_target_properties(${TARGET} PROPERTIES PREFIX "")
set_target_properties(${TARGET} PROPERTIES SUFFIX ".o")

default_c_compile_options(${TARGET})
