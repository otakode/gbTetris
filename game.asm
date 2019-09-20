; Global Variables
counter EQU _RAM + 0 ; end +1
secCounter EQU _RAM + 1 ; end +2
string EQU _RAM + 2 ; end +6

	; --- Init ---
Init:
	; Set Font Tileset
	ld hl, _VRAM + $1000 ; BG Character Data is after Object Character Data
	ld de, FontTiles
	ld bc, FontTilesEnd - FontTiles
	call Memcpy

	; set Timer to 16Hz interruptions (lowest possible)
	; set TMA
	ld a, $00 ; overflow at 256th timer
	ld [rTMA], a
	; set TAC
	ld a, TACF_4KHZ
	ld [rTAC], a
	ld a, TACF_START
	ld [rTAC], a

	; set Timer Interrupt
	ld a, [rIE]
	or IEF_TIMER
	ld [rIE], a

	ld a, 0
	ld [counter], a
	ld [secCounter], a

	ret
	; --- End Init ---


	; --- Game ---
Game:
	ld a, [rIF]
	and IEF_TIMER
	call nz, ProcessTimer

	ld a, [rIF]
	and IEF_VBLANK
	call nz, ProcessVBlank

	ld a, 0
	ld [rIF], a

	ret
	; --- End Game ---


	; --- ProcessTimer ---
ProcessTimer:
	; set Timer Interrupt
	ld a, [rIE]
	or IEF_TIMER
	ld [rIE], a

	; increment counter
	ld a, [counter]
	add 1
	ld [counter], a
	sub 16
	ret nz

	ld [counter], a ; reset counter
	; increment Seconds counter
	ld a, [secCounter]
	add 1
	ld [secCounter], a

	ret
	; --- End ProcessTimer ---


	; --- ProcessVBlank ---
ProcessVBlank:
	; set VBlank Interrupt
	ld a, [rIE]
	or IEF_VBLANK
	ld [rIE], a

	ld hl, _SCRN0 + SCRN_X_B - 1 ; top right of the screen
	ld a, [secCounter]

	ld b, a
	; and $0F

	daa
	swap a
	ld c, a
	swap a

	and $0F
	add "0"
	ld [hld], a

	ld a, b
	swap a
	and $0F
	add c

	daa

	and $0F
	add "0"
	ld [hld], a

	ld a, b
	swap a

	and $0F
	add "0"
	ld [hld], a

	ret
	; --- End ProcessVBlank ---
