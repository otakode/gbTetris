
SECTION "Game", ROM0


	; --- Splash ---
Splash:
	WAIT_FRAMES 15
	ld a, %00001000
	ld [rBGP], a
	WAIT_FRAMES 3
	ld a, %00000100
	ld [rBGP], a
	WAIT_FRAMES 3
	ld a, %00000000
	ld [rBGP], a

	WAIT_FRAMES 15

	; Turn off LCD
	xor a ; ld a, 0
	ld [rLCDC], a

	; Set OtakodeLogo TileSet
	ld hl, _VRAM
	ld de, OtakodeLogoTileSet
	ld bc, OtakodeLogoTileSetEnd - OtakodeLogoTileSet
	call Memcpy

	; Set OtakodeLogo TileMap
	ld hl, _SCRN0
	ld de, OtakodeLogoTileMap
	ld bc, 20 << 8 | 18 ; same as both `ld b, 20` and `ld c, 18`
	call TileMapCopy

	ld a, %01000000
	ld [rBGP], a

	; Turn on LCD
	ld a, LCDCF_ON | LCDCF_WIN9800 | LCDCF_WINOFF | LCDCF_BG8000 | LCDCF_BG9800 | LCDCF_OBJ8 | LCDCF_OBJOFF | LCDCF_BGON
	ld [rLCDC], a

	WAIT_FRAMES 3
	ld a, %10010000
	ld [rBGP], a
	WAIT_FRAMES 3
	ld a, %11100100
	ld [rBGP], a

	WAIT_FRAMES 120

	ld a, %10010000
	ld [rBGP], a
	WAIT_FRAMES 3
	ld a, %01000000
	ld [rBGP], a
	WAIT_FRAMES 3
	ld a, %00000000
	ld [rBGP], a

	WAIT_FRAMES 15

	ret
	; --- End Splash ---


	; --- Init ---
Init:
	WAIT_VBLANK

	; Turn off LCD
	xor a ; ld a, 0
	ld [rLCDC], a

	; Init memory variables
	ld [wTimerIECounter], a
	ld [wTimeSec], a
	ld [wTimeSec + 1], a

	; Set Font TileSet
	ld hl, _VRAM
	ld de, FontTileSet
	ld bc, FontTileSetEnd - FontTileSet
	call Memcpy

	; Set GameBoy TileSet
	ld hl, _VRAM
	ld de, GameBoyTileSet
	ld bc, GameBoyTileSetEnd - GameBoyTileSet
	call Memcpy

	; Set GameBoy TileMap
	ld hl, _SCRN0
	ld de, GameBoyTileMap
	ld bc, 20 << 8 | 18 ; same as both `ld b, 20` and `ld c, 18`
	call TileMapCopy

	call InitGameBoyObjects

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

	call CopyDMARoutine
	call ProcessVBlank ; first frame to init OAM

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


	; --- InitGameBoyObjects ---
InitGameBoyObjects:
	SET_SPRITE wDPadDown,     12*8, 6*8,  4, 0
	SET_SPRITE wDPadUp,       10*8, 6*8,  1, 0
	SET_SPRITE wDPadLeft,     11*8, 5*8,  2, 0
	SET_SPRITE wDPadRight,    11*8, 7*8,  3, 0
	SET_SPRITE wButtonStart,  15*8, 10*8, 7, 0
	SET_SPRITE wButtonSelect, 15*8, 8*8,  7, 0
	SET_SPRITE wButtonB,      12*8, 12*8, 6, 0
	SET_SPRITE wButtonA,      11*8, 14*8, 6, 0
	ld hl, wObjectsEnd
	ld bc, wShadowOAMEnd - wObjectsEnd
	call Memzero
	ret
	; --- End InitGameBoyObjects ---


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
	ld [wInputState], a

	ret
	; --- End CheckInput ---


	; --- UpdateObjects ---
UPDATE_BUTTON: MACRO
	ld a, [wInputState]
	and \1
	ld a, \4
	jr z, .then\@
	\3 a
.then\@
	ld [\2], a
ENDM

UpdateObjects:
	UPDATE_BUTTON PADF_DOWN,   wDPadDown.y,     dec, (12*8+16)
	UPDATE_BUTTON PADF_UP,     wDPadUp.y,       inc, (10*8+16)
	UPDATE_BUTTON PADF_LEFT,   wDPadLeft.x,     inc, (5*8+8)
	UPDATE_BUTTON PADF_RIGHT,  wDPadRight.x,    dec, (7*8+8)
	UPDATE_BUTTON PADF_START,  wButtonStart.y,  inc, (15*8+16)
	UPDATE_BUTTON PADF_SELECT, wButtonSelect.y, inc, (15*8+16)
	UPDATE_BUTTON PADF_B,      wButtonB.y,      inc, (12*8+16)
	UPDATE_BUTTON PADF_A,      wButtonA.y,      inc, (11*8+16)
	ret
	; --- End UpdateObjects ---
