; JOGO DA COBRINHA
jmp Main

posMinhoca: var #1			; Contem a posicao atual da Nave
posAntMinhoca: var #1		; Contem a posicao anterior da Nave

guardaTeclado: var #1

score: var #1000

 Main:
 	call ApagaTela
 	loadn R1, #tela0Linha0	    ; Endereco onde comeca a primeira linha do cenario
	loadn R2, #1536  			; cor branca
	call ImprimeTela
	
	loadn R0, #699			
	store posMinhoca, R0		; Zera Posicao Atual da minhoca
	store posAntMinhoca, R0	    ; Zera Posicao Anterior da minhoca
 	
 	loadn R0, #0
 	loadn R2, #0
 	 
 	store score, R0
 	
 	Loop:
	
		loadn R1, #10
		mod R1, R0, R1
		cmp R1, R2		; if (mod(c/10)==0
		ceq MoveMinhoca
		
		call Delay
		inc R0
		jmp Loop
 
 MoveMinhoca: 
 	push R0
 	push R1
 		
 	call MoveMinhoca_RecalculaPos
 	
 	load R0, posMinhoca
 	load R1, posAntMinhoca
 	cmp R0, R1
 	jeq MoveMinhoca_Skip
 		call MoveMinhoca_Apaga
 		call MoveMinhoca_Desenha
 	MoveMinhoca_Skip:
 		pop R1
 		pop R0
 		rts
 		
 MoveMinhoca_Apaga:
 	push R0
 	push R1
 	push R2
 	push R3
 	push R4
 	push R5
 	load R0, posAntMinhoca
 	loadn R1, #tela0Linha0
 	add R2, R1, R0
 	loadn R4, #40
 	div R3, R0, R4
 	Add R2, R2, R3
 	Loadi R5, R2
 	Outchar R5, R0
 	
 	pop R5
 	pop R4
 	pop R3
 	pop R2
 	pop R1
 	pop R0
 	rts
 	
 MoveMinhoca_RecalculaPos:
 	push R0 
 	push R1
 	push R2
 	push R3
 	
 	load R0, posMinhoca
 	
 	inchar R1
 	loadn R2, #'a'
 	cmp R1, R2
 	jeq MoveMinhoca_RecalculaPos_A
 	
 	loadn R2, #'d'
 	cmp R1, R2
 	jeq MoveMinhoca_RecalculaPos_D
 	
 	loadn R2, #'w'
 	cmp R1, R2
 	jeq MoveMinhoca_RecalculaPos_W
 	
 	loadn R2, #'s'
 	cmp R1, R2
 	jeq MoveMinhoca_RecalculaPos_S
 	
 	
 	loadn R2, #'a'
 	load R1, guardaTeclado
 	cmp R1, R2
 	jeq MoveMinhoca_RecalculaPos_A
 	
 	loadn R2, #'d'
 	load R1, guardaTeclado
 	cmp R1, R2
 	jeq MoveMinhoca_RecalculaPos_D
 	
 	loadn R2, #'w'
 	load R1, guardaTeclado
 	cmp R1, R2
 	jeq MoveMinhoca_RecalculaPos_W
 	
 	loadn R2, #'s'
 	load R1, guardaTeclado
 	cmp R1, R2
 	jeq MoveMinhoca_RecalculaPos_S
 	
 	
 	MoveMinhoca_RecalculaPos_Fim:
 		store posMinhoca, R0
 		pop R3
 		pop R2
 		pop R1
 		pop R0
 		rts
 		
 	MoveMinhoca_RecalculaPos_A:
 		loadn R1, #40
 		loadn R2, #0
 		mod R1, R0, R1
 		cmp R1, R2
 		jeq MoveMinhoca_RecalculaPos_Fim
 		dec R0
 		loadn R3, #'a'
 		store guardaTeclado, R3
 		jmp MoveMinhoca_RecalculaPos_Fim
 		
 	MoveMinhoca_RecalculaPos_D:
 		loadn R1, #40
 		loadn R2, #39
 		mod R1, R0, R1
 		cmp R1, R2
 		jeq MoveMinhoca_RecalculaPos_Fim
 		inc R0
 		loadn R3, #'d'
 		store guardaTeclado, R3
 		jmp MoveMinhoca_RecalculaPos_Fim
 		
 	MoveMinhoca_RecalculaPos_W:
 		loadn R1, #40
 		cmp R0, R1
 		jeq MoveMinhoca_RecalculaPos_Fim
 		sub R0, R0, R1
 		loadn R3, #'w'
 		store guardaTeclado, R3
 		jmp MoveMinhoca_RecalculaPos_Fim
 		
 	MoveMinhoca_RecalculaPos_S:
 		loadn R1, #1159
 		cmp R0, R1
 		jgr MoveMinhoca_RecalculaPos_Fim
 		loadn R1, #40
 		add R0, R0, R1
 		loadn R3, #'s'
 		store guardaTeclado, R3
 		jmp MoveMinhoca_RecalculaPos_Fim
 		
 	MoveMinhoca_Desenha: 
 		push R0
 		push R1
 		
 		Loadn R1, #'O'
 		load R0, posMinhoca
 		outchar R1, R0
 		store posAntMinhoca, R0
 		
 		pop R1
 		pop R0
 		rts
 		
 	
 	
 	
 
 
 ApagaTela:
	push r0
	push r1
	
	loadn r0, #1200		; apaga as 1200 posicoes da Tela
	loadn r1, #' '		; com "espaco"
	
	   ApagaTela_Loop:	;;label for(r0=1200;r3>0;r3--)
		dec r0
		outchar r1, r0
		jnz ApagaTela_Loop
 
	pop r1
	pop r0
	rts	
	
ImprimeTela: 	;  Rotina de Impresao de Cenario na Tela Inteira
		;  r1 = endereco onde comeca a primeira linha do Cenario
		;  r2 = cor do Cenario para ser impresso

	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r4 na pilha para ser usado na subrotina

	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	
   ImprimeTela_Loop:
		call ImprimeStr
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela_Loop	; Enquanto r0 < 1200

	pop r5	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
ImprimeStr:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	
	loadn r3, #'\0'	; Criterio de parada

   ImprimeStr_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr_Sai
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		jmp ImprimeStr_Loop
	
   ImprimeStr_Sai:	
	pop r4	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
Delay:
						;Utiliza Push e Pop para nao afetar os Ristradores do programa principal
	push R0
	push R1
	
	loadn R1, #50  ; a
   Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	loadn R0, #3000	; b
   Delay_volta: 
	dec R0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	jnz Delay_volta	
	dec R1
	jnz Delay_volta2
	
	pop R1
	pop R0
	
	rts	
	
tela0Linha0  : string "                           SCORE:       "
tela0Linha1  : string "________________________________________"
tela0Linha2  : string "                                        "
tela0Linha3  : string "                                        "
tela0Linha4  : string "                                        "
tela0Linha5  : string "                                        "
tela0Linha6  : string "                                        "
tela0Linha7  : string "                                        "
tela0Linha8  : string "                                        "
tela0Linha9  : string "                                        "
tela0Linha10 : string "                                        "
tela0Linha11 : string "                                        "
tela0Linha12 : string "                                        "
tela0Linha13 : string "                                        "
tela0Linha14 : string "                                        "
tela0Linha15 : string "                                        "
tela0Linha16 : string "                                        "
tela0Linha17 : string "                                        "
tela0Linha18 : string "                                        "
tela0Linha19 : string "                                        "
tela0Linha20 : string "                                        "
tela0Linha21 : string "                                        "
tela0Linha22 : string "                                        "
tela0Linha23 : string "                                        "
tela0Linha24 : string "                                        "
tela0Linha25 : string "                                        "
tela0Linha26 : string "                                        "
tela0Linha27 : string "                                        "
tela0Linha28 : string "                                        "
tela0Linha29 : string "                                        "