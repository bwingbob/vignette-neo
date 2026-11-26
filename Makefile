CA65 ?= ca65
LD65 ?= ld65
PYTHON ?= python3

SRC_DIR := src
BUILD_DIR := build
DIST_DIR := dist
CFG := cfg/neo.cfg

SOURCES := $(SRC_DIR)/main.s $(SRC_DIR)/api.s $(SRC_DIR)/input.s $(SRC_DIR)/rooms.s
OBJECTS := $(BUILD_DIR)/main.o $(BUILD_DIR)/api.o $(BUILD_DIR)/input.o $(BUILD_DIR)/rooms.o

TARGET_BIN := $(BUILD_DIR)/vignette.bin
TARGET_NEO := $(DIST_DIR)/vignette.neo

.PHONY: all clean dirs

all: dirs $(TARGET_NEO)

dirs:
	@mkdir -p $(BUILD_DIR) $(DIST_DIR)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.s $(SRC_DIR)/neo.inc
	$(CA65) -I $(SRC_DIR) -t none -o $@ $<

$(TARGET_BIN): $(OBJECTS) $(CFG)
	$(LD65) -C $(CFG) -o $@ $(OBJECTS)

$(TARGET_NEO): $(TARGET_BIN) tools/make_neo.py
	$(PYTHON) tools/make_neo.py $< $@ --load 0x1000 --exec 0x1000 --comment "Vignette MVP"

clean:
	rm -rf $(BUILD_DIR) $(DIST_DIR)
