cmake_minimum_required(VERSION 2.8.12)
# enable_testing()

message("ToyOS: Build type is: \"${CMAKE_BUILD_TYPE}\".")

include(cmake/utils.cmake)

project(ToyOS)

include_directories(${ToyOS_SOURCE_DIR}/include)

add_subdirectory(boot)
add_subdirectory(drivers)
add_subdirectory(kernel)


add_custom_command(OUTPUT kernel_bin
  COMMAND ld -m elf_i386 -o kernel_bin -Ttext 0x1000
  ${boot_BINARY_DIR}/kernel_entry.elf
  ${kernel_BINARY_DIR}/kernel.o
  ${drivers_BINARY_DIR}/drivers.o
  --oformat binary
  DEPENDS kernel_entry kernel drivers
)

add_custom_command(OUTPUT kernel_elf
  COMMAND ld -m elf_i386 -o kernel_elf -Ttext 0x1000
  ${boot_BINARY_DIR}/kernel_entry.elf
  ${kernel_BINARY_DIR}/kernel.o
  ${drivers_BINARY_DIR}/drivers.o
  DEPENDS kernel_entry kernel drivers
)

add_custom_command(OUTPUT ToyOS-image.bin
  COMMAND cat ${boot_BINARY_DIR}/bootsect.bin
  kernel_bin
  ">" ToyOS-image.bin
  DEPENDS bootsect kernel_bin kernel_elf
)

add_custom_target(ToyOS-image ALL DEPENDS ToyOS-image.bin)
