
SECTION "Interrupts", ROM0[$0040]

VBlankInterrupt:
	push af ; 1 byte
	ld a, HIGH(wObjects) ; 2 bytes
	call hOAMDMA ; 3 bytes
	pop af ; 1 byte
	reti ; 1 byte

LCDStatInterrupt:
	reti ; 1 byte

	; nop for alignment
	nop
	nop
	nop
	nop
	nop
	nop
	nop

TimerInterrupt:
	push af ; 1 byte
	call ProcessTimer ; 3 bytes
	pop af ; 1 byte
	reti ; 1 byte

	; nop for alignment
	nop
	nop

SerialInterrupt:
	reti ; 1 byte

	; nop for alignment
	nop
	nop
	nop
	nop
	nop
	nop
	nop

JoypadInterrupt:
	reti ; 1 byte

	; Last interrupt, no need to align
