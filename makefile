RGBDS_PATH=..\Tools\rgbds
OUTDIR=..\Build

# Specify assembler
AS=$(RGBDS_PATH)\rgbasm.exe

# Specify linker
LINK=$(RGBDS_PATH)\rgblink.exe

# Specify fixer
FIX=$(RGBDS_PATH)\rgbfix.exe

TARGET_NAME=Project
TARGET=$(OUTDIR)\$(TARGET_NAME).gb
SYM=$(OUTDIR)\$(TARGET_NAME).sym

SRC=main.asm

OBJ=$(SRC:.asm=.o)

.asm.o:
	$(AS) $(AFLAGS) -o $@ $<

all : $(OBJ)
	$(LINK) -o $(TARGET) -n $(SYM) $(OBJ)
	$(FIX) -v -p 0 $(TARGET)

# Clean target
clean :
	del $(OBJ) $(TARGET)

# Rebuild target
rebuild : clean all
