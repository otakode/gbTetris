
SECTION "Interruption Handlers", ROM0

	; --- ProcessVBlank ---
ProcessVBlank:
	ld hl, _SCRN0 + SCRN_X_B - (sTimerEnd - sTimer) ; top right of the screen
	ld de, sTimer
	call StrCpy

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
	ld [wTimeSec], a
	cp a, $00
	ret nz

	; increment high byte value for wTimeSec
	ld a, [wTimeSec + 1]
	add 1
	ld [wTimeSec + 1], a

	ret
	; --- End ProcessTimer ---
