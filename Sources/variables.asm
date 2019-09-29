
SECTION "Variables", WRAM0


bInputState: db ; input bits set if a button is down
; bInputPress: db ; input bits set when changing from up to down
; bInputRelease: db ; input bits set when changing from down to up

bTimerIECounter: db ; counter for Timer Interruptions

wTimeSec: dw ; time in seconds (BCD)


SECTION "OAM Sprites", WRAM0 [$C100]


Objects: ; --- Sprite Objects ---
DPadDown: SPRITE_OBJECT
DPadUp: SPRITE_OBJECT
DPadLeft: SPRITE_OBJECT
DPadRight: SPRITE_OBJECT
ButtonStart: SPRITE_OBJECT
ButtonSelect: SPRITE_OBJECT
ButtonB: SPRITE_OBJECT
ButtonA: SPRITE_OBJECT
ObjectsEnd: ; --- End Sprite Objects ---

REPT $A0 - (ObjectsEnd - Objects)
	db
ENDR


SECTION "OAM DMA", HRAM

hOAMDMA::
	ds DMARoutineEnd - DMARoutine ; Reserve space to copy the routine to
