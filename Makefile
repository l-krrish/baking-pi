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

$(BUILD)mailbox.o: $(SOURCE)mailbox.s
	$(ARMGNU)-as -I $(SOURCE) $(SOURCE)mailbox.s -o $(BUILD)mailbox.o

$(BUILD)framebuffer.o: $(SOURCE)framebuffer.s
	$(ARMGNU)-as -I $(SOURCE) $(SOURCE)framebuffer.s -o $(BUILD)framebuffer.o

kernel.img: $(BUILD)main.o $(BUILD)gpio.o $(BUILD)systemTimer.o $(BUILD)mailbox.o $(BUILD)framebuffer.o
	$(ARMGNU)-ld --no-undefined $(BUILD)main.o $(BUILD)gpio.o $(BUILD)systemTimer.o $(BUILD)mailbox.o $(BUILD)framebuffer.o -o $(BUILD)output.elf -T kernel.ld
	$(ARMGNU)-objcopy $(BUILD)output.elf -O binary kernel.img