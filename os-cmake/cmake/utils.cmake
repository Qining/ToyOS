function(default_c_compile_options TARGET)
  target_compile_options(${TARGET} PRIVATE
    -std=c99 -m32 -march=i386 -ffreestanding -g
    -fno-exceptions -nostdlib -nostdinc -fno-stack-protector)
endfunction(default_c_compile_options)

function(default_cpp_compile_options TARGET)
  target_compile_options(${TARGET} PRIVATE
    -m32 -std=c++11 -march=i386 -ffreestanding -g
    -fno-rtti -fno-exceptions -nostdlib -nostdinc
    -fno-stack-protector)
endfunction(default_cpp_compile_options)

function(default_nasm_elf_options TARGET)
  target_compile_options(${TARGET} PRIVATE
    -f elf)
  set_target_properties(${TARGET} PROPERTIES SUFFIX ".elf")
  set_target_properties(${TARGET} PROPERTIES PREFIX "")
endfunction(default_nasm_elf_options)

function(default_nasm_bin_options TARGET)
  target_compile_options(${TARGET} PRIVATE
    -f bin)
  set_target_properties(${TARGET} PROPERTIES SUFFIX ".bin")
  set_target_properties(${TARGET} PROPERTIES PREFIX "")
endfunction(default_nasm_bin_options)
