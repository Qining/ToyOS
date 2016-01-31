[bits 16] ; (?)

switch_to_pm:
    cli ; disable interrupts
    lgdt [gdt_descriptor] ; lgdt accepts an address to find
                          ; gdt descriptor
    mov eax, cr0 ; get cr0 content
    or eax, 0x1 ; set bit 0 to 'protected mode'
    mov cr0, eax ; set to cr0
    jmp CODE_SEG:init_pm ; far jump by using a different segment (?)
                         ; this automatically update CS reg (?)

[bits 32]
init_pm: ; now in protected mode
    mov ax, DATA_SEG ; update the seg registers.
                     ; we update all seg reg except code seg reg
                     ; to data segment.
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000 ; let's assume our stack will be here (?)
    mov esp, ebp

    call BEGIN_PM ; call main function of protected mode, maybe
                  ; our kernel.
