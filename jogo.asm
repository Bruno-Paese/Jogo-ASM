.model small

.stack 1000H ; define a stack of 256 bytes (100H)

.data
    videoMemStart equ 0A000h
    screenWidth equ 320 ; Width of the screen in pixels
    pixelColor equ 5  ; Color attribute (e.g., white)

.code

SET_VIDEO_MODE proc
    mov ax, 13h
    int 10h ; Set the video mode to mode 13h (320x200, 256 colors)
    ret
endp

PRINT_PIXEL_ROW proc
    mov cx, screenWidth ; Number of pixels in a row

    mov ax, 320          
    mov di,ax             
    
    ; Fill the row with pixels
    mov al, pixelColor ; Set the pixel color

    rep stosb ; Repeat the store operation to write pixels

    ret
endp

INICIO:
    mov ax, @data
    mov ds, ax
    mov ax, videoMemStart
    mov es, ax

    call SET_VIDEO_MODE
    
    call PRINT_PIXEL_ROW

    mov ax, 4Ch ; Function to terminate the program
    int 21h ; Execute
end INICIO
