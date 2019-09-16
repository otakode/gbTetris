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
	cp 144 ; are we past VBlank
	jr c, .waitVBlank

	; set rLCDC to 0
	xor a; ld a, 0; equivalent
	ld [rLCDC], a

	; Set Font Tileset
	ld hl, $9000
	ld bc, FontTiles
	ld de, FontTilesEnd - FontTiles
.copyFont
	ld a, [bc]
	ld [hli], a ; hli increments hl after use
	inc bc
	dec de
	ld a, d
	or c
	jr nz, .copyFont


	ld hl, $9800 ; location of the top left part of the screen
	ld bc, HelloWorldStr
.copyString
	ld a, [bc]
	ld [hli], a
	inc bc
	and a ; test if zero
	jr nz, .copyString

	; Init display registers
	ld a, %11100100
	ld [rBGP], a

	xor a ; ld a, 0
	ld [rSCY], a
	ld [rSCX], a

	; No sound
	ld [rNR52], a

	; Turn screen on, display background
	ld a, %10000001
	ld [rLCDC], a


	; Lock
.lock
	jr .lock


SECTION "FONT", ROM0

FontTiles:
INCBIN "font.chr"
FontTilesEnd:

SECTION "Hello String", ROM0

HelloWorldStr:
	db "Hello World!", 0