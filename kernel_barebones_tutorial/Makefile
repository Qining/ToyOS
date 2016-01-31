# Really should review a little bit about Makefile

all: os-image.bin kernel_whole.elf

os-image.bin: bootsect.bin kernel_whole.bin
	cat $^ > $@

kernel_whole.bin: kernel_entry.o kernel.o
	# Note the value 0x1000 used in the tutorial!
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

kernel_whole.elf: kernel_entry.o kernel.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^

kernel.o: kernel.c
	gcc -std=c99 -m32 -march=i386 -ffreestanding -g -c $^ -o $@

kernel_entry.o: kernel_entry.nasm
	nasm $^ -f elf -o $@

bootsect.bin: bootsect.nasm
	nasm -fbin $^ -o $@

clean:
	rm *.bin *.o *.dis

debug: os-image.bin kernel_whole.elf
	qemu -s -fda os-image.bin &
	gdb -ex "target remote localhost:1234" -ex "symbol-file kernel_whole.elf"
