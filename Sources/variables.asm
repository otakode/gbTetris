
SECTION "Variables", WRAM0

	; Interrupts
wInterrupts:     db ; interrupt bit set when served

	; Inputs
wInputState:     db ; input bits set if a button is down
wLastInputState: db ; state from the last frame
wInputPress:     db ; input bits set if pressed this frame
wInputRelease:   db ; input bits set if released this frame

	; RNG
wRNG db;

	; Time
wTimerIECounter: db ; counter for Timer Interruptions
wTimeSec:        dw ; time in seconds (BCD)

	; Game Logic
wUpdateLabel: dw ; current update function address

	; Game Screen memory
wGameMemoryStart:
wScore:      dl ; current Score value (BCD)
wLevel:      db ; current Level value (BCD)
wLines:      dw ; current Lines value (BCD)
wPiecePos:
wPiecePos_y: db ; y position of the piece
wPiecePos_x: db ; x position of the piece
wPiece:      dw ; current Piece (Rom address)
wNextPiece:  dw ; next Piece
wBlockMap:   ds 2 * 20 ; block map is 10 wide (2 bytes per line) and 20 tall (with 2 hidden lines above the screen)
                     ; stored in reverse order (last line first)
wBlockMapEnd:
wGameMemoryEnd:

	; Score Screen memory
wHighScore:
wHighScore_0: HIGHSCORE_OBJECT
wHighScore_1: HIGHSCORE_OBJECT
wHighScore_2: HIGHSCORE_OBJECT
wHighScore_3: HIGHSCORE_OBJECT
wHighScore_4: HIGHSCORE_OBJECT
wHighScore_5: HIGHSCORE_OBJECT
wHighScore_6: HIGHSCORE_OBJECT
wHighScore_7: HIGHSCORE_OBJECT
wHighScore_8: HIGHSCORE_OBJECT
wHighScore_9: HIGHSCORE_OBJECT
wHighScoreEnd:


SECTION "OAM Sprites", WRAM0 [$C100]


wObjects: ; --- Sprite Objects ---
	SPRITE_OBJECT wObject_00
	SPRITE_OBJECT wObject_01
	SPRITE_OBJECT wObject_02
	SPRITE_OBJECT wObject_03
	SPRITE_OBJECT wObject_04
	SPRITE_OBJECT wObject_05
	SPRITE_OBJECT wObject_06
	SPRITE_OBJECT wObject_07
	SPRITE_OBJECT wObject_08
	SPRITE_OBJECT wObject_09
	SPRITE_OBJECT wObject_10
	SPRITE_OBJECT wObject_11
	SPRITE_OBJECT wObject_12
	SPRITE_OBJECT wObject_13
	SPRITE_OBJECT wObject_14
	SPRITE_OBJECT wObject_15
	SPRITE_OBJECT wObject_16
	SPRITE_OBJECT wObject_17
	SPRITE_OBJECT wObject_18
	SPRITE_OBJECT wObject_19
	SPRITE_OBJECT wObject_20
	SPRITE_OBJECT wObject_21
	SPRITE_OBJECT wObject_22
	SPRITE_OBJECT wObject_23
	SPRITE_OBJECT wObject_24
	SPRITE_OBJECT wObject_25
	SPRITE_OBJECT wObject_26
	SPRITE_OBJECT wObject_27
	SPRITE_OBJECT wObject_28
	SPRITE_OBJECT wObject_29
	SPRITE_OBJECT wObject_30
	SPRITE_OBJECT wObject_31
	SPRITE_OBJECT wObject_32
	SPRITE_OBJECT wObject_33
	SPRITE_OBJECT wObject_34
	SPRITE_OBJECT wObject_35
	SPRITE_OBJECT wObject_36
	SPRITE_OBJECT wObject_37
	SPRITE_OBJECT wObject_38
	SPRITE_OBJECT wObject_39
wObjectsEnd: ; --- End Sprite Objects ---
