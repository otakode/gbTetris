
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

	; Init input variable
	ld [wInputState], a

	; Init memory variables
	ld [wTimerIECounter], a
	ld [wTimeSec], a
	ld [wTimeSec + 1], a

	call InitObjects

	; Set Font TileSet
	ld hl, _VRAM
	ld de, FontTileSet
	ld bc, FontTileSetEnd - FontTileSet
	call Memcpy

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

	TOGGLE_LCD
	; Init game state
	call InitTitle

	call CopyDMARoutine
	ld a, HIGH(wObjects)
	call hOAMDMA

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


	; --- InitObjects ---
InitObjects:
	ld hl, wObjects
	ld bc, wObjectsEnd - wObjects
	call Memzero
	ret
	; --- End InitObjects ---


	; --- Update ---
Update:
	call CheckInput
	ld a, [wUpdateLabel]
	ld l, a
	ld a, [wUpdateLabel + 1]
	ld h, a
	jp hl

	ret ; will never be reached, but just in case
	; --- End Update ---


	; --- CheckInputs ---
CheckInput:
	ld hl, rP1

	; Update wLastInputState
	ld a, [wInputState]
	ld [wLastInputState], a

	; Update wInputState
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

	; Press and Release
	ld b, a
	ld a, [wLastInputState]
	xor b
	ld c, a

	; Update wInputPress
	and b
	ld [wInputPress], a

	; Update wInputRelease
	ld a, b
	cpl
	ld b, a
	ld a, c
	cpl
	and b
	cpl
	ld [wInputRelease], a

	ret
	; --- End CheckInput ---


	; --- InitTitle ---
InitTitle:
	WAIT_VBLANK
	TOGGLE_LCD

	LOAD_ADDRESS wUpdateLabel, UpdateTitle

	; Set Title TileMap
	ld hl, _SCRN0
	ld de, TitleTileMap
	ld bc, 20 << 8 | 18 ; same as both `ld b, 20` and `ld c, 18`
	call TileMapCopy

	SET_SPRITE wObject_00, Y_POS 10, X_POS 6, $7F, $00

	TOGGLE_LCD
	ret
	; --- End UpdateTitle ---


	; --- UpdateTitle ---
UpdateTitle:
	ld a, [wObject_00.y]
	sub Y_POS 10
	jr z, .start
.options
	TEST_INPUT wInputPress, PADF_A, .notOptions
	call InitOptions
	ret
.notOptions
	TEST_INPUT wInputPress, PADF_UP, .afterUp
	ld a, Y_POS 10
	ld [wObject_00.y], a
.afterUp
	ret
.start
	TEST_INPUT wInputPress, PADF_A, .notStart
	; launch Start
	ret
.notStart
	TEST_INPUT wInputPress, PADF_DOWN, .afterDown
	ld a, Y_POS 12
	ld [wObject_00.y], a
.afterDown
	ret
	; --- End UpdateTitle ---


	; --- InitOptions ---
InitOptions:
	WAIT_VBLANK
	TOGGLE_LCD

	LOAD_ADDRESS wUpdateLabel, UpdateOptions

	; Set Options TileMap
	ld hl, _SCRN0
	ld de, OptionsTileMap
	ld bc, 20 << 8 | 18 ; same as both `ld b, 20` and `ld c, 18`
	call TileMapCopy

	SET_SPRITE wObject_00, Y_POS 14, X_POS 7, $7F, $00

	TOGGLE_LCD
	ret
	; --- End InitOptions


	; --- UpdateOptions ---
UpdateOptions:
	ld a, [wObject_00.y]
	cp Y_POS 11
	jr z, .sfx
	cp Y_POS 14
	jr z, .back

.music
	TEST_INPUT wInputPress, PADF_A, .notMusic
	; music adjustment
	ret
.notMusic
	TEST_INPUT wInputPress, PADF_DOWN, .afterMusicDown
	jr .toSfx
.afterMusicDown
	ret
.toMusic
	ld a, Y_POS 6
	ld [wObject_00.y], a
	ld a, X_POS 2
	ld [wObject_00.x], a
	ret

.sfx
	TEST_INPUT wInputPress, PADF_A, .notSfx
	; sfx adjustment
	ret
.notSfx
	TEST_INPUT wInputPress, PADF_DOWN, .afterSfxDown
	jr .toBack
.afterSfxDown
	TEST_INPUT wInputPress, PADF_UP, .afterSfxUp
	jr .toMusic
.afterSfxUp
	ret
.toSfx
	ld a, Y_POS 11
	ld [wObject_00.y], a
	ld a, X_POS 2
	ld [wObject_00.x], a
	ret

.back
	TEST_INPUT wInputPress, PADF_A, .notBack
	call InitTitle
	ret
.notBack
	TEST_INPUT wInputPress, PADF_UP, .afterBackUp
	jr .toSfx
.afterBackUp
	ret
.toBack
	ld a, Y_POS 14
	ld [wObject_00.y], a
	ld a, X_POS 7
	ld [wObject_00.x], a
	ret
	; --- End UpdateOptions ---


	; --- InitGame ---
InitGame:
	LOAD_ADDRESS wUpdateLabel, UpdateGame
	ret
	; --- End InitGame ---


	; --- UpdateGame ---
UpdateGame:
	ret
	; --- End UpdateGame ---


	; --- InitScore ---
InitScore:
	LOAD_ADDRESS wUpdateLabel, UpdateScore
	ret
	; --- End InitScore ---


	; --- UpdateScore ---
UpdateScore:
	ret
	; --- End UpdateScore ---
