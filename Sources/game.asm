
SECTION "Game", ROM0

	; --- Init ---
Init:
	; Turn off LCD
.waitVBlank
	ld a, [rLY]
	cp SCRN_Y ; are we past VBlank
	jr c, .waitVBlank

	; set rLCDC to 0
	xor a ; ld a, 0
	ld [rLCDC], a

	; Init memory variables
	ld [bTimerIECounter], a
	ld [wTimeSec], a
	ld [wTimeSec + 1], a

	; Set GameBoy TileSet
	ld hl, _VRAM + $800 ; BG Character Data is after Object Character Data
	ld de, GameBoyTileSet
	ld bc, GameBoyTileSetEnd - GameBoyTileSet
	call Memcpy

	; Set Font TileSet
	ld hl, _VRAM + $1000 ; BG Character Data is after Object Character Data
	ld de, FontTiles
	ld bc, FontTilesEnd - FontTiles
	call Memcpy

	; Set GameBoy TileMap
	ld hl, _SCRN0
	ld de, GameBoyTileMap
	ld b, 20
	ld c, 18
	call TileMapCopy

	; Init display registers
	ld a, %11100100 ; 11 10 01 00 simple dark to light color palette
	ld [rBGP], a

	; Set Screen position to 0,0
	xor a ; ld a, 0
	ld [rSCY], a
	ld [rSCX], a

	; No sound
	ld [rNR52], a

	; Turn screen on, display background
	ld a, LCDCF_ON | LCDCF_BGON
	ld [rLCDC], a

	; set Interrupts
	ld a, IEF_TIMER | IEF_VBLANK
	ld [rIE], a

	; set Timer to 16Hz interruptions (lowest possible)
	; set TMA
	xor a ; ld a, $00 ; overflow at 256th timer frequency
	ld [rTMA], a
	; set TAC
	ld a, TACF_4KHZ
	ld [rTAC], a
	ld a, TACF_START
	ld [rTAC], a

	ei

	ret
	; --- End Init ---


	; --- Game ---
Game:
	call CheckInput
	ret
	; --- End Game ---


	; --- CheckInputs ---
CheckInput:
	ld hl, rP1

	ld [hl], ~P1F_4
REPT 2
	ld a, [hl]
ENDR
	and $0F
	swap a
	ld b, a

	ld [hl], ~P1F_5
REPT 6
	ld a, [hl]
ENDR
	and $0F
	or b
	cpl
	ld [bInputState], a

	ret
	; --- End CheckInput ---
