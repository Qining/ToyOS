C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
OBJS = ${C_SOURCES:.c=.o}

CC = gcc -std=c99 -m32 -march=i386
GDB = gdb

CFLAGS = -g

all: os-image.bin kernel_whole.elf

os-image.bin: boot/bootsect.bin kernel_whole.bin
	cat $^ > $@

kernel_whole.bin: boot/kernel_entry.o ${OBJS}
	# Note the value 0x1000 used in the tutorial!
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

kernel_whole.elf: boot/kernel_entry.o ${OBJS}
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^

# Generic compilations rules
%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} -ffreestanding -c $< -o $@

%.o: %.nasm
	nasm $< -f elf -o $@

%.bin: %.nasm
	nasm $< -f bin -o $@

debug: os-image.bin kernel_whole.elf
	qemu -s -fda os-image.bin &
	gdb -ex "target remote localhost:1234" -ex "symbol-file kernel_whole.elf"

clean:
	rm *.bin
	rm *.elf
	rm kernel/*.o
	rm boot/*.bin
	rm boot/*.o
	rm drivers/*.o
	rm *.dis
