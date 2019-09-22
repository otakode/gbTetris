
SECTION "Tools Functions", ROM0

	; --- Memcpy ---
	; @param hl ; address to copy to ; return address after data copy
	; @param de ; address to copy from ; return address after data copy
	; @param bc ; byte size of data to copy ; return 0
	; @flags ; a = 0 ; C const ; H unk ; N- ; Z set
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
	; @flags ; a = 0 ; C const ; H unk ; N+ ; Z set
StrCpy:
	ld a, [de]
	ld [hli], a
	inc de
	and a ; test if zero
	jr nz, StrCpy
	ret
	; --- End StrCpy ---


	; --- R8ToStr ---
	; @param hl ; address to write string to (3 chars + null) ; return address to the character at the start of the string
	; @param d ; value of the number ; return unchanged
	; @param bc ; out param ; return size of the string
	; @flags ; a? ; C? ; H? ; N? ; Z?
R8ToStr:
	; just write in hexadecimal for now...
	call R8ToHexStr

	ret
	; --- End R8ToStr ---


	; --- R16ToStr ---
	; @param hl ; address to write string to (5 chars + null) ; return address to the character at the start of the string
	; @param de ; value of the number ; return unchanged
	; @param bc ; out param ; return size of the string
	; @flags ; a? ; C? ; H? ; N? ; Z?
R16ToStr:
	; just write in hexadecimal for now...
	call R16ToHexStr

	ret
	; --- End R16ToStr ---


	; --- R8ToHexStr ---
	; @param hl ; address to write string to (3 chars + null) ; return address to the character at the start of the string
	; @param d ; value of the number ; return unchanged
	; @param bc ; out param ; return size of the string
	; @flags ; a? ; C? ; H? ; N? ; Z?
R8ToHexStr:
	ld c, 3
	ld b, 0
	add hl, bc

	ld [hl], 0 ; null terminator
	dec hl

	ld a, d
	and $0F
	cp $0A
	jr c, .notHex3
	add "A" - 10
	jr .write3
.notHex3
	add "0"
.write3
	ld [hld], a

	ld a, d
	swap a
	and $0F
	cp $0A
	jr c, .notHex2
	add "A" - 10
	jr .write2
.notHex2
	add "0"
.write2
	ld [hld], a

	ld [hl], "0"

	ret
	; --- End R8ToHexStr ---


	; --- R16ToHexStr ---
	; @param hl ; address to write string to (5 chars + null) ; return address to the character at the start of the string
	; @param de ; value of the number ; return unchanged
	; @param bc ; out param ; return size of the string
	; @flags ; a? ; C? ; H? ; N? ; Z?
R16ToHexStr:
	; just write in hexadecimal for now...
	ld c, 5
	ld b, 0
	add hl, bc

	ld [hl], 0 ; null terminator
	dec hl

	ld a, d
	and $0F
	cp $0A
	jr c, .notHex5
	add "A" - 10
	jr .write5
.notHex5
	add "0"
.write5
	ld [hld], a

	ld a, d
	swap a
	and $0F
	cp $0A
	jr c, .notHex4
	add "A" - 10
	jr .write4
.notHex4
	add "0"
.write4
	ld [hld], a

	ld a, e
	and $0F
	cp $0A
	jr c, .notHex3
	add "A" - 10
	jr .write3
.notHex3
	add "0"
.write3
	ld [hld], a

	ld a, e
	swap a
	and $0F
	cp $0A
	jr c, .notHex2
	add "A" - 10
	jr .write2
.notHex2
	add "0"
.write2
	ld [hld], a

	ld [hl], "0"

	ret
	; --- End R16ToHexStr ---
