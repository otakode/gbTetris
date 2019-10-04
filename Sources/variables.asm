
SECTION "Variables", WRAM0

	; Inputs
wInputState: db ; input bits set if a button is down
wLastInputState: db ; inputState from the last frame
wInputPress: db ; input bits set if pressed this frame
wInputRelease: db ; input bits set if released this frame

	; Time
wTimerIECounter: db ; counter for Timer Interruptions
wTimeSec: dw ; time in seconds (BCD)

wUpdateLabel: dw ; current update function


SECTION "OAM Sprites", WRAM0 [$C100]


wObjects: ; --- Sprite Objects ---
wObject_00: SPRITE_OBJECT
wObject_01: SPRITE_OBJECT
wObject_02: SPRITE_OBJECT
wObject_03: SPRITE_OBJECT
wObject_04: SPRITE_OBJECT
wObject_05: SPRITE_OBJECT
wObject_06: SPRITE_OBJECT
wObject_07: SPRITE_OBJECT
wObject_08: SPRITE_OBJECT
wObject_09: SPRITE_OBJECT
wObject_10: SPRITE_OBJECT
wObject_11: SPRITE_OBJECT
wObject_12: SPRITE_OBJECT
wObject_13: SPRITE_OBJECT
wObject_14: SPRITE_OBJECT
wObject_15: SPRITE_OBJECT
wObject_16: SPRITE_OBJECT
wObject_17: SPRITE_OBJECT
wObject_18: SPRITE_OBJECT
wObject_19: SPRITE_OBJECT
wObject_20: SPRITE_OBJECT
wObject_21: SPRITE_OBJECT
wObject_22: SPRITE_OBJECT
wObject_23: SPRITE_OBJECT
wObject_24: SPRITE_OBJECT
wObject_25: SPRITE_OBJECT
wObject_26: SPRITE_OBJECT
wObject_27: SPRITE_OBJECT
wObject_28: SPRITE_OBJECT
wObject_29: SPRITE_OBJECT
wObject_30: SPRITE_OBJECT
wObject_31: SPRITE_OBJECT
wObject_32: SPRITE_OBJECT
wObject_33: SPRITE_OBJECT
wObject_34: SPRITE_OBJECT
wObject_35: SPRITE_OBJECT
wObject_36: SPRITE_OBJECT
wObject_37: SPRITE_OBJECT
wObject_38: SPRITE_OBJECT
wObject_39: SPRITE_OBJECT
wObjectsEnd: ; --- End Sprite Objects ---

wCursor EQUS "wObject_00"
