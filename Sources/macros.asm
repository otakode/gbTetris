
Y_POS EQUS "16 + 8 *"

X_POS EQUS "8 + 8 *"


WAIT_VBLANK: MACRO
.waitVBlank\@
	ld a, [rLY]
	cp SCRN_Y
	jr c, .waitVBlank\@
ENDM


WAIT_POST_VBLANK: MACRO
.waitPostVBlank\@
	ld a, [rLY]
	cp SCRN_Y
	jr nc, .waitPostVBlank\@
ENDM


	; WAIT_FRAMES <NumberOfFrames>
WAIT_FRAMES: MACRO
	ld b, \1
.nextFrame\@
	WAIT_POST_VBLANK
	WAIT_VBLANK
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


	; TEST_INPUT <InputFlag>, <InactiveLabel>
TEST_INPUT: MACRO
	ld a, [wInputState]
	and \1
	jr z, \2
ENDM
