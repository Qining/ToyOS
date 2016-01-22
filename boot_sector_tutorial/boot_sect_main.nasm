[org 0x7c00] ; the address to which BIOS copies the mbr sector data, and run.

; set the stack to be far enough from our code and static data
mov bp, 0x8000
mov sp, bp

mov bx, 0x9000 ; this is address to where we copy, actually [ES:BX] is the address.
mov dh, 2 ; read 5 sectors (?), this value actually goes to al when we int 0x13
; the bios will set dl for us, which is the drive number.

; seems like dx is ready, call disk_load, keep in mind that dx the our arg
call disk_load

mov bx, HELLO
call print

; print new line
call print_nl

mov dx, 0x1234
call print_hex

; have a look about the data copied to memory
mov bx, FIRST_COPIED_WORD
call print
call print_nl
mov dx, [0x9000]
call print_hex
call print_nl

; check the first word in the next sector (we copied 5...)A
mov bx, FIRST_WORD_SECTOR_3
call print
call print_nl
mov dx, [0x9000 + 512]
call print_hex
call print_nl

; trapping
jmp $

; we need to include the subroutines below, as the EIP start at 0x7c00, and we
; don't want it starts at our subrountines. So 'main' goes first.
%include "boot_sect_print.nasm"
%include "boot_sect_print_hex.nasm"
%include "boot_sect_disk_load.nasm"

; data
HELLO:
	db 'Hello, world - ToyOS', 0

GOODBYE:
	db 'Goodbye - ToyOS', 0

FIRST_COPIED_WORD:
	db 'Here is the first copied word (two bytes): ', 0

FIRST_WORD_SECTOR_3:
	db 'Here is the first word in sector 3: ', 0

; padding
times 510-($-$$) db 0
dw 0xaa55

; Now, let's make some disk data to copy with
times 256 dw 0xdada ; content in the sector 2
times 256 dw 0xabab ; content in the sector 3
