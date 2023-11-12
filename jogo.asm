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
    ; Codigos:
    ; 255: Primeiro pixel de objeto que se move para a esquerda
    spaceshipSprite db 0,0,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0,0,0Fh,3,3,3,0,0,0,0,0,0Fh,3,3,0Fh,0,0,0,0,0,0,3,3,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,3,0Fh,0Fh,0Fh,0Fh,1,1,0Fh,0Fh,0Fh,3,0Fh,0Fh,0Fh,0Fh,1,1,0Fh,0Fh,0Fh,3,3,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0Fh,3,3,0Fh,0,0,0,0,0,0,0,0Fh,3,3,3,0,0,0,0,0,0,0,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0    
    asteroidSprite db 255,254,7,7,7,7,7,7,254,254,254,7,7,8,8,8,7,7,7,254,7,7,8,8,8,8,7,7,7,7,7,8,8,8,8,7,7,7,8,7,7,8,8,8,7,7,7,8,8,7,7,8,8,7,7,7,8,8,8,7,7,7,7,7,7,8,8,8,8,7,7,7,7,8,8,8,8,8,7,7,254,7,7,7,8,8,8,7,7,254,254,254,7,7,7,7,7,7,254,254
    shieldSprite db 255,254,254,1,1,1,1,254,254,254,254,254,1,0Fh,0Fh,0Fh,0Fh,1,254,254,254,1,0Fh,1,1,1,1,0Fh,1,254,1,0Fh,1,1,1,1,1,1,0Fh,1,1,0Fh,3,3,3,3,3,3,0Fh,1,1,0Fh,3,3,3,3,3,3,0Fh,1,1,0Fh,0Fh,3,3,3,3,0Fh,0Fh,1,254,1,0Fh,0Fh,3,3,0Fh,0Fh,1,254,254,254,1,0Fh,0Fh,0Fh,0Fh,1,254,254,254,254,254,1,1,1,1,254,254,254
    healthSprite db 255,254,254,2,2,2,2,254,254,254,254,254,2,0Fh,0Fh,0Fh,0Fh,2,254,254,254,2,0Fh,0Fh,2,2,0Fh,0Fh,2,254,2,0Fh,0Fh,0Fh,2,2,0Fh,0Fh,0Fh,2,2,0Fh,2,2,2,2,2,2,0Fh,2,2,0Fh,2,2,2,2,2,2,0Fh,2,2,0Fh,0Fh,0Fh,2,2,0Fh,0Fh,0Fh,2,254,2,0Fh,0Fh,2,2,0Fh,0Fh,2,254,254,254,2,0Fh,0Fh,0Fh,0Fh,2,254,254,254,254,254,2,2,2,2,254,254,254
   
    ;Locais de inicio de video
    videoMemStart equ 0A000h
    uiRegionStart equ 57600
    uiHealthBarStart equ 59205
    uiTimeBarStart equ 59385
    playerInitialPosition equ 29915
    playerPositionY dw 29915
   
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
    
    ;cycles per spawn
    ;   defines the interval between each spawn in main game loop unit
    ;   preferentialy, use values dividible by the same divisors of 250. ex: 10 (10), 12 (2), 65 (5)
    asteroidSpawnCycle equ 50
    maxSpawnCycle equ 249 ; Controls when counter should reset (Must be less than 255, otherwise code must be changed)
    
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
        push ax
        push bx
        
        ; Caso o sprite esteja no final da tela
        ; garante que seja printado apenas o
        ; que cabe
        
        ; Prepara para a divisao
        mov ax, di
        add ax, 10
        xor dx, dx  
        mov bx, screenWidth
        div bx
        
               
        mov ax, 10 ; Configura tamanho padrao dos sprites
        cmp dx, 10 ; Compara o resto para ver se algum pixel passou da tela
        jc PRINT_SPRITE_END_SCREEN
        jmp PRINT_SPRITE_SKIP
        PRINT_SPRITE_END_SCREEN:
            sub ax, dx
        PRINT_SPRITE_SKIP:
        sub bx, ax
        
        ; Printa sprite
        mov dx, 10
        PRINT_SPRITE_LOOP:
            mov cx, ax
            rep movsb
            dec dx
            add di, bx
            
            ; Configura qual parte do sprite e printada
            add si, 10
            sub si, ax
            
            or dx, dx
            jnz PRINT_SPRITE_LOOP
        
        pop bx
        pop ax
        pop si
        pop di
        pop cx
        pop dx
    ret
endp

; Funcao para printar pixel na tela (DEBUG)
; Parametros
; DI: Posicao do pixel
PRINT_PIXEL proc
    mov es:[di], 0Eh
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
    rep stosb
   
    pop di
    pop cx
    pop ax
  ret
endp

; Gera um n?mero aleat?rio considerando o tempo do sistema e a posi??o do player
; Parametros
; BX: numero aleat?rio maximo + 1
; Retorno
; DX: numero aleaatorio 
GENERATE_RANDOM_NUMBER proc
    push ax
    push bx

    mov ah, 0
    int 1ah         ; Interrup??o para pegar a hora do sistema

    mov ax, dx
    add ax, playerPositionY
    xor dx, dx
    div bx

    pop bx
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
    push di
   
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
    
    ; ToDo:
    ; Call de final de jogo (por tempo)
   
    SKIP_END_CONDITION:
        pop di
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
    
        cmp ax, 280h
        jbe END_KI
        
        mov playerPositionY, ax
   
        call PRINT_PLAYER
        jmp END_KI
        
    PLAYER_DOWN:
        mov ax, playerPositionY
        add ax, playerMovementIncrement

        cmp ax, 0D000h
        jae END_KI

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

; Spawna um asteroide/vida/escudo no final da tela
; Parametros
; SI: sprite para spawnar
SPAWN_SPRITE_END_SCREEN proc

    push ax
    push dx
    push si
    push di
          
    mov bx, 170 ; Screen height - sprite size (10) - UI bar size (20)
    call GENERATE_RANDOM_NUMBER
    mov ax, screenWidth 
    ;mov dx, 0 ; prints always in first line for debbuging
    mul dx
    add ax, 319 ; Para printar no final da linha
    mov di, ax
    call PRINT_SPRITE
    mov ax, es:[di]
    pop di
    pop si
    pop dx
    pop ax
    
    ret
endp

; Get which sprite is being rendered
; Parametros:
; DI: posicao inicial do sprite
; Retorno:
; SI: endereco do sprite
GET_SPRITE proc
    push di
    push ax
    push ds
    
    
    mov si, di
    mov ax, es
    mov ds, ax
    add si, 1280 ; Vai para primeiro pixel da quarta linha
    lodsb
    
    ;shield (case 1)
    cmp al, 1
    mov si, offset shieldSprite
    je GET_SPRITE_END
    
    ;health (case 2)
    cmp al, 2
    mov si, offset healthSprite
    je GET_SPRITE_END
    
    ;asteroid (case 7)
    cmp al, 7
    mov si, offset asteroidSprite
    je GET_SPRITE_END
    
    ;player (default)
    mov si, offset spaceshipSprite
    
    GET_SPRITE_END:
    
    pop ds
    pop ax
    pop di    
    ret
endp


; Move sprite um pixel para a esquerda
; Parametros
; DI: posicao inicial do sprite
MOVE_SPRITE_LEFT proc
    push si
    push di
    push ax
    
    mov si, di
    inc si
    mov al, es:[si]
    call GET_SPRITE
    call REMOVE_SPRITE           
    dec di
    call PRINT_SPRITE
          
    pop ax      
    pop di
    pop si
    ret
endp

; Move all sprites from the screen (asteroid, shield and heal)
; Sem parametros
MOVE_SPRITES proc
    push ax
    push bx
    push cx
    push di
    push dx
    
    mov cx, 63999
    mov bx, screenWidth
    xor di, di
    
    MOVE_SPRITES_LOOP:
    mov al, 255
        repne scasb
        jne MOVE_SPRITES_BREAK
        dec di
        
        ; Calcula se deve mover ou remover sprite
        mov ax, di
        xor dx, dx
        div bx
        or dx, dx
        jz MOVE_SPRITES_REMOVE
            call MOVE_SPRITE_LEFT
            jmp MOVE_SPRITES_CONDITION_END
        MOVE_SPRITES_REMOVE:
            call REMOVE_SPRITE
        MOVE_SPRITES_CONDITION_END:
        
        dec cx
    jmp MOVE_SPRITES_LOOP
    
    MOVE_SPRITES_BREAK:
    pop dx
    pop di
    pop cx
    pop bx
    pop ax
    
    ret  
endp

; Retorna a posição do primeiro pixel do objeto a partir de qualquer pixel da primeira coluna
; Parametros:
; DI: Pixel na qual foi identificada a colis?o frontal
; Retorno
; DI: Pixel do in?cio do sprite
GET_OBJECT_FROM_FRONTSIDE_COLLISION proc
    push cx
    push ax

    mov cx, 10
    mov al, 255
    GET_OBJECT_FROM_FRONTSIDE_COLLISION_LOOP:
       cmp al, es:[di]
       je GET_OBJECT_FROM_FRONTSIDE_COLLISION_BREAK
       sub di, screenWidth
       dec cx
       or cx, cx
    jnz GET_OBJECT_FROM_FRONTSIDE_COLLISION_LOOP
    
    GET_OBJECT_FROM_FRONTSIDE_COLLISION_BREAK:
    pop ax
    pop cx
    ret
endp

; Retorna a posição do primeiro pixel do objeto a partir de qualquer pixel desde que o primeiro pixel não tenha sido destruido
; Parametros:
; DI: Pixel na qual foi identificada a colis?o na parte superior
; Retorno
; DI: Pixel do in?cio do sprite
GET_OBJECT_FROM_TOPSIDE_COLLISION proc
    push cx
    push ax
    
    ; Find the first line of the sprite
    xor ax, ax
    mov cx, 10
    GET_OBJECT_FROM_TOPSIDE_COLLISION_LOOP:
       cmp al, es:[di]
       je GET_OBJECT_FROM_TOPSIDE_COLLISION_BREAK
       sub di, screenWidth
       dec cx
       or cx, cx
    jnz GET_OBJECT_FROM_TOPSIDE_COLLISION_LOOP
    GET_OBJECT_FROM_TOPSIDE_COLLISION_BREAK:
    add di, screenWidth
    
    ;Find the first pixel
    mov cx, 10
    mov al, 255
    std
    repne scasb
    cld
    ; ToDo: Entender porque isso e necessario
    inc di ; Corrige a posi??o do primeiro pixel do sprite
    
    pop ax
    pop cx
    ret
endp

; Retorna a posição do primeiro pixel do objeto a partir 
; de qualquer pixel seguindo as seguintes etapas:
; - Vai até a primeira coluna do pixel que estiver
; - Vai até a última linha
; - Soma dez linhas para chegar ao primeiro pixel
; Parametros:
; DI: Pixel na qual foi identificada a colis?o na parte inferior
; Retorno
; DI: Pixel do in?cio do sprite
GET_OBJECT_FROM_BOTTOMSIDE_COLLISION proc
    push cx
    push ax
    
    ;Find the first column
    mov cx, 10
    xor al, 0
    std
    repne scasb
    cld
    ; ToDo: Entender porque isso e necessario
    add di, 2 ; Corrige a posi??o do primeiro pixel do sprite
    
    ;Find last pixel of first column + 1
    xor ax, ax
    mov cx, 10
    GET_OBJECT_FROM_BOTTOMSIDE_COLLISION_LOOP:
       cmp al, es:[di]
       je GET_OBJECT_FROM_BOTTOMSIDE_COLLISION_BREAK
       add di, screenWidth
       dec cx
       or cx, cx
    jnz GET_OBJECT_FROM_BOTTOMSIDE_COLLISION_LOOP
    GET_OBJECT_FROM_BOTTOMSIDE_COLLISION_BREAK:
    
    ;Find first pixel
    sub di, 3200 ; (up 10 times)
    
    pop ax
    pop cx
    ret
endp


; Exibe hitbox do player (DEBUG)
PLAYER_HITBOX proc
    push di
    push cx
    push ax
    
    mov al, 150
    mov di, playerPositionY
    sub di, 320
    mov cx, 11
    rep stosb
    
    add di, 3519; 11 lines above
    mov cx, 11
    std
    rep stosb
    cld
    
    sub di, 3189
    mov cx, 10
    PLAYER_HITBOX_LOOP:
        call PRINT_PIXEL
        add di, screenWidth
        dec cx
        or cx, cx
        jnz PLAYER_HITBOX_LOOP
    
    pop ax
    pop cx
    pop di
    
    ret
endp

HANDLE_PLAYER_COLLISION proc
    push di
    push cx
    push ax
    
    mov di, playerPositionY
    sub di, 320
    mov cx, 10
    xor al, al 
    repe scasb
    je CHECK_PLAYER_COLLISION_BOTTOM
    
    ; Collision upside
    call GET_OBJECT_FROM_TOPSIDE_COLLISION
    jmp CHECK_PLAYER_COLLISION_HANDLER
    
    
    ; Bottom collision check must come before front collision check since 
    ; some collision can trigger both and front collision does not handle
    ; with objects without reference (start pixel with 255)
    CHECK_PLAYER_COLLISION_BOTTOM:
    add di, 3520 ; Eleven lines above    
    std
    mov cx, 10
    repe scasb
    cld   
    je CHECK_PLAYER_COLLISION_RIGHT
    
    ; Collision bottomside
    call GET_OBJECT_FROM_BOTTOMSIDE_COLLISION
    jmp CHECK_PLAYER_COLLISION_HANDLER
    
    
    
    CHECK_PLAYER_COLLISION_RIGHT:
    sub di, 3190 ; Up 10 pixels, right 10 pixels
    mov cx, 10
    CHECK_PLAYER_COLLISION_RIGHT_LOOP:
        cmp al, es:[di]
        jne CHECK_PLAYER_COLLIDED_RIGHT
        add di, screenWidth
        dec cx
        or cx, cx
        jz CHECK_PLAYER_COLLISION_BREAK
     jmp CHECK_PLAYER_COLLISION_RIGHT_LOOP
        
    ; Collision rightside
    CHECK_PLAYER_COLLIDED_RIGHT:
    call GET_OBJECT_FROM_FRONTSIDE_COLLISION
    
        
    
    
    CHECK_PLAYER_COLLISION_HANDLER:
    ; TODO: Implementar acao que deve ser feita ao colidir
    call REMOVE_SPRITE
    ;call PRINT_PIXEL
    ;jmp SAIR_JOGO

    CHECK_PLAYER_COLLISION_BREAK:
    
    pop ax
    pop cx
    pop di
    
    ret
endp

MAIN_GAME proc

    xor SI, SI
    call PRINT_PLAYER
    
    xor cx, cx ; Used to control main cycle count (control spawns)

    MAIN_LOOP:
   
        ;call GAME_TIMER
        call READ_KEYBOARD_INPUT
        
        call CLEAR_KEYBOARD_BUFFER

        
        ; Controls asteroid spawn cycle
        mov bl, asteroidSpawnCycle
        mov ax, cx
        div bl
        or ah, ah ; Verifica se resto e zero
        jz MAIN_LOOP_SPAWN_ASTEROID
        jmp MAIN_LOOP_SPAWN_ASTEROID_END
        MAIN_LOOP_SPAWN_ASTEROID:
            mov si, offset asteroidSprite
            call SPAWN_SPRITE_END_SCREEN
        MAIN_LOOP_SPAWN_ASTEROID_END:

        
        ; Resets counter when it reaches to max value
        mov bl, maxSpawnCycle
        mov ax, cx
        div bl
        or ah, ah ; Verifica se resto e zero
        jz MAIN_LOOP_RESET_COUNTER
        jmp MAIN_LOOP_RESET_COUNTER_END
        MAIN_LOOP_RESET_COUNTER:
        
            xor cx, cx
        MAIN_LOOP_RESET_COUNTER_END:
        
        call MOVE_SPRITES 
       
        call HANDLE_PLAYER_COLLISION
        ;call PLAYER_HITBOX 
        
        
        inc cx
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
    ;call PRINT_UI
    call MAIN_GAME
   
    SAIR_JOGO:
    mov ax, 4Ch     ; Function to terminate the program
    int 21h         ; Execute
end INICIO
