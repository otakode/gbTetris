
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

WAIT_FRAMES: MACRO
	ld b, \1
.nextFrame\@
	WAIT_POST_VBLANK
	WAIT_VBLANK
	dec b
	jr nz, .nextFrame\@
ENDM


SPRITE_OBJECT: MACRO
.y db
.x db
.tile db
.flags db
ENDM


Y_POS: MACRO
	\1 * 8 + 16
ENDM

X_POS: MACRO
	\1 * 8 + 8
ENDM


SET_SPRITE: MACRO
	ld a, \2 + 16
	ld [\1.y], a
	ld a, \3 + 8
	ld [\1.x], a
	ld a, \4
	ld [\1.tile], a
	ld a, \5
	ld [\1.flags], a
ENDM
