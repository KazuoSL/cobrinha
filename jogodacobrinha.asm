; JOGO DA COBrINHA
jmp Main

posMinhoca: var #1			   ; Contem a posicao atual da minhoca
posCaudaMinhoca: var #1		   ; Contem a posicao anterior da minhoca
iComida: var #1				   ; Contem o incremento do vetor de posições da comida
posComida: var #1			   ; Contem a posição da comida
guardaTeclado: var #1          ; Guarda a ultima tecla AWSD, para manter o movimento
tamanho: var #1                ; Armazena o tamanho da cobrinha
corpoMinhoca: var #300         ; Armazena a posição do corpo da cobrinha

Main:
	; Inicio com a tela de menu, apagando a tela e imprimindo a tela
	TelaMenu:
	call ApagaTela            ; Chama a função ApagaTela
 	loadn r1, #tela1Linha0	  ; Carrega o endereço onde comeca a primeira linha do cenario do menu
	loadn r2, #1536  	      ; Cor azul
	call ImprimeTela          ; Imprime o cenario do menu com a cor azul
	
	; Função que espera o Enter para o início do jogo
	TelaMenu_loop:            
	loadn r3, #13             ; Carrega o 13, número ascii do enter
	inchar r4                 ; Recebe dado do teclado
	cmp r4, r3                ; Compara se foi teclado enter
	jeq InicioJogo            ; Se sim, começa o jogo
	jmp TelaMenu_loop
	
	; Função que volta ao menu na tela de morte. A diferença é que mostra o score da rodada
	TelaMorte:
	call ApagaTela            ; Apaga tela
 	loadn r1, #tela2Linha0	  ; Endereco onde comeca a primeira linha do cenario do menu de morte
	loadn r2, #1536  	      ; cor azul
	call ImprimeTela          ; Imprime a tela do menu de morte na cor azul
	loadn r0, #464            ; Imprime o score na posição 464
	call MostraScore          
	
	; Aguarda a tecla enter para reinício do jogo
	TelaMorte_loop:
	loadn r3, #13             ; Carrega o 13, número ascii do enter
	inchar r4                 ; Recebe dado do teclado
	cmp r4, r3                ; Compara se foi teclado enter
	jeq InicioJogo            ; Se sim, recomeça o jogo
	jmp TelaMorte_loop
	
	
	; Rotina para inicialização do jogo
	; Apaga a tela e imprime o cenario do jogo
	; Zera o tamanho da minhoca
	; Imprime a cobrinha na posição inicial andando pra cima
	; Imprime a primeira comida e começa o loop
	InicioJogo:               
 	call ApagaTela            ; Limpa a tela
 	loadn r1, #tela0Linha0	  ; Endereco onde comeca a primeira linha do cenario do jogo
	loadn r2, #1536  	      ; Cor azul
	call ImprimeTela          ; Imprime o cenario na cor azul
	loadn r5, #0              ; Zera o tamanho
	store tamanho, r5
	loadn r0, #36             ; Posição onde será mostrada o score no meio do jogo
	call MostraScore          ; Printa o score na tela
	loadn r0, #700			  ; Posição inicial da cobrinha
 	store posMinhoca, r0      ; Armazena a posição na variavel
	dec r0                    
	store corpoMinhoca, r0	  ; Posicao inicial da minhoca
	
	loadn r0, #'w'            ; Configura para a cobra começar a andar para cima
	store guardaTeclado, r0   ; E armazena no guardaTeclado para manter o movimento a cada ciclo
 	
	call Imprime_Comida       ; Chama a função Imprime_Comida para aparecer a´primeira comida do jogo
 	
 	; O loop do jogo é basciamente o movimento da cobrinha, printar a cobrinha e o delay
 	; Como o jogo é composto só pelo movimento da cobrinha, não é necessario utilizar o mod
 	Loop:
		call MoveMinhoca      ; Chama a função responsável pelo movimento da minhoca
 		call Desenha_Minhoca  ; Chama a função responsável por printar a cobra
		call Delay            ; Chama a função responsável pelo delay
		jmp Loop              ; Recomeça o loop

; A função Desenha_Minhoca pega a posição da minhoca e printa na tela, depois faz um loop do corpo de acordo com o tamanho
Desenha_Minhoca:
    push r0                   ; Preserva os valores dos registradores
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
	
    loadn r1, #'G'            ; Usamos o caractere G para representar a cobrinha
    loadn r5, #' '            ; Também carregamos o ' ' para apagar o corpo
    
    load r0, posMinhoca       ; Carregamos a posição da minhoca em R0
    loadn r2, #corpoMinhoca   ; Carrega endereço da primeira posição do corpo da minhoca
	loadn r4, #0              ; Carrega com 0 e tamanho para fazer o loop do corpo da minhoca
	load r6, tamanho          
	
	; No loop do Desenha_Minhoca_Loop, printamos a cobra para cada posição do corpo
	; Para explicação, definimos uma posição 1 e posição 2
    Desenha_Minhoca_Loop:    	
		loadi r3, r2          ; Primeiro, carregamos a posição 2 a primeira posição do corpo da minhoca (que seria a posição anterior da posição 1)
		outchar r1, r0        ; Imprime a posição 1
	    outchar r5, r3        ; Apaga a posição 2
	    ; No primeiro loop, printamos com um caractere 'G' e depois do segundo loop, printamos com caractere '0'
	    ; Nota-se também que a cada loop, imprimimos a posição 1 e apagamos a posição 2, dando movimento 
	    loadn r1, #'0'        ; Definimos o corpo com o caractere '0' depois do primeiro loop
      	storei r2, r0         ; Armazenamos então a posição 1 no vetor CorpoMinhoca
      	mov r0, r3            ; Agora a posição 2 passa para o próximo loop
        cmp r4, r6            ; Faz a comparação se foi imprimido todos os segmentos da cobrinha, de acordo com a variável tamanho
        ; Se foi imprimido todos, finaliza a rotina
        jeq Desenha_Minhoca_Fim
        ; Caso contrário, vai para a próxima posição do corpo e incrementa o R4 para fazer a comparação com o tamanho da cobra no próximo loop
        inc r4
        inc r2
        jmp Desenha_Minhoca_Loop
    ; No fim, armazena a posição da cauda e faz o pop para os registradores
    Desenha_Minhoca_Fim:
	    store posCaudaMinhoca,r3
	    pop r6
	    pop r5
	    pop r4
	    pop r3
	    pop r2
	    pop r1
	    pop r0
	    rts   

; Função para ficar atualizando o score do jogo no canto direito superior da tela	    
MostraScore:
    push r0                   ; Preservamos os valores dos registradores na pilha
    push r1
    push r2
    push r3
    push r4

    loadn r4, #'0'            ; Definimos R4 como 0     
    load r1, tamanho          ; Carregamos o tamanho da cobrinha em R1
    loadn r2, #10             ; Carregamos 10 em R2
    mod r3, r1, r2            ; R3 recebe a sobra da divisão entre R1 e R2 (no caso, as unidades)
    div r1, r1, r2            ; R1 recebe a divisão de R1 e R2 (no caso, as dezenas)
    add r3, r4, r3            ; Somamos a sobra da divisão (unidades) por 0
    outchar r3, r0            ; Imprimimos o valor

    ; Continua a conversão enquanto o valor não for zero
    MostraScore_Loop:
    	loadn r3, #0
    	cmp r1, r3            
    	; Compara o resultado da divisão por 10, se for 0 (<10), para de imprimir
    	; Se for diferente de 0 (<10), imprime o valor das dezenas, e continua para centenas
    	jeq MostraScore_Fim
        dec r0
        mod r3, r1, r2       ; Resto da divisão por 10
	    div r1, r1, r2       ; Resultado da divisão por 10
	    add r3, r4, r3       ; Soma com 0
	    outchar r3, r0       ; Imprime o valor
;		Retorno ao loop
        jmp MostraScore_Loop
   	; Quando finaliza de imprimir, restaura os valores dos registradores
    MostraScore_Fim:
    	pop r4
	    pop r3
	    pop r2
	    pop r1
	    pop r0
	    rts

; Função que verifica a colisão da cobrinha com o próprio corpo
verificaColisao:
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	
	load r0, posMinhoca      ; Carrega a posição da minhoca em R0
	loadn r1, #corpoMinhoca  ; Carrega o vetor de endereço dos corpos
	loadn r2, #0             ; Carrega o 0 em R2
	load r4, tamanho         ; Carrega o tamanho da cobra em R4
	loadn r5, #'*'           ; Carrega o * em R5 (paredes)
	; Temos o loop de verificação da colisão
	verificaColisaoLoop:
		cmp r2, r4           ; For i de 0 ao tamanho da cobra
		jeq verificaColisaoFim
		loadi r3,r1	         ; Carrega a posição de cada pedaço do corpo da cobra
		cmp r0, r3			 ; Compara a posição da cabeça com o pedaço do corpo da minhoca
		; Se for igual, morreu
		; Se for diferente, passa para o próximo pedaço da sobra
		jeq TelaMorte
		inc r2               ; Incrementa i no for
		inc r1               ; Passa para o próxima posição do pedaço do corpo da cobra
		jmp verificaColisaoLoop
	verificaColisaoFim:
		; Restaura os valores nos registradores
		pop r5
		pop r4
		pop r3
		pop r2
		pop r1
		pop r0
		rts

; Função de movimentação da cobrinha
MoveMinhoca:
 	push r0          	 	 ; Preserva os valores dos registradores na pilha
 	push r1   
 	push r2
 	; Chama a função responsável por calcular a próxima posição da minhoca
 	call MoveMinhoca_recalculaPos
 	; Após movimentar, verifica se a cobra comeu a frutinha
 	load r0, posMinhoca 	 ; Carrega a posição da minhoca
 	load r2, posComida       ; Carrega a posição da frutinha
 	; Se for igual (comeu), chama a função de aumentar a cobra
 	cmp r0, r2
	jeq Incrementa_Minhoca 		
	; Chama a função de verificar se a cobra sofreu colisão 
	call verificaColisao
 	MoveMinhoca_Skip:
 		pop r2  			 ; Restaura os valores dos registradores
 		pop r1
 		pop r0
 		rts
 		
; Função que recalcula a nova posição da cobrinha
MoveMinhoca_recalculaPos:
 	push r0  				 ; Preserva os valores dos registradores na pilha
 	push r1
 	push r2
 	push r3
 	push r4
 	push r5
 	
 	load r0, posMinhoca      ; Carrega a posição atual da cobrinha
 	
 	inchar r1 				 ; Recebe a tecla teclada
 	loadn r2, #'a'           ; Verifica se a tecla teclada foi 'a'
 	cmp r1, r2
 	jeq MoveMinhoca_recalculaPos_A
 	loadn r2, #'d'			 ; Verifica se a tecla teclada foi 'd'
 	cmp r1, r2
 	jeq MoveMinhoca_recalculaPos_D
 	loadn r2, #'w'			 ; Verifica se a tecla teclada foi 'w'
 	cmp r1, r2
 	jeq MoveMinhoca_recalculaPos_W;
 	loadn r2, #'s'			 ; Verifica se a tecla teclada foi 's'
 	cmp r1, r2
 	jeq MoveMinhoca_recalculaPos_S
 	
 	; Porém, se não foi teclado nada, a cobrinha deve manter o movimento para a mesma direção
 	; Assim, usamos o guardaTeclado para armazenar a direção da cobrinha
 	loadn r2, #'a'
 	load r1, guardaTeclado   ; Se a cobra está andando para esquerda
 	cmp r1, r2
 	jeq MoveMinhoca_recalculaPos_A
 	loadn r2, #'d'
 	load r1, guardaTeclado   ; Se a cobra está andando para direita
 	cmp r1, r2
 	jeq MoveMinhoca_recalculaPos_D
 	loadn r2, #'w'
 	load r1, guardaTeclado   ; Se a cobra está andando para cima
 	cmp r1, r2
 	jeq MoveMinhoca_recalculaPos_W
 	loadn r2, #'s'
 	load r1, guardaTeclado   ; Se a cobna está andando para baixo
 	cmp r1, r2
 	jeq MoveMinhoca_recalculaPos_S
 	; Fim da função
 	MoveMinhoca_recalculaPos_Fim:
 		store posMinhoca, r0 ; Armazena a posição da minhoca
 		pop r5 				 ; Restaura os valores armazenados nos registradores
 		pop r4
 		pop r3
 		pop r2
 		pop r1
 		pop r0
 		rts
 	
 	; Tratamento para movimentar para esquerda
 	MoveMinhoca_recalculaPos_A:
 		loadn r1, #40        
 		loadn r2, #1
 		mod r1, r0, r1		 ; Pega o resto da divisão da posição da cobrinha por 40
 		cmp r1, r2           ; Verifica se está na coluna 1 da tela (borda do cenário)
 		; Se sim, morte!
 		jeq TelaMorte
 		; Caso contrário, compara se foi teclado 'a' depois de 'd'
 		; Não pode! A cobra não pode estar andando para direita e depois virar direto para esquerda
 		; Se isso ocorre, ignora que foi teclado 'a' e mantém o movimento para direita
 		load r4, guardaTeclado
 		loadn r5, #'d'
 		cmp r4, r5
 		jeq MoveMinhoca_recalculaPos_D
 		; Caso contrário, anda uma casa para esquerda
 		dec r0
 		loadn r3, #'a'		 ; Armazena 'a' no guardaTeclado
 		store guardaTeclado, r3
 		jmp MoveMinhoca_recalculaPos_Fim
 		
 	;Tratamento para movimentar para direita
 	MoveMinhoca_recalculaPos_D:
 		loadn r1, #40
 		loadn r2, #38
 		mod r1, r0, r1		 ; Pega o resto da divisão da posição da cobrinha por 40
 		cmp r1, r2			 ; Verifica se está na coluna 38 da tela (borda do cenário)
 		; Se sim, morte!
 		jeq TelaMorte
 		; Caso contrário, compara se foi teclado 'd' depois de 'a'
 		; Não pode! A cobra não pode estar andando para esquerda e depois virar direto para esquerda
 		; Se isso ocorre, ignora que foi teclado 'd' e mantém o movimento para esquerda
 		load r4, guardaTeclado
 		loadn r5, #'a'
 		cmp r4, r5
 		jeq MoveMinhoca_recalculaPos_A
 		; Caso contrário, anda uma casa para direita
 		inc r0
 		loadn r3, #'d'		 ; Armazena 'd' no guardaTeclado
 		store guardaTeclado, r3
 		jmp MoveMinhoca_recalculaPos_Fim
 	
 	; Tratamento para movimentar para cima
 	MoveMinhoca_recalculaPos_W:
 		loadn r1, #160
 		cmp r0, r1			 ; Compara se a cobra está na linha 3 (<160)
 		; Se sim, morte!
 		jle TelaMorte	
 		; Caso contrário, compara se foi teclado 'w' depois de 's'
 		; Não pode! A cobra não pode estar andando pra baixo e depois virar direto para cima
 		; Se isso ocorre, ignora que foi teclado 'w' e mantém o movimento para baixo 	 
 		load r4, guardaTeclado
 		loadn r5, #'s'
 		cmp r4, r5
 		jeq MoveMinhoca_recalculaPos_S
 		; Caso contrário, anda uma casa pra cima (-40)
 		loadn r1, #40
 		sub r0, r0, r1
 		loadn r3, #'w'		 ; Armazena 'w' no guardaTeclado
 		store guardaTeclado, r3
 		jmp MoveMinhoca_recalculaPos_Fim
 	
 	; Tratamento para movimentar para baixo
 	MoveMinhoca_recalculaPos_S:
 		loadn r1, #1119
 		cmp r0, r1			 ; Compara se a cobra está na linha 29
 		; Se sim, morte!
 		jgr TelaMorte
 		; Caso contrário, compara se foi teclado 's' depois de 'w'
 		; Não pode! A cobra não pode estar andando para cima e depois virar direto para baixo
 		; Se isso ocorre, ignora que foi teclado 's' e mantém o movimento para cima
 		load r4, guardaTeclado
 		loadn r5, #'w'
 		cmp r4, r5
 		jeq MoveMinhoca_recalculaPos_W
 		; Caso contrário, anda uma casa para baixo (+40)
 		loadn r1, #40
 		add r0, r0, r1
 		loadn r3, #'s'		 ; Armazena 's' no guardaTeclado
 		store guardaTeclado, r3
 		jmp MoveMinhoca_recalculaPos_Fim

; Função que aumenta a cobrinha quando come uma frutinha
Incrementa_Minhoca:
	push r0
	push r1
	push r2
	;Se a cobrinha come a comida, imprime outra
	call Imprime_Comida      
	; Carregamos a posição da cauda
	load r0, posCaudaMinhoca
	; Carregamos também o tamanho da cobrinha
	load r2, tamanho
	; E o endereço do vetor de posições
	loadn r1, #corpoMinhoca
	inc r2			         ; Incrementa o tamanho
	add r1, r1, r2			 ; Pegamos a primeira posição do vetor e somamos com o tamanho (ultima posição)
	storei r1, r0			 ; Armazenamos a posição da cauda no ultima posição do vetor
	
	store tamanho, r2		 ; Armazena o tamanho da cobra
	loadn r0, #36			 ; Imprime o score na posição 36 da tela
	call MostraScore
	
	pop r2					 ; Restaura os valores dos registradores
	pop r1
	pop r0
	jmp MoveMinhoca_Skip

; Função de apagar a tela
ApagaTela:
	push r0					 ; Preserva os valores dos registradores
	push r1
	
	loadn r0, #1200			 ; Carrega 1200, que será usado para o loop de apagar as 1200 posições da tela
	loadn r1, #' '		     ; O "apagar" é imprimir espaço
	
	   ApagaTela_Loop:		 ; Fazemos um for para as 1200 posições da tela
		dec r0				 ; i--
		outchar r1, r0		 ; Imprime espaço
		jnz ApagaTela_Loop
 
	pop r1					 ; Restaura os registradores
	pop r0
	rts	
	
;  Rotina de Impresao de Cenario na Tela Inteira
ImprimeTela:
	push r0					 ; Protege o registrador na pilha para ser usado na subrotina
	;  r1 = endereco onde comeca a primeira linha do Cenario
	;  r2 = cor do Cenario para ser impresso
	push r3					
	push r4
	push r5	
	
	loadn r0, #0  			 ; Posicao inicial tem que ser o comeco da tela!
	loadn r3, #40			 ; Passa para próxima linha
	loadn r4, #41			 ; incremento do ponteiro 
	loadn r5, #1200			 ; Limite da tela
	
   ImprimeTela_Loop:
		call ImprimeStr		 ; Chama a função imprimeStr para imprimir cada pixel
		add r0, r0, r3  	 ; incrementa posicao para a segunda linha na tela -->  r0 = r0 + 40
		add r1, r1, r4  	 ; incrementa o ponteiro para o comeco da proxima linha na memoria
		cmp r0, r5			 ; Verifica se acabou a tela
		jne ImprimeTela_Loop
	; Restaura os valroes dos registradores
	pop r5	
	pop r4
	pop r3
	pop r0
	rts

;  Rotina de impresao de mensagens
ImprimeStr:  
	; r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso
	; r1 = endereco onde comeca a mensagem; 
	; r2 = cor da mensagem
	; A mensagem será impressa até encontrar \0
	push r0	; Protege o registrador na pilha para preservar seu valor
	push r1
	push r2	
	push r3	
	push r4	
	
	loadn r3, #'\0'			 ; Criterio de parada
	
   ImprimeStr_Loop:	
		loadi r4, r1		 ; Obtem o primeiro caractere
		cmp r4, r3		     ; Verifica critério de parada
		jeq ImprimeStr_Sai
		add r4, r2, r4		 ; Soma a Cor
		outchar r4, r0		 ; Imprime o caractere na tela
		inc r0				 ; Incrementa a posicao na tela
		inc r1				 ; Incrementa o ponteiro da String
		jmp ImprimeStr_Loop
	
   ImprimeStr_Sai:	
	pop r4					 ; Restaura os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts

; Rotina de impressão da frutinha
Imprime_Comida:
	push r0 				 ; Protege os registradores na pilha
	push r1
	push r2
	push r3

	loadn r1, #2368			 ; Caractere @ vermelho
	loadn r2, #comida		 ; Endereço do primeiro vetor de posição da frutinha
	load r3, iComida		 ; Incremento para caminhar pela string
	add r0, r2, r3           ; Posição x da string
	loadi r2, r0			 ; Carrega a posição da frutinha na tela
	outchar r1, r2		 	 ; Imprime a frutinha na posição dada
	
	inc r3					 ; Depois de impresso, passa para a próxima frutinha do vetor
	store iComida, r3
	store posComida, r2
	
	pop r3					 ; Restaura os valores do registrador
	pop r2
	pop r1
	pop r0
	rts
	
; Rotina de delay, vai definir a velocidade da cobrinha
Delay:
	push r0					 ; Preserva os registradores
	push r1
	
	loadn r1, #400			 ; Define o primeiro valor para o loop
   	Delay_volta2:		
		loadn r0, #3000	 	 ; Define o segundo valor para o loop
   	Delay_volta: 
   	; No delay_volta, a cada ciclo de maquina decrementa de 3000 até 0
   	; Quando atinge 0, decrementa de R1 e recarrega R0 com 3000
   	; O delay finaliza quando ambos os registradores atingem 0
   	; O tempo de delay é dado de acordo com os valores dos registradores e o tempo do ciclo de maquina
		dec r0			
		jnz Delay_volta	
		dec r1
		jnz Delay_volta2
	
		pop r1				 ; Restaura os valores dos registradores
		pop r0
		rts	

; Cenário do jogo
tela0Linha0  : string "                           SCORE:       "
tela0Linha1  : string "________________________________________"
tela0Linha2  : string "****************************************"
tela0Linha3  : string "*                                      *"
tela0Linha4  : string "*                                      *"
tela0Linha5  : string "*                                      *"
tela0Linha6  : string "*                                      *"
tela0Linha7  : string "*                                      *"
tela0Linha8  : string "*                                      *"
tela0Linha9  : string "*                                      *"
tela0Linha10 : string "*                                      *"
tela0Linha11 : string "*                                      *"
tela0Linha12 : string "*                                      *"
tela0Linha13 : string "*                                      *"
tela0Linha14 : string "*                                      *"
tela0Linha15 : string "*                                      *"
tela0Linha16 : string "*                                      *"
tela0Linha17 : string "*                                      *"
tela0Linha18 : string "*                                      *"
tela0Linha19 : string "*                                      *"
tela0Linha20 : string "*                                      *"
tela0Linha21 : string "*                                      *"
tela0Linha22 : string "*                                      *"
tela0Linha23 : string "*                                      *"
tela0Linha24 : string "*                                      *"
tela0Linha25 : string "*                                      *"
tela0Linha26 : string "*                                      *"
tela0Linha27 : string "*                                      *"
tela0Linha28 : string "*                                      *"
tela0Linha29 : string "****************************************"

; Tela de inicio do jogo
tela1Linha0  : string "                                        "
tela1Linha1  : string "________________________________________"
tela1Linha2  : string "****************************************"
tela1Linha3  : string "*                                      *"
tela1Linha4  : string "*                                      *"
tela1Linha5  : string "*                                      *"
tela1Linha6  : string "*                                      *"
tela1Linha7  : string "*                                      *"
tela1Linha8  : string "*                                      *"
tela1Linha9  : string "*            JOGO DA COBRINHA          *"
tela1Linha10 : string "*                                      *"
tela1Linha11 : string "*                                      *"
tela1Linha12 : string "*       DIGITE ENTER PARA COMECAR      *"
tela1Linha13 : string "*                                      *"
tela1Linha14 : string "*                                      *"
tela1Linha15 : string "*                                      *"
tela1Linha16 : string "*                                      *"
tela1Linha17 : string "*                                      *"
tela1Linha18 : string "*                                      *"
tela1Linha19 : string "*                                      *"
tela1Linha20 : string "*                                      *"
tela1Linha21 : string "*                                      *"
tela1Linha22 : string "*                                      *"
tela1Linha23 : string "*                                      *"
tela1Linha24 : string "*                                      *"
tela1Linha25 : string "*                                      *"
tela1Linha26 : string "*                                      *"
tela1Linha27 : string "*                                      *"
tela1Linha28 : string "*                                      *"
tela1Linha29 : string "****************************************"

; Tela de morte
tela2Linha0  : string "                                        "
tela2Linha1  : string "________________________________________"
tela2Linha2  : string "****************************************"
tela2Linha3  : string "*                                      *"
tela2Linha4  : string "*                                      *"
tela2Linha5  : string "*                                      *"
tela2Linha6  : string "*                                      *"
tela2Linha7  : string "*                                      *"
tela2Linha8  : string "*                                      *"
tela2Linha9  : string "*               GAME OVER              *"
tela2Linha10 : string "*                                      *"
tela2Linha11 : string "*               SCORE:                 *"
tela2Linha12 : string "*                                      *"
tela2Linha13 : string "*       DIGITE ENTER PARA COMECAR      *"
tela2Linha14 : string "*                                      *"
tela2Linha15 : string "*                                      *"
tela2Linha16 : string "*                                      *"
tela2Linha17 : string "*                                      *"
tela2Linha18 : string "*                                      *"
tela2Linha19 : string "*                                      *"
tela2Linha20 : string "*                                      *"
tela2Linha21 : string "*                                      *"
tela2Linha22 : string "*                                      *"
tela2Linha23 : string "*                                      *"
tela2Linha24 : string "*                                      *"
tela2Linha25 : string "*                                      *"
tela2Linha26 : string "*                                      *"
tela2Linha27 : string "*                                      *"
tela2Linha28 : string "*                                      *"
tela2Linha29 : string "****************************************"

; Vetor de posição da frutinha
; Pseudo-aleatória
comida : var #1200
static comida + #0, #536
static comida + #1, #1097
static comida + #2, #1020
static comida + #3, #620
static comida + #4, #451
static comida + #5, #1078
static comida + #6, #772
static comida + #7, #1047
static comida + #8, #976
static comida + #9, #565
static comida + #10, #490
static comida + #11, #515
static comida + #12, #175
static comida + #13, #350
static comida + #14, #510
static comida + #15, #165
static comida + #16, #275
static comida + #17, #605
static comida + #18, #726
static comida + #19, #654
static comida + #20, #938
static comida + #21, #766
static comida + #22, #841
static comida + #23, #391
static comida + #24, #163
static comida + #25, #990
static comida + #26, #388
static comida + #27, #450
static comida + #28, #331
static comida + #29, #534
static comida + #30, #1038
static comida + #31, #847
static comida + #32, #989
static comida + #33, #968
static comida + #34, #216
static comida + #35, #194
static comida + #36, #567
static comida + #37, #485
static comida + #38, #913
static comida + #39, #751
static comida + #40, #207
static comida + #41, #628
static comida + #42, #407
static comida + #43, #572
static comida + #44, #1051
static comida + #45, #885
static comida + #46, #945
static comida + #47, #402
static comida + #48, #607
static comida + #49, #258
static comida + #50, #725
static comida + #51, #550
static comida + #52, #463
static comida + #53, #291
static comida + #54, #949
static comida + #55, #431
static comida + #56, #796
static comida + #57, #643
static comida + #58, #794
static comida + #59, #979
static comida + #60, #1014
static comida + #61, #975
static comida + #62, #300
static comida + #63, #267
static comida + #64, #1056
static comida + #65, #710
static comida + #66, #481
static comida + #67, #1048
static comida + #68, #314
static comida + #69, #532
static comida + #70, #763
static comida + #71, #542
static comida + #72, #1023
static comida + #73, #1044
static comida + #74, #555
static comida + #75, #354
static comida + #76, #386
static comida + #77, #340
static comida + #78, #478
static comida + #79, #994
static comida + #80, #797
static comida + #81, #665
static comida + #82, #382
static comida + #83, #269
static comida + #84, #337
static comida + #85, #557
static comida + #86, #1104
static comida + #87, #943
static comida + #88, #948
static comida + #89, #728
static comida + #90, #822
static comida + #91, #531
static comida + #92, #624
static comida + #93, #881
static comida + #94, #409
static comida + #95, #1063
static comida + #96, #283
static comida + #97, #983
static comida + #98, #972
static comida + #99, #525
static comida + #100, #958
static comida + #101, #365
static comida + #102, #929
static comida + #103, #577
static comida + #104, #831
static comida + #105, #708
static comida + #106, #818
static comida + #107, #771
static comida + #108, #201
static comida + #109, #435
static comida + #110, #593
static comida + #111, #294
static comida + #112, #677
static comida + #113, #215
static comida + #114, #462
static comida + #115, #1010
static comida + #116, #816
static comida + #117, #564
static comida + #118, #753
static comida + #119, #211
static comida + #120, #658
static comida + #121, #325
static comida + #122, #898
static comida + #123, #579
static comida + #124, #210
static comida + #125, #649
static comida + #126, #568
static comida + #127, #1087
static comida + #128, #196
static comida + #129, #422
static comida + #130, #830
static comida + #131, #1036
static comida + #132, #357
static comida + #133, #326
static comida + #134, #805
static comida + #135, #584
static comida + #136, #276
static comida + #137, #547
static comida + #138, #987
static comida + #139, #798
static comida + #140, #695
static comida + #141, #874
static comida + #142, #1019
static comida + #143, #1102
static comida + #144, #379
static comida + #145, #511
static comida + #146, #433
static comida + #147, #1109
static comida + #148, #1107
static comida + #149, #928
static comida + #150, #457
static comida + #151, #651
static comida + #152, #735
static comida + #153, #894
static comida + #154, #780
static comida + #155, #1108
static comida + #156, #214
static comida + #157, #349
static comida + #158, #946
static comida + #159, #854
static comida + #160, #604
static comida + #161, #705
static comida + #162, #459
static comida + #163, #686
static comida + #164, #370
static comida + #165, #282
static comida + #166, #343
static comida + #167, #917
static comida + #168, #569
static comida + #169, #251
static comida + #170, #1029
static comida + #171, #896
static comida + #172, #701
static comida + #173, #832
static comida + #174, #259
static comida + #175, #204
static comida + #176, #638
static comida + #177, #714
static comida + #178, #985
static comida + #179, #295
static comida + #180, #668
static comida + #181, #627
static comida + #182, #891
static comida + #183, #452
static comida + #184, #234
static comida + #185, #642
static comida + #186, #523
static comida + #187, #845
static comida + #188, #1100
static comida + #189, #869
static comida + #190, #302
static comida + #191, #746
static comida + #192, #792
static comida + #193, #1061
static comida + #194, #363
static comida + #195, #614
static comida + #196, #587
static comida + #197, #310
static comida + #198, #915
static comida + #199, #1012
static comida + #200, #426
static comida + #201, #663
static comida + #202, #712
static comida + #203, #212
static comida + #204, #802
static comida + #205, #730
static comida + #206, #487
static comida + #207, #807
static comida + #208, #1004
static comida + #209, #1002
static comida + #210, #1083
static comida + #211, #414
static comida + #212, #857
static comida + #213, #873
static comida + #214, #1067
static comida + #215, #248
static comida + #216, #471
static comida + #217, #747
static comida + #218, #1094
static comida + #219, #436
static comida + #220, #174
static comida + #221, #1082
static comida + #222, #806
static comida + #223, #856
static comida + #224, #438
static comida + #225, #997
static comida + #226, #942
static comida + #227, #432
static comida + #228, #860
static comida + #229, #739
static comida + #230, #924
static comida + #231, #506
static comida + #232, #226
static comida + #233, #693
static comida + #234, #886
static comida + #235, #764
static comida + #236, #289
static comida + #237, #956
static comida + #238, #644
static comida + #239, #770
static comida + #240, #795
static comida + #241, #205
static comida + #242, #190
static comida + #243, #901
static comida + #244, #425
static comida + #245, #573
static comida + #246, #1071
static comida + #247, #698
static comida + #248, #844
static comida + #249, #423
static comida + #250, #922
static comida + #251, #926
static comida + #252, #724
static comida + #253, #344
static comida + #254, #941
static comida + #255, #824
static comida + #256, #317
static comida + #257, #419
static comida + #258, #801
static comida + #259, #252
static comida + #260, #641
static comida + #261, #509
static comida + #262, #397
static comida + #263, #223
static comida + #264, #316
static comida + #265, #472
static comida + #266, #892
static comida + #267, #1049
static comida + #268, #167
static comida + #269, #288
static comida + #270, #1089
static comida + #271, #884
static comida + #272, #862
static comida + #273, #466
static comida + #274, #890
static comida + #275, #378
static comida + #276, #995
static comida + #277, #396
static comida + #278, #1001
static comida + #279, #522
static comida + #280, #571
static comida + #281, #870
static comida + #282, #303
static comida + #283, #533
static comida + #284, #264
static comida + #285, #323
static comida + #286, #262
static comida + #287, #721
static comida + #288, #691
static comida + #289, #619
static comida + #290, #909
static comida + #291, #424
static comida + #292, #286
static comida + #293, #808
static comida + #294, #364
static comida + #295, #756
static comida + #296, #220
static comida + #297, #1081
static comida + #298, #273
static comida + #299, #758
static comida + #300, #322
static comida + #301, #415
static comida + #302, #304
static comida + #303, #1033
static comida + #304, #384
static comida + #305, #878
static comida + #306, #166
static comida + #307, #1116
static comida + #308, #1091
static comida + #309, #733
static comida + #310, #1084
static comida + #311, #952
static comida + #312, #998
static comida + #313, #306
static comida + #314, #249
static comida + #315, #1065
static comida + #316, #1103
static comida + #317, #675
static comida + #318, #514
static comida + #319, #442
static comida + #320, #966
static comida + #321, #963
static comida + #322, #526
static comida + #323, #1030
static comida + #324, #313
static comida + #325, #189
static comida + #326, #969
static comida + #327, #305
static comida + #328, #1034
static comida + #329, #430
static comida + #330, #934
static comida + #331, #652
static comida + #332, #329
static comida + #333, #173
static comida + #334, #366
static comida + #335, #496
static comida + #336, #347
static comida + #337, #561
static comida + #338, #597
static comida + #339, #855
static comida + #340, #583
static comida + #341, #702
static comida + #342, #842
static comida + #343, #1011
static comida + #344, #461
static comida + #345, #804
static comida + #346, #346
static comida + #347, #437
static comida + #348, #540
static comida + #349, #476
static comida + #350, #837
static comida + #351, #455
static comida + #352, #387
static comida + #353, #1054
static comida + #354, #676
static comida + #355, #636
static comida + #356, #1095
static comida + #357, #954
static comida + #358, #743
static comida + #359, #342
static comida + #360, #351
static comida + #361, #947
static comida + #362, #441
static comida + #363, #556
static comida + #364, #825
static comida + #365, #817
static comida + #366, #779
static comida + #367, #964
static comida + #368, #381
static comida + #369, #473
static comida + #370, #301
static comida + #371, #241
static comida + #372, #828
static comida + #373, #809
static comida + #374, #1027
static comida + #375, #263
static comida + #376, #810
static comida + #377, #925
static comida + #378, #231
static comida + #379, #867
static comida + #380, #464
static comida + #381, #731
static comida + #382, #608
static comida + #383, #255
static comida + #384, #546
static comida + #385, #734
static comida + #386, #1117
static comida + #387, #421
static comida + #388, #673
static comida + #389, #394
static comida + #390, #410
static comida + #391, #937
static comida + #392, #871
static comida + #393, #566
static comida + #394, #1111
static comida + #395, #260
static comida + #396, #689
static comida + #397, #477
static comida + #398, #356
static comida + #399, #398
static comida + #400, #609
static comida + #401, #1058
static comida + #402, #447
static comida + #403, #281
static comida + #404, #377
static comida + #405, #1070
static comida + #406, #406
static comida + #407, #781
static comida + #408, #229
static comida + #409, #492
static comida + #410, #601
static comida + #411, #988
static comida + #412, #1021
static comida + #413, #537
static comida + #414, #615
static comida + #415, #1092
static comida + #416, #467
static comida + #417, #973
static comida + #418, #843
static comida + #419, #375
static comida + #420, #711
static comida + #421, #367
static comida + #422, #933
static comida + #423, #238
static comida + #424, #697
static comida + #425, #541
static comida + #426, #1016
static comida + #427, #411
static comida + #428, #1113
static comida + #429, #272
static comida + #430, #393
static comida + #431, #202
static comida + #432, #1042
static comida + #433, #594
static comida + #434, #744
static comida + #435, #1064
static comida + #436, #581
static comida + #437, #1101
static comida + #438, #270
static comida + #439, #591
static comida + #440, #768
static comida + #441, #740
static comida + #442, #986
static comida + #443, #195
static comida + #444, #332
static comida + #445, #932
static comida + #446, #257
static comida + #447, #254
static comida + #448, #836
static comida + #449, #852
static comida + #450, #1118
static comida + #451, #783
static comida + #452, #670
static comida + #453, #502
static comida + #454, #660
static comida + #455, #246
static comida + #456, #188
static comida + #457, #418
static comida + #458, #713
static comida + #459, #1090
static comida + #460, #528
static comida + #461, #951
static comida + #462, #392
static comida + #463, #803
static comida + #464, #598
static comida + #465, #848
static comida + #466, #521
static comida + #467, #448
static comida + #468, #187
static comida + #469, #774
static comida + #470, #612
static comida + #471, #784
static comida + #472, #328
static comida + #473, #232
static comida + #474, #454
static comida + #475, #685
static comida + #476, #769
static comida + #477, #1003
static comida + #478, #978
static comida + #479, #782
static comida + #480, #980
static comida + #481, #390
static comida + #482, #475
static comida + #483, #911
static comida + #484, #887
static comida + #485, #741
static comida + #486, #443
static comida + #487, #1096
static comida + #488, #1068
static comida + #489, #266
static comida + #490, #529
static comida + #491, #338
static comida + #492, #1017
static comida + #493, #570
static comida + #494, #465
static comida + #495, #961
static comida + #496, #633
static comida + #497, #897
static comida + #498, #875
static comida + #499, #895
static comida + #500, #355
static comida + #501, #750
static comida + #502, #709
static comida + #503, #773
static comida + #504, #683
static comida + #505, #324
static comida + #506, #967
static comida + #507, #850
static comida + #508, #191
static comida + #509, #914
static comida + #510, #1106
static comida + #511, #469
static comida + #512, #403
static comida + #513, #737
static comida + #514, #664
static comida + #515, #228
static comida + #516, #757
static comida + #517, #429
static comida + #518, #687
static comida + #519, #265
static comida + #520, #893
static comida + #521, #866
static comida + #522, #268
static comida + #523, #586
static comida + #524, #549
static comida + #525, #504
static comida + #526, #791
static comida + #527, #877
static comida + #528, #562
static comida + #529, #1060
static comida + #530, #846
static comida + #531, #197
static comida + #532, #858
static comida + #533, #524
static comida + #534, #376
static comida + #535, #299
static comida + #536, #1015
static comida + #537, #775
static comida + #538, #706
static comida + #539, #1073
static comida + #540, #456
static comida + #541, #787
static comida + #542, #1035
static comida + #543, #965
static comida + #544, #408
static comida + #545, #287
static comida + #546, #330
static comida + #547, #551
static comida + #548, #617
static comida + #549, #851
static comida + #550, #827
static comida + #551, #380
static comida + #552, #900
static comida + #553, #244
static comida + #554, #352
static comida + #555, #790
static comida + #556, #602
static comida + #557, #755
static comida + #558, #716
static comida + #559, #176
static comida + #560, #284
static comida + #561, #180
static comida + #562, #1037
static comida + #563, #935
static comida + #564, #907
static comida + #565, #548
static comida + #566, #245
static comida + #567, #247
static comida + #568, #530
static comida + #569, #630
static comida + #570, #315
static comida + #571, #694
static comida + #572, #369
static comida + #573, #218
static comida + #574, #235
static comida + #575, #991
static comida + #576, #219
static comida + #577, #1007
static comida + #578, #427
static comida + #579, #939
static comida + #580, #493
static comida + #581, #474
static comida + #582, #483
static comida + #583, #236
static comida + #584, #575
static comida + #585, #503
static comida + #586, #1110
static comida + #587, #953
static comida + #588, #646
static comida + #589, #762
static comida + #590, #460
static comida + #591, #974
static comida + #592, #341
static comida + #593, #1066
static comida + #594, #667
static comida + #595, #611
static comida + #596, #703
static comida + #597, #655
static comida + #598, #230
static comida + #599, #271
static comida + #600, #930
static comida + #601, #821
static comida + #602, #692
static comida + #603, #789
static comida + #604, #1105
static comida + #605, #899
static comida + #606, #865
static comida + #607, #811
static comida + #608, #179
static comida + #609, #833
static comida + #610, #707
static comida + #611, #992
static comida + #612, #458
static comida + #613, #786
static comida + #614, #736
static comida + #615, #908
static comida + #616, #616
static comida + #617, #554
static comida + #618, #1008
static comida + #619, #576
static comida + #620, #977
static comida + #621, #1041
static comida + #622, #696
static comida + #623, #372
static comida + #624, #729
static comida + #625, #1072
static comida + #626, #669
static comida + #627, #345
static comida + #628, #912
static comida + #629, #516
static comida + #630, #335
static comida + #631, #318
static comida + #632, #1032
static comida + #633, #931
static comida + #634, #508
static comida + #635, #1024
static comida + #636, #468
static comida + #637, #767
static comida + #638, #563
static comida + #639, #637
static comida + #640, #585
static comida + #641, #761
static comida + #642, #916
static comida + #643, #666
static comida + #644, #512
static comida + #645, #820
static comida + #646, #626
static comida + #647, #1077
static comida + #648, #927
static comida + #649, #362
static comida + #650, #1031
static comida + #651, #653
static comida + #652, #1052
static comida + #653, #906
static comida + #654, #498
static comida + #655, #486
static comida + #656, #1088
static comida + #657, #835
static comida + #658, #1099
static comida + #659, #224
static comida + #660, #859
static comida + #661, #348
static comida + #662, #723
static comida + #663, #172
static comida + #664, #727
static comida + #665, #513
static comida + #666, #168
static comida + #667, #1006
static comida + #668, #416
static comida + #669, #444
static comida + #670, #982
static comida + #671, #596
static comida + #672, #777
static comida + #673, #1098
static comida + #674, #227
static comida + #675, #754
static comida + #676, #290
static comida + #677, #242
static comida + #678, #923
static comida + #679, #621
static comida + #680, #311
static comida + #681, #588
static comida + #682, #405
static comida + #683, #785
static comida + #684, #1074
static comida + #685, #374
static comida + #686, #1086
static comida + #687, #327
static comida + #688, #622
static comida + #689, #905
static comida + #690, #539
static comida + #691, #420
static comida + #692, #936
static comida + #693, #297
static comida + #694, #518
static comida + #695, #815
static comida + #696, #181
static comida + #697, #552
static comida + #698, #169
static comida + #699, #984
static comida + #700, #1022
static comida + #701, #589
static comida + #702, #491
static comida + #703, #250
static comida + #704, #237
static comida + #705, #657
static comida + #706, #631
static comida + #707, #645
static comida + #708, #274
static comida + #709, #580
static comida + #710, #682
static comida + #711, #955
static comida + #712, #823
static comida + #713, #333
static comida + #714, #413
static comida + #715, #312
static comida + #716, #849
static comida + #717, #674
static comida + #718, #192
static comida + #719, #185
static comida + #720, #1043
static comida + #721, #595
static comida + #722, #225
static comida + #723, #868
static comida + #724, #389
static comida + #725, #590
static comida + #726, #1059
static comida + #727, #650
static comida + #728, #217
static comida + #729, #629
static comida + #730, #1026
static comida + #731, #940
static comida + #732, #981
static comida + #733, #904
static comida + #734, #748
static comida + #735, #634
static comida + #736, #970
static comida + #737, #678
static comida + #738, #962
static comida + #739, #902
static comida + #740, #206
static comida + #741, #864
static comida + #742, #648
static comida + #743, #717
static comida + #744, #1085
static comida + #745, #495
static comida + #746, #353
static comida + #747, #883
static comida + #748, #417
static comida + #749, #882
static comida + #750, #198
static comida + #751, #178
static comida + #752, #1069
static comida + #753, #164
static comida + #754, #412
static comida + #755, #1075
static comida + #756, #186
static comida + #757, #863
static comida + #758, #428
static comida + #759, #358
static comida + #760, #889
static comida + #761, #944
static comida + #762, #578
static comida + #763, #778
static comida + #764, #950
static comida + #765, #309
static comida + #766, #704
static comida + #767, #545
static comida + #768, #752
static comida + #769, #1005
static comida + #770, #368
static comida + #771, #921
static comida + #772, #957
static comida + #773, #625
static comida + #774, #715
static comida + #775, #993
static comida + #776, #277
static comida + #777, #500
static comida + #778, #700
static comida + #779, #829
static comida + #780, #308
static comida + #781, #261
static comida + #782, #910
static comida + #783, #208
static comida + #784, #623
static comida + #785, #293
static comida + #786, #732
static comida + #787, #876
static comida + #788, #1114
static comida + #789, #745
static comida + #790, #404
static comida + #791, #853
static comida + #792, #497
static comida + #793, #819
static comida + #794, #1093
static comida + #795, #221
static comida + #796, #632
static comida + #797, #278
static comida + #798, #765
static comida + #799, #484
static comida + #800, #1050
static comida + #801, #170
static comida + #802, #535
static comida + #803, #813
static comida + #804, #749
static comida + #805, #171
static comida + #806, #861
static comida + #807, #647
static comida + #808, #656
static comida + #809, #385
static comida + #810, #494
static comida + #811, #1057
static comida + #812, #517
static comida + #813, #718
static comida + #814, #610
static comida + #815, #243
static comida + #816, #253
static comida + #817, #1009
static comida + #818, #162
static comida + #819, #543
static comida + #820, #690
static comida + #821, #826
static comida + #822, #445
static comida + #823, #738
static comida + #824, #184
static comida + #825, #872
static comida + #826, #505
static comida + #827, #1013
static comida + #828, #453
static comida + #829, #659
static comida + #830, #1025
static comida + #831, #574
static comida + #832, #499
static comida + #833, #538
static comida + #834, #213
static comida + #835, #1018
static comida + #836, #681
static comida + #837, #298
static comida + #838, #371
static comida + #839, #592
static comida + #840, #1045
static comida + #841, #699
static comida + #842, #373
static comida + #843, #544
static comida + #844, #812
static comida + #845, #788
static comida + #846, #285
static comida + #847, #401
static comida + #848, #553
static comida + #849, #292
static comida + #850, #482
static comida + #851, #606
static comida + #852, #209
static comida + #853, #618
static comida + #854, #793
static comida + #855, #776
static comida + #856, #307
static comida + #857, #161
static comida + #858, #635
static comida + #859, #193
static comida + #860, #334
static comida + #861, #395
static comida + #862, #662
static comida + #863, #688
static comida + #864, #446
static comida + #865, #182
static comida + #866, #971
static comida + #867, #507
static comida + #868, #203
static comida + #869, #918
static comida + #870, #1062
static comida + #871, #488
static comida + #872, #834
static comida + #873, #603
static comida + #874, #661
static comida + #875, #222
static comida + #876, #177
static comida + #877, #383
static comida + #878, #1028
static comida + #879, #888
static comida + #880, #336
static comida + #881, #672
static comida + #882, #256
static comida + #883, #470
static comida + #884, #434
static comida + #885, #558
static comida + #886, #501
static comida + #887, #1055
static comida + #888, #321
static comida + #889, #449
static comida + #890, #1112
static comida + #891, #489
static comida + #892, #722
static comida + #893, #1046
static comida + #894, #361
static comida + #895, #1076
static comida + #896, #814
static comida + #897, #527
static comida + #898, #339
static comida + #899, #296
static comida + #900, #838
static comida + #901, #903
static comida + #902, #742
static comida + #903, #1053
static comida + #904, #582
static comida + #905, #671
static comida + #906, #613
static comida + #907, #233
static comida + #908, #996
static comida + #909, #183
static comida + #910, #1115
static comida + #911, #684