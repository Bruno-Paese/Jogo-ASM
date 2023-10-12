.model small

.stack 100H ; define a stack of 256 bytes (100H)

.data
    ;Sprites
    spaceshipSprite db "00FFFFF000 0F33300000 F33F000000 33FFFFFF00 3FFFF11FFF 3FFFF11FFF 33FFFFFF00 F33F000000 0F33300000?00FFFFF000"
    asteroidSprite db "0077777700 0778887770 7788887777 7888877787 7888777887 7887778887 7777788887 7778888877 0777888770?0077777700"
    shieldSprite db "0001111000 001FFFF100 01F1111F10 1F111111F1 1F333333F1 1F333333F1 1FF3333FF1 01FF33FF10 001FFFF100??0001111000"
    healthSprite db "0002222000 0021111200 02FF22FF20 2FFF22FFF2 2F222222F2 2F222222F2 2FFF22FFF2 02FF22FF20 0021111200?0002222000"
    
    ;Locais de inicio de v?deo
    videoMemStart equ 0A000h
    uiRegionStart equ 57600
    uiHealthBarStart equ 59205
    uiTimeBarStart equ 59385
    
    ;UI widths
    healthBarWidth dw 130
    timeBarWidth dw 130
    
    
    screenWidth equ 320
    screenHeight equ 200
    
    ;UI colors
    uiBackgroundColor equ 7 
    uiHealthBarColor equ 4
    uiTimeBarColor equ 11 
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
    mov al, uiHealthBarColor
    mov cx, healthBarWidth
    
    call PRINT_UI_BAR
        
    mov dx, 10
    mov di, uiTimeBarStart
    mov al, uiTimeBarColor
    mov cx, timeBarWidth
    
    call PRINT_UI_BAR

    ret
endp

; Proc para escrever uma barra na UI
; Recebe altura em DX
; Recebe em DI o Endere?o de inicio
; Recebe a largura da barra em CX
; Recebe em AL a cor
PRINT_UI_BAR proc

    push dx

    LOOP_UI_BAR:
        push cx
        rep stosb
        pop cx
        add di, screenWidth
        sub di, cx
        dec dx
        cmp dx, bx
        jne LOOP_UI_BAR
        
    pop dx
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
