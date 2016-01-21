; Infinite loop (e9 fd ff : the generated binary code, in byte)
loop:
	jmp loop

; Fill with zeros
times 510-($-$$) db 0

; Append the magic number to make it a bootable sector
dw 0xaa55

; The EIP will contain: 0x7c00.
; This is because when the BIOS of a IBM PC compatible machine selects
; a boot device, it will copy the first sector from the device (which may
; be a MBR or any other executable code), into physical memory at memory
; address 0x7c00. That is the reason why EIP points to that address.

; EAX contains 0xaa55, which is the last word in our bootable sector.
; This is probably the sign that it is used for coping our sector to
; memory.

; ESP contains 0x6f2c, don't know why.
; EFL contains 0x0202, don't know why, may be not relevant here.
