; JOGO DA COBrINHA
jmp Main

posMinhoca: var #1			; Contem a posicao atual da Nave
posCaudaMinhoca: var #1		; Contem a posicao anterior da Nave
iComida: var #1
posComida: var #1
guardaTeclado: var #1
tamanho: var #1

corpoMinhoca: var #300

score: var #1000

Main:
 	call ApagaTela
 	loadn r1, #tela0Linha0	    ; Endereco onde comeca a primeira linha do cenario
	loadn r2, #1536  			; cor branca
	call ImprimeTela
	
	loadn r0, #699			
 	loadn r2, #corpoMinhoca
 	storei r2, r0
	dec r0
	store posMinhoca, r0		; Zera Posicao Atual da minhoca
	
	loadn r0, #'w'
	store guardaTeclado, r0
	
	;store posCaudaMinhoca, r0	    ; Zera Posicao Anterior da minhoca
	
 	
 	 
 	loadn r0, #0    	
 	store tamanho, r0
 	store score, r0
 	
	call Imprime_Comida
 	
 	Loop:
	
		loadn r1, #10
		mod r1, r0, r1
		cmp r1, r2		; if (mod(c/10)==0
		call MoveMinhoca
 		call Desenha_Minhoca
		
		call Delay
		inc r0
		jmp Loop
 
 		
Incrementa_Minhoca:
	push r0
	;pop r1
	;pop r2
	;pop r3
	
	call Imprime_Comida
	
	load r0, posCaudaMinhoca
	load r2, tamanho

	loadn r1, #corpoMinhoca
	inc r2
	
	add r1, r1, r2
	storei r1, r0
	
	store tamanho, r2
	;call Desenha_Minhoca
	
	
	
	;storei r0, r2
	;outchar r1, r0
	;push r3
	;push r2
	;push r1
	pop r0
	jmp MoveMinhoca_Skip
	;rts

Desenha_Minhoca:
    push r0
    push r1
    push r2
    push r3
    
	;loadn r1, #'T'
	;outchar r1, r6
	
	
    loadn r1, #'G'         ; Caractere para representar a cobra na tela
    loadn r5, #' '
    
    
    load r0, posMinhoca    ; Posição atual da cabeça da cobra
    
    loadn r2, #corpoMinhoca    ; Tamanho do corpo da cobra
    	
	loadn r4, #0
	load r6, tamanho
	
    Desenha_Minhoca_Loop:
		loadi r3, r2
		
		outchar r1, r0
	    outchar r5, r3        ; Desenha o caractere do corpo da cobra
	    loadn r1, #'0'         
      	storei r2, r0
      	
      	mov r0, r3
    	
        cmp r4, r6               ; Decrementa o contador do corpo
        jeq Desenha_Minhoca_Fim ; Se o corpo acabou, sai do loop
        
        inc r4
        inc r2; Move para a próxima posição do corpo
        jmp Desenha_Minhoca_Loop
    
    Desenha_Minhoca_Fim:
	    store posCaudaMinhoca,r3
	    ;loadn r1, #'L'
	    ;outchar r1,r3 
	    pop r3
	    pop r2
	    pop r1
	    pop r0
	    rts
	    
verificaColisao:
	load r0, posMinhoca
	loadn r1, #corpoMinhoca
	loadn r2, #0
	load r4, tamanho 
;	inc r4
	;add r1,r1, r2
	
	
	verificaColisaoLoop:
	
		cmp r2, r4
		jeq verificaColisaoFim
		loadi r3,r1	
		
		
		cmp r0, r3
		jeq jogoFinalizado
		
		
		inc r2
		inc r1
		jmp verificaColisaoLoop
		
	verificaColisaoFim:
		rts
	
MoveMinhoca: 
 	push r0
 	push r1
 		
 	call MoveMinhoca_recalculaPos
 	
 	;loadn r0, #corpoMinhoca
 	;loadi r0, r0
 	load r0, posMinhoca
 	load r1, posCaudaMinhoca
 	load r3, posComida
 	
 	cmp r0, r3
	jeq Incrementa_Minhoca 		
	
	call verificaColisao
 		
 	MoveMinhoca_Skip:
 		pop r1
 		pop r0
 		rts
 		
 	
MoveMinhoca_recalculaPos:
 	push r0 
 	push r1
 	push r2
 	push r3
 	
 	load r0, posMinhoca
 	
 	inchar r1
 	loadn r2, #'a'
 	cmp r1, r2
 	jeq MoveMinhoca_recalculaPos_A
 	
 	loadn r2, #'d'
 	cmp r1, r2
 	jeq MoveMinhoca_recalculaPos_D
 	
 	loadn r2, #'w'
 	cmp r1, r2
 	jeq MoveMinhoca_recalculaPos_W;
 	
 	loadn r2, #'s'
 	cmp r1, r2
 	jeq MoveMinhoca_recalculaPos_S
 	
 	
 	loadn r2, #'a'
 	load r1, guardaTeclado
 	cmp r1, r2
 	jeq MoveMinhoca_recalculaPos_A
 	
 	loadn r2, #'d'
 	load r1, guardaTeclado
 	cmp r1, r2
 	jeq MoveMinhoca_recalculaPos_D
 	
 	loadn r2, #'w'
 	load r1, guardaTeclado
 	cmp r1, r2
 	jeq MoveMinhoca_recalculaPos_W
 	
 	loadn r2, #'s'
 	load r1, guardaTeclado
 	cmp r1, r2
 	jeq MoveMinhoca_recalculaPos_S
 	
 	
 	MoveMinhoca_recalculaPos_Fim:
 		store posMinhoca, r0
 		pop r3
 		pop r2
 		pop r1
 		pop r0
 		rts
 		
 	MoveMinhoca_recalculaPos_A:
 		loadn r1, #40
 		loadn r2, #0
 		mod r1, r0, r1
 		cmp r1, r2
 		jeq MoveMinhoca_recalculaPos_Fim
 		dec r0
 		loadn r3, #'a'
 		store guardaTeclado, r3
 		jmp MoveMinhoca_recalculaPos_Fim
 		
 	MoveMinhoca_recalculaPos_D:
 		loadn r1, #40
 		loadn r2, #39
 		mod r1, r0, r1
 		cmp r1, r2
 		jeq MoveMinhoca_recalculaPos_Fim
 		inc r0
 		loadn r3, #'d'
 		store guardaTeclado, r3
 		jmp MoveMinhoca_recalculaPos_Fim
 		
 	MoveMinhoca_recalculaPos_W:
 		loadn r1, #120
 		cmp r0, r1
 		jle MoveMinhoca_recalculaPos_Fim
 		loadn r1, #40
 		sub r0, r0, r1
 		loadn r3, #'w'
 		store guardaTeclado, r3
 		jmp MoveMinhoca_recalculaPos_Fim
 		
 	MoveMinhoca_recalculaPos_S:
 		loadn r1, #1159
 		cmp r0, r1
 		jgr MoveMinhoca_recalculaPos_Fim
 		loadn r1, #40
 		add r0, r0, r1
 		loadn r3, #'s'
 		store guardaTeclado, r3
 		jmp MoveMinhoca_recalculaPos_Fim


 
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
	
ImprimeTela: 	;  rotina de Impresao de Cenario na Tela Inteira
		;  r1 = endereco onde comeca a primeira linha do Cenario
		;  r2 = cor do Cenario para ser impresso

	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r4 na pilha para ser usado na subrotina

	loadn r0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn r3, #40  	; Incremento da posicao da tela!
	loadn r4, #41  	; incremento do ponteiro das linhas da tela
	loadn r5, #1200 ; Limite da tela!
	
   ImprimeTela_Loop:
		call ImprimeStr
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = r0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela_Loop	; Enquanto r0 < 1200
	
	pop r5	; resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
ImprimeStr:	;  rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
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
	pop r4	; resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
Imprime_Comida:
	push r0
	push r1
	push r2
	push r3

	loadn r1, #'@'
	loadn r2, #comida
	load r3, iComida
	add r0, r2, r3
	loadi r2, r0
	outchar r1, r2
	

	inc r3
	store iComida, r3
	store posComida, r2
	
	pop r3
	pop r2
	pop r1
	pop r0
	rts

jogoFinalizado:
	call ApagaTela
	jmp Main

Delay:
						;Utiliza Push e Pop para nao afetar os ristradores do programa principal
	push r0
	push r1
	
	loadn r1, #100  ; a
   Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	loadn r0, #3000	; b
   Delay_volta: 
	dec r0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	jnz Delay_volta	
	dec r1
	jnz Delay_volta2
	
	pop r1
	pop r0
	
	rts	
	
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

comida : var #1200
static comida + #0, #258
static comida + #1, #299
static comida + #2, #1014
static comida + #3, #880
static comida + #4, #687
static comida + #5, #290
static comida + #6, #899
static comida + #7, #510
static comida + #8, #303
static comida + #9, #899
static comida + #10, #888
static comida + #11, #14
static comida + #12, #810
static comida + #13, #132
static comida + #14, #941
static comida + #15, #922
static comida + #16, #1198
static comida + #17, #453
static comida + #18, #304
static comida + #19, #55
static comida + #20, #313
static comida + #21, #202
static comida + #22, #913
static comida + #23, #908
static comida + #24, #190
static comida + #25, #657
static comida + #26, #225
static comida + #27, #469
static comida + #28, #896
static comida + #29, #169
static comida + #30, #209
static comida + #31, #1138
static comida + #32, #1107
static comida + #33, #345
static comida + #34, #59
static comida + #35, #353
static comida + #36, #1094
static comida + #37, #32
static comida + #38, #385
static comida + #39, #131
static comida + #40, #1070
static comida + #41, #359
static comida + #42, #904
static comida + #43, #473
static comida + #44, #20
static comida + #45, #1062
static comida + #46, #272
static comida + #47, #95
static comida + #48, #477
static comida + #49, #199
static comida + #50, #597
static comida + #51, #896
static comida + #52, #827
static comida + #53, #1003
static comida + #54, #628
static comida + #55, #607
static comida + #56, #170
static comida + #57, #103
static comida + #58, #729
static comida + #59, #225
static comida + #60, #741
static comida + #61, #350
static comida + #62, #265
static comida + #63, #260
static comida + #64, #6
static comida + #65, #315
static comida + #66, #439
static comida + #67, #228
static comida + #68, #62
static comida + #69, #210
static comida + #70, #553
static comida + #71, #1023
static comida + #72, #892
static comida + #73, #751
static comida + #74, #946
static comida + #75, #1160
static comida + #76, #141
static comida + #77, #974
static comida + #78, #730
static comida + #79, #810
static comida + #80, #62
static comida + #81, #997
static comida + #82, #811
static comida + #83, #561
static comida + #84, #688
static comida + #85, #631
static comida + #86, #717
static comida + #87, #443
static comida + #88, #1107
static comida + #89, #268
static comida + #90, #816
static comida + #91, #164
static comida + #92, #1074
static comida + #93, #144
static comida + #94, #407
static comida + #95, #982
static comida + #96, #127
static comida + #97, #755
static comida + #98, #1200
static comida + #99, #640
static comida + #100, #343
static comida + #101, #928
static comida + #102, #651
static comida + #103, #857
static comida + #104, #440
static comida + #105, #227
static comida + #106, #947
static comida + #107, #609
static comida + #108, #954
static comida + #109, #335
static comida + #110, #697
static comida + #111, #706
static comida + #112, #831
static comida + #113, #301
static comida + #114, #887
static comida + #115, #984
static comida + #116, #1182
static comida + #117, #623
static comida + #118, #790
static comida + #119, #669
static comida + #120, #68
static comida + #121, #400
static comida + #122, #627
static comida + #123, #1165
static comida + #124, #848
static comida + #125, #346
static comida + #126, #1161
static comida + #127, #865
static comida + #128, #53
static comida + #129, #797
static comida + #130, #49
static comida + #131, #394
static comida + #132, #963
static comida + #133, #364
static comida + #134, #1004
static comida + #135, #75
static comida + #136, #208
static comida + #137, #969
static comida + #138, #1106
static comida + #139, #644
static comida + #140, #990
static comida + #141, #724
static comida + #142, #69
static comida + #143, #470
static comida + #144, #775
static comida + #145, #75
static comida + #146, #662
static comida + #147, #14
static comida + #148, #1063
static comida + #149, #392
static comida + #150, #219
static comida + #151, #467
static comida + #152, #350
static comida + #153, #776
static comida + #154, #979
static comida + #155, #1153
static comida + #156, #884
static comida + #157, #756
static comida + #158, #53
static comida + #159, #786
static comida + #160, #883
static comida + #161, #75
static comida + #162, #114
static comida + #163, #951
static comida + #164, #245
static comida + #165, #885
static comida + #166, #773
static comida + #167, #544
static comida + #168, #724
static comida + #169, #1014
static comida + #170, #278
static comida + #171, #896
static comida + #172, #804
static comida + #173, #1165
static comida + #174, #15
static comida + #175, #1164
static comida + #176, #736
static comida + #177, #1028
static comida + #178, #319
static comida + #179, #291
static comida + #180, #348
static comida + #181, #900
static comida + #182, #357
static comida + #183, #801
static comida + #184, #114
static comida + #185, #864
static comida + #186, #291
static comida + #187, #1036
static comida + #188, #305
static comida + #189, #399
static comida + #190, #920
static comida + #191, #474
static comida + #192, #432
static comida + #193, #849
static comida + #194, #429
static comida + #195, #110
static comida + #196, #173
static comida + #197, #458
static comida + #198, #706
static comida + #199, #671
static comida + #200, #118
static comida + #201, #133
static comida + #202, #658
static comida + #203, #405
static comida + #204, #471
static comida + #205, #880
static comida + #206, #13
static comida + #207, #981
static comida + #208, #968
static comida + #209, #740
static comida + #210, #549
static comida + #211, #856
static comida + #212, #354
static comida + #213, #1032
static comida + #214, #866
static comida + #215, #365
static comida + #216, #698
static comida + #217, #1096
static comida + #218, #436
static comida + #219, #332
static comida + #220, #108
static comida + #221, #224
static comida + #222, #539
static comida + #223, #124
static comida + #224, #1179
static comida + #225, #550
static comida + #226, #918
static comida + #227, #411
static comida + #228, #552
static comida + #229, #295
static comida + #230, #1166
static comida + #231, #543
static comida + #232, #45
static comida + #233, #365
static comida + #234, #1058
static comida + #235, #91
static comida + #236, #1017
static comida + #237, #378
static comida + #238, #1018
static comida + #239, #13
static comida + #240, #570
static comida + #241, #308
static comida + #242, #895
static comida + #243, #492
static comida + #244, #6
static comida + #245, #28
static comida + #246, #181
static comida + #247, #114
static comida + #248, #79
static comida + #249, #776
static comida + #250, #1125
static comida + #251, #177
static comida + #252, #400
static comida + #253, #493
static comida + #254, #755
static comida + #255, #722
static comida + #256, #869
static comida + #257, #853
static comida + #258, #1166
static comida + #259, #54
static comida + #260, #531
static comida + #261, #209
static comida + #262, #76
static comida + #263, #794
static comida + #264, #938
static comida + #265, #344
static comida + #266, #858
static comida + #267, #673
static comida + #268, #550
static comida + #269, #1012
static comida + #270, #65
static comida + #271, #571
static comida + #272, #274
static comida + #273, #360
static comida + #274, #385
static comida + #275, #913
static comida + #276, #164
static comida + #277, #114
static comida + #278, #5
static comida + #279, #232
static comida + #280, #321
static comida + #281, #164
static comida + #282, #117
static comida + #283, #42
static comida + #284, #745
static comida + #285, #111
static comida + #286, #764
static comida + #287, #836
static comida + #288, #403
static comida + #289, #776
static comida + #290, #309
static comida + #291, #316
static comida + #292, #885
static comida + #293, #27
static comida + #294, #710
static comida + #295, #273
static comida + #296, #718
static comida + #297, #400
static comida + #298, #112
static comida + #299, #221
static comida + #300, #50
static comida + #301, #554
static comida + #302, #1141
static comida + #303, #625
static comida + #304, #585
static comida + #305, #105
static comida + #306, #367
static comida + #307, #950
static comida + #308, #308
static comida + #309, #823
static comida + #310, #1176
static comida + #311, #629
static comida + #312, #232
static comida + #313, #912
static comida + #314, #220
static comida + #315, #443
static comida + #316, #462
static comida + #317, #875
static comida + #318, #554
static comida + #319, #649
static comida + #320, #1030
static comida + #321, #516
static comida + #322, #262
static comida + #323, #387
static comida + #324, #196
static comida + #325, #637
static comida + #326, #781
static comida + #327, #602
static comida + #328, #645
static comida + #329, #676
static comida + #330, #632
static comida + #331, #805
static comida + #332, #1141
static comida + #333, #693
static comida + #334, #778
static comida + #335, #482
static comida + #336, #1037
static comida + #337, #374
static comida + #338, #18
static comida + #339, #940
static comida + #340, #790
static comida + #341, #785
static comida + #342, #841
static comida + #343, #278
static comida + #344, #114
static comida + #345, #512
static comida + #346, #894
static comida + #347, #1179
static comida + #348, #570
static comida + #349, #860
static comida + #350, #679
static comida + #351, #965
static comida + #352, #1040
static comida + #353, #145
static comida + #354, #1111
static comida + #355, #10
static comida + #356, #1144
static comida + #357, #894
static comida + #358, #1142
static comida + #359, #1118
static comida + #360, #224
static comida + #361, #855
static comida + #362, #129
static comida + #363, #221
static comida + #364, #830
static comida + #365, #990
static comida + #366, #325
static comida + #367, #555
static comida + #368, #478
static comida + #369, #936
static comida + #370, #142
static comida + #371, #697
static comida + #372, #320
static comida + #373, #565
static comida + #374, #978
static comida + #375, #288
static comida + #376, #996
static comida + #377, #434
static comida + #378, #815
static comida + #379, #433
static comida + #380, #570
static comida + #381, #19
static comida + #382, #311
static comida + #383, #1008
static comida + #384, #1003
static comida + #385, #537
static comida + #386, #462
static comida + #387, #822
static comida + #388, #218
static comida + #389, #1132
static comida + #390, #79
static comida + #391, #378
static comida + #392, #942
static comida + #393, #370
static comida + #394, #694
static comida + #395, #1081
static comida + #396, #16
static comida + #397, #377
static comida + #398, #932
static comida + #399, #1150
static comida + #400, #13
static comida + #401, #953
static comida + #402, #686
static comida + #403, #410
static comida + #404, #17
static comida + #405, #383
static comida + #406, #139
static comida + #407, #6
static comida + #408, #490
static comida + #409, #868
static comida + #410, #483
static comida + #411, #651
static comida + #412, #602
static comida + #413, #479
static comida + #414, #204
static comida + #415, #676
static comida + #416, #305
static comida + #417, #508
static comida + #418, #967
static comida + #419, #360
static comida + #420, #108
static comida + #421, #192
static comida + #422, #145
static comida + #423, #817
static comida + #424, #1048
static comida + #425, #1183
static comida + #426, #433
static comida + #427, #696
static comida + #428, #1039
static comida + #429, #881
static comida + #430, #1192
static comida + #431, #517
static comida + #432, #33
static comida + #433, #1008
static comida + #434, #310
static comida + #435, #1097
static comida + #436, #46
static comida + #437, #1100
static comida + #438, #25
static comida + #439, #621
static comida + #440, #121
static comida + #441, #120
static comida + #442, #1142
static comida + #443, #754
static comida + #444, #153
static comida + #445, #1103
static comida + #446, #212
static comida + #447, #1150
static comida + #448, #738
static comida + #449, #930
static comida + #450, #209
static comida + #451, #138
static comida + #452, #340
static comida + #453, #947
static comida + #454, #13
static comida + #455, #872
static comida + #456, #609
static comida + #457, #1007
static comida + #458, #1036
static comida + #459, #436
static comida + #460, #343
static comida + #461, #457
static comida + #462, #544
static comida + #463, #811
static comida + #464, #190
static comida + #465, #1016
static comida + #466, #431
static comida + #467, #61
static comida + #468, #99
static comida + #469, #674
static comida + #470, #30
static comida + #471, #855
static comida + #472, #889
static comida + #473, #1036
static comida + #474, #1094
static comida + #475, #862
static comida + #476, #185
static comida + #477, #196
static comida + #478, #739
static comida + #479, #734
static comida + #480, #639
static comida + #481, #998
static comida + #482, #260
static comida + #483, #249
static comida + #484, #878
static comida + #485, #1065
static comida + #486, #728
static comida + #487, #128
static comida + #488, #450
static comida + #489, #532
static comida + #490, #1193
static comida + #491, #774
static comida + #492, #448
static comida + #493, #253
static comida + #494, #169
static comida + #495, #1143
static comida + #496, #140
static comida + #497, #1123
static comida + #498, #747
static comida + #499, #385
static comida + #500, #322
static comida + #501, #1093
static comida + #502, #145
static comida + #503, #850
static comida + #504, #709
static comida + #505, #1126
static comida + #506, #396
static comida + #507, #102
static comida + #508, #990
static comida + #509, #479
static comida + #510, #1027
static comida + #511, #209
static comida + #512, #455
static comida + #513, #891
static comida + #514, #1131
static comida + #515, #464
static comida + #516, #871
static comida + #517, #1068
static comida + #518, #1142
static comida + #519, #1089
static comida + #520, #660
static comida + #521, #882
static comida + #522, #1013
static comida + #523, #141
static comida + #524, #162
static comida + #525, #312
static comida + #526, #401
static comida + #527, #515
static comida + #528, #406
static comida + #529, #937
static comida + #530, #588
static comida + #531, #1074
static comida + #532, #721
static comida + #533, #626
static comida + #534, #633
static comida + #535, #520
static comida + #536, #1099
static comida + #537, #959
static comida + #538, #866
static comida + #539, #1095
static comida + #540, #627
static comida + #541, #410
static comida + #542, #1030
static comida + #543, #427
static comida + #544, #394
static comida + #545, #855
static comida + #546, #82
static comida + #547, #559
static comida + #548, #86
static comida + #549, #5
static comida + #550, #303
static comida + #551, #191
static comida + #552, #320
static comida + #553, #616
static comida + #554, #904
static comida + #555, #952
static comida + #556, #993
static comida + #557, #979
static comida + #558, #870
static comida + #559, #435
static comida + #560, #933
static comida + #561, #562
static comida + #562, #932
static comida + #563, #295
static comida + #564, #37
static comida + #565, #990
static comida + #566, #263
static comida + #567, #960
static comida + #568, #1174
static comida + #569, #512
static comida + #570, #241
static comida + #571, #979
static comida + #572, #994
static comida + #573, #835
static comida + #574, #241
static comida + #575, #175
static comida + #576, #657
static comida + #577, #792
static comida + #578, #9
static comida + #579, #536
static comida + #580, #747
static comida + #581, #311
static comida + #582, #754
static comida + #583, #493
static comida + #584, #462
static comida + #585, #758
static comida + #586, #607
static comida + #587, #233
static comida + #588, #595
static comida + #589, #507
static comida + #590, #235
static comida + #591, #838
static comida + #592, #37
static comida + #593, #766
static comida + #594, #702
static comida + #595, #466
static comida + #596, #94
static comida + #597, #28
static comida + #598, #723
static comida + #599, #688
static comida + #600, #33
static comida + #601, #31
static comida + #602, #227
static comida + #603, #997
static comida + #604, #933
static comida + #605, #178
static comida + #606, #185
static comida + #607, #1072
static comida + #608, #161
static comida + #609, #603
static comida + #610, #611
static comida + #611, #926
static comida + #612, #386
static comida + #613, #1158
static comida + #614, #679
static comida + #615, #699
static comida + #616, #725
static comida + #617, #924
static comida + #618, #1073
static comida + #619, #1121
static comida + #620, #286
static comida + #621, #600
static comida + #622, #536
static comida + #623, #467
static comida + #624, #789
static comida + #625, #835
static comida + #626, #51
static comida + #627, #509
static comida + #628, #450
static comida + #629, #782
static comida + #630, #868
static comida + #631, #5
static comida + #632, #486
static comida + #633, #272
static comida + #634, #749
static comida + #635, #668
static comida + #636, #307
static comida + #637, #165
static comida + #638, #844
static comida + #639, #572
static comida + #640, #844
static comida + #641, #520
static comida + #642, #675
static comida + #643, #124
static comida + #644, #804
static comida + #645, #334
static comida + #646, #121
static comida + #647, #659
static comida + #648, #916
static comida + #649, #960
static comida + #650, #806
static comida + #651, #185
static comida + #652, #628
static comida + #653, #954
static comida + #654, #742
static comida + #655, #908
static comida + #656, #826
static comida + #657, #874
static comida + #658, #936
static comida + #659, #544
static comida + #660, #418
static comida + #661, #1114
static comida + #662, #1097
static comida + #663, #616
static comida + #664, #6
static comida + #665, #449
static comida + #666, #17
static comida + #667, #605
static comida + #668, #24
static comida + #669, #605
static comida + #670, #425
static comida + #671, #938
static comida + #672, #823
static comida + #673, #730
static comida + #674, #414
static comida + #675, #783
static comida + #676, #471
static comida + #677, #31
static comida + #678, #286
static comida + #679, #1194
static comida + #680, #393
static comida + #681, #727
static comida + #682, #947
static comida + #683, #820
static comida + #684, #268
static comida + #685, #1100
static comida + #686, #196
static comida + #687, #49
static comida + #688, #307
static comida + #689, #898
static comida + #690, #842
static comida + #691, #627
static comida + #692, #116
static comida + #693, #474
static comida + #694, #795
static comida + #695, #450
static comida + #696, #761
static comida + #697, #804
static comida + #698, #991
static comida + #699, #271
static comida + #700, #105
static comida + #701, #470
static comida + #702, #508
static comida + #703, #1049
static comida + #704, #837
static comida + #705, #973
static comida + #706, #843
static comida + #707, #693
static comida + #708, #189
static comida + #709, #444
static comida + #710, #671
static comida + #711, #912
static comida + #712, #508
static comida + #713, #412
static comida + #714, #750
static comida + #715, #1168
static comida + #716, #3
static comida + #717, #955
static comida + #718, #534
static comida + #719, #237
static comida + #720, #252
static comida + #721, #297
static comida + #722, #974
static comida + #723, #784
static comida + #724, #910
static comida + #725, #947
static comida + #726, #576
static comida + #727, #1087
static comida + #728, #1169
static comida + #729, #819
static comida + #730, #304
static comida + #731, #397
static comida + #732, #593
static comida + #733, #778
static comida + #734, #279
static comida + #735, #923
static comida + #736, #212
static comida + #737, #718
static comida + #738, #234
static comida + #739, #580
static comida + #740, #836
static comida + #741, #1160
static comida + #742, #358
static comida + #743, #808
static comida + #744, #1030
static comida + #745, #720
static comida + #746, #1041
static comida + #747, #1198
static comida + #748, #85
static comida + #749, #948
static comida + #750, #229
static comida + #751, #506
static comida + #752, #374
static comida + #753, #929
static comida + #754, #24
static comida + #755, #792
static comida + #756, #374
static comida + #757, #583
static comida + #758, #279
static comida + #759, #888
static comida + #760, #52
static comida + #761, #956
static comida + #762, #1097
static comida + #763, #1177
static comida + #764, #447
static comida + #765, #300
static comida + #766, #797
static comida + #767, #435
static comida + #768, #624
static comida + #769, #115
static comida + #770, #784
static comida + #771, #648
static comida + #772, #304
static comida + #773, #837
static comida + #774, #68
static comida + #775, #149
static comida + #776, #996
static comida + #777, #906
static comida + #778, #352
static comida + #779, #949
static comida + #780, #878
static comida + #781, #983
static comida + #782, #807
static comida + #783, #598
static comida + #784, #771
static comida + #785, #659
static comida + #786, #931
static comida + #787, #322
static comida + #788, #1094
static comida + #789, #810
static comida + #790, #909
static comida + #791, #858
static comida + #792, #487
static comida + #793, #992
static comida + #794, #809
static comida + #795, #735
static comida + #796, #601
static comida + #797, #489
static comida + #798, #688
static comida + #799, #849
static comida + #800, #909
static comida + #801, #724
static comida + #802, #348
static comida + #803, #50
static comida + #804, #631
static comida + #805, #1077
static comida + #806, #51
static comida + #807, #342
static comida + #808, #723
static comida + #809, #1151
static comida + #810, #1199
static comida + #811, #70
static comida + #812, #231
static comida + #813, #941
static comida + #814, #770
static comida + #815, #1005
static comida + #816, #811
static comida + #817, #451
static comida + #818, #908
static comida + #819, #734
static comida + #820, #711
static comida + #821, #70
static comida + #822, #56
static comida + #823, #109
static comida + #824, #244
static comida + #825, #413
static comida + #826, #510
static comida + #827, #139
static comida + #828, #952
static comida + #829, #522
static comida + #830, #867
static comida + #831, #160
static comida + #832, #377
static comida + #833, #908
static comida + #834, #325
static comida + #835, #16
static comida + #836, #865
static comida + #837, #49
static comida + #838, #749
static comida + #839, #640
static comida + #840, #571
static comida + #841, #1107
static comida + #842, #169
static comida + #843, #370
static comida + #844, #467
static comida + #845, #624
static comida + #846, #532
static comida + #847, #400
static comida + #848, #547
static comida + #849, #831
static comida + #850, #537
static comida + #851, #933
static comida + #852, #671
static comida + #853, #705
static comida + #854, #735
static comida + #855, #1087
static comida + #856, #686
static comida + #857, #763
static comida + #858, #1198
static comida + #859, #398
static comida + #860, #1156
static comida + #861, #887
static comida + #862, #90
static comida + #863, #287
static comida + #864, #850
static comida + #865, #50
static comida + #866, #251
static comida + #867, #767
static comida + #868, #891
static comida + #869, #438
static comida + #870, #918
static comida + #871, #1119
static comida + #872, #720
static comida + #873, #169
static comida + #874, #883
static comida + #875, #912
static comida + #876, #868
static comida + #877, #17
static comida + #878, #695
static comida + #879, #633
static comida + #880, #412
static comida + #881, #628
static comida + #882, #721
static comida + #883, #330
static comida + #884, #45
static comida + #885, #869
static comida + #886, #775
static comida + #887, #333
static comida + #888, #1133
static comida + #889, #946
static comida + #890, #2
static comida + #891, #1034
static comida + #892, #659
static comida + #893, #1098
static comida + #894, #1165
static comida + #895, #917
static comida + #896, #631
static comida + #897, #730
static comida + #898, #398
static comida + #899, #256
static comida + #900, #91
static comida + #901, #524
static comida + #902, #97
static comida + #903, #379
static comida + #904, #913
static comida + #905, #999
static comida + #906, #551
static comida + #907, #988
static comida + #908, #290
static comida + #909, #80
static comida + #910, #245
static comida + #911, #82
static comida + #912, #596
static comida + #913, #40
static comida + #914, #577
static comida + #915, #362
static comida + #916, #824
static comida + #917, #895
static comida + #918, #1128
static comida + #919, #727
static comida + #920, #98
static comida + #921, #1085
static comida + #922, #995
static comida + #923, #898
static comida + #924, #470
static comida + #925, #992
static comida + #926, #434
static comida + #927, #206
static comida + #928, #829
static comida + #929, #230
static comida + #930, #485
static comida + #931, #1054
static comida + #932, #791
static comida + #933, #230
static comida + #934, #216
static comida + #935, #443
static comida + #936, #208
static comida + #937, #785
static comida + #938, #428
static comida + #939, #96
static comida + #940, #314
static comida + #941, #132
static comida + #942, #911
static comida + #943, #787
static comida + #944, #728
static comida + #945, #360
static comida + #946, #175
static comida + #947, #1100
static comida + #948, #661
static comida + #949, #880
static comida + #950, #598
static comida + #951, #1164
static comida + #952, #510
static comida + #953, #485
static comida + #954, #1059
static comida + #955, #1034
static comida + #956, #432
static comida + #957, #342
static comida + #958, #152
static comida + #959, #1109
static comida + #960, #838
static comida + #961, #7
static comida + #962, #36
static comida + #963, #535
static comida + #964, #861
static comida + #965, #273
static comida + #966, #748
static comida + #967, #820
static comida + #968, #1004
static comida + #969, #889
static comida + #970, #65
static comida + #971, #797
static comida + #972, #386
static comida + #973, #540
static comida + #974, #435
static comida + #975, #229
static comida + #976, #1071
static comida + #977, #1022
static comida + #978, #915
static comida + #979, #637
static comida + #980, #975
static comida + #981, #490
static comida + #982, #430
static comida + #983, #662
static comida + #984, #504
static comida + #985, #441
static comida + #986, #739
static comida + #987, #525
static comida + #988, #433
static comida + #989, #777
static comida + #990, #561
static comida + #991, #1113
static comida + #992, #1134
static comida + #993, #1138
static comida + #994, #168
static comida + #995, #847
static comida + #996, #663
static comida + #997, #299
static comida + #998, #259
static comida + #999, #1074
static comida + #1000, #826
static comida + #1001, #1181
static comida + #1002, #899
static comida + #1003, #352
static comida + #1004, #767
static comida + #1005, #1002
static comida + #1006, #418
static comida + #1007, #575
static comida + #1008, #738
static comida + #1009, #323
static comida + #1010, #1064
static comida + #1011, #235
static comida + #1012, #1173
static comida + #1013, #247
static comida + #1014, #1092
static comida + #1015, #1062
static comida + #1016, #533
static comida + #1017, #383
static comida + #1018, #1117
static comida + #1019, #125
static comida + #1020, #992
static comida + #1021, #341
static comida + #1022, #261
static comida + #1023, #1173
static comida + #1024, #1070
static comida + #1025, #1190
static comida + #1026, #243
static comida + #1027, #186
static comida + #1028, #186
static comida + #1029, #1090
static comida + #1030, #518
static comida + #1031, #1066
static comida + #1032, #249
static comida + #1033, #339
static comida + #1034, #780
static comida + #1035, #1113
static comida + #1036, #1164
static comida + #1037, #793
static comida + #1038, #350
static comida + #1039, #318
static comida + #1040, #204
static comida + #1041, #508
static comida + #1042, #277
static comida + #1043, #699
static comida + #1044, #501
static comida + #1045, #931
static comida + #1046, #583
static comida + #1047, #828
static comida + #1048, #1000
static comida + #1049, #518
static comida + #1050, #413
static comida + #1051, #531
static comida + #1052, #612
static comida + #1053, #96
static comida + #1054, #379
static comida + #1055, #563
static comida + #1056, #1119
static comida + #1057, #661
static comida + #1058, #391
static comida + #1059, #788
static comida + #1060, #27
static comida + #1061, #509
static comida + #1062, #453
static comida + #1063, #27
static comida + #1064, #43
static comida + #1065, #269
static comida + #1066, #705
static comida + #1067, #694
static comida + #1068, #336
static comida + #1069, #420
static comida + #1070, #1023
static comida + #1071, #293
static comida + #1072, #1054
static comida + #1073, #829
static comida + #1074, #62
static comida + #1075, #402
static comida + #1076, #535
static comida + #1077, #100
static comida + #1078, #696
static comida + #1079, #23
static comida + #1080, #346
static comida + #1081, #670
static comida + #1082, #611
static comida + #1083, #1151
static comida + #1084, #652
static comida + #1085, #765
static comida + #1086, #816
static comida + #1087, #1109
static comida + #1088, #238
static comida + #1089, #650
static comida + #1090, #766
static comida + #1091, #1035
static comida + #1092, #1143
static comida + #1093, #686
static comida + #1094, #740
static comida + #1095, #696
static comida + #1096, #109
static comida + #1097, #738
static comida + #1098, #351
static comida + #1099, #477
static comida + #1100, #627
static comida + #1101, #891
static comida + #1102, #256
static comida + #1103, #12
static comida + #1104, #360
static comida + #1105, #5
static comida + #1106, #973
static comida + #1107, #1180
static comida + #1108, #464
static comida + #1109, #631
static comida + #1110, #89
static comida + #1111, #1018
static comida + #1112, #792
static comida + #1113, #388
static comida + #1114, #927
static comida + #1115, #851
static comida + #1116, #1074
static comida + #1117, #123
static comida + #1118, #790
static comida + #1119, #504
static comida + #1120, #282
static comida + #1121, #151
static comida + #1122, #64
static comida + #1123, #515
static comida + #1124, #767
static comida + #1125, #1117
static comida + #1126, #381
static comida + #1127, #362
static comida + #1128, #79
static comida + #1129, #961
static comida + #1130, #691
static comida + #1131, #106
static comida + #1132, #208
static comida + #1133, #361
static comida + #1134, #1054
static comida + #1135, #720
static comida + #1136, #1001
static comida + #1137, #1004
static comida + #1138, #654
static comida + #1139, #90
static comida + #1140, #607
static comida + #1141, #583
static comida + #1142, #244
static comida + #1143, #244
static comida + #1144, #381
static comida + #1145, #967
static comida + #1146, #37
static comida + #1147, #174
static comida + #1148, #809
static comida + #1149, #480
static comida + #1150, #71
static comida + #1151, #1018
static comida + #1152, #631
static comida + #1153, #921
static comida + #1154, #997
static comida + #1155, #855
static comida + #1156, #427
static comida + #1157, #1087
static comida + #1158, #291
static comida + #1159, #1013
static comida + #1160, #907
static comida + #1161, #801
static comida + #1162, #821
static comida + #1163, #499
static comida + #1164, #260
static comida + #1165, #663
static comida + #1166, #406
static comida + #1167, #970
static comida + #1168, #1150
static comida + #1169, #13
static comida + #1170, #792
static comida + #1171, #1026
static comida + #1172, #673
static comida + #1173, #50
static comida + #1174, #244
static comida + #1175, #256
static comida + #1176, #578
static comida + #1177, #578
static comida + #1178, #737
static comida + #1179, #538
static comida + #1180, #104
static comida + #1181, #776
static comida + #1182, #67
static comida + #1183, #1140
static comida + #1184, #229
static comida + #1185, #925
static comida + #1186, #594
static comida + #1187, #117
static comida + #1188, #238
static comida + #1189, #467
static comida + #1190, #471
static comida + #1191, #879
static comida + #1192, #713
static comida + #1193, #442
static comida + #1194, #684
static comida + #1195, #1128
static comida + #1196, #969
static comida + #1197, #1088
static comida + #1198, #876
static comida + #1199, #983