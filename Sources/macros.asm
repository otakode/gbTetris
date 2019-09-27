SPRITE_OBJECT: MACRO
.y db
.x db
.tile db
.flags db
ENDM

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