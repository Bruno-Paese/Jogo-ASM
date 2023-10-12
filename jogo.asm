.model small

.stack 100H ; define a stack of 256 bytes (100H)

.data
    ;Sprites
    spaceshipSprite db 0,0,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0,0,0Fh,3,3,3,0,0,0,0,0,0Fh,3,3,0Fh,0,0,0,0,0,0,3,3,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,3,0Fh,0Fh,0Fh,0Fh,1,1,0Fh,0Fh,0Fh,3,0Fh,0Fh,0Fh,0Fh,1,1,0Fh,0Fh,0Fh,3,3,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0Fh,3,3,0Fh,0,0,0,0,0,0,0,0Fh,3,3,3,0,0,0,0,0,0,0,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0    
    asteroidSprite db 0,0,7,7,7,7,7,7,0,0,0,7,7,8,8,8,7,7,7,0,7,7,8,8,8,8,7,7,7,7,7,8,8,8,8,7,7,7,8,7,7,8,8,8,7,7,7,8,8,7,7,8,8,7,7,7,8,8,8,7,7,7,7,7,7,8,8,8,8,7,7,7,7,8,8,8,8,8,7,7,0,7,7,7,8,8,8,7,7,0,0,0,7,7,7,7,7,7,0,0,0
    shieldSprite db 0,0,0,1,1,1,1,0,0,0,0,0,1,0Fh,0Fh,0Fh,0Fh,1,0,0,0,1,0Fh,1,1,1,1,0Fh,1,0,1,0Fh,1,1,1,1,1,1,0Fh,1,1,0Fh,3,3,3,3,3,3,0Fh,1,1,0Fh,3,3,3,3,3,3,0Fh,1,1,0Fh,0Fh,3,3,3,3,0Fh,0Fh,1,0,1,0Fh,0Fh,3,3,0Fh,0Fh,1,0,0,0,1,0Fh,0Fh,0Fh,0Fh,1,0,0,0,0,0,1,1,1,1,0,0,0
    healthSprite db 0,0,0,2,2,2,2,0,0,0,0,0,2,0Fh,0Fh,0Fh,0Fh,2,0,0,0,2,0Fh,0Fh,2,2,0Fh,0Fh,2,0,2,0Fh,0Fh,0Fh,2,2,0Fh,0Fh,0Fh,2,2,0Fh,2,2,2,2,2,2,0Fh,2,2,0Fh,2,2,2,2,2,2,0Fh,2,2,0Fh,0Fh,0Fh,2,2,0Fh,0Fh,0Fh,2,0,2,0Fh,0Fh,2,2,0Fh,0Fh,2,0,0,0,2,0Fh,0Fh,0Fh,0Fh,2,0,0,0,0,0,2,2,2,2,0,0,0
    
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
    
    ;timer
    timer dw 1300
    timeBarScaleDecrement equ 10
    timeScaleInterval equ 100
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
    push di
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
    pop di
    ret
endp

;Bloqueia a execu??o do programa na quantidade definida
;na constante timeScaleInterval
BLOCK_GAME_EXECUTION proc
    push cx

    xor cx, cx
    mov cx, timeScaleInterval
    int 15h
    
    pop cx
    ret
endp

MAIN_LOOP proc
    
    
    
    ret
endp

;Recebe sprite em SI
;DI recebe a posi??o do primeiro pixel do sprite
PRINT_SPRITE proc
        push dx
        push cx
        push di
        push si

        mov dx, 10
        PRINT_SPRITE_LOOP:
            mov cx, 10
            rep movsb 
            dec dx
            add di, 310
            cmp dx, 0
            jnz PRINT_SPRITE_LOOP
         
        pop si
        pop di
        pop cx
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

    mov si, offset healthSprite
    mov di, 0
    call PRINT_SPRITE
    
    mov ax, 4Ch     ; Function to terminate the program
    int 21h         ; Execute
end INICIO
