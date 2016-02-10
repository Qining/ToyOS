cmake_minimum_required(VERSION 2.8.12)
# enable_testing()

message(STATUS "ToyOS: Build type is: \"${CMAKE_BUILD_TYPE}\".")

include(cmake/utils.cmake)

project(ToyOS)

include_directories(${ToyOS_SOURCE_DIR}/include)

add_subdirectory(src)

add_custom_command(OUTPUT 

add_custom_command(OUTPUT ToyOS-image
  COMMAND cat "${boot_BINARY_DIR}/bootsect.bin"
  "${CMAKE_CURRENT_BINARY_DIR}/kernel.bin"
  "> ${CMAKE_CURRENT_BINARY_DIR}/ToyOS-image.bin"
  DEPENDS bootsect kernel_bin
)

