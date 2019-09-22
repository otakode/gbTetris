
SECTION "Tools Functions", ROM0

	; --- Memcpy ---
	; @param hl ; address to copy to ; return address after data copy
	; @param de ; address to copy from ; return address after data copy
	; @param bc ; byte size of data to copy ; return 0
	; @flags ; a = 0 ; C unchanged ; H unchanged ; N = true ; Z = true
Memcpy:
	ld a, [de]
	ld [hli], a ; hli increments hl after use
	inc de
	dec bc
	ld a, b
	or c
	jr nz, Memcpy
	ret
	; --- End Memcpy ---


	; --- StrCpy ---
	; @param hl ; address to copy to ; return address after data copy
	; @param de ; address to copy from ; return address after data copy
	; @flags ; a = 0 ; C unchanged ; H unchanged ; N = true ; Z = true
StrCpy:
	ld a, [de]
	ld [hli], a
	inc de
	and a ; test if zero
	jr nz, StrCpy
	ret
	; --- End StrCpy ---


	; --- R8ToStr ---
	; @param hl ; address to write string to (1-3 chars + null) ; return address after the string
	; @param e ; value of the number ; return unchanged
	; @flags ; a? ; C? ; H? ; N? ; Z?
R8ToStr:
	; just write in hexadecimal for now...
	ld [hl], "0"
	inc hl
	call R8ToHexStr
	ld [hl], 0
	inc hl

	ret
	; --- End R8ToStr ---


	; --- R16ToStr ---
	; @param hl ; address to write string to (1-5 chars + null) ; return address after the string
	; @param de ; value of the number ; return unchanged
	; @flags ; a? ; C? ; H? ; N? ; Z?
R16ToStr:
	; just write in hexadecimal for now...
	ld [hl], "0"
	inc hl
	call R16ToHexStr
	ld [hl], 0
	inc hl

	ret
	; --- End R16ToStr ---


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
