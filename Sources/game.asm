
SECTION "Game", ROM0


	; --- Splash ---
Splash:
	WAIT_FRAMES 15
	ld a, %00001000
	ld [rBGP], a
	WAIT_FRAMES 3
	ld a, %00000100
	ld [rBGP], a
	WAIT_FRAMES 3
	ld a, %00000000
	ld [rBGP], a

	WAIT_FRAMES 15

	; Turn off LCD
	xor a ; ld a, 0
	ld [rLCDC], a

	; Set OtakodeLogo TileSet
	ld hl, _VRAM
	ld de, OtakodeLogoTileSet
	ld bc, OtakodeLogoTileSetEnd - OtakodeLogoTileSet
	call Memcpy

	; Set OtakodeLogo TileMap
	ld hl, _SCRN0
	ld de, OtakodeLogoTileMap
	ld bc, 20 << 8 | 18 ; same as both `ld b, 20` and `ld c, 18`
	call TileMapCopy

	ld a, %01000000
	ld [rBGP], a

	; Turn on LCD
	ld a, LCDCF_ON | LCDCF_WIN9800 | LCDCF_WINOFF | LCDCF_BG8000 | LCDCF_BG9800 | LCDCF_OBJ8 | LCDCF_OBJOFF | LCDCF_BGON
	ld [rLCDC], a

	WAIT_FRAMES 3
	ld a, %10010000
	ld [rBGP], a
	WAIT_FRAMES 3
	ld a, %11100100
	ld [rBGP], a

	WAIT_FRAMES 120

	ld a, %10010000
	ld [rBGP], a
	WAIT_FRAMES 3
	ld a, %01000000
	ld [rBGP], a
	WAIT_FRAMES 3
	ld a, %00000000
	ld [rBGP], a

	WAIT_FRAMES 15

	ret
	; --- End Splash ---


	; --- Init ---
Init:
	WAIT_VBLANK

	; Turn off LCD
	xor a ; ld a, 0
	ld [rLCDC], a

	; Init input variable
	ld [wInputState], a

	; Init memory variables
	ld [wTimerIECounter], a
	ld [wTimeSec], a
	ld [wTimeSec + 1], a

	; Init game state
	ld a, LOW(UpdateTitle)
	ld [wUpdateLabel], a
	ld a, HIGH(UpdateTitle)
	ld [wUpdateLabel + 1], a

	; Set Font TileSet
	ld hl, _VRAM
	ld de, FontTileSet
	ld bc, FontTileSetEnd - FontTileSet
	call Memcpy

	; Set Title TileMap
	ld hl, _SCRN0
	ld de, TitleTileMap
	ld bc, 20 << 8 | 18 ; same as both `ld b, 20` and `ld c, 18`
	call TileMapCopy

	; Init display registers
	ld a, %11100100 ; 11 10 01 00 simple dark to light color palette
	ld [rBGP], a
	ld [rOBP0], a
	ld [rOBP1], a

	; Set Screen position to 0,0
	xor a ; ld a, 0
	ld [rSCY], a
	ld [rSCX], a

	; No sound
	ld [rNR52], a

	call InitObjects
	call CopyDMARoutine
	call ProcessVBlank ; first frame to init OAM

	; Turn screen on, display background
	ld a, LCDCF_ON | LCDCF_WIN9800 | LCDCF_WINOFF | LCDCF_BG8000 | LCDCF_BG9800 | LCDCF_OBJ8 | LCDCF_OBJON | LCDCF_BGON
	ld [rLCDC], a

	; set Interrupts
	ld a, IEF_TIMER | IEF_VBLANK
	ld [rIE], a

	; set Timer to 16Hz interruptions (lowest possible)
	; set TMA
	xor a ; ld a, $00 ; overflow at 256th timer frequency
	ld [rTMA], a
	; set TAC
	ld a, TACF_4KHZ
	ld [rTAC], a
	ld a, TACF_START
	ld [rTAC], a

	ei

	ret
	; --- End Init ---


	; --- InitObjects ---
InitObjects:
	ld hl, wObjects
	ld bc, wObjectsEnd - wObjects
	call Memzero
	ret
	; --- End InitObjects ---


	; --- Game ---
Game:
	call CheckInput
	ld a, [wUpdateLabel]
	ld l, a
	ld a, [wUpdateLabel + 1]
	ld h, a
	jp hl

	ret ; will never be reached, but just in case
	; --- End Game ---


	; --- CheckInputs ---
CheckInput:
	ld hl, rP1

	ld [hl], ~P1F_4
REPT 2
	ld a, [hl]
ENDR
	and $0F
	swap a
	ld b, a

	ld [hl], ~P1F_5
REPT 6
	ld a, [hl]
ENDR
	and $0F
	or b
	cpl
	ld [wInputState], a

	ret
	; --- End CheckInput ---


	; --- InitTitle ---
InitTitle:
	ret
	; --- End UpdateTitle ---


	; --- UpdateTitle ---
UpdateTitle:
	ret
	; --- End UpdateTitle ---


	; --- UpdateOptions ---
UpdateOptions:
	ret
	; --- End UpdateOptions ---


	; --- UpdateGame ---
UpdateGame:
	ret
	; --- End UpdateGame ---


	; --- UpdateScore ---
UpdateScore:
	ret
	; --- End UpdateScore ---
