.model small

.stack 200H ; define a stack of 256 bytes (100H)

.data

    ; Controles (Scan code)
    ; (codigos para utilizar com a int 16h 00h)
    ; Scan code table: https://www.win.tue.nl/~aeb/linux/kbd/scancodes-1.html
    upArrow equ 48h
    downArrow equ 50h
    accept equ 1Ch ; ENTER (enter is a reserved word)
   
    ; Codigos ASCII
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
    playerPositionY dw 29780
   
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
   
    ;player constants
    playerMovementIncrement equ 1280
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
; bp: Rndere?o da mem?ria com texto a ser escrito
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

CLEAR_SCREEN proc
    push ax
    push cx
    push di
           
    mov di, 0
    mov al, 0
    mov cx, 64000
    rep movsb
   
    pop di
    pop cx
    pop ax
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
    cmp ah, accept
    jz MENU_INICIAL_ACCEPT
   
    ; Seta para cima ou para baixo
    cmp ah, upArrow
    jz MENU_INICIAL_TOGGLE_OPTION
    cmp ah, downArrow
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
            rep stosb
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

PRINT_PLAYER proc

    mov SI, offset spaceShipSprite
    mov DI, playerPositionY

    call PRINT_SPRITE
   
   
    ret
endp

READ_KEYBOARD_INPUT proc
    push di
    push ax
    push bx


    ; Check if a key is available in the keyboard buffer
    mov ah, 01h
    int 16h

    ; If ZF (Zero Flag) is set, no key is available, so jump to NoKeyPress
    jz END_KI
    mov DI, playerPositionY
    
    call REMOVE_SPRITE

    ; A key is available, so check if it's 'W'
    mov ah, 0
    int 16h

    cmp al, 'w'      ; Check if the key is 'w'
    je PLAYER_UP
    
    
    cmp al, 's'      ; Check if the key is 's'
    je PLAYER_DOWN
    
    jmp END_KI
   
    PLAYER_UP:
        mov ax, playerPositionY
        sub ax, playerMovementIncrement
    
        cmp ax, 320
        jl END_KI
        
        mov playerPositionY, ax
   
        call PRINT_PLAYER
        jmp END_KI
        
    PLAYER_DOWN:
        mov ax, playerPositionY
        add ax, playerMovementIncrement
        
        mov playerPositionY, ax
   
        call PRINT_PLAYER
        jmp END_KI

    END_KI:
        pop bx
        pop ax
        pop di
        
        call PRINT_PLAYER
    ret
endp

;Limpa o buffer do teclado
CLEAR_KEYBOARD_BUFFER proc
    mov ah, 01h 
    int 16h       

    jz BufferCleared  
    mov ah, 00h   
    int 16h       

    jmp CLEAR_KEYBOARD_BUFFER

BufferCleared:
    ret
CLEAR_KEYBOARD_BUFFER endp

MAIN_GAME proc

    xor SI, SI
    call PRINT_PLAYER

    MAIN_LOOP:
   
        call GAME_TIMER
        call READ_KEYBOARD_INPUT
        
        call CLEAR_KEYBOARD_BUFFER
       
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
   
    call CLEAR_SCREEN
   
    ; Jogo
    call PRINT_UI
    call MAIN_GAME
   
    SAIR_JOGO:
    mov ax, 4Ch     ; Function to terminate the program
    int 21h         ; Execute
end INICIO