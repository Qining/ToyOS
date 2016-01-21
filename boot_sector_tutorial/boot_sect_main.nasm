[org 0x7c00] ; the address to which BIOS copies the mbr sector data, and run.

mov bx, HELLO
call print

; print new line
call print_nl

mov dx, 0x12fe
call print_hex

jmp $

; we need to include the subroutines below, as the EIP start at 0x7c00, and we
; don't want it starts at our subrountines. So 'main' goes first.
%include "boot_sect_print.nasm"
%include "boot_sect_print_hex.nasm"

; data
HELLO:
	db 'Hello, world - ToyOS', 0

GOODBYE:
	db 'Goodbye - ToyOS', 0

; padding
times 510-($-$$) db 0
dw 0xaa55
