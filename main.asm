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
	ld hl, $9000 ; VRAM location of Tilesets
	ld de, FontTiles
	ld bc, FontTilesEnd - FontTiles
	call Memcpy

	; Write Hello World to the top left of the screen
	ld hl, $9800 ; VRAM location of the top left part of the screen
	ld de, HelloWorldStr
	call StrCpy

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

	; Lock loop
.lock
	jr .lock


	; --- Memcpy ---
	; @param hl ; address to copy to ; return address after data copy
	; @param de ; address to copy from ; return address after data copy
	; @param bc ; byte size of data to copy ; return 0
	; @flags ; a = 0 ; C const ; H unk ; N- ; Z set
Memcpy:
	ld a, [de]
	ld [hli], a ; hli increments hl after use
	inc de
	dec bc
	ld a, b
	or c
	jr nz, Memcpy
	ret
	; --- End Memcpy ---


	; --- StrCpy ---
	; @param hl ; address to copy to ; return address after data copy
	; @param de ; address to copy from ; return address after data copy
	; @flags ; a = 0 ; C const ; H unk ; N+ ; Z set
StrCpy:
	ld a, [de]
	ld [hli], a
	inc de
	and a ; test if zero
	jr nz, StrCpy
	ret
	; --- End StrCpy ---


SECTION "FONT", ROM0

FontTiles:
INCBIN "font.chr"
FontTilesEnd:

SECTION "Hello String", ROM0

HelloWorldStr:
	db "Hello World!", 0