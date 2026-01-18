ARMGNU ?= arm-none-eabi

BUILD = build/
SOURCE = source/

all: kernel.img

clean:
	rm -rf $(BUILD)
	mkdir $(BUILD)

$(BUILD)main.o: $(SOURCE)main.s
	$(ARMGNU)-as -I $(SOURCE) $(SOURCE)main.s -o $(BUILD)main.o

$(BUILD)gpio.o: $(SOURCE)gpio.s
	$(ARMGNU)-as -I $(SOURCE) $(SOURCE)gpio.s -o $(BUILD)gpio.o

$(BUILD)systemTimer.o: $(SOURCE)systemTimer.s
	$(ARMGNU)-as -I $(SOURCE) $(SOURCE)systemTimer.s -o $(BUILD)systemTimer.o

kernel.img: $(BUILD)main.o $(BUILD)gpio.o $(BUILD)systemTimer.o
	$(ARMGNU)-ld --no-undefined $(BUILD)main.o $(BUILD)gpio.o $(BUILD)systemTimer.o -o $(BUILD)output.elf -T kernel.ld
	$(ARMGNU)-objcopy $(BUILD)output.elf -O binary kernel.img