
SECTION "Interrupts", ROM0[$0040]

VBlankInterrupt:
	call ProcessVBlank ; 3 bytes instruction
	reti ; 1 byte instruction

	; nop for alignment
	nop
	nop
	nop
	nop

LCDStatInterrupt:
	reti ; 1 byte instruction

	; nop for alignment
	nop
	nop
	nop
	nop
	nop
	nop
	nop

TimerInterrupt:
	call ProcessTimer ; 3 bytes instruction
	reti ; 1 byte instruction

	; nop for alignment
	nop
	nop
	nop
	nop

SerialInterrupt:
	reti ; 1 byte instruction

	; nop for alignment
	nop
	nop
	nop
	nop
	nop
	nop
	nop

JoypadInterrupt:
	reti ; 1 byte instruction

	; Last interrupt, no need to align
