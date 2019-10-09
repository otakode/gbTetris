
; --- TileSets ---

INCLUDE "../TileSet/OtakodeLogoTileSet.z80"
OtakodeLogoTileSetEnd:

INCLUDE "../TileSet/FontTileSet.z80"
FontTileSetEnd:

INCLUDE "../TileSet/TetrisTileSet.z80"
TetrisTileSetEnd:

; --- End TileSets ---


; --- TileMaps ---

INCLUDE "../TileMap/OtakodeLogoTileMap.z80"
OtakodeLogoTileMapEnd:

INCLUDE "../TileMap/TitleTileMap.z80"
TitleTileMapEnd:

INCLUDE "../TileMap/OptionsTileMap.z80"
OptionsTileMapEnd:

INCLUDE "../TileMap/GameTileMap.z80"
GameTileMapEnd:

INCLUDE "../TileMap/ScoreTileMap.z80"
ScoreTileMapEnd:

; --- End TileMaps ---


; --- GameData ---

InitialHighScore:
CHARMAP " ", 0
db "First     "
dl $12345678
db "Second    "
dl $23456789
db "Third     "
dl $34567890
db "Fourth    "
dl $45678901
db "Fifth     "
dl $56789012
db "Sixth     "
dl $67890123
db "Seventh   "
dl $78901234
db "Eighth    "
dl $89012345
db "Ninth     "
dl $90123456
db "Tenth     "
dl $01234567
InitialHighScoreEnd:

; --- End GameData ---
