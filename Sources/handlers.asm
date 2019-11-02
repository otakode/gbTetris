
SECTION "Interruption Handlers", ROM0

	; --- ProcessVBlank ---
ProcessVBlank:
	ld a, [wInterrupts]
	or IEF_VBLANK
	ld [wInterrupts], a
	ld a, HIGH(wObjects) ; 2 bytes
	call hOAMDMA ; 3 bytes
	ret
	; --- End ProcessVBlank ---


	; --- No LCDStat ---


	; --- ProcessTimer ---
ProcessTimer:
	; increment interrupt counter
	ld a, [wTimerIECounter]
	inc a
	ld [wTimerIECounter], a
	sub 16
	ret nz

	ld [wTimerIECounter], a ; reset counter
	; increment Seconds counter
	ld a, [wTimeSec]
	inc a
	daa
	ld [wTimeSec], a
	ret nc

	; increment high byte value for wTimeSec
	ld a, [wTimeSec + 1]
	inc a
	daa
	ld [wTimeSec + 1], a

	ret
	; --- End ProcessTimer ---


	; --- No Serial ---


	; --- No Joypad ---
