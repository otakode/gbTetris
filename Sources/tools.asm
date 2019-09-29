
SECTION "OAM DMA routine", ROM0


	; --- CopyDMARoutine ---
CopyDMARoutine:
	ld hl, DMARoutine
	ld b, DMARoutineEnd - DMARoutine ; Number of bytes to copy
	ld c, LOW(hOAMDMA) ; Low byte of the destination address
.copy
	ld a, [hli]
	ldh [c], a
	inc c
	dec b
	jr nz, .copy
	ret
	; --- End CopyDMARoutine ---


	; --- DMARoutine ---
DMARoutine:
	ldh [rDMA], a
	ld a, 40
.wait
	dec a
	jr nz, .wait
	ret
DMARoutineEnd:
	; --- End DMARoutine ---


SECTION "Tools Functions", ROM0


	; --- Memzero ---
	; @param hl ; address to set 0 to ; return address after data copy
	; @param bc ; byte size of data to set ; return 0
	; @flags ; a = 0 ; C unchanged ; H unchanged ; N = true ; Z = true
Memzero:
	xor a ; ld a, 0
	ldi [hl], a
	dec bc
	ld a, b
	or c
	jr nz, Memzero
	ret
	; --- End Memcpy ---


	; --- Memcpy ---
	; @param hl ; address to copy to ; return address after data copy
	; @param de ; address to copy from ; return address after data copy
	; @param bc ; byte size of data to copy ; return 0
	; @flags ; a = 0 ; C unchanged ; H unchanged ; N = true ; Z = true
Memcpy:
	ld a, [de]
	ldi [hl], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, Memcpy
	ret
	; --- End Memcpy ---


	; --- StrCpy ---
	; @param hl ; address to copy to ; return address after data copied to
	; @param de ; address to copy from ; return address after data copied from
	; @flags ; a = 0 ; C unchanged ; H unchanged ; N = true ; Z = true
StrCpy:
	ld a, [de]
	ld [hli], a
	inc de
	and a ; test if zero
	jr nz, StrCpy
	ret
	; --- End StrCpy ---


	; --- TileMapCopy ---
	; @param hl ; address to copy the tilemap to ; return address below the bottom left tile (can be Out of Bounds)
	; @param de ; address to copy the tilemap from ; return address after the data
	; @param b ; width of the tilemap ; return b*8
	; @param c ; height of the tilemap ; return 0
	; @flags ; a=0 ; C unknown ; H unknown ; N = true ; Z = true
TileMapCopy:

.row
	ld a, c
	dec c
	and a
	ret z
.col
	; copy line
	push bc
	push hl
	ld a, b
	ld c, a
	ld b, 0
	call Memcpy
	pop hl

	; next line
	ld a, l
	add SCRN_VX_B
	ld l, a
	ld a, 0
	adc a, h
	ld h, a
	pop bc

	jr .row
	;ret
	; --- End TileMapCopy ---


	; --- R8ToHexStr ---
	; @param hl ; address to write string to (2 chars) ; return address to the character at the start of the string
	; @param e ; value of the number ; return unchanged
	; @flags ; a = last character ; C = is last character a letter ; H = C ; N = true ; Z = false
R8ToHexStr:
	ld a, e
	swap a
	and $0F
	cp $0A
	jr c, .notHex1
	add "A" - 10 - "0"
.notHex1
	add "0"
	ldi [hl], a

	ld a, e
	and $0F
	cp $0A
	jr c, .notHex2
	add "A" - 10 - "0"
.notHex2
	add "0"
	ldi [hl], a

	ret
	; --- End R8ToHexStr ---


	; --- R16ToHexStr ---
	; @param hl ; address to write string to (4 chars) ; return address after the string (+4)
	; @param de ; value of the number ; return unchanged
	; @flags ; a = last character ; C = is last character a letter ; H = C ; N = true ; Z = false
R16ToHexStr:
	ld a, d
	swap a
	and $0F
	cp $0A
	jr c, .notHex1
	add "A" - 10 - "0"
.notHex1
	add "0"
	ldi [hl], a

	ld a, d
	and $0F
	cp $0A
	jr c, .notHex2
	add "A" - 10 - "0"
.notHex2
	add "0"
	ldi [hl], a

	ld a, e
	swap a
	and $0F
	cp $0A
	jr c, .notHex3
	add "A" - 10 - "0"
.notHex3
	add "0"
	ldi [hl], a

	ld a, e
	and $0F
	cp $0A
	jr c, .notHex4
	add "A" - 10 - "0"
.notHex4
	add "0"
	ldi [hl], a

	ret
	; --- End R16ToHexStr ---
