# Really should review a little bit about Makefile

all: os-image.bin

os-image.bin: bootsect.bin kernel_whole.bin
	cat $^ > $@

kernel_whole.bin: kernel_entry.o kernel.o
	# The offset should be 0x8c00=0x7c00+0x1000(the kernel address)
	# The value 0x1000 used in the tutorial might be wrong!
	ld -m elf_i386 -o $@ -Ttext 0x8c00 $^ --oformat binary

kernel.o: kernel.c
	gcc -std=c99 -m32 -march=i386 -ffreestanding -c $^ -o $@

kernel_entry.o: kernel_entry.nasm
	nasm $^ -f elf -o $@

bootsect.bin: bootsect.nasm
	nasm -fbin $^ -o $@

clean:
	rm *.bin *.o *.dis
