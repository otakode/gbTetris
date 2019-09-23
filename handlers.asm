
SECTION "Interruption Handlers", ROM0

	; --- ProcessVBlank ---
ProcessVBlank:
	ld hl, _SCRN0 + SCRN_X_B - 1 ; top right of the screen
	ld de, wTimeSec

	ld a, [de]
	and a, $0F
	add "0"
	ldd [hl], a

	ld a, [de]
	swap a
	and a, $0F
	add "0"
	ldd [hl], a

	inc de

	ld a, [de]
	and a, $0F
	add "0"
	ldd [hl], a

	ld a, [de]
	swap a
	and a, $0F
	add "0"
	ld [hl], a

	ret
	; --- End ProcessVBlank ---


	; --- ProcessTimer ---
ProcessTimer:
	; increment interrupt counter
	ld a, [bTimerIECounter]
	inc a
	ld [bTimerIECounter], a
	sub 16
	ret nz

	ld [bTimerIECounter], a ; reset counter
	; increment Seconds counter
	ld a, [wTimeSec]
	inc a
	daa
	ld [wTimeSec], a
	ret nc

	; increment high byte value for wTimeSec
	ld a, [wTimeSec + 1]
	add 1
	daa
	ld [wTimeSec + 1], a

	ret
	; --- End ProcessTimer ---
