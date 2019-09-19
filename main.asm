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

	; Set Font Tileset
	ld hl, _VRAM + $1000 ; BG Character Data is after Object Character Data
	ld de, FontTiles
	ld bc, FontTilesEnd - FontTiles
	call Memcpy

	; Write Hello World to Screen0
	ld hl, _SCRN0
	ld de, HelloWorldStr
	call StrCpy

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

Main:
	; Game processing
	call Game
.waitVBlank
	; Set the VBlank Interrupt
	ld b, IEF_VBLANK
	call AddIEFlag

	; Halt until next interrupt
	Halt
	nop ; required after a halt

	jr Main

INCLUDE "game.asm"

INCLUDE "tools.asm"

SECTION "FONT", ROM0

FontTiles:
INCBIN "font.chr"
FontTilesEnd:

SECTION "Hello String", ROM0

HelloWorldStr:
	db "Hello World!", 0