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
    SPACE equ 32
 
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

    nextPhaseText   db "  _____              _                 ", CR, LF
                    db " | ___ \            (_)                ", CR, LF
                    db " | |_/ / __ _____  ___ _ __ ___   __ _ ", CR, LF
                    db " |  __/ '__/ _ \ \/ / | '_ ` _ \ / _` |", CR, LF
                    db " | |  | | | (_) >  <| | | | | | | (_| |", CR, LF
                    db " \_|  |_|  \___/_/\_\_|_| |_| |_|\__,_|", CR, LF
                    db "                                       ", CR, LF
                    db "                                       ", CR, LF
                    db "            __                         ", CR, LF
                    db "           / _|                        ", CR, LF
                    db "           | |_ __ _ ___  ___          ", CR, LF
                    db "           |  _/ _` / __|/ _ \         ", CR, LF
                    db "           | || (_| \__ \  __/         ", CR, LF
                    db "           |_| \__,_|___/\___|         ", CR, LF
                    db "                                       ", CR, LF
                    db "                                       ", CR, LF

    defeatText  db "                                    ", CR, LF
                db "           _____                    ", CR, LF
                db "          |  |  |___ ___ ___        ", CR, LF
                db "          |  |  | . |  _| -_|       ", CR, LF
                db "           \___/|___|___|___|       ", CR, LF
                db "                                    ", CR, LF
                db "                                 __ ", CR, LF
                db "       _____           _        |  |", CR, LF
                db "      |  _  |___ ___ _| |___ _ _|  |", CR, LF
                db "      |   __| -_|  _| . | -_| | |__|", CR, LF
                db "      |__|  |___|_| |___|___|___|__|", CR, LF
                db "                                    ", CR, LF

    sucessText  db "                                    __ ", CR, LF
                db "  _____             _              |  |", CR, LF
                db " |  _  |___ ___ ___| |_ ___ ___ ___|  |", CR, LF
                db " |   __| .'|  _| .'| . | -_|   |_ -|__|", CR, LF
                db " |__|  |__,|_| |__,|___|___|_|_|___|__|", CR, LF
                db "                                       ", CR, LF

    jogar db "Jogar"
    sair db "Sair"
    selectedOption db "[] "
   
    ;Sprites
    ; Codigos:
    ; 255: Primeiro pixel de objeto que se move para a esquerda
    spaceshipSprite db 0,0,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0,0,0Fh,3,3,3,0,0,0,0,0,0Fh,3,3,0Fh,0,0,0,0,0,0,3,3,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,3,0Fh,0Fh,0Fh,0Fh,1,1,0Fh,0Fh,0Fh,3,0Fh,0Fh,0Fh,0Fh,1,1,0Fh,0Fh,0Fh,3,3,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0Fh,3,3,0Fh,0,0,0,0,0,0,0,0Fh,3,3,3,0,0,0,0,0,0,0,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0    
    imuneSpaceshipSprite db 0,0,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0,0,0Fh,5,5,5,0,0,0,0,0,0Fh,5,5,0Fh,0,0,0,0,0,0,5,5,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,5,0Fh,0Fh,0Fh,0Fh,1,1,0Fh,0Fh,0Fh,5,0Fh,0Fh,0Fh,0Fh,1,1,0Fh,0Fh,0Fh,5,5,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0Fh,5,5,0Fh,0,0,0,0,0,0,0,0Fh,5,5,5,0,0,0,0,0,0,0,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0
    asteroidSprite db 255,254,7,7,7,7,7,7,254,254,254,7,7,8,8,8,7,7,7,254,7,7,8,8,8,8,7,7,7,7,7,8,8,8,8,7,7,7,8,7,7,8,8,8,7,7,7,8,8,7,7,8,8,7,7,7,8,8,8,7,7,7,7,7,7,8,8,8,8,7,7,7,7,8,8,8,8,8,7,7,254,7,7,7,8,8,8,7,7,254,254,254,7,7,7,7,7,7,254,254
    shieldSprite db 255,254,254,1,1,1,1,254,254,254,254,254,1,0Fh,0Fh,0Fh,0Fh,1,254,254,254,1,0Fh,1,1,1,1,0Fh,1,254,1,0Fh,1,1,1,1,1,1,0Fh,1,1,0Fh,3,3,3,3,3,3,0Fh,1,1,0Fh,3,3,3,3,3,3,0Fh,1,1,0Fh,0Fh,3,3,3,3,0Fh,0Fh,1,254,1,0Fh,0Fh,3,3,0Fh,0Fh,1,254,254,254,1,0Fh,0Fh,0Fh,0Fh,1,254,254,254,254,254,1,1,1,1,254,254,254
    healthSprite db 255,254,254,2,2,2,2,254,254,254,254,254,2,0Fh,0Fh,0Fh,0Fh,2,254,254,254,2,0Fh,0Fh,2,2,0Fh,0Fh,2,254,2,0Fh,0Fh,0Fh,2,2,0Fh,0Fh,0Fh,2,2,0Fh,2,2,2,2,2,2,0Fh,2,2,0Fh,2,2,2,2,2,2,0Fh,2,2,0Fh,0Fh,0Fh,2,2,0Fh,0Fh,0Fh,2,254,2,0Fh,0Fh,2,2,0Fh,0Fh,2,254,254,254,2,0Fh,0Fh,0Fh,0Fh,2,254,254,254,254,254,2,2,2,2,254,254,254
    shootColor db 30
    
    ;Locais de inicio de video
    videoMemStart equ 0A000h
    uiRegionStart equ 57600
    uiHealthBarStart equ 59385
    uiTimeBarStart equ 59205
    
    ; Locais de jogo
    playerInitialPosition equ 29914
    playerPositionY dw 29914 ; Precisa ser par
    shootArraySize equ 10
    shootsPosition dw shootArraySize dup(0)
   
    ;UI widths
    healthBarWidth dw 130
    timeBarWidth dw 130
   
   
    screenWidth equ 320
    screenHeight equ 200
   
    ;UI colors
    uiBackgroundColor equ 7
    uiHealthBarColor equ 2
    uiTimeBarColor equ 11
   
    ;timer
    ; Primeiro valor para o level 1 e segundo para o 2
    levelTime dw 1300, 1300 ; Configura o tempo das fases (max: 1300)
    timer dw 1300 ; Time of level 1
    timeBarScaleDecrement dw 2
    timeScaleIntervalCX equ 1
    timeScaleIntervalDX equ 086A0h
   
    ;player constants
    playerMovementIncrement equ 1280
    
    ;cycles per spawn
    ;   defines the interval between each spawn in main game loop unit
    ;   each unit value is 50ms
    ;   preferentialy, use divisors of 200. ex: 10, 20, 25, 50, 100, 200...
    asteroidSpawnCycle db 50
    shieldSpawnCycle equ 200 ; 200 x 50ms = 10s
    maxSpawnCycle equ 199 ; Currently do 200 cycles
    
    ; Configuracoes de jogo
    
    ; Nivel 1
    ; level = 00000000
    ; asteroidSpeed = 1
    ; spawnColumnPosition = 319
    ; healthKitRemaining = 1
    
    ; Nivel 2
    ; level = 11111111
    ; asteroidSpeed = 2
    ; spawnColumnPosition = 318
    ; healthKitRemaining = 1
    
    healthKitRemaining db 1
    level db 0
    asteroidSpeed db 1
    spawnColumnPosition dw 319
    
    
    ; Informacoes do jogo
    life db 10
    shieldDuration equ 5050 ; seta valor para 5050 (5s + tempo para aguentar segundo asteroide)
    imunityTime dw 0
    fireRate equ 1000 ; um segundo entre cada disparo
    fireCooldown dw 0 ; Tempo de cooldown
    
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
    push ax
    push cx
    push dx
    
    mov es:[di], 0Eh
    mov ah, 86h
    mov cx, 1
    mov dx, 086A0h
    int 15h
    
    pop dx
    pop cx
    pop ax
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


CLEAR_GAME_SCREEN proc
    push ax
    push cx
    push di
           
    mov di, 0
    mov al, 0
    mov cx, uiRegionStart
    rep stosb
   
    pop di
    pop cx
    pop ax
  ret
endp

; Gera um n?mero aleat?rio considerando o tempo do sistema e a posi??o do player
; Parametros
; BX: numero aleat?rio maximo + 1
; SI: numero para diferenciar sprites (pode ser o proprio endereco)
; Retorno
; DX: numero aleatorio 
GENERATE_RANDOM_NUMBER proc
    push ax
    push bx
    push cx
    push si
    
    mov ah, 0
    int 1ah         ; Interrupcao para pegar a hora do sistema
                    ; Destroi CX e DX

    mov ax, dx
    add ax, playerPositionY
    sub ax, si
    xor dx, dx
    div bx

    pop si
    pop cx
    pop bx
    pop ax

    ret
endp

;-----------------------------------------------------------------------------------------------;
;                                                                                               ;
;  FUNCOES DO MENU INICIAL                                                                      ;
;                                                                                               ;
;-----------------------------------------------------------------------------------------------;

; recebe em ax o offset do texto
; recebe em cx o tamanho do texto
; bl cor
; dh: linha
PRINT_GAME_TEXT proc
   
    push bp
    push dx
    push cx
    push bx

    mov bp, ax; Text to print
    mov dl, 0 ; Column to print
   
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
    mov ax, offset gameName
    mov cx, 574 ; Size of string printed
    mov bl, 0Ah
    xor dh, dh
    call PRINT_GAME_TEXT  

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

; Sem parametros
PROX_FASE_MSG proc
    push cx
    push dx
    push ax

    mov ax, offset nextPhaseText
    mov cx, 586
    mov bx, 30
    mov dh, 5
    call PRINT_GAME_TEXT

    mov ah, 86h
    mov cx, 50
    mov dx, 086A0h
    int 15h
   
    pop ax
    pop dx
    pop cx
    ret
endp

DEFEAT_SCREEN proc
    push cx
    push dx
    push bx
    push ax
    
    mov ax, offset defeatText
    mov cx, 432
    mov bl, 248
    mov dh, 5
    call PRINT_GAME_TEXT

    mov cx, 14400 ; 57600 / 4 (Para n?o limpar a UI)
    mov SI, 0
    
    LOOP_DEATH_SCREEN:
    mov bl, 20 
        DEATH_SCREEN_CHUNK:
            mov al, 28h ; Vermelho
            mov bh, es:[SI]
            cmp bh, 248
            jne DEATH_SCREEN_PRINT_PIXEL 
                mov al, 0Fh ; Seta para branco para o texto
            DEATH_SCREEN_PRINT_PIXEL:
            mov es:[SI], al
            dec bl
            inc si
            or bl, bl
        jnz DEATH_SCREEN_CHUNK

        push cx
        mov ah, 86h
        mov al, 0
        xor cx, cx
        mov dx, 1
        int 15h
        pop cx
        
    loop LOOP_DEATH_SCREEN

    
    
    mov ah, 86h
    mov al, 0
    mov cx, 1
    mov dx, 086A0h
    int 15h
   
    pop ax
    pop bx
    pop dx
    pop cx
    ret
endp

SUCCESS_SCREEN proc
    push cx
    push dx
    push bx
    push ax
    
    mov ax, offset sucessText
    mov cx, 246
    mov bl, 248 ; Printa em preto com outro codigo para saber onde e texto
    mov dh, 8
    call PRINT_GAME_TEXT
    
    mov cx, 14400 ; 57600 / 4 (Para n?o limpar a UI)
    mov SI, 0

    LOOP_SUCCESS_SCREEN:
        mov bl, 20 
        SUCCESS_SCREEN_CHUNK:
            mov al, 74h ; Para usar Amarelo, mudar para 2ch. Tabela de cores em: https://www.fountainware.com/EXPL/vga_color_palettes.htm
            mov bh, es:[SI]
            cmp bh, 248
            jne SUCCESS_SCREEN_PRINT_PIXEL 
                mov al, 0fh ; Seta para branco para o texto
            SUCCESS_SCREEN_PRINT_PIXEL:
            mov es:[SI], al
            dec bl
            inc si
            or bl, bl
        jnz SUCCESS_SCREEN_CHUNK

        push cx
        mov ah, 86h
        mov al, 0
        xor cx, cx
        mov dx, 1
        int 15h
        pop cx
        
    loop LOOP_SUCCESS_SCREEN

    mov ah, 86h
    mov cx, 1
    mov dx, 086A0h
    int 15h
   
    pop ax
    pop bx
    pop dx
    pop cx
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
        or dx, dx
        jnz LOOP_UI_BAR
       
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

;Temporizador de fase do jogo
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
    
    call PROX_FASE
    
    SKIP_END_CONDITION:
        pop di
        pop cx
        pop dx
        pop ax
    ret
endp

;Altera valores para preparar para a pr?xima fase
PROX_FASE proc
    push ax
    push bx
    push cx
    push si
    
    mov al, level
    inc al
    mov level, al
    cmp al, 2
    je PROX_FASE_END_GAME
    
    call CLEAR_GAME_SCREEN
    call PROX_FASE_MSG
    call CLEAR_GAME_SCREEN

    mov bx, 2
    mul bl
    mov bl, al
    mov ax, levelTime[bx]
    mov timer, ax
    
    mov al, asteroidSpawnCycle
    sub al, 5
    mov asteroidSpawnCycle, al
    
    mov al, asteroidSpeed
    inc al
    mov asteroidSpeed, al
    
    mov ax, playerInitialPosition
    mov playerPositionY, ax
    
    xor ax, ax
    mov imunityTime, ax
    mov fireCooldown, ax
    
    ; Remove tiros da mem?ria
    push es
    mov ax, ds
    mov es, ax
    xor ax, ax
    mov di, offset shootsPosition
    mov cx, shootArraySize
    rep stosw
    pop es
    
    ; Regenera a vida
    mov cx, 10
    call SET_HEALTH
    
    PROX_FASE_END_GAME:

    pop di
    pop cx
    pop bx
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
    push di
    push si

    xor di, di
    cmp di, imunityTime
    jne PRINT_PLAYER_IMUNE
        mov SI, offset spaceShipSprite
        jmp PRINT_PLAYER_ENDIF
    PRINT_PLAYER_IMUNE:
        mov SI, offset imuneSpaceshipSprite
    PRINT_PLAYER_ENDIF:
    mov DI, playerPositionY

    call PRINT_SPRITE
   
    pop si
    pop di
    ret
endp

; Parametros
; DI: Posicao do tiro
CREATE_SHOOT proc
    push ax
    push bx
    
    mov al, shootColor
    mov es:[di], al

    ; Salva tiro na mem?ria
    xor bx, bx
    sub bx, 2
    xor ax, ax
    CREATE_SHOOT_LOOP:
        add bx, 2
        cmp ax, shootsPosition[bx]       
    jne CREATE_SHOOT_LOOP
    
    mov shootsPosition[bx], di
    
    pop bx
    pop ax
    
    ret
endp

; Parametros
; DI: posicao do tiro
REMOVE_SHOOT proc
    push dx
    push bx
    push ax
    
    ; Remove tiro da memoria
    xor bx, bx
    sub bx, 2    
    REMOVE_SHOOT_LOOP:
        add bx, 2    
        cmp di, shootsPosition[bx]
    jne REMOVE_SHOOT_LOOP
    
    xor dx, dx
    mov shootsPosition[bx], dx
    
    mov al, shootColor
    cmp al, es:[di]
    ; Avoids to remove if its not necessary
    jne REMOVE_SHOOT_SKIP
        mov es:[di], dl
    REMOVE_SHOOT_SKIP:
    
    pop ax
    pop bx
    pop dx
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

    cmp ah, upArrow      ; Check if the key is 'w'
    je PLAYER_UP
    
    
    cmp ah, downArrow      ; Check if the key is 's'
    je PLAYER_DOWN
    
    
    cmp al, SPACE
    je SHOOT
    
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

    SHOOT:
        ; Verifica se esta em tempo de cooldown
        mov ax, fireCooldown
        or ax, ax
        jnz END_KI
        ; Procede com o tiro
        mov di, playerPositionY
        add di, 1612 ; Moves shoot to the front middle of spaceship
        call CREATE_SHOOT
        mov ax, fireRate
        mov fireCooldown, ax
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
    push bx
    push dx
    push si
    push di
          
    mov bx, 170 ; Screen height - sprite size (10) - UI bar size (20)
    call GENERATE_RANDOM_NUMBER
    mov ax, screenWidth
    mul dx
    add ax, spawnColumnPosition ; Para printar no final da linha
    mov di, ax
    call PRINT_SPRITE
    mov ax, es:[di]
    
    pop di
    pop si
    pop dx
    pop bx
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
    push bx
    push ax
    
    mov si, di
    inc si
    mov al, es:[si]
    call GET_SPRITE
    call REMOVE_SPRITE
    xor bx, bx
    mov bl, asteroidSpeed
    sub di, bx
    call PRINT_SPRITE
          
    pop ax 
    pop bx    
    pop di
    pop si
    ret
endp

; Parametros
; CX: Velocidade do tiro
; DI: Posicao do tiro
CHECK_BULLETS_COLISION proc
    push ax
    push bx
    push cx
    push di
    push si

        xor bx, bx
    CHECK_BULLETS_COLISION_LOOP:
        inc bx
        cmp bx, cx
        jg CHECK_BULLET_COLISION_END
        mov al, es:[di+bx]
        or al, al ; Pixel nao tem nada
    jz CHECK_BULLETS_COLISION_LOOP
    
    call REMOVE_SHOOT
    add di, bx
    call GET_OBJECT_FROM_SHOOT_COLLISION
    call GET_SPRITE
    cmp si, offset asteroidSprite
    jne CHECK_BULLET_COLISION_END
        call REMOVE_SPRITE
    CHECK_BULLET_COLISION_END:
    pop si
    pop di
    pop cx
    pop bx
    pop ax
    
    ret
endp

; Retorna a posicao do primeiro pixel do objeto a partir de qualquer pixel desde que o primeiro pixel n?o tenha sido destruido
; Parametros:
; DI: Pixel na qual foi identificada a colis?o na parte superior
; Retorno
; DI: Pixel do inicio do sprite
GET_OBJECT_FROM_SHOOT_COLLISION proc
    push cx
    push ax
    
    call PRINT_PIXEL
    
    ; Find the first line of the sprite
    xor ax, ax
    mov cx, 10
    GET_OBJECT_FROM_SHOOT_COLLISION_LOOP:
       cmp al, es:[di]
       je GET_OBJECT_FROM_SHOOT_COLLISION_BREAK
       sub di, screenWidth
       dec cx
       or cx, cx
       jnz GET_OBJECT_FROM_SHOOT_COLLISION_LOOP
    GET_OBJECT_FROM_SHOOT_COLLISION_BREAK:
    add di, screenWidth
    
    ;Find the first pixel
    mov cx, 10
    mov al, 255
    std
    repne scasb
    cld
    inc di ; Corrige a posicao do primeiro pixel do sprite

    pop ax
    pop cx
    ret
endp


; Move all sprites from the screen (asteroid, shield and heal)
; Sem parametros
MOVE_SPRITES proc
    push ax
    push bx
    push cx
    push di
    push bp
    push dx
    
    xor bx, bx
    mov si, screenWidth
    xor di, di
    
    ; Obtem velocidade do tiro
    xor cx, cx
    mov cl, asteroidSpeed
    add cl, cl ; Tiro e duas vezes velocidade do asteroide
        
    xor ax, ax
    MOVE_SPRITES_SHOOT_LOOP:
        mov di, shootsPosition[bx]
        cmp ax, di
        je MOVE_SPRITES_SHOOT_SKIP_MOVEMENT
        call REMOVE_SHOOT
        ; Calcula se deve mover ou so remover tiro
        xor dx, dx
        mov ax, di
        add ax, cx ; Para verificar a futura posicao e nao a atual
        xor dx, dx
        mov si, screenWidth
        div si
        cmp dx, 20 ; Margem no inicio da tela para deletar o tiro
        jl MOVE_SPRITES_SHOOT_SKIP_MOVEMENT
            ; Cria novo tiro
            add di, cx ; Incrementa velocidade do tiro
            call CREATE_SHOOT
            call CHECK_BULLETS_COLISION
        MOVE_SPRITES_SHOOT_SKIP_MOVEMENT:
        add bx, 2
        mov dx, shootArraySize
        add dx, shootArraySize
        cmp bx, dx
    jne MOVE_SPRITES_SHOOT_LOOP
    
    mov cx, 63999
    ;jmp MOVE_SPRITES_BREAK
    
    MOVE_SPRITES_LOOP:
        mov al, 255
        repne scasb
        jne MOVE_SPRITES_BREAK
        dec di
        
        ; Calcula se deve mover ou remover sprite
        mov ax, di
        xor dx, dx
        div si
        xor ax, ax
        mov al, asteroidSpeed
        cmp dx, ax ; Margem do lado direito para deletar
        jl MOVE_SPRITES_REMOVE
            call MOVE_SPRITE_LEFT
            jmp MOVE_SPRITES_CONDITION_END
        MOVE_SPRITES_REMOVE:
            call REMOVE_SPRITE
        MOVE_SPRITES_CONDITION_END:
        
        dec cx
    jmp MOVE_SPRITES_LOOP
    
    MOVE_SPRITES_BREAK:
    
    pop dx
    pop si
    pop di
    pop cx
    pop bx
    pop ax
    
    ret  
endp

; Retorna a posicao do primeiro pixel do objeto a partir de qualquer pixel da primeira coluna
; Parametros:
; DI: Pixel na qual foi identificada a colisao frontal
; Retorno
; DI: Pixel do inicio do sprite
GET_OBJECT_FROM_FRONTSIDE_COLLISION proc
    push cx
    push ax

    mov cx, 10
    mov ax, 255
    std
    repne scasb
    cld
    inc di

    pop ax
    pop cx
    ret
endp

; Retorna a posicao do primeiro pixel do objeto a partir de qualquer pixel desde que o primeiro pixel n?o tenha sido destruido
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
    inc di ; Corrige a posicao do primeiro pixel do sprite
    
    pop ax
    pop cx
    ret
endp

; Retorna a posicao do primeiro pixel do objeto a partir 
; de qualquer pixel seguindo as seguintes etapas:
; - Vai ate a primeira coluna do pixel que estiver
; - Vai ate a ultima linha
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
    xor al, al
    std
    repne scasb
    cld
    add di, 2 ; Corrige a posicao do primeiro pixel do sprite

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

; Parametros:
; CX: Vida (0 a 10)
SET_HEALTH proc
    push di
    push dx
    push cx
    push bx
    push ax
    
    mov life, cl

    
    ; Calcula tamanho da barra de vida em vermelho
    mov ax, 13
    mul cx
    mov bx, ax
    
    ; Printa barra
    mov cx, healthBarWidth
    mov dx, 10
    mov di, uiHealthBarStart
    xor ax, ax
    call PRINT_UI_BAR
    
    mov ax, uiHealthBarColor
    mov cx, bx
    call PRINT_UI_BAR
    
    pop ax
    pop bx
    pop cx
    pop dx
    pop di
    
    ret
endp

HANDLE_PLAYER_COLLISION proc
    push di
    push cx
    push ax
    
    mov di, playerPositionY
    sub di, 320
    mov cx, 11
    xor al, al 
    repe scasb
    je CHECK_PLAYER_COLLISION_BOTTOM
    ; Collision upside
    dec di
    call GET_OBJECT_FROM_TOPSIDE_COLLISION
    jmp CHECK_PLAYER_COLLISION_HANDLER
    
    
    ; Bottom collision check must come before front collision check since 
    ; some collision can trigger both and front collision does not handle
    ; with objects without reference (start pixel with 255)
    CHECK_PLAYER_COLLISION_BOTTOM:
    add di, 3509 ; Eleven lines above, 10 column to the left  
    
    mov cx, 10
    repe scasb
    
    je CHECK_PLAYER_COLLISION_RIGHT
    ; Collision bottomside
    inc di
    
    call GET_OBJECT_FROM_BOTTOMSIDE_COLLISION
    jmp CHECK_PLAYER_COLLISION_HANDLER
    
    
    
    CHECK_PLAYER_COLLISION_RIGHT:
    sub di, 3200 ; Up 10 pixels
    cmp al, es:[di]
    je CHECK_PLAYER_COLLISION_BREAK
    
    ; Collision rightside
    call GET_OBJECT_FROM_FRONTSIDE_COLLISION
    
    CHECK_PLAYER_COLLISION_HANDLER:
    call GET_SPRITE
    
    cmp si, offset shieldSprite
    jne CHECK_PLAYER_COLLISION_HEALTH
    ; Bateu em um escudo
    mov imunityTime, shieldDuration
    ; ---------------------
    jmp CHECK_PLAYER_COLLISION_REMOVE_SPRITE
    CHECK_PLAYER_COLLISION_HEALTH:
    ;health (case 2)
    cmp si, offset healthSprite
    jne CHECK_PLAYER_COLLISION_ASTEROID
    ; Bateu em uma vida
    mov cx, 10
    call SET_HEALTH
    ; ---------------------
    jmp CHECK_PLAYER_COLLISION_REMOVE_SPRITE
    CHECK_PLAYER_COLLISION_ASTEROID:
    cmp si, offset asteroidSprite
    jne CHECK_PLAYER_COLLISION_REMOVE_SPRITE
    ; Bateu em um asteroide
    xor cx, cx
    
    ; Estava imune
    cmp cx, imunityTime
    jne CHECK_PLAYER_COLLISION_REMOVE_SPRITE
    
    mov cl, life
    dec cl
    call SET_HEALTH
    
    ; ---------------------
    CHECK_PLAYER_COLLISION_REMOVE_SPRITE:
    call REMOVE_SPRITE

    CHECK_PLAYER_COLLISION_BREAK:
    
    pop ax
    pop cx
    pop di
    
    ret
endp

HEALTH_SPAWN_CYCLE proc
    push bx
    push si

    ; Controls life spawn cycle
    ; Health should spawn just if:
    ; - life is <= 5
    ; - healthKitRemaining > 0
    mov bl, life
    cmp bl, 5
    jg HEALTH_SPAWN_CYCLE_END
    mov bh, healthKitRemaining
    or bh, bh
    jz HEALTH_SPAWN_CYCLE_END
        dec healthKitRemaining
        mov si, offset healthSprite
        call SPAWN_SPRITE_END_SCREEN
    HEALTH_SPAWN_CYCLE_END:   
    
    pop si
    pop bx
    ret
endp

; Parametros
; CX: Contador de ciclos
SHIELD_SPAWN_CYCLE proc
    push ax
    push bx
    push si

    ; Controls shield spawn cycle
    mov bl, level
    or bl, bl                       ; Verifica qual level esta
    jz MAIN_LOOP_SPAWN_SHIELD_END   ; O shield so deve ser spawnado no level 2
    mov bl, shieldSpawnCycle
    mov ax, cx
    div bl
    or ah, ah ; Verifica se resto e zero
    jnz MAIN_LOOP_SPAWN_SHIELD_END
        mov si, offset shieldSprite
        call SPAWN_SPRITE_END_SCREEN
    MAIN_LOOP_SPAWN_SHIELD_END:

        
    pop si
    pop bx
    pop ax
    ret
endp

; Parametros
; CX: Contador de ciclos
ASTEROID_SPAWN_CYCLE proc
    push ax
    push bx
    push si

    ; Controls asteroid spawn cycle
    mov bl, asteroidSpawnCycle
    mov ax, cx
    div bl
    or ah, ah ; Verifica se resto e zero
    jnz MAIN_LOOP_SPAWN_ASTEROID_END
        mov si, offset asteroidSprite
        call SPAWN_SPRITE_END_SCREEN
    MAIN_LOOP_SPAWN_ASTEROID_END:
        
    pop si
    pop bx
    pop ax
        
    ret
endp

MAIN_GAME proc

    xor SI, SI
    call PRINT_PLAYER
    
    xor cx, cx ; Used to control main cycle count (control spawns)

    MAIN_LOOP:
   
        call GAME_TIMER
        call READ_KEYBOARD_INPUT
        
        call CLEAR_KEYBOARD_BUFFER

        call ASTEROID_SPAWN_CYCLE
        call SHIELD_SPAWN_CYCLE
        call HEALTH_SPAWN_CYCLE
        
        
        ; Resets counter when it reaches to max value
        cmp cx, maxSpawnCycle
        je MAIN_LOOP_RESET_COUNTER
        jmp MAIN_LOOP_RESET_COUNTER_END
        MAIN_LOOP_RESET_COUNTER:
            xor cx, cx
            not cx
        MAIN_LOOP_RESET_COUNTER_END:
        
        call MOVE_SPRITES 
       
        call HANDLE_PLAYER_COLLISION
        ;call PLAYER_HITBOX 
        
        
        ; Decrementa tempo do escudo
        mov ax, imunityTime
        or ax, ax
        jz MAIN_LOOP_NO_SHIELD
        sub ax, 50
        mov imunityTime, ax
        MAIN_LOOP_NO_SHIELD:
        
        ; Decrementa cooldown do tiro
        mov ax, fireCooldown
        or ax, ax
        jz MAIN_LOOP_FIRE_READY
        sub ax, 50
        mov fireCooldown, ax
        MAIN_LOOP_FIRE_READY:
        
        ; Death
        mov al, life
        or al, al
        jnz SKIP_HP_END_CONDITION
        call DEFEAT_SCREEN
        jmp END_GAME
        SKIP_HP_END_CONDITION:
        
        ; Win
        mov al, level
        cmp al, 2
        jne SKIP_WIN
        call SUCCESS_SCREEN
        jmp END_GAME
        SKIP_WIN:
        
        
        inc cx
        call BLOCK_GAME_EXECUTION
   
        cmp SI, 1
        jne MAIN_LOOP
        
    END_GAME:
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
    call CLEAR_SCREEN
    SAIR_JOGO:
    mov ah, 4Ch     ; Function to terminate the program
    int 21h         ; Execute
end INICIO
