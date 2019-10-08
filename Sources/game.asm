
SECTION "Game", ROM0


	; --- Splash ---
Splash:
	WAIT_VBLANK

	; Init OAM
	call InitObjects
	call CopyDMARoutine
	ld a, HIGH(wObjects)
	call hOAMDMA

	SET_FLAG rIE, IEF_VBLANK
	ei

	HALT_FRAMES 15
	SET_FLAG rBGP, %00001000
	HALT_FRAMES 3
	SET_FLAG rBGP, %00000100
	HALT_FRAMES 3
	SET_FLAG rBGP, %00000000

	HALT_FRAMES 15

	SET_FLAG rLCDC, LCDCF_OFF

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

	SET_FLAG rBGP, %01000000

	SET_FLAG rLCDC, LCDCF_ON | LCDCF_BG8000 | LCDCF_BG9800 | LCDCF_BGON

	HALT_FRAMES 3
	SET_FLAG rBGP, %10010000
	HALT_FRAMES 3
	SET_FLAG rBGP, %11100100

	HALT_FRAMES 120

	SET_FLAG rBGP, %10010000
	HALT_FRAMES 3
	SET_FLAG rBGP, %01000000
	HALT_FRAMES 3
	SET_FLAG rBGP, %00000000

	HALT_FRAMES 15

	ret
	; --- End Splash ---


	; --- Init ---
Init:
	HALT_VBLANK
	di

	SET_FLAG rLCDC, LCDCF_OFF

	; Init timer variables
	ld [wTimerIECounter], a
	ld [wTimeSec], a
	ld [wTimeSec + 1], a

	; set Timer to 16Hz interruptions (lowest possible)
	SET_FLAG rTMA, $00 ; overflow at 256th timer frequency
	SET_FLAG rTAC, TACF_4KHZ
	SET_FLAG rTAC, TACF_START

	; set Interrupts
	SET_FLAG rIE, IEF_TIMER | IEF_VBLANK

	; Turn off Sound
	ld [rNR52], a

	; Set Tetris TileSet
	ld hl, _VRAM
	ld de, TetrisTileSet
	ld bc, TetrisTileSetEnd - TetrisTileSet
	call Memcpy

	SET_FLAG rBGP,  %11100100
	SET_FLAG rOBP0, %11100100
	SET_FLAG rOBP1, %00011011

	; Turn screen on, display background
	SET_FLAG rLCDC, LCDCF_ON | LCDCF_BG8000 | LCDCF_BG9800 | LCDCF_OBJ8 | LCDCF_OBJON | LCDCF_BGON

	; Init game state
	call InitTitle

	; Init input variable
	ld [wInputState], a

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
	and c
	ld [wInputRelease], a

	ret
	; --- End CheckInput ---


START_Y_POS  EQUS "Y_POS 13"
OPTION_Y_POS EQUS "Y_POS 15"
CURSOR_X_POS EQUS "X_POS 5"
	; --- InitTitle ---
InitTitle:
	WAIT_VBLANK
	TOGGLE_FLAG rLCDC, LCDCF_ON

	LOAD_ADDRESS wUpdateLabel, UpdateTitle

	; Set Title TileMap
	ld hl, _SCRN0
	ld de, TitleTileMap
	ld bc, 20 << 8 | 18 ; same as both `ld b, 20` and `ld c, 18`
	call TileMapCopy

	SET_SPRITE wObject_00, START_Y_POS, CURSOR_X_POS, $7F, OAMF_PAL1

	TOGGLE_FLAG rLCDC, LCDCF_ON
	ret
	; --- End UpdateTitle ---


	; --- UpdateTitle ---
UpdateTitle:
	ld a, [wObject_00.y]
	sub OPTION_Y_POS
	jr z, .options

.start
	TEST_INPUT wInputPress, PADF_A, .notStart
	call InitGame
	ret
.notStart
	TEST_INPUT wInputPress, PADF_DOWN, .afterDown
	ld a, OPTION_Y_POS
	ld [wObject_00.y], a
.afterDown
	ret

.options
	TEST_INPUT wInputPress, PADF_A, .notOptions
	call InitOptions
	ret
.notOptions
	TEST_INPUT wInputPress, PADF_UP, .afterUp
	ld a, START_Y_POS
	ld [wObject_00.y], a
.afterUp
	ret
	; --- End UpdateTitle ---


MUSIC_Y_POS EQUS "Y_POS 6"
SOUND_Y_POS EQUS "Y_POS 11"
BACK_Y_POS  EQUS "Y_POS 15"
BACK_X_POS  EQUS "X_POS 6"
LEFT_X_POS  EQUS "X_POS 3"
RIGHT_X_POS EQUS "X_POS 16"
	; --- InitOptions ---
InitOptions:
	WAIT_VBLANK
	TOGGLE_FLAG rLCDC, LCDCF_ON

	LOAD_ADDRESS wUpdateLabel, UpdateOptions

	; Set Options TileMap
	ld hl, _SCRN0
	ld de, OptionsTileMap
	ld bc, 20 << 8 | 18 ; same as both `ld b, 20` and `ld c, 18`
	call TileMapCopy

	SET_SPRITE wObject_00, BACK_Y_POS, BACK_X_POS, $7F, OAMF_PAL1
	SET_SPRITE wObject_01, 0, RIGHT_X_POS, $7F, OAMF_PAL0

	TOGGLE_FLAG rLCDC, LCDCF_ON
	ret
	; --- End InitOptions


	; --- UpdateOptions ---
UpdateOptions:
	ld a, [wObject_00.y]
	cp SOUND_Y_POS
	jr z, .sfx
	cp BACK_Y_POS
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
	ld a, MUSIC_Y_POS
	ld [wObject_00.y], a
	ld [wObject_01.y], a
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
	ld a, SOUND_Y_POS
	ld [wObject_00.y], a
	ld [wObject_01.y], a
	ld a, LEFT_X_POS
	ld [wObject_00.x], a
	ld a, OAMF_XFLIP
	ld [wObject_00.flags], a
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
	ld a, BACK_Y_POS
	ld [wObject_00.y], a
	ld a, BACK_X_POS
	ld [wObject_00.x], a
	ld a, OAMF_PAL1
	ld [wObject_00.flags], a
	ld a, 0 ; move right arrow off screen
	ld [wObject_01.y], a
	ret
	; --- End UpdateOptions ---


	; --- InitGame ---
InitGame:
	WAIT_VBLANK
	TOGGLE_FLAG rLCDC, LCDCF_ON

	LOAD_ADDRESS wUpdateLabel, UpdateGame

	; Set Game TileMap
	ld hl, _SCRN0
	ld de, GameTileMap
	ld bc, 20 << 8 | 18 ; same as both `ld b, 20` and `ld c, 18`
	call TileMapCopy

	SET_SPRITE wObject_00, 0, 0, $00, $00

	

	TOGGLE_FLAG rLCDC, LCDCF_ON
	ret
	; --- End InitGame ---


	; --- UpdateGame ---
UpdateGame:
	HALT_FRAMES 120
	call InitScore
	ret
	; --- End UpdateGame ---


	; --- InitScore ---
InitScore:
	WAIT_VBLANK
	TOGGLE_FLAG rLCDC, LCDCF_ON

	LOAD_ADDRESS wUpdateLabel, UpdateScore

	; Set Score TileMap
	ld hl, _SCRN0
	ld de, ScoreTileMap
	ld bc, 20 << 8 | 18 ; same as both `ld b, 20` and `ld c, 18`
	call TileMapCopy

	SET_SPRITE wObject_00, Y_POS 15, X_POS 6, $7F, OAMF_PAL1

	TOGGLE_FLAG rLCDC, LCDCF_ON
	ret
	; --- End InitScore ---


	; --- UpdateScore ---
UpdateScore:
	TEST_INPUT wInputPress, PADF_A, .notBack
	call InitTitle
	ret
.notBack
	ret
	; --- End UpdateScore ---
