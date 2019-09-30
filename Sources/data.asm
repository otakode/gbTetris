
; --- TileSets ---

SECTION "FONT", ROM0
FontTiles:
INCBIN "../TileSet/font.chr"
FontTilesEnd:

INCLUDE "../TileSet/GameBoyTileSet.z80"
GameBoyTileSetEnd:

INCLUDE "../TileSet/OtakodeLogoTileSet.z80"
OtakodeLogoTileSetEnd:

; --- End TileSets ---


; --- TileMaps ---

INCLUDE "../TileMap/GameBoyTileMap.z80"
GameBoyTileMapEnd:

INCLUDE "../TileMap/OtakodeLogoTileMap.z80"
OtakodeLogoTileMapEnd:

; --- End TileMaps ---
