project(drivers C CXX)

set(TARGET drivers)

set(SRC
  basic_io_ports.c
  basic_screen.c
  )

add_library(${TARGET} STATIC ${SRC})

default_c_compile_options(${TARGET})
