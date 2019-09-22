
SECTION "Variables", WRAM0

bTimerIECounter:
	db ; counter for Timer Interruptions

wTimeSec:
	dw ; time since game start in seconds

sTimer:
	ds 5 ; string for displayed timer (5 chars + null terminator)
sTimerEnd:
	db ; null terminator
