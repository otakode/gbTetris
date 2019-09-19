; Global Variables
counter EQU _RAM + 0
counter2 EQU _RAM + 1

Init:
	; Set Font Tileset
	ld hl, _VRAM + $1000 ; BG Character Data is after Object Character Data
	ld de, FontTiles
	ld bc, FontTilesEnd - FontTiles
	call Memcpy

	; Write Hello World to Screen0
	ld hl, _SCRN0
	ld de, HelloWorldStr
	call StrCpy

	; set Timer Interrupt
	ld a, [rIE]
	or IEF_TIMER
	ld [rIE], a

	; set Timer
	; set TMA
	ld a, 0 ; overflow at 256th timer
	ld [rTMA], a
	; set TAC
	ld a, TACF_4KHZ
	ld [rTAC], a
	ld a, TACF_START
	ld [rTAC], a

	ld a, 0
	ld [counter], a

	ret

Game:
	ld a, [rIE]
	and IEF_TIMER

	ret z

	; set Timer Interrupt
	ld a, [rIE]
	or IEF_TIMER
	ld [rIE], a

	; set TMA
	ld a, $00 ; overflow at 256th timer
	ld [rTMA], a
	; set TAC
	ld a, TACF_4KHZ
	ld [rTAC], a
	ld a, TACF_START
	ld [rTAC], a

	; increment counter
	ld a, [counter]
	add 1
	ld [counter], a

	sub $FF
	jp nz, .end

	ld b, a
	ld a, [counter2]
	add 1
	ld [counter2], a

	daa

	ld hl, _SCRN0 + SCRN_X_B - 1 ; top right of the screen

	ld b, a
	and $0F
	add "0"
	ld [hld], a

	ld a, b
	swap a
	and $0F
	add "0"
	ld [hld], a

.end
	ret

