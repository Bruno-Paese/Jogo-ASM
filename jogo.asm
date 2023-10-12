.model small

.stack 100H ; define a stack of 256 bytes (100H)

.data
    ;Locais de inicio de v?deo
    videoMemStart equ 0A000h
    uiRegionStart equ 57600
    uiHealthBarStart equ 59205
    
    ;UI widths
    healthBarWidth dw 130
    
    
    screenWidth equ 320
    screenHeight equ 200
    
    ;UI colors
    uiBackgroundColor equ 7 ; Color attribute (e.g., white)
    uiHealthBarColor equ 4 ; Color attribute (e.g., white)
.code

SET_VIDEO_MODE proc
    mov ax, 13h
    int 10h         ; Set the video mode to mode 13h (320x200, 256 colors)
    ret
endp

PRINT_UI proc
   
    mov di, uiRegionStart   ; Starting offset in video memory

    ; Fill the row with pixels
    
    xor bx, bx
    mov dx, 20
    
    LOOP_UI_BACKGROUND:
        mov al, uiBackgroundColor   ; Set the pixel color
        mov cx, screenWidth         ; Number of pixels in a row
        rep stosb                   ; Repeat the store operation to write pixels
        dec dx
        cmp dx, bx
        jne LOOP_UI_BACKGROUND
    
    mov dx, 10
    mov di, uiHealthBarStart
    LOOP_UI_HEALTHBAR:
        mov al, uiHealthBarColor
        mov cx, healthBarWidth
        rep stosb
        add di, screenWidth          ; Repeat the store operation to write pixels
        sub di, healthBarWidth
        dec dx
        cmp dx, bx
        jne LOOP_UI_HEALTHBAR
    ret
endp

INICIO:
    mov ax, @data
    mov ds, ax
    mov ax, videoMemStart
    mov es, ax

    call SET_VIDEO_MODE

    call PRINT_UI

    mov ax, 4Ch     ; Function to terminate the program
    int 21h         ; Execute
end INICIO
