# Make sure we have C language flag here, so that we can use nasm
# ref: https://metricpanda.com/using-nasm-with-cmake-and-clang
project(boot C CXX)

enable_language(ASM_NASM)

# A useful reference about os code with CMake:
# https://ebitg.wordpress.com/2011/12/29/compiling-os-code-with-cmake/

file(GLOB_RECURSE BOOT_ASM_SOURCES "${CMAKE_CURRENT_SRC_DIR}/*.nasm")

add_library(bootsect STATIC
  bootsect.nasm
  boot_sect_print.nasm
  boot_sect_disk_load.nasm
  boot_sect_print_hex.nasm
  32bit-switch.nasm
  32bit-gdt.nasm
  32bit-print.nasm)
default_nasm_bin_compile_options(bootsect)

add_library(kernel_entry STATIC
  kernel_entry.nasm)
default_nasm_elf_compile_options(kernel_entry)
