
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

	; Set Font TileSet
	ld hl, _VRAM
	ld de, FontTiles
	ld bc, FontTilesEnd - FontTiles
	call Memcpy

	; Set GameBoy TileSet
	ld hl, _VRAM
	ld de, GameBoyTileSet
	ld bc, GameBoyTileSetEnd - GameBoyTileSet
	call Memcpy

	; Set GameBoy TileMap
	ld hl, _SCRN0
	ld de, GameBoyTileMap
	ld b, 20
	ld c, 18
	call TileMapCopy

	call CreateGameBoyObjects

	; Init display registers
	ld a, %11100100 ; 11 10 01 00 simple dark to light color palette
	ld [rBGP], a
	ld [rOBP0], a
	ld [rOBP1], a

	; Set Screen position to 0,0
	xor a ; ld a, 0
	ld [rSCY], a
	ld [rSCX], a

	; No sound
	ld [rNR52], a

	; Turn screen on, display background
	ld a, LCDCF_ON | LCDCF_WIN9800 | LCDCF_WINOFF | LCDCF_BG8000 | LCDCF_BG9800 | LCDCF_OBJ8 | LCDCF_OBJON | LCDCF_BGON
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


	; --- CreateGameBoyObjects ---
CreateGameBoyObjects:
	SET_SPRITE wDPadUp, 10*8+16, 6*8+8, 1, 0
	SET_SPRITE wDPadDown, 12*8+16, 6*8+8, 4, 0
	SET_SPRITE wDPadLeft, 11*8+16, 5*8+8, 2, 0
	SET_SPRITE wDPadRight, 11*8+16, 7*8+8, 3, 0
	SET_SPRITE wButtonA, 11*8+16, 14*8+8, 6, 0
	SET_SPRITE wButtonB, 12*8+16, 12*8+8, 6, 0
	SET_SPRITE wButtonStart, 15*8+16, 10*8+8, 7, 0
	SET_SPRITE wButtonSelect, 15*8+16, 8*8+8, 7, 0
	ld hl, _OAMRAM
	ld de, wObjects
	ld bc, wObjectsEnd - wObjects
	call Memcpy
	ld bc, $A0 - (wObjectsEnd - wObjects)
	call Memzero
	ret
	; --- End CreateGameBoyObjects ---
