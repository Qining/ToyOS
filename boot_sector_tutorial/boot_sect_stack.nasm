mov ah, 0x0e ; teletype mode

mov bp, 0x8000 ; we assume the bottom (highest address) of our stack is here.
mov sp, bp ; the initial sp is set to be equal to bp.

; push characters.
push 'T'
push 'o'
push 'y'
push 'O'
push 'S'

pop bx ; we can only pop to 16bit (or 32bit/64bit) registers, not 8bit ones.
mov al, bl
int 0x10

pop bx
mov al, bl
int 0x10

pop bx
mov al, bl
int 0x10

pop bx
mov al, bl
int 0x10

pop bx
mov al, bl
int 0x10

jmp $
times 510-($-$$) db 0
dw 0xaa55
