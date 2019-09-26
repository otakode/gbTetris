
; --- TileSets ---

SECTION "FONT", ROM0
FontTiles:
INCBIN "../TileSet/font.chr"
FontTilesEnd:

INCLUDE "../TileSet/GameBoyTileSet.z80"
GameBoyTileSetEnd:

; --- End TileSets ---

; --- TileMaps ---

INCLUDE "../TileMap/GameBoyTileMap.z80"
GameBoyTileMapEnd:

; --- End TileMaps ---