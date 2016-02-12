; this assembly file is to write GDT data.
gdt_start:
    ; the GDT starts with a null 8-byte
    dd 0x0 ; write double word: 4 byte
    dd 0x0 ; another double word

; The GDT entry for code segment
gdt_code:
    dw 0xffff ; segment length: bits 0-15
    dw 0x0 ; segment base: bits 0-15
    db 0x0 ; segment base: bits 16-23
    db 10011010b ; access byte (8 bits)
    db 11001111b ; flags (4 bits) + segment length: bits 16-19
    db 0x0 ; segment base: bits 24-31

; The GDT entry for data segment
gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

; label the end of our gdt data block(this is an address)
gdt_end:

; GDT descriptor, this is the content we need to tell
; CPU:" hey, the GDT is here", CPU needs 1) size of the
; GDT, and 2) base address of GDT.
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; get the size, we need to minus 1
                               ; as this is the demand from Intel.
    dd gdt_start ; base address

; define some constants
; generally the offset of each entry from the base.
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

