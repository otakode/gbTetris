
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


	; --- CreateGameBoyObjects ---
CreateGameBoyObjects:
	SET_SPRITE DPadDown, 12*8+16, 6*8+8, 4, 0
	SET_SPRITE DPadUp, 10*8+16, 6*8+8, 1, 0
	SET_SPRITE DPadLeft, 11*8+16, 5*8+8, 2, 0
	SET_SPRITE DPadRight, 11*8+16, 7*8+8, 3, 0
	SET_SPRITE ButtonStart, 15*8+16, 10*8+8, 7, 0
	SET_SPRITE ButtonSelect, 15*8+16, 8*8+8, 7, 0
	SET_SPRITE ButtonB, 12*8+16, 12*8+8, 6, 0
	SET_SPRITE ButtonA, 11*8+16, 14*8+8, 6, 0
	ret
	; --- End CreateGameBoyObjects ---


	; --- Game ---
Game:
	call CheckInput
	call UpdateObjects
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


	; --- UpdateObjects ---
UPDATE_BUTTON: MACRO
	ld a, [bInputState]
	and \1
	ld a, \4
	jr z, .then\@
	\3 a
.then\@
	ld hl, \2
	ld [hl], a
ENDM

UpdateObjects:
	UPDATE_BUTTON PADF_DOWN, DPadDown.y, dec, (12*8+16)
	UPDATE_BUTTON PADF_UP, DPadUp.y, inc, (10*8+16)
	UPDATE_BUTTON PADF_LEFT, DPadLeft.x, inc, (5*8+8)
	UPDATE_BUTTON PADF_RIGHT, DPadRight.x, dec, (7*8+8)
	UPDATE_BUTTON PADF_START, ButtonStart.y, inc, (15*8+16)
	UPDATE_BUTTON PADF_SELECT, ButtonSelect.y, inc, (15*8+16)
	UPDATE_BUTTON PADF_B, ButtonB.y, inc, (12*8+16)
	UPDATE_BUTTON PADF_A, ButtonA.y, inc, (11*8+16)
	ret
	; --- End UpdateObjects ---
