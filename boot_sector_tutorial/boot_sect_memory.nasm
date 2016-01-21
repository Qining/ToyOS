; Try to print the "X" in four ways, actually not all of them will work.

mov ah, 0x0e
mov al, '1'
int 0x10

mov ah, 0x0e
mov al, the_secret
int 0x10

mov ah, 0x0e
mov al, '2'
int 0x10

mov ah, 0x0e
mov al, [the_secret]
int 0x10

mov ah, 0x0e
mov al, '3'
int 0x10

mov ah, 0x0e
mov al, the_secret + 0x7c00
int 0x10

mov ah, 0x0e
mov al, '4'
int 0x10

mov ah, 0x0e
mov al, the_secret + 0x2d
int 0x10

mov ah, 0x0e
mov al, '5'
int 0x10

mov ah, 0x0e
mov al, [the_secret + 0x7c00]
int 0x10

the_secret:
	db "X"

jmp $

times 510-($-$$) db 0
dw 0xaa55
