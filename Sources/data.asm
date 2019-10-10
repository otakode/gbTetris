
SECTION "TileSets", ROM0


; --- TileSets ---

INCLUDE "../TileSet/OtakodeLogoTileSet.z80"
OtakodeLogoTileSetEnd:

INCLUDE "../TileSet/FontTileSet.z80"
FontTileSetEnd:

INCLUDE "../TileSet/TetrisTileSet.z80"
TetrisTileSetEnd:

; --- End TileSets ---


SECTION "TileMaps", ROM0


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


SECTION "Game Data", ROM0


; --- GameData ---

Pieces:
.L: db 1
.J: db 2
.S: db 3
.Z: db 4
.O: db 5
.T: db 6
.I: db 7
PiecesEnd:

InitialHighScore:
CHARMAP " ", 0
First:
	HIGHSCORE_DATA "First     ", $10000000
Second:
	HIGHSCORE_DATA "Second    ", $05000000
Third:
	HIGHSCORE_DATA "Third     ", $01000000
Fourth:
	HIGHSCORE_DATA "Fourth    ", $00500000
Fifth:
	HIGHSCORE_DATA "Fifth     ", $00100000
Sixth:
	HIGHSCORE_DATA "Sixth     ", $00050000
Seventh:
	HIGHSCORE_DATA "Seventh   ", $00010000
Eighth:
	HIGHSCORE_DATA "Eighth    ", $00005000
Ninth:
	HIGHSCORE_DATA "Ninth     ", $00001000
Tenth:
	HIGHSCORE_DATA "Tenth     ", $00000100
InitialHighScoreEnd:

; --- End GameData ---
