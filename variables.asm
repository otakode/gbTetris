
SECTION "Variables", WRAM0

bTimerIECounter:
	db ; counter for Timer Interruptions

wTimeSec:
	dw ; time since game start in seconds

sTimer:
	db ; string for displayed timer (5 chars + null terminator)
	db
	db
	db
	db
sTimerEnd:
	db
