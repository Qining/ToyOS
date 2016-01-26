If didn't build cross compiler, you may need to use gcc in 32bit mode
use gcc -m32 -march=i386 to compile:
 gcc -m32 -march=i386 -ffreestanding -c function.c -o function.o

use ld -m elf_i386 to link:
 ld -m elf_i386 -o function.bin -Ttext 0x0 --oformat binary function.o

to examine the disassembly code of the bin:
 ndisasm -b 32 function.bin

objdump can be used for the .o file

you can also use xxd to dump the .bin and .o file. (that is more like hexdump)
