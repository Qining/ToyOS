[org 0x7c00] ; bootloader offset

mov bp, 0x8000 ; setup a stack (let's keep everything in one seg)
mov sp, bp

mov bx, MSG_REAL_MODE
call print

call switch_to_pm
jmp $ ; This should not ever be executed!

; we need to put real mode print before 32 bit subrountes!
; otherwise the generated code will be for 32 bit mode, and
; I guess, the decoded instruction will be wrong.
; In this case, it will keep printing 'S', and ebx's value
; will be very small.
%include "../boot_sector_tutorial/boot_sect_print.nasm"
; If you want to place 16 bit print after those 32 bit code,
; you need to add [bits 16] at the top of 16 bit print code.

; And, 32bit-gdt.nasm can be put before 16 bit print, as it
; is purely static data.

; In one word, don't put 32 bit print and switch code before
; 16 bit print code!

%include "32bit-print.nasm"
%include "32bit-gdt.nasm"
%include "32bit-switch.nasm"

[bits 32]
BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_string_pm
    jmp $

MSG_REAL_MODE:
    db "ToyOS: Started in 16-bit real mode", 0

MSG_PROT_MODE:
    db "ToyOS: Loaded 32-bit protected mode", 0

times 510-($-$$) db 0
dw 0xaa55
