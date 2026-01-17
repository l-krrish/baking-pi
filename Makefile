ARMGNU ?= arm-none-eabi

COPS = -Wall -nostdlib -nostartfiles -ffreestanding
ASMOPS = -Iinclude

BUILD = build/
SOURCE = source/

all: kernel.img

clean:
	rm -rf $(BUILD)
	mkdir $(BUILD)

$(BUILD)main.o: $(SOURCE)main.s
	$(ARMGNU)-as -I $(SOURCE) $(SOURCE)main.s -o $(BUILD)main.o

kernel.img: $(BUILD)main.o
	$(ARMGNU)-ld --no-undefined $(BUILD)main.o -o $(BUILD)output.elf -T kernel.ld
	$(ARMGNU)-objcopy $(BUILD)output.elf -O binary kernel.img