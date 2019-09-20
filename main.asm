INCLUDE "hardware.inc"

SECTION "HEADER", ROM0[$100]

EntryPoint:
	di
	jp Start

REPT $150 - $104
	db 0
ENDR

SECTION "Game Code", ROM0

Start:
	; Turn off LCD
.waitVBlank
	ld a, [rLY]
	cp SCRN_Y ; are we past VBlank
	jr c, .waitVBlank

	; set rLCDC to 0
	xor a; ld a, 0
	ld [rLCDC], a

	call Init

	; Init display registers
	ld a, %11100100 ; 11 10 01 00 simple dark to light color palette
	ld [rBGP], a

	xor a ; ld a, 0
	ld [rSCY], a
	ld [rSCX], a

	; No sound
	ld [rNR52], a

	; Turn screen on, display background
	ld a, LCDCF_ON | LCDCF_BGON
	ld [rLCDC], a

	; --- Main ---
Main:
	; Game processing
	call Game
.waitVBlank
	; Halt until next interrupt
	Halt
	nop ; required after a halt

	jr Main
	; --- End Main ---

INCLUDE "game.asm"

INCLUDE "tools.asm"

SECTION "FONT", ROM0

FontTiles:
INCBIN "font.chr"
FontTilesEnd:

SECTION "Hello String", ROM0

HelloWorldStr:
	db "Hello World!", 0