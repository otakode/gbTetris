
SECTION "STimer", ROM0
sTimerInit:
	db "00000", 0
sTimerInitEnd:

SECTION "FONT", ROM0
FontTiles:
INCBIN "font.chr"
FontTilesEnd:
