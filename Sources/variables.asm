
SECTION "Variables", WRAM0

	; Inputs
wInputState: db ; input bits set if a button is down

	; Time
wTimerIECounter: db ; counter for Timer Interruptions
wTimeSec: dw ; time in seconds (BCD)


SECTION "OAM Sprites", WRAM0 [$C100]


wShadowOAM:
wObjects: ; --- Sprite Objects ---
wDPadDown: SPRITE_OBJECT
wDPadUp: SPRITE_OBJECT
wDPadLeft: SPRITE_OBJECT
wDPadRight: SPRITE_OBJECT
wButtonStart: SPRITE_OBJECT
wButtonSelect: SPRITE_OBJECT
wButtonB: SPRITE_OBJECT
wButtonA: SPRITE_OBJECT
wObjectsEnd: ; --- End Sprite Objects ---

	; filling remaining empty space
REPT $A0 - (wObjectsEnd - wObjects)
	db
ENDR
wShadowOAMEnd:


SECTION "OAM DMA", HRAM

hOAMDMA::
	ds DMARoutineEnd - DMARoutine ; Reserve space to copy the routine to
