
SECTION "VBlank Interrupt", ROM0[$0040]

VBlankInterrupt:
	push af ; 1 byte
	call ProcessVBlank
	pop af ; 1 byte
	reti ; 1 byte


SECTION "LCDStat Interrupt", ROM0[$0048]

LCDStatInterrupt:
	reti ; 1 byte


SECTION "Timer Interrupt", ROM0[$0050]

TimerInterrupt:
	push af ; 1 byte
	call ProcessTimer ; 3 bytes
	pop af ; 1 byte
	reti ; 1 byte


SECTION "Serial Interrupt", ROM0[$0058]

SerialInterrupt:
	reti ; 1 byte


SECTION "Joypad Interrupt", ROM0[$0060]

JoypadInterrupt:
	reti ; 1 byte
