; This is just an transit station from asm to c

[bits 32] ; we come from protected mode label: BEGIN_PM

[extern main]

call main
jmp $ ; trap here, so the code below BEGIN_PM's call to this entry address,
	  ; which is KERNEL_ADDR, should be unreachable.
