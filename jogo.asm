               .model medium

.stack 100H ; define a stack of 256 bytes (100H)

.data

    ;Controles / códigos ASCII
    upArrow equ 4800h
    downArrow equ 5000h
    accept equ 1C0Dh ; ENTER (enter is a reserved word)
    CR equ 13
    LF equ 10
 
    ;Menu Inicial
    ;41x14
    gameName db "    ___      _                 _     _ ", CR, LF
             db "   / _ \    | |               (_)   | |", CR, LF
             db "  / /_\ \___| |_ ___ _ __ ___  _  __| |", CR, LF
             db "  |  _  / __| __/ _ \ '__/ _ \| |/ _` |", CR, LF
             db "  | | | \__ \ ||  __/ | | (_) | | (_| |", CR, LF
             db "  \_| |_/___/\__\___|_|  \___/|_|\__,_|", CR, LF
             db "          _    _                       ", CR, LF
             db "         | |  | |                      ", CR, LF
             db "         | |  | | __ _ _   _           ", CR, LF
             db "         | |/\| |/ _` | | | |          ", CR, LF
             db "         \  /\  / (_| | |_| |          ", CR, LF
             db "          \/  \/ \__,_|\__, |          ", CR, LF
             db "                        __/ |          ", CR, LF
             db "                       |___/           ", CR, LF
    
    jogar db "Jogar"
    sair db "Sair"
    selectedOption db "[] "
    
    ;Sprites
    spaceshipSprite db 0,0,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0,0,0Fh,3,3,3,0,0,0,0,0,0Fh,3,3,0Fh,0,0,0,0,0,0,3,3,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,3,0Fh,0Fh,0Fh,0Fh,1,1,0Fh,0Fh,0Fh,3,0Fh,0Fh,0Fh,0Fh,1,1,0Fh,0Fh,0Fh,3,3,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0Fh,3,3,0Fh,0,0,0,0,0,0,0,0Fh,3,3,3,0,0,0,0,0,0,0,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0    
    asteroidSprite db 0,0,7,7,7,7,7,7,0,0,0,7,7,8,8,8,7,7,7,0,7,7,8,8,8,8,7,7,7,7,7,8,8,8,8,7,7,7,8,7,7,8,8,8,7,7,7,8,8,7,7,8,8,7,7,7,8,8,8,7,7,7,7,7,7,8,8,8,8,7,7,7,7,8,8,8,8,8,7,7,0,7,7,7,8,8,8,7,7,0,0,0,7,7,7,7,7,7,0,0,0
    shieldSprite db 0,0,0,1,1,1,1,0,0,0,0,0,1,0Fh,0Fh,0Fh,0Fh,1,0,0,0,1,0Fh,1,1,1,1,0Fh,1,0,1,0Fh,1,1,1,1,1,1,0Fh,1,1,0Fh,3,3,3,3,3,3,0Fh,1,1,0Fh,3,3,3,3,3,3,0Fh,1,1,0Fh,0Fh,3,3,3,3,0Fh,0Fh,1,0,1,0Fh,0Fh,3,3,0Fh,0Fh,1,0,0,0,1,0Fh,0Fh,0Fh,0Fh,1,0,0,0,0,0,1,1,1,1,0,0,0
    healthSprite db 0,0,0,2,2,2,2,0,0,0,0,0,2,0Fh,0Fh,0Fh,0Fh,2,0,0,0,2,0Fh,0Fh,2,2,0Fh,0Fh,2,0,2,0Fh,0Fh,0Fh,2,2,0Fh,0Fh,0Fh,2,2,0Fh,2,2,2,2,2,2,0Fh,2,2,0Fh,2,2,2,2,2,2,0Fh,2,2,0Fh,0Fh,0Fh,2,2,0Fh,0Fh,0Fh,2,0,2,0Fh,0Fh,2,2,0Fh,0Fh,2,0,0,0,2,0Fh,0Fh,0Fh,0Fh,2,0,0,0,0,0,2,2,2,2,0,0,0
    
    ;Locais de inicio de video
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

;-----------------------------------------------------------------------------------------------;
;                                                                                               ;
;  FUNCOES DE USO GERAL                                                                         ;
;                                                                                               ;
;-----------------------------------------------------------------------------------------------;

; Sem parametros
; Destroi ax
SET_VIDEO_MODE proc
    mov ax, 13h
    int 10h         ; Set the video mode to mode 13h (320x200, 256 colors)
    ret
endp

; Parametros 
; SI: Sprite (memoria)
; DI: Posicao do primeiro pixel do sprite
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

; Parametros:
; bp: Rndereço da memória com texto a ser escrito
; dh: Linha
; dl: Coluna
; cx: Tamanho da string
; bl: Cor do texto
PRINT_TEXT proc
    push es
    push ax
    push bx
    push di
    push si
    push bp

    mov di, sp
      
    mov ax, ds    
    mov es, ax
    
    mov bh, 0
    
    mov ah, 13h
    mov al, 1
    int 10h ; Registers destroyed: AX, SP, BP, SI
    
    mov sp, di
    pop bp
    pop si
    pop di
    pop bx
    pop ax
    pop es
    ret
endp

;-----------------------------------------------------------------------------------------------;
;                                                                                               ;
;  FUNCOES DO MENU INICIAL                                                                      ;
;                                                                                               ;
;-----------------------------------------------------------------------------------------------;

; Sem parametros
PRINT_GAME_NAME proc
    
    push bp
    push dx
    push cx
    push bx

    mov bp, offset gameName ; Text to print
    mov dh, 0 ; Line to print
    mov dl, 0 ; Column to print
    mov cx, 574 ; Size of string printed
    mov bl, 50 ; Color
    
    call PRINT_TEXT
    
    pop bx
    pop cx
    pop dx
    pop bp
    ret
endp

; Sem parametros
PRINT_OPTIONS proc

    push bp
    push dx
    push cx
    push bx
    
    mov bp, offset jogar ; Text to print
    mov dh, 20 ; Line to print
    mov dl, 17 ; Column to print
    mov cx, 5 ; Size of string printed
    mov bl, 15 ; Color
    call PRINT_TEXT

    mov bp, offset sair ; Text to print
    mov dh, 22 ; Line to print
    mov dl, 17 ; Column to print
    mov cx, 4 ; Size of string printed
    mov bl, 15 ; Color
    call PRINT_TEXT
    
    pop bx
    pop cx
    pop dx
    pop bp
    
    ret
endp

; Parametros
; bh: opcao selecionada 
;   zero: Jogar
;   qualquer outra coisa: Sair
PRINT_OPTION_SELECTED proc
    push ax
    push bp
    push dx
    push cx
    push bx
    
    
    ; Determina qual linha esta selecionada
    or bh, bh
    jz PRINT_OPTION_SELECTED_JOGAR
    ; Sair selecionado (Configura a linha)
    mov dh, 22 ; Line to print selected
    mov al, 20 ; Line to print deselected
    jmp PRINT_OPTION_SELECTED_PRINT
    PRINT_OPTION_SELECTED_JOGAR:
    ; Jogar Selecionado (Configura a linha)
    mov dh, 20 ; Line to print selected
    mov al, 22 ; Line to print deselected   
    
    PRINT_OPTION_SELECTED_PRINT:
    ; Printar colchetes
    mov bp, offset selectedOption ; Text to print
    mov dl, 15 ; Column to print
    mov bl, 15 ; Color
    mov cx, 1 ; Size of string printed
    call PRINT_TEXT
    mov dl, 23 ; Column to print
    inc bp ; Para printar o segundo caracter (])
    call PRINT_TEXT
    
    ; Remover colchetes anteriores
    inc bp ; Para printar o terceiro caracter ( )
    mov dl, 15
    mov dh, al
    call PRINT_TEXT
    mov dl, 23
    call PRINT_TEXT
    
    
    pop bx
    pop cx
    pop dx
    pop bp
    pop ax
    ret
endp

; Sem parametros
; Retorno
; bh 
;   zero: sair
;   um: jogar
; Destroi BX
MENU_INICIAL proc
    ; TODO: salvar contexto
    call PRINT_GAME_NAME  

    mov si, offset spaceshipSprite
    mov di, 40400
    call PRINT_SPRITE

    mov si, offset asteroidSprite
    add di, 50
    call PRINT_SPRITE
    
    mov si, offset healthSprite
    add di, 50
    call PRINT_SPRITE
    
    mov si, offset shieldSprite
    add di, 50
    call PRINT_SPRITE
    
    call PRINT_OPTIONS
    
    xor bh, bh ; Seta opcao para Jogar
    
    MENU_INICIAL_CONTROLE:
    call PRINT_OPTION_SELECTED
    mov ah, 00h   ; Input do teclado (considera as setas)
    int 16h
    
    ; Enter
    cmp ax, accept 
    jz MENU_INICIAL_ACCEPT
    
    ; Seta para cima ou para baixo
    cmp ax, upArrow 
    jz MENU_INICIAL_TOGGLE_OPTION
    cmp ax, downArrow
    jz MENU_INICIAL_TOGGLE_OPTION
    
    ; Qualquer outra tecla
    jmp MENU_INICIAL_CONTROLE
    
    ; Acao das setas
    MENU_INICIAL_TOGGLE_OPTION:
    not bh
    jmp MENU_INICIAL_CONTROLE
    
    ; Acao de aceitar
    MENU_INICIAL_ACCEPT:
    ret
endp

;-----------------------------------------------------------------------------------------------;
;                                                                                               ;
;  FUNCOES DO JOGO                                                                              ;
;                                                                                               ;
;-----------------------------------------------------------------------------------------------;

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
        REMOVE_SPRITE_LOOP:
            mov cx, 10
            rep movsb 
            dec dx
            add di, 310
            cmp dx, 0
            jnz REMOVE_SPRITE_LOOP
         
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
        ;mov playerPositionY, ax

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

    call MENU_INICIAL
    
    or bh, bh ; Verifica opcao selecionada (se deve sair do jogo)
    jnz SAIR_JOGO
    
    ; Jogo
    call PRINT_UI
    call MAIN_GAME
    
    SAIR_JOGO:
    mov ax, 4Ch     ; Function to terminate the program
    int 21h         ; Execute
end INICIO
