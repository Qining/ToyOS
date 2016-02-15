# Make sure we have C language flag here, so that we can use nasm
# ref: https://metricpanda.com/using-nasm-with-cmake-and-clang
project(boot C CXX)

message("Build bootsect.bin and kernel_entry.o")

enable_language(ASM_NASM)

# Have to handle include path manually.
# nasm require the include directory ends with '/'!
# but cmake always strip that '/' and will cause 'can not found include file'
# error!
set(ASM_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/")
set(CMAKE_ASM_NASM_COMPILE_OBJECT
  "<CMAKE_ASM_NASM_COMPILER> <FLAGS> -I${ASM_INCLUDE_DIR} -o <OBJECT> <SOURCE>")

# A useful reference about os code with CMake:
# https://ebitg.wordpress.com/2011/12/29/compiling-os-code-with-cmake/

file(GLOB BOOT_ASM_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/*.nasm")

# Still, we can not use add_library for our code, because we need to let cmake
# knows we have dependencies on many files, instead of only bootsect.nasm.
add_custom_command(OUTPUT bootsect.bin
  COMMAND nasm -f bin -i${ASM_INCLUDE_DIR}
  -o "${CMAKE_CURRENT_BINARY_DIR}/bootsect.bin"
  "${CMAKE_CURRENT_SOURCE_DIR}/bootsect.nasm"
  DEPENDS ${BOOT_ASM_SOURCES}
  )

add_custom_target(bootsect ALL DEPENDS bootsect.bin)

# static library doesn't work even for kernel_entry.elf.
# This might be relevant to the linking map. Once we have it 'compiled' as a
# static library, we sort of lost the controll to fix its location in the
# generated binary, so that our 'jump to kernel' may fail.

add_custom_command(OUTPUT kernel_entry.elf
  COMMAND nasm -f elf -i${ASM_INCLUDE_DIR}
  -o "${CMAKE_CURRENT_BINARY_DIR}/kernel_entry.elf"
  "${CMAKE_CURRENT_SOURCE_DIR}/kernel_entry.nasm"
  DEPENDS kernel_entry.nasm)

add_custom_target(kernel_entry ALL DEPENDS kernel_entry.elf)
