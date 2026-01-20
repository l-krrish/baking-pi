# Raspberry Pi OS - Baking Pi Tutorial (Lessons 1-6)

A bare-metal operating system for Raspberry Pi built from scratch using ARM assembly language.

## Project Overview

This project implements a minimal operating system following Cambridge University's "Baking Pi" tutorial series. It demonstrates low-level hardware programming without any existing OS layer.

## Features Implemented

- **Lesson 1-2 (OK01-OK02)**: GPIO control and LED blinking
- **Lesson 3 (OK03)**: Functions, stack management, and code organization
- **Lesson 4 (OK04)**: System timer for precise delays
- **Lesson 5 (OK05)**: Data storage and pattern sequences
- **Lesson 6 (Screen01)**: Framebuffer graphics and screen output

## File Structure

```
baking-pi/
├── source/
│   ├── main.s              # Main program entry and rendering loop
│   ├── gpio.s              # GPIO controller functions
│   ├── systemTimer.s       # System timer functions
│   ├── mailbox.s           # Mailbox communication with GPU
│   └── framebuffer.s       # Framebuffer initialization
├── build/                  # Compiled object files (generated)
├── Makefile                # Build automation
├── kernel.ld               # Linker script
└── kernel.img              # Final kernel image (generated)
```

## Prerequisites

### WSL/Linux
```bash
sudo apt-get update
sudo apt-get install gcc-arm-none-eabi make qemu-system-arm
```

## Building

```bash
# Clean build
make clean

# Compile
make
```

This generates `kernel.img` which can be run on Raspberry Pi or in QEMU.

## Testing in QEMU

```bash
qemu-system-arm -m 1024 -M raspi2b -kernel kernel.img -serial stdio
```

You should see a colorful gradient pattern on the screen!

## How It Works

1. **Boot**: The Raspberry Pi loads `kernel.img` at address 0x8000
2. **Initialization**: Sets up stack pointer and initializes framebuffer
3. **GPU Communication**: Uses mailbox to request framebuffer from GPU
4. **Rendering**: Continuously draws pixels to screen memory
5. **Display**: GPU reads framebuffer and outputs to screen

## Technical Details

- **Architecture**: ARMv6 (Raspberry Pi 1)
- **Assembler**: GNU ARM Assembler (arm-none-eabi-as)
- **Display Mode**: High Color (16-bit, 65,536 colors)
- **Resolution**: 1024x768 pixels
- **Memory Layout**: Code at 0x8000, stack grows down from 0x8000

## Key Concepts Learned

- ARM assembly language and instruction set
- Bare-metal hardware programming
- Memory-mapped I/O
- Function calling conventions (ABI)
- Stack management
- Hardware timers
- DMA and GPU communication
- Framebuffer graphics

## Next Steps

Continue with:
- **Screen02-04**: Drawing lines, text, and terminal output
- **Input01-02**: Keyboard and mouse input

## Resources

- [Baking Pi Tutorial](https://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/)
- [ARM Architecture Reference Manual](https://developer.arm.com/documentation/)
- [BCM2835 Peripherals Guide](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bcm2835/README.md)

## License

Educational project following Cambridge University's Baking Pi tutorial.