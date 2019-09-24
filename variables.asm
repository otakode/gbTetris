
SECTION "Variables", WRAM0

bInputState: db ; input bits set if a button is down
; bInputPress: db ; input bits set when changing from up to down
; bInputRelease: db ; input bits set when changing from down to up

bTimerIECounter: db ; counter for Timer Interruptions

wTimeSec: dw ; time in seconds (BCD)
