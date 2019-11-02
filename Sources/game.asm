
SECTION "Game", ROM0


	; --- Splash ---
Splash:
	WAIT_VBLANK

	; Init OAM
	call InitObjects
	call CopyDMARoutine
	ld a, HIGH(wObjects)
	call hOAMDMA

	; Init Interrupts
	xor a
	ld [wInterrupts], a
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

	HALT_FRAMES 60

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

	; Init RNG
	ld [wRNG], a

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


START_Y_POS  SET Y_POS 13
OPTION_Y_POS SET Y_POS 15
CURSOR_X_POS SET X_POS 5
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
	ld a, [wObject_00_y]
	sub OPTION_Y_POS
	jr z, .options

.start
	TEST_INPUT wInputPress, PADF_A, .notStart
	call InitGame
	ret
.notStart
	TEST_INPUT wInputPress, PADF_DOWN, .afterDown
	ld a, OPTION_Y_POS
	ld [wObject_00_y], a
.afterDown
	ret

.options
	TEST_INPUT wInputPress, PADF_A, .notOptions
	call InitOptions
	ret
.notOptions
	TEST_INPUT wInputPress, PADF_UP, .afterUp
	ld a, START_Y_POS
	ld [wObject_00_y], a
.afterUp
	ret
	; --- End UpdateTitle ---


MUSIC_Y_POS SET Y_POS 6
SOUND_Y_POS SET Y_POS 11
BACK_Y_POS  SET Y_POS 15
BACK_X_POS  SET X_POS 6
LEFT_X_POS  SET X_POS 3
RIGHT_X_POS SET X_POS 16
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
	ld a, [wObject_00_y]
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
	ld [wObject_00_y], a
	ld [wObject_01_y], a
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
	ld [wObject_00_y], a
	ld [wObject_01_y], a
	ld a, LEFT_X_POS
	ld [wObject_00_x], a
	ld a, OAMF_XFLIP
	ld [wObject_00_flags], a
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
	ld [wObject_00_y], a
	ld a, BACK_X_POS
	ld [wObject_00_x], a
	ld a, OAMF_PAL1
	ld [wObject_00_flags], a
	ld a, 0 ; move right arrow off screen
	ld [wObject_01_y], a
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

	ld hl, wGameMemoryStart
	ld bc, wGameMemoryEnd - wGameMemoryStart
	call Memzero
	ld a, Y_POS 7
	ld [wPiecePos_y], a
	ld a, X_POS 4
	ld [wPiecePos_x], a

	ld hl, wPiece
	ld bc, 2 * (wNextPiece - wPiece)
	call Memzero
	call ChangePiece
	call ChangePiece

	TOGGLE_FLAG rLCDC, LCDCF_ON
	ret
	; --- End InitGame ---


	; --- UpdateGame ---
UpdateGame:

	TEST_INPUT wInputPress, PADF_DOWN, .notDown
	call ChangePiece
.notDown

	; Rotations
	TEST_INPUT wInputPress, PADF_B, .notB
	ld b, 0
	call TurnPiece
	jr .display
.notB
	TEST_INPUT wInputPress, PADF_A, .notA
	ld b, 1
	call TurnPiece
	;jr .display
.notA

.display
	; Score
	ld hl, _SCRN0 + 3 * SCRN_VX_B + 12
	ld de, wScore + 3
	call BCDToStr
	dec de
	call BCDToStr
	dec de
	call BCDToStr
	dec de
	call BCDToStr

	; Level
	ld hl, _SCRN0 + 7 * SCRN_VX_B + 14
	ld de, wLevel + 1
	call BCDToStr
	dec de
	call BCDToStr

	; Lines
	ld hl, _SCRN0 + 10 * SCRN_VX_B + 14
	ld de, wLines + 1
	call BCDToStr
	dec de
	call BCDToStr

	; Piece
	ld a, [wPiece]
	ld l, a
	ld a, [wPiece + 1]
	ld h, a
	ld de, wObject_00
	ld a, [wPiecePos_y]
	ld b, a
	ld a, [wPiecePos_x]
	ld c, a
	call UpdatePiece

	; Next Piece
	ld a, [wNextPiece]
	ld l, a
	ld a, [wNextPiece + 1]
	ld h, a
	; de is already pointing to wObject_04
	ld a, Y_POS 13
	ld b, a
	ld a, X_POS 14
	ld c, a
	call UpdatePiece

	; Gameover check
	TEST_INPUT wInputPress, PADF_START, .notGameOver
	call InitScore
.notGameOver
	ret
	; --- End UpdateGame ---


	; --- TurnPiece ---
	; @param b ; 1 to turn right, 0 to turn left
TurnPiece:
	sla b ; 2 or 0

	ld a, [wPiece]
	add b
	ld l, a
	ld a, [wPiece + 1]
	adc 0
	ld h, a

	ldi a, [hl]
	ld [wPiece], a
	ld a, [hl]
	ld [wPiece + 1], a

	ret
	; --- End TurnPiece ---


	; --- ChangePiece ---
ChangePiece:
	ld a, [wNextPiece]
	ld [wPiece], a
	ld a, [wNextPiece + 1]
	ld [wPiece + 1], a

	call RNG
	and %1110
	add LOW(PieceTable)
	ld l, a
	ld a, HIGH(PieceTable)
	adc 0
	ld h, a
	ldi a, [hl]
	ld [wNextPiece], a
	ld a, [hl]
	ld [wNextPiece + 1], a

	ret
	; --- End ChangePiece ---


	; --- UpdatePiece
	; @param hl ; address of the piece data
	; @param de ; address of the first of the 4 sprites
	; @param b, c ; b=y and c=x position of the piece
UpdatePiece:

	ld a, l
	add (L0_blocks - L0) ; blocks offset
	ld l, a
	ld a, h
	adc 0
	ld h, a

REPT 4
	ld a, [hl]
	and $C0
	srl a
	srl a
	srl a ; YY00 0000 -> 000Y Y000 ; shift and multiply by 8
	add b
	ld [de], a
	inc de

	ld a, [hl]
	and $30
	rrca ; 00XX 0000 -> 000X X000 ; shift and multiply by 8
	add c
	ld [de], a
	inc de

	ldi a, [hl]
	and $0F
	ld [de], a

	ld a, e
	add a, (wObject_01 - wObject_00) - 2 ; -2 for the already incremented de
	ld e, a
	ld a, d
	adc 0
	ld d, a
ENDR

	ret
	; --- End UpdatePiece ---


BACK_Y_POS SET Y_POS 15
BACK_X_POS SET X_POS 6
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

	SET_SPRITE wObject_00, BACK_Y_POS, BACK_X_POS, $7F, OAMF_PAL1

	ld hl, wObject_01
	ld bc, wObject_08 - wObject_01
	call Memzero

	ld hl, wHighScore
	ld de, InitialHighScore
	ld bc, wHighScoreEnd - wHighScore
	call Memcpy

COUNT SET 0
REPT 10
	ld hl, _SCRN0 + (3 + COUNT) * SCRN_VX_B + 1
	ld de, wHighScore + COUNT * (wHighScore_1 - wHighScore_0)
	ld bc, 10
	call Memcpy
	inc de
	inc de
	inc de
	call BCDToStr
	dec de
	call BCDToStr
	dec de
	call BCDToStr
	dec de
	call BCDToStr
COUNT SET COUNT + 1
ENDR

	TOGGLE_FLAG rLCDC, LCDCF_ON
	ret
	; --- End InitScore ---


	; --- UpdateScore ---
UpdateScore:
	TEST_INPUT wInputPress, PADF_A, .notBack
	call InitTitle
.notBack
	ret
	; --- End UpdateScore ---
