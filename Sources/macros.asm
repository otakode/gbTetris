

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
LABEL_NAME \2
PURGE LABEL_NAME
PURGE MEMBER_NAME
ENDM


	; Structure
SPRITE_OBJECT: MACRO
	STRUCT \1
	MEMBER y,     db
	MEMBER x,     db
	MEMBER tile,  db
	MEMBER flags, db
	STRUCT_END
ENDM


	; SPRITE_DATA <YPosition>, <XPosition>, <TileID>, <Flags>
SPRITE_DATA: MACRO
.y     db \1
.x     db \2
.tile  db \3
.flags db \4
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
PIECE_OBJECT: MACRO
	STRUCT \1
	MEMBER previous, db
	MEMBER next, db
	STRUCT_END
ENDM


	; PIECE_DATA <>
PIECE_DATA: MACRO
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
