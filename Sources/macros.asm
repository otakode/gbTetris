
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


	; Structure
SPRITE_OBJECT: MACRO
.y db
.x db
.tile db
.flags db
ENDM


	; SET_SPRITE <SpriteName>, <YPosition>, <XPosition>, <TileID>, <Flags>
SET_SPRITE: MACRO
	ld a, \2
	ld [\1.y], a
	ld a, \3
	ld [\1.x], a
	ld a, \4
	ld [\1.tile], a
	ld a, \5
	ld [\1.flags], a
ENDM


	; TEST_INPUT <InputValue>, <InputFlag>, <InactiveLabel>
TEST_INPUT: MACRO
	ld a, [\1]
	and \2
	jr z, \3
ENDM
