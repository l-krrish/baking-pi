.section .init
.globl _start
_start:
    b main

.section .text
main:
    mov sp,#0x8000

    @ Set GPIO 16 to output
    pinNum .req r0
    pinFunc .req r1
    mov pinNum,#16
    mov pinFunc,#1
    bl SetGpioFunction
    .unreq pinNum
    .unreq pinFunc

    @ Load the pattern
    ptrn .req r4
    ldr ptrn,=pattern
    ldr ptrn,[ptrn]
    seq .req r5
    mov seq,#0

loop$:
    @ Calculate if LED should be on or off
    mov r1,#1
    lsl r1,seq
    and r1,ptrn

    @ Set LED based on pattern bit
    pinNum .req r0
    pinVal .req r1
    mov pinNum,#16
    bl SetGpio
    .unreq pinNum
    .unreq pinVal

    @ Wait 250,000 microseconds (0.25 seconds)
    ldr r0,=250000
    bl Wait

    @ Increment sequence and wrap at 32
    add seq,#1
    and seq,#31

    b loop$

.section .data
.align 2
pattern:
.int 0b11111111101010100010001000101010
