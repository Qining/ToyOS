; print the word (two bytes) value held in REG: dx.

print_hex:
	pusha

	mov cx, 0

hex_loop:
	cmp cx, 4
	je hex_loop_end

	; fall through to print one 'byte' in reg dx
	mov ax, dx
	and ax, 0xf
	add al, 0x30 ; '0' == 0x30, note al is part of ax
	cmp al, 0x39
	jle put_to_buf
	; fall through for A~F
	; e.g 0xa -> dec10, we add it with 0x30(dec48) -> dec58
	; 'A' == dec65, so we need to add another dec7
	add al, 7

	; then we put the ascii char to our buffer
put_to_buf:
	mov bx, HEX_TEMP_BUFF + 5
	sub bx, cx
	mov [bx], al
	ror dx, 4 ; right rotate (different with right shift.)

	; increment
	add cx, 1
	jmp hex_loop

hex_loop_end:
	mov bx, HEX_TEMP_BUFF
	call print ; defined in boot_sect_print.nasm
	popa
	ret

HEX_TEMP_BUFF:
	db '0x0000', 0 ; we call 'print' on this string. note this string is 6 bytes long.
