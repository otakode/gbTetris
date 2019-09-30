RGBDS_PATH = Tools\rgbds\ 
SRC_PATH = Sources\ 
BUILD_PATH = Build\ 

# Specify remover
RM = del

# Specify assembler
AS = $(RGBDS_PATH)rgbasm.exe
AFLAGS = -i $(SRC_PATH)

# Specify linker
LINK = $(RGBDS_PATH)rgblink.exe

# Specify fixer
FIX = $(RGBDS_PATH)rgbfix.exe

TARGET_NAME=Project
TARGET = $(BUILD_PATH)$(TARGET_NAME).gb
SYM = $(BUILD_PATH)$(TARGET_NAME).sym

SRC = main.asm

OBJ = $(BUILD_PATH)$(SRC:.asm=.o)

{$(SRC_PATH)}.asm{$(BUILD_PATH)}.o:
	$(AS) $(AFLAGS) -o $@ $<

all : $(OBJ)
	$(LINK) -o $(TARGET) -n $(SYM) $(OBJ)
	$(FIX) -v -p 0 $(TARGET)

# Clean target
clean :
#	$(RM) $(OBJ) $(TARGET)

# Rebuild target
rebuild : clean all
