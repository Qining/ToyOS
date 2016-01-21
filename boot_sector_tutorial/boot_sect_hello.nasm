; According to wiki: wiki/INT_10H, when AH=0Eh, it is Teletype output
; function to be called. Then AL should hold the character, BH holds
; the Page Number(?), BL holds Color(?).
mov ah, 0x0e
mov al, 'H'
int 0x10

mov ah, 0x0e
mov al, 'e'
int 0x10

mov ah, 0x0e
mov al, 'l'
int 0x10

mov ah, 0x0e
mov al, 'l'
int 0x10

mov ah, 0x0e
mov al, 'o'
int 0x10

mov ah, 0x0e
mov al, ','
int 0x10

mov ah, 0x0e
mov al, 'T'
int 0x10

mov ah, 0x0e
mov al, 'o'
int 0x10

mov ah, 0x0e
mov al, 'y'
int 0x10

mov ah, 0x0e
mov al, 'O'
int 0x10

mov ah, 0x0e
mov al, 'S'
int 0x10

jmp $ ; jump to current address

times 510 - ($-$$) db 0
dw 0xaa55
