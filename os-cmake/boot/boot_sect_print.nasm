; TODO: adopt C calling convention for these subrountines.
; and this will need a stack.

; label print, which is a name of our subrountine: print
; register bx holds the address of the string we want to print.
print:
	pusha

	; while (string[i] != 0) {print string[i]; i++}
start:
	mov al, [bx]
	cmp al, 0
	je done

	; fall through
	mov ah, 0x0e
	int 0x10
	add bx, 1
	jmp start

done:
	popa
	ret

; another subrountine: print new line: print_nl
print_nl:
	pusha

	; we need \n AND \r
	mov ah, 0x0e
	mov al, 0x0a ; ascii for \n
	int 0x10
	mov al, 0x0d ; ascii for \r
	int 0x10

	popa
	ret
