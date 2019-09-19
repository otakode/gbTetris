	; Tools Functions

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

