INCLUDE "hardware.inc"
INCLUDE "macros.asm"

;INCLUDE "rst.asm"
INCLUDE "interrupts.asm"


SECTION "HEADER", ROM0[$100]


	; --- EntryPoint ---
EntryPoint:
	di
	jp Start
	; --- End EntryPoint ---


REPT $150 - $104
	db 0
ENDR


SECTION "Main", ROM0


	; --- Start ---
Start:
	; Splash screen
	call Splash
	call Init
	; continue to main
	; --- End Start ---


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
