; First, set the global offset
[org 0x7c00]

KERNEL_ADDR equ 0x1000 ; We need to use the same offset when linking!

[bits 16]
boot_to_protected_mode:
	mov [BOOT_DRIVE], dl ; BIOS sets the boot drive value in dl
	mov bp, 0x9000 ; set up a stack to use
	mov sp, bp

	mov bx, MSG_REAL_MODE
	call print
	call print_nl

	call load_kernel ; this is to copy kernel code/data to memory
	call switch_to_pm ; switch to protected mode
	; we will never return back again.

	; not reachable below.
	mov bx, MSG_NOT_REACHABLE
	call print
	call print_nl
	jmp $

load_kernel:
	pusha
	; print status
	mov bx, MSG_LOAD_KERNEL
	call print
	call print_nl

	; copy the kernel block to its address
	mov bx, KERNEL_ADDR
	mov dh, 03 ; this goes to al in disk_load.
			   ; we use it as an arg here.
			   ; This should 1, not 2 as the tutorial says!
			   ; Because we actually have only one sector for our kernel.
			   ; We may need to change this in future as we have larger
			   ; kernel.
	mov dl, [BOOT_DRIVE] ; get the cached boot_drive value.
	call disk_load

	popa
	ret

; We have to add boot/ as working directory here.
; It seems that nasm does not have relative including support.
; As we are calling 'nasm' at the parent directory through Makefile,
; we have to add boot/
%include "boot_sect_print.nasm"
%include "boot_sect_disk_load.nasm"
%include "boot_sect_print_hex.nasm"

[bits 32]
; critical label, switch_to_pm -> init_pm (internally) => BEGIN_PM
BEGIN_PM:
	; print status
	mov ebx, MSG_PROT_MODE
	call print_string_pm

	; Now, we jump to kernel space!
	call KERNEL_ADDR

	; not reachable below.
	mov ebx, MSG_NOT_REACHABLE
	call print_string_pm
	jmp $


%include "32bit-switch.nasm"
; 32bit-switch.nasm doesn't include gdt, so we need to include it here.
%include "32bit-gdt.nasm"
%include "32bit-print.nasm"


BOOT_DRIVE:
	db 0 ; just a static data to store boot drive value

MSG_REAL_MODE:
	db "ToyOS: <boot>: In Real Mode", 0

MSG_PROT_MODE:
	db "ToyOS: <boot>: In Protected Mode", 0

MSG_LOAD_KERNEL:
	db "ToyOS: <boot>: Loading kernel", 0

MSG_NOT_REACHABLE:
	db "ToyOS: <boot>: Unreachable location, Error!", 0

; padding and magic number
; we nearly run out of space in this sector actually!
times 510 - ($-$$) db 0
dw 0xaa55
