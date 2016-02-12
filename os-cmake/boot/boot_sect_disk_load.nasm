; TODO: make it comply with C calling convention.
; define disk_load subrountine here

disk_load:
	pusha

	; we need to store our 'parameter' value to stack for later use...
	; c calling convention can fix this ugly push...
	push dx

	; prepare for disk reading. we will be using int 0x13 to read the disk.
	mov ah, 0x02 ; 0x02 == read
	mov al, dh ; how many sectors to read
	mov cl, 0x02 ; which sector to start? 0x01 is our boot sector (Note, not 0x00!)
				 ; start at 0x02 then.
	mov ch, 0x00 ; ch <- cylinder
				 ; actually the higher 10bits of cx is used for cylinder/head...
				 ; and it is weird, seems like the 2bits in cl is the higher bits,
				 ; while the 8bits in ch is the lower bits....(?)
	mov dh, 0x00 ; dh <- head number
	; dl is set to drive number by our caller(actually BIOS).

	; copy to the address pointed by [ES:BX], here, we set this in the caller(i.e. main)
	int 0x13 ; if error, carry bit will be set.
			 ; on return, ah holds status, al holds num of sectors read.
	jc disk_error

	; if no disk error
	pop dx ; now, let's get our parameter
	cmp al, dh ; check the number of sectors read with the our expect
	jne sectors_error ; jump if not equal

	popa
	ret

disk_error:
	mov bx, DISK_ERROR
	call print
	call print_nl
	mov dh, ah ; ah has error code, dl has the disk drive that dropped the error.
			   ; we want to print dx in hex, so we can see the [error code][error drive].
	call print_hex
	jmp disk_load_trapping_loop

sectors_error:
	mov bx, SECTORS_ERROR
	call print
	call print_nl
	; fall through to disk_load_trapping_loop

disk_load_trapping_loop:
	jmp $

; error msg strings
DISK_ERROR:
	db "Disk read error", 0

SECTORS_ERROR:
	db "Incorrect number of sectors read", 0
