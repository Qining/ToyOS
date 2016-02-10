project(kernel C CXX)

set(TARGET kernel)

set(SRC
  kernel.c
  )

add_library(${TARGET} STATIC ${SRC})

default_c_compile_options(${TARGET})
