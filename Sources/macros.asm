

Y_POS EQUS "16 + 8 *"
X_POS EQUS "8 + 8 *"


SET_FLAG: MACRO
	ld a, \2
	ld [\1], a
ENDM


TOGGLE_FLAG: MACRO
	ld a, [\1]
	xor \2
	ld [\1], a
ENDM


WAIT_VBLANK: MACRO
.waitVBlank\@
	ld a, [rLY]
	cp SCRN_Y
	jr c, .waitVBlank\@
ENDM


HALT_VBLANK: MACRO
.waitVBlank\@
	Halt
	ld a, [rIF]
	cp IEF_VBLANK
	jr z, .waitVBlank\@
ENDM


	; HALT_FRAMES <NumberOfFrames>
HALT_FRAMES: MACRO
	ld b, \1
.nextFrame\@
	HALT_VBLANK
	dec b
	jr nz, .nextFrame\@
ENDM


	; LOAD_ADDRESS <StoringVariable>, <Label>
LOAD_ADDRESS: MACRO
	ld a, LOW(\2)
	ld [\1], a
	ld a, HIGH(\2)
	ld [\1 + 1], a
ENDM


	; TEST_INPUT <InputValue>, <InputFlag>, <InactiveLabel>
TEST_INPUT: MACRO
	ld a, [\1]
	and \2
	jr z, \3
ENDM


STRUCT: MACRO
STRUCT_NAME EQUS "\1"
;PRINTT "Struct: {STRUCT_NAME}\n"
STRUCT_NAME
ENDM


STRUCT_END: MACRO
PURGE STRUCT_NAME
ENDM


MEMBER: MACRO
MEMBER_NAME EQUS "\1"
;PRINTT "Member: {MEMBER_NAME}\n"
LABEL_NAME EQUS "{STRUCT_NAME}_{MEMBER_NAME}"
;PRINTT "Label: {LABEL_NAME}\n"
LABEL_NAME
PURGE LABEL_NAME
PURGE MEMBER_NAME
ENDM


	; Structure
SPRITE_STRUCT: MACRO
	STRUCT \1
	MEMBER y
	\2
	MEMBER x
	\3
	MEMBER tile
	\4
	MEMBER flags
	\5
	STRUCT_END
ENDM


	; Structure
SPRITE_OBJECT: MACRO
	SPRITE_STRUCT \1, db, db, db, db
ENDM


	; SPRITE_DATA <YPosition>, <XPosition>, <TileID>, <Flags>
SPRITE_DATA: MACRO
	SPRITE_STRUCT \1, db \2, db \3, db \4, db \5
ENDM


	; SET_SPRITE <SpriteName>, <YPosition>, <XPosition>, <TileID>, <Flags>
SET_SPRITE: MACRO
	ld a, \2
	ld [\1], a
	ld a, \3
	ld [\1 + 1], a
	ld a, \4
	ld [\1 + 2], a
	ld a, \5
	ld [\1 + 3], a
ENDM


	; Structure
	; blocks represent the 4 blocks of the piece
	; value represent tile ID, X and Y offsets 
	; encoded 4 bits of tile and 2 bits per offsets %YYXXTTTT
PIECE_DATA: MACRO
	STRUCT \1
	MEMBER previous
	dw \2
	MEMBER next
	dw \3
	MEMBER blocks
	db \4
	db \5
	db \6
	db \7
	STRUCT_END
ENDM


	; Structure
HIGHSCORE_OBJECT: MACRO
.name  ds 10
.score dl
ENDM


	; HIGHSCORE_DATA <name>, <score>
HIGHSCORE_DATA: MACRO
.name  db \1
.score dl \2
ENDM
