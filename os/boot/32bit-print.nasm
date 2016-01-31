; to use 32-bit protected mode
[bits 32]

; define constants (?)
VIDEO_MEMORY_BASE equ 0xb8000
WHITE_ON_BLACK equ 0x0f ; the color byte for each char

; TODO: replace with C calling convention
print_string_pm:
    pusha
    mov edx, VIDEO_MEMORY_BASE
    ; we should fall through to a print loop

print_string_pm_loop:
    mov al, [ebx] ; still, we want ebx holds the address
                  ; (what about seg reg?)
    mov ah, WHITE_ON_BLACK ; set color
    cmp al, 0 ; is this '\0'?
    je print_string_pm_done
    ; fall through to print
    mov [edx], ax ; remember that we have edx points
                  ; to the video memory base.
    add ebx, 1 ; incremental for char
    add edx, 2 ; incremental for memory

    jmp print_string_pm_loop ; next iteration

print_string_pm_done:
    popa
    ret
