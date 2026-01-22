.section .text

@ SetPixel function - draws a single pixel
@ r0: x coordinate
@ r1: y coordinate  
@ r2: color (16-bit)
.globl SetPixel
SetPixel:
    px .req r0
    py .req r1
    
    @ Validate coordinates
    cmp px,#1024
    cmpls py,#768
    movhi pc,lr
    
    @ Get framebuffer address
    push {r0-r3,lr}
    ldr r0,=FrameBufferInfo
    ldr r0,[r0,#32]
    pop {r0-r3,lr}
    
    @ Check if framebuffer is valid
    teq r0,#0
    moveq pc,lr
    
    @ Calculate pixel address: addr = fbAddr + (y * width + x) * 2
    ldr r3,[r0,#-32+8]  @ Load width from FrameBufferInfo
    mla px,py,r3,px
    .unreq py
    add r0,px,lsl #1
    .unreq px
    
    @ Store pixel color
    strh r2,[r0]
    
    mov pc,lr


@ DrawLine function - draws a line between two points
@ r0: x0 (start x)
@ r1: y0 (start y)
@ r2: x1 (end x)
@ r3: y1 (end y)
@ Stack: color
.globl DrawLine
DrawLine:
    push {r4,r5,r6,r7,r8,r9,r10,r11,r12,lr}
    x0 .req r9
    x1 .req r10
    y0 .req r11  
    y1 .req r12
    
    mov x0,r0
    mov x1,r2
    mov y0,r1
    mov y1,r3
    
    @ dx = abs(x1 - x0)
    dx .req r4
    sub dx,x1,x0
    cmp dx,#0
    rsblt dx,dx,#0
    
    @ dy = abs(y1 - y0)
    dy .req r5
    sub dy,y1,y0
    cmp dy,#0
    rsblt dy,dy,#0
    
    @ sx = x0 < x1 ? 1 : -1
    sx .req r6
    cmp x0,x1
    movlt sx,#1
    movge sx,#-1
    
    @ sy = y0 < y1 ? 1 : -1
    sy .req r7
    cmp y0,y1
    movlt sy,#1
    movge sy,#-1
    
    @ err = dx - dy
    err .req r8
    sub err,dx,dy
    
    ldr r0,[sp,#40]  @ Load color from stack
    color .req r0
    
    drawPixelLoop$:
        @ SetPixel(x0, y0, color)
        push {r0-r3}
        mov r0,x0
        mov r1,y0
        mov r2,color
        bl SetPixel
        pop {r0-r3}
        
        @ Check if we've reached the end point
        teq x0,x1
        teqeq y0,y1
        beq drawLineEnd$
        
        @ e2 = 2 * err
        e2 .req r3
        mov e2,err,lsl #1
        
        @ if (e2 > -dy)
        neg .req r2
        rsb neg,dy,#0
        cmp e2,neg
        .unreq neg
        addle err,dy
        addle x0,sx
        
        @ if (e2 < dx)
        cmp e2,dx
        .unreq e2
        addlt err,dx
        addlt y0,sy
        
        b drawPixelLoop$
    
    drawLineEnd$:
    .unreq x0
    .unreq x1
    .unreq y0
    .unreq y1
    .unreq dx
    .unreq dy
    .unreq sx
    .unreq sy
    .unreq err
    .unreq color
    
    pop {r4,r5,r6,r7,r8,r9,r10,r11,r12,pc}


@ DrawCircle function - draws a circle
@ r0: cx (center x)
@ r1: cy (center y)
@ r2: radius
@ r3: color
.globl DrawCircle
DrawCircle:
    push {r4,r5,r6,r7,r8,lr}
    cx .req r4
    cy .req r5
    radius .req r6
    color .req r7
    
    mov cx,r0
    mov cy,r1
    mov radius,r2
    mov color,r3
    
    x .req r0
    y .req r1
    mov x,radius
    mov y,#0
    
    err .req r8
    rsb err,radius,#1
    
    circleLoop$:
        @ Plot 8 symmetric points
        push {r0-r3}
        
        @ (cx + x, cy + y)
        add r0,cx,x
        add r1,cy,y
        mov r2,color
        bl SetPixel
        
        @ (cx + y, cy + x)
        add r0,cx,y
        add r1,cy,x
        mov r2,color
        bl SetPixel
        
        @ (cx - y, cy + x)
        sub r0,cx,y
        add r1,cy,x
        mov r2,color
        bl SetPixel
        
        @ (cx - x, cy + y)
        sub r0,cx,x
        add r1,cy,y
        mov r2,color
        bl SetPixel
        
        @ (cx - x, cy - y)
        sub r0,cx,x
        sub r1,cy,y
        mov r2,color
        bl SetPixel
        
        @ (cx - y, cy - x)
        sub r0,cx,y
        sub r1,cy,x
        mov r2,color
        bl SetPixel
        
        @ (cx + y, cy - x)
        add r0,cx,y
        sub r1,cy,x
        mov r2,color
        bl SetPixel
        
        @ (cx + x, cy - y)
        add r0,cx,x
        sub r1,cy,y
        mov r2,color
        bl SetPixel
        
        pop {r0-r3}
        
        @ Check if done
        cmp y,x
        bgt circleEnd$
        
        @ Update y
        add y,#1
        
        @ Update error
        cmp err,#0
        addlt err,y,lsl #1
        sublt err,#1
        blt circleLoop$
        
        @ Update x and error
        sub x,#1
        sub r3,y,x
        add err,r3,lsl #1
        add err,#1
        
        b circleLoop$
    
    circleEnd$:
    .unreq cx
    .unreq cy
    .unreq radius
    .unreq color
    .unreq x
    .unreq y
    .unreq err
    
    pop {r4,r5,r6,r7,r8,pc}