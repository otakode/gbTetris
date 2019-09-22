
SECTION "Game", ROM0

	; --- Init ---
Init:
	; Turn off LCD
.waitVBlank
	ld a, [rLY]
	cp SCRN_Y ; are we past VBlank
	jr c, .waitVBlank

	; set rLCDC to 0
	xor a ; ld a, 0
	ld [rLCDC], a

	; Init memory variables
	ld [bTimerIECounter], a
	ld [wTimeSec], a
	ld [wTimeSec + 1], a

	; Set font tileset
	ld hl, _VRAM + $1000 ; BG Character Data is after Object Character Data
	ld de, FontTiles
	ld bc, FontTilesEnd - FontTiles
	call Memcpy

	ld hl, sTimer
	ld de, sTimerInit
	call StrCpy
	ld [hl], 0

	; Init display registers
	ld a, %11100100 ; 11 10 01 00 simple dark to light color palette
	ld [rBGP], a

	; Set Screen position to 0,0
	xor a ; ld a, 0
	ld [rSCY], a
	ld [rSCX], a

	; No sound
	ld [rNR52], a

	; Turn screen on, display background
	ld a, LCDCF_ON | LCDCF_BGON
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


	; --- Game ---
Game:
	ld a, [wTimeSec]
	ld e, a
	ld a, [wTimeSec + 1]
	ld d, a
	ld hl, sTimer

	call R8ToStr

	ret
	; --- End Game ---
