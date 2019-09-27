INCLUDE "hardware.inc"
INCLUDE "macros.asm"

SECTION "HEADER", ROM0[$100]

EntryPoint:
	di
	jp Start

REPT $150 - $104
	db 0
ENDR

INCLUDE "interrupts.asm"

SECTION "Main", ROM0

Start:
	call Init

	; --- Main ---
Main:
	; Game processing
	call Game
.waitVBlank
	; Halt until next interrupt
	Halt
	nop ; required after a halt

	ld a, [rIF]
	cp IEF_VBLANK
	jr z, .waitVBlank
	jr Main
	; --- End Main ---

INCLUDE "handlers.asm"

INCLUDE "game.asm"

INCLUDE "tools.asm"

INCLUDE "variables.asm"

INCLUDE "data.asm"
