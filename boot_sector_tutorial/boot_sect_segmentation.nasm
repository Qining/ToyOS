; first, set tty mode
mov ah, 0x0e

mov al, [the_secret]
int 0x10 ; This won't work, as there is an offset 0x7c00 when copied to memory.

mov bx, 0x7c0 ; 1) there is left shift following, 2) we have to use reg to copy value to ES/CS/DS/SS
mov ds, bx

; from now on, all memory reference to data will be offset by 'ds'.

mov al, [the_secret]
int 0x10 ; this should work

; another way to do this.
mov bx, 0x7c0
mov es, bx
mov al, [es:the_secret]
int 0x10

; it seems that there is a complex protocol about when a seg regiter
; will be used implicitly during forming a memory access.

jmp $

the_secret:
	db "X"

times 510-($-$$) db 0
dw 0xaa55
