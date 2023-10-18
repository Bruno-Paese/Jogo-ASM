.model medium

.stack 100H ; define a stack of 256 bytes (100H)

.data
    ;Sprites
    spaceshipSprite db 0,0,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0,0,0Fh,3,3,3,0,0,0,0,0,0Fh,3,3,0Fh,0,0,0,0,0,0,3,3,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,3,0Fh,0Fh,0Fh,0Fh,1,1,0Fh,0Fh,0Fh,3,0Fh,0Fh,0Fh,0Fh,1,1,0Fh,0Fh,0Fh,3,3,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0Fh,3,3,0Fh,0,0,0,0,0,0,0,0Fh,3,3,3,0,0,0,0,0,0,0,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0    
    asteroidSprite db 0,0,7,7,7,7,7,7,0,0,0,7,7,8,8,8,7,7,7,0,7,7,8,8,8,8,7,7,7,7,7,8,8,8,8,7,7,7,8,7,7,8,8,8,7,7,7,8,8,7,7,8,8,7,7,7,8,8,8,7,7,7,7,7,7,8,8,8,8,7,7,7,7,8,8,8,8,8,7,7,0,7,7,7,8,8,8,7,7,0,0,0,7,7,7,7,7,7,0,0,0
    shieldSprite db 0,0,0,1,1,1,1,0,0,0,0,0,1,0Fh,0Fh,0Fh,0Fh,1,0,0,0,1,0Fh,1,1,1,1,0Fh,1,0,1,0Fh,1,1,1,1,1,1,0Fh,1,1,0Fh,3,3,3,3,3,3,0Fh,1,1,0Fh,3,3,3,3,3,3,0Fh,1,1,0Fh,0Fh,3,3,3,3,0Fh,0Fh,1,0,1,0Fh,0Fh,3,3,0Fh,0Fh,1,0,0,0,1,0Fh,0Fh,0Fh,0Fh,1,0,0,0,0,0,1,1,1,1,0,0,0
    healthSprite db 0,0,0,2,2,2,2,0,0,0,0,0,2,0Fh,0Fh,0Fh,0Fh,2,0,0,0,2,0Fh,0Fh,2,2,0Fh,0Fh,2,0,2,0Fh,0Fh,0Fh,2,2,0Fh,0Fh,0Fh,2,2,0Fh,2,2,2,2,2,2,0Fh,2,2,0Fh,2,2,2,2,2,2,0Fh,2,2,0Fh,0Fh,0Fh,2,2,0Fh,0Fh,0Fh,2,0,2,0Fh,0Fh,2,2,0Fh,0Fh,2,0,0,0,2,0Fh,0Fh,0Fh,0Fh,2,0,0,0,0,0,2,2,2,2,0,0,0
    
    ;GameName
    gameName db "  ___      _                 _     _   _    _ ", 0
             db " / _ \    | |               (_)   | | | |  | |", 0
             db "/ /\ \___| | ___ _ __ ___  _  __| | | |  | | __ _ _   _", 0
             db "|  _  / __| __/ _ \ '__/ _ \| |/ _` | | |/\| |/ _` | | | |", 0
             db "| | | \__ \ ||  __/ | | (_) | | (_| | \  /\  / (_| | |_| |", 0
             db "\_| |_/___/\__\___|_|  \___/|_|\__,_|  \/  \/ \__,_|\__, |", 0
             db "                                                     __/ |", 0
             db "                                                    |___/", 0
    
    ;Locais de inicio de v?deo
    videoMemStart equ 0A000h
    uiRegionStart equ 57600
    uiHealthBarStart equ 59205
    uiTimeBarStart equ 59385
    playerInitialPosition equ 30420
    playerPositionY equ 30420
    
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
    timeBarScaleDecrement equ 1
    timeScaleIntervalCX equ 1
    timeScaleIntervalDX equ 086A0h
.code

SET_VIDEO_MODE proc
    mov ax, 13h
    int 10h         ; Set the video mode to mode 13h (320x200, 256 colors)
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

;Bloqueia a execu??o do programa na quantidade definida
;na constante timeScaleInterval
BLOCK_GAME_EXECUTION proc
    push cx
    push dx
    push ax
    
    mov ah, 86h
    mov cx, timeScaleIntervalCX
    mov dx, timeScaleIntervalDX
    int 15h
    
    pop ax
    pop dx
    pop cx
    ret
endp

GAME_TIMER proc
    push ax
    push dx
    push cx
    
    mov ax, timer
    sub ax, timeBarScaleDecrement
    mov timer, ax

    xor dx, dx  ; Clear DX
    mov cx, 10  ; Divisor
    div cx      ; Divide AX by 10, result in AX, remainder in DX

    mov timeBarWidth, ax
    
    ; Clear the remaining time bar space with the background color
    mov dx, 10
    mov di, uiTimeBarStart
    mov al, uiBackgroundColor
    mov cx, 130  ; Use the constant for the width
    call PRINT_UI_BAR
    
    mov dx, 10
    mov di, uiTimeBarStart
    mov al, uiTimeBarColor
    mov cx, timeBarWidth  ; Use the constant for the width
    call PRINT_UI_BAR

    cmp cx, 0
    jne SKIP_END_CONDITION
    MOV SI, 1
    
    
    SKIP_END_CONDITION:
        pop cx
        pop dx
        pop ax
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
            rep stosb 
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

;Removes a sprite from the screen
;DI recebe a posi??o do primeiro pixel do sprite
REMOVE_SPRITE proc
        push ax
        push dx
        push cx
        push di
        push si

        mov dx, 10
        mov al, 0
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
        pop ax
    ret
endp

READ_KEYBOARD_INPUT proc
    
    mov ah, 01
    int 16h
    jnz END_KI
    
    cmp al, 119
    jz PLAYER_UP
    
    PLAYER_UP:
        mov ax, playerPositionY
        sub ax, screenWidth
        mov playerPositionY, ax

    END_KI:
    ret
endp

PRINT_PLAYER proc
    
    mov SI, offset spaceShipSprite
    mov DI, playerPositionY

    call REMOVE_SPRITE
    
    call READ_KEYBOARD_INPUT
    
    call PRINT_SPRITE
    
    ret
endp

MAIN_GAME proc

    xor SI, SI
    MAIN_LOOP:
    
        call GAME_TIMER
        call PRINT_PLAYER
        
        call BLOCK_GAME_EXECUTION
    
        cmp SI, 1
        jne MAIN_LOOP
    ret
endp

INICIO:
    mov ax, @data
    mov ds, ax
    mov ax, videoMemStart
    mov es, ax

    call SET_VIDEO_MODE

    call PRINT_UI
    
    call MAIN_GAME
    

    mov ax, 4Ch     ; Function to terminate the program
    int 21h         ; Execute
end INICIO
