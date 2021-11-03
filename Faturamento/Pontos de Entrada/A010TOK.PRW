#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"

/*
{Protheus.doc} A010TOK
@type  Function
@description Função de validação para inclusão ou alteração do Produto.
@author Aparecida de F.Stevanato Data
@since 06/10/2008
@revs 23/04/09 - Atualiza data de revisao (B1_UREV)
      15/12/08 - Alt. de Revisao - Verifica programa de dobra
      04/03/16 - Descrição do fonte e alteração de mensagem 
*/

User Function A010TOK()

Local I, J, N
Local _cTitulo    	:= ""
Local _cDestino   	:= ""
Local _cCco       	:= ""
Local _cMsg       	:= ""
Local _cDE		  	:= ""
Local _cMsg1      	:= ""
Local _cAnexo     	:= ""
Local cNomeUsu    	:= ""
Local _aOps       	:= {}
Local _aSC1       	:= {}
Local _aSC7       	:= {}
Local cPortaria   	:= ""
Local cCodAtiv    	:= ""
Local cDesenho   	:= ""
Local cCertif     	:= "N"
Local cRev        	:= ""

Private _cDeptoUsu	:= ""
Private _cUsuario 	:= RetCodUsr()
Private _aArea 	  	:= GetArea()

	If Type("lCopia")="U" 
		lCopia := .F.
	EndIf

	If	ALLTRIM(M->B1_SEGUM) <> "" .OR. M->B1_CONV > 0
		If	ALLTRIM(M->B1_SEGUM) <> "" .AND. ALLTRIM(M->B1_SEGUM) == ALLTRIM(M->B1_UM)
			ALERT("A SEGUNDA UNIDADE DE MEDIDA NÃO PODE SER IGUAL A PRIMEIRA ")
			Return .F.
		EndIf
		If	ALLTRIM(M->B1_SEGUM) <> "" .AND. M->B1_CONV <= 0
			
			ALERT("FATOR DE CONVERSÃO TEM QUE SER MAIOR QUE ZERO! OU RETIRE A SEGUNDA UNIDADE DE MEDIDA")
			Return .F.
		Elseif ALLTRIM(M->B1_SEGUM) == "" .AND. M->B1_CONV > 0
			ALERT("SEGUNDA UNIDADE DE MEDIDA ESTÁ EM BRANCO! OU RETIRE O FATOR DE CONVERSÃO")
			Return .F.
		EndIf
		If M->B1_TIPCONV == "M" .OR. M->B1_TIPCONV == "D"
		Else
			Alert("Informe O tipo de converção. Divisor ou Multiplicador")
			Return .F.
		EndIf
	EndIf

	IF !SUBSTR(cNumEmp,1,2) == "15"
		
		// Campos que serao usados para envio de e_mail
		Private _nEscolha := 1
		Private aAreaSBM  := {}
		
		// Variaveis utilizadas para exclusão dos desenhos com revisoes anteriores
		Private aRev      := {" ","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
		Private cPasta    := ""
		Private cArqPLT   := ""
		Private I         := 0
		
		_nRec	:= RecNo()
		_aArea:= GetArea()
		
		PswOrder(1)
		If PswSeek(_cUsuario,.T.)
			_aUsuario := PswRet()
			_cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
			If SubStr(_cDeptoUsu,1,12) = "ENG.MECANICA"
				_cDeptoUsu := SubStr(_cDeptousu,1,12)
			EndIf
		EndIf
		
		If SubStr(cNumEmp,1,2) $ "01_10" // MASIPACK
			If M->B1_ETIQUET == "S" .And. Empty(M->B1_MSMAQUI)
				apmsgAlert("ATENÇÃO, Informe o Tipo de Maquina - Produto com etiqueta")
				Return(.F.)
			EndIf
		EndIf
		
		If lCopia
			M->B1_POSIPI  := ""
			M->B1_GRTRIB  := ""
			M->B1_ESTFOR  := SPACE(03)
			M->B1_EMIN    := 0.00
			M->B1_ESTSEG  := 0.00
			M->B1_FORPRZ  := SPACE(03)
			M->B1_PE      := 0
			M->B1_LM      := 0.00
			M->B1_LE      := 0.00
			M->B1_TOLER   := 0
			M->B1_PRVALID := 0
			M->B1_EMAX    := 0.00
		EndIf
		
		cNomeUsu  := UsrRetName(RetCodUsr())
		
		SYD->(DbSetOrder(1))
		If SYD->(Dbseek(xFilial("SYD")+M->B1_POSIPI))
			cCodAtiv  := SYD->YD_MSCATIV
			cPortaria := SYD->YD_MSPORTA
		EndIf
		
		If SubStr(cNumEmp,1,2) == "01" // Masipack
			_cDE		  := "pcmasipack.totvs@masipack.com.br"
		ElseIf SubStr(cNumEmp,1,2) $ "10_11" // Fabrima
			_cDE		  := "pcfabrima.totvs@masipack.com.br"
		Else
			//_cDE		  := "masipack@masipack.com.br"
		EndIf
		
		If SubStr(cNumEmp,1,2) $ "01_10" // MASIPACK
			If Inclui
				M->B1_DATAC := Date()
				m->b1_local := ""
				If Alltrim(M->B1_GRUPO) == "0090"
					If Alltrim(M->B1_TIPO) <> "MP"
						M->B1_LOCAL  := "T"
					EndIf
				EndIf
				m->b1_custd := 0
				m->b1_msdtinv := CTOD(SPACE(8))
				m->b1_qtdinic := 0
				If M->B1_MSGRVEN <> "IN"
					If SubStr(cNumEmp,1,2) $ "10_11"
						_cDestino:= "fabrima@fabrima.com.br"
					EndIf
					_cTitulo := "Inclusao de Produtos"
					_cMsg    := "Atenção, Inclusão do  Produto: "+Alltrim(M->B1_COD)+ " - "+Alltrim(M->B1_DESC)+CRLF
					_cMsg    += CRLF
					_cMsg    += "Grupo de Vendas: "+Alltrim(M->B1_MSGRVEN)+CRLF
					_cMsg    += "Tipo: "+Alltrim(M->B1_TIPO)+CRLF
					_cMsg    += "Armazem Padrão: "+Alltrim(M->B1_LOCPAD)+CRLF
					_cMsg    += "Procedencia: "+Alltrim(M->B1_PROCED)+CRLF
					_cMsg    += "Unidade de Medida: "+ M->B1_UM+CRLF
					_cMsg    += "Classif.Fiscal: "+ M->B1_POSIPI+CRLF
					_cMsg    += CRLF
					_cMsg    += "Incluido por: "+Alltrim(cNomeUsu) +CRLF+CRLF
					
					PswOrder(1)
					If PswSeek(RetCodUsr(),.T.)
						_cMsg += "Nome do usuário: " + PswRet()[1][4] + CRLF+CRLF
					EndIf
					oMail:= EnvMail():NEW(.F.)
					If oMail:ConnMail()
						oMail:SendMail(_cTitulo,_cDestino,_cCCo,,_cMsg)
					EndIf
					oMail:DConnMail()
				EndIf
				
				IF "ENG" $ _cDeptoUsu
					If apmsgYesNo("Este Produto possui desenho ?")
						cDesenho := M->B1_COD
					EndIf
					
					IF M->B1_TIPO $ "MP,TS,AF,FF,FM,IM,IP"  .OR. SUBSTR(M->B1_COD,1,5) == "AC088"
						If apmsgYesNo("Produto necessita de Certificado de Qualidade?")
							cCertif := 'S'
						EndIf
					ENDIF
				EndIf
			Else
				If Altera
					If SB1->B1_POSIPI <> M->B1_POSIPI .And. Alltrim(M->B1_GRUPO) <> "0090" .And. !(_cDeptoUsu $ "CONTABILIDADE_CONTABILIDADE/FISCAL_FATURAMENTO_INFORMATICA_INFORMATICA/QUALIDADE")
						apmsgAlert("Esta alteração só poderá ser feita pelos Deptos. Contabilidade/Fiscal")
						M->B1_POSIPI := SB1->B1_POSIPI
					EndIf
					If SubStr(SB1->B1_COD,1,2) <> "MQ" .And. (SB1->B1_DESC <> M->B1_DESC .Or. SB5->B5_CEME <> M->B5_CEME) .And. !(_cDeptoUsu $ "INFORMATICA_INFORMATICA/QUALIDADE_ENG.MECANICA_ENG.ELETRICA_ENG. ELETRONICA_203-MAKLASER_DOCUMENTACAO TECNICA/ENG_ENGENHARIA OBRAS/COMERCIAL")
						apmsgAlert("Somente Engenharias pode Alterar os Campos: Descrição e Descrição Prolongada")
					EndIf
					IF "ENG" $ _cDeptoUsu
						If apmsgYesNo("Este Produto possui desenho ?")
							cDesenho := M->B1_COD
						EndIf
					ENDIF
					
				EndIf
			EndIf
			If Altera .And. SB1->B1_REVATU <> M->B1_REVATU
				M->B1_UREV  := Date()
				cRev        := M->B1_REVATU
				If apmsgYesNo("Esta Revisão altera o programa de Dobra?")
					SG2->(DbSetOrder(3))
					If SG2->(Dbseek(xFilial("SG2")+SB1->B1_COD))
						Do While SG2->(!Eof()) .And. SG2->G2_PRODUTO == SB1->B1_COD
							If Alltrim(SG2->G2_RECURSO) == "C003"
								RecLock("SG2",.F.)
								SG2->G2_MSPROG := ""
								SG2->(MsUnlock())
							EndIf
							SG2->(DbSkip())
							Loop
						EndDo
					EndIf
				EndIf
				_wTitulo   := ""
				_wDestino  := ""
				_wMsg      := ""
				_wCCo      := ""
				_wAnexo    := ""
				IF apmsgYESNO("Roteiro de operações dever ser alterado?")
					_wTitulo := "ALTERAÇÃO DE ROTEIRO DE CÁLCULO"
					_wMsg    := "Produto  : " + SB1->B1_COD
					_wMsg    += CRLF
					_wMsg    += "Descrição: " + SB1->B1_DESC
					_wMsg    += CRLF
					_wMsg    += " Revisão Anterior : " + SB1->B1_REVATU + "       Revisão Atual : " + M->B1_REVATU
					_wMsg    += CRLF
					_wMsg    += CRLF
					_wMsg    += "Por favor verificar a necessidade de inclusão de um novo roteiro de cálculo "
					_wMsg    += CRLF
					_wMsg    += "ou alteração do atual. "
					_wMsg    += CRLF
					
					PswOrder(1)
					If PswSeek(RetCodUsr(),.T.)
						_wMsg += "Nome do usuário: " + PswRet()[1][4] + CRLF+CRLF
					EndIf
					
					_cDestino := "pcp2@masipack.com.br"
					oMail:= EnvMail():NEW(.F.)
					If oMail:ConnMail()
						oMail:SendMail(_wTitulo,_wDestino,_wCCo,,_wMsg)
					EndIf
					oMail:DConnMail()
				ELSE
					_wTitulo := "ALTERAÇÃO DA REVISAO DO PRODUTO"
					_wMsg    := "Produto  : " + SB1->B1_COD + " Revisao Anterior : " + SB1->B1_REVATU
					_wMsg    += CRLF
					_wMsg    += "Descrição: " + SB1->B1_DESC
					_wMsg    += CRLF
					_wMsg    += " Revisão Anterior : " + SB1->B1_REVATU + "       Revisão Atual : " + M->B1_REVATU
					_wMsg    += CRLF
					_wMsg    += CRLF
					_wMsg    += "Não se faz necessário a alteração do roteiro de operações para esse produto. "
					_wMsg    += CRLF

					PswOrder(1)
					If PswSeek(RetCodUsr(),.T.)
						_wMsg += "Nome do usuário: " + PswRet()[1][4] + CRLF+CRLF
					EndIf
					
					_wDestino := "pcp2@masipack.com.br"
					oMail:= EnvMail():NEW(.F.)
					If oMail:ConnMail()
						oMail:SendMail(_wTitulo,_wDestino,_wCCo,,_wMsg)
					EndIf
					oMail:DConnMail()
				ENDIF
				SC2->(DbSetOrder(2))
				If SC2->(DbSeek(xFilial("SC2")+SB1->B1_COD))
					Do While SC2->(!Eof()) .And. SC2->C2_PRODUTO == SB1->B1_COD
						If Empty(SC2->C2_DATRF)
							AADD(_aOPs,{SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,StrZero(SC2->C2_QUANT,2),Alltrim(SC2->C2_MSREDUZ),Alltrim(SC2->C2_MSPOSIC),DTOC(SC2->C2_MSIMPR)})
						EndIf
						SC2->(DbSkip())
					EndDo
				EndIf
				SC1->(DbSetOrder(2))
				If SC1->(DbSeek(xFilial("SC1")+SB1->B1_COD))
					Do While SC1->(!Eof()) .And. SC1->C1_PRODUTO == SB1->B1_COD
						If SC1->C1_RESIDUO == " " .AND.  SC1->C1_QUJE < SC1->C1_QUANT
							AADD(_aSC1,{SC1->C1_NUM+SC1->C1_ITEM,StrZero(SC1->C1_QUANT,2),DTOC(SC1->C1_EMISSAO),DTOC(SC1->C1_DATPRF),ALLTRIM(SC1->C1_MSAPROP)})
						EndIf
						SC1->(DbSkip())
					EndDo
				EndIf
				SC7->(DbSetOrder(2))
				If SC7->(DbSeek(xFilial("SC7")+SB1->B1_COD))
					Do While SC7->(!Eof()) .And. SC7->C7_PRODUTO == SB1->B1_COD
						If SC7->C7_RESIDUO == " " .AND.  SC7->C7_QUJE < SC7->C7_QUANT
							AADD(_aSC7,{SC7->C7_NUM+SC7->C7_ITEM,StrZero(SC7->C7_QUANT,2),DTOC(SC7->C7_EMISSAO),DTOC(SC7->C7_DATPRF),SC7->C7_FORNECE+SC7->C7_LOJA})
						EndIf
						SC7->(DbSkip())
					EndDo
				EndIf
				// Grava na Tabela de Complemento de Produto
				SYD->(DbSetOrder(1))
				If SYD->(Dbseek(xFilial("SYD")+M->B1_POSIPI))
					If Found()
						cCodAtiv  := SYD->YD_MSCATIV
						cPortaria := SYD->YD_MSPORTA
					EndIf
				EndIf
				
				SB2->(DbSetOrder(1))
				SB2->(DbSeek(xFilial("SB2")+SB1->B1_COD+"01"))
				If Len(_aOPs) > 0 .Or. SB2->B2_QATU > 0 .Or. SB1->B1_UM == "CJ" .OR. Len(_aSC1) > 0 .OR. Len(_aSC7) > 0
					If SubStr(cNumEmp,1,2) == "01"
						_cDestino := "doc.tec@masipack.com.br"
					EndIf
					_cTitulo  := "Alteração de Revisão do Produto"
					_cMsg  := "Atenção, Alteração de Revisão: "+Alltrim(SB1->B1_COD)+ " - "+Alltrim(M->B1_DESC) + " => Rev.: "+cRev
					_cMsg  += CRLF

					PswOrder(1)
					If PswSeek(RetCodUsr(),.T.)
						_cMsg += "Nome do usuário: " + PswRet()[1][4] + CRLF+CRLF
					EndIf
					
					If SB1->B1_UM == "CJ"
						_cMsg1 := _cMsg + CRLF + CRLF + "Documentaçao Técnica - Verifique o manual deste Conjunto" + CRLF
						oMail:= EnvMail():NEW(.F.)
						If oMail:ConnMail()
							oMail:SendMail(_ctitulo,_cDestino,_cCCo,,_cMsg1)
						EndIf
						oMail:DConnMail()
					EndIf
					
					_cMsg += CRLF+CRLF
					If Len(_aOps) > 0 .OR. Len(_aSC1) > 0 .OR. Len(_aSC7) > 0
						If SubStr(cNumEmp,1,2) == "01"
							_cDestino := "caldeiraria@masipack.com.br;usinagem@masipack.com.br;silvano.manoel@masipack.com.br"
						ElseIf SubStr(cNumEmp,1,2) $ "10_11"
							_cDestino := "fabrima@fabrima.com.br;rafael.nascimento@fabrima.com.br"
						EndIf
						IF Len(_aOps) > 0
							_cMsg  += "Verifique as OP's que estão na fabrica: "+CRLF
							_cMsg  += CRLF
							For I = 1 To Len(_aOps)
								_cMsg += _aOps[I][1] + " Qtde.: " + _aOps[I][2] + " Cliente: " +_aOPs[I][3] + " - Posição: " + _aOPs[I][4]+" Impressa em: " + _aOps[I][5]+CRLF
							Next I
							_cMsg  += CRLF
						ENDIF
						IF Len(_aSC1) > 0
							_cMsg  += "Verifique as Solicitações de Compras em aberto : "+CRLF
							_cMsg  += CRLF
							For J = 1 To Len(_aSC1)
								_cMsg += _aSC1[J][1] + " Qtde.: " + _aSC1[J][2] + " Apropr.: " +_aSC1[J][5] + " - Emissâo: " + _aSC1[J][3]+" - Prev.Entrega " + _aSC1[J][4]+CRLF
							Next J
							_cMsg  += CRLF
						ENDIF
						IF Len(_aSC7) > 0
							_cMsg  += "Verifique as Pedidos de Compras em aberto : "+CRLF
							_cMsg  += CRLF
							For N = 1 To Len(_aSC7)
								_cFornec := Posicione("SA2",1,xFilial("SA2")+_aSC7[N][5],"A2_NREDUZ")
								_cMsg += _aSC7[N][1] + " Qtde.: " + _aSC7[N][2] + " Fornec.: " + _cFornec + " - Emissao: " + _aSC7[N][3]+" - Prev.Entrega " + _aSC7[N][4]+CRLF
							Next N
							_cMsg  += CRLF
						ENDIF
						If SB2->B2_QATU > 0
							_cMsg  += CRLF
							_cMsg  += "Verifique peças no estoque: "+Transform(SB2->B2_QATU,"@E 999999.999")+ " - Local: "+SB1->B1_LOCAL+CRLF
							_cMsg  += CRLF
							If SubStr(cNumEmp,1,2) == "01"
								_cDestino += "lider.almox@masipack.com.br"
							EndIf
						EndIf
						oMail:= EnvMail():NEW(.F.)
						If oMail:ConnMail()
							oMail:SendMail(_ctitulo,_cDestino,_cCCo,,_cMsg)
						EndIf
						oMail:DConnMail()
					Else
						If SB2->B2_QATU > 0 .And. _nEscolha > 1
							_cMsg += "Não há OP's na fabrica"+CRLF+CRLF
							_cMsg += "Verifique peças no estoque: "+Transform(SB2->B2_QATU,"@E 999999.999")+ " - Local: "+SB1->B1_LOCAL+CRLF // TROCADO B1_MSQAUNT POR B2_QATU EM 17/09/13 - LIZANDRA
							_cMsg += CRLF
							If SubStr(cNumEmp,1,2) == "01"
								_cDestino := "lider.almox@masipack.com.br"
							ElseIf SubStr(cNumEmp,1,2) $ "10_11"
								_cDestino := "fabrima@fabrima.com.br"
							EndIf
							oMail:= EnvMail():NEW(.F.)
							If oMail:ConnMail()
								oMail:SendMail(_ctitulo,_cDestino,_cCCo,,_cMsg)
							EndIf
							oMail:DConnMail()
						EndIf
					EndIf
				EndIf
				If Len(Alltrim(SB1->B1_REVATU)) == 1
					AtuPlotter()       // Esta rotina Exclui os arquivos PLT's das revisoes anteriores
				EndIf
			EndIf
/*
			SB5->(DbSetOrder(1))
			If SB5->(Dbseek(xFilial("SB5")+M->B1_COD))
				RecLock("SB5",.F.)
				SB5->B5_CEME    := IIF( !( UPPER(Alltrim(M->B5_CEME)) == UPPER(Alltrim(M->B1_DESC)) ), M->B5_CEME, M->B1_DESC )
				SB5->B5_INSPAT  := cPortaria
				SB5->B5_CODATIV := cCodAtiv
				SB5->B5_DES     := cDesenho
				SB5->B5_CERT    := cCertif
				SB5->(MsUnlock())
			EndIf
*/			
		EndIf
		
		If Substr(M->B1_COD,1,2) == 'MP' .And. DTOS(M->B1_UCOM) >= "20100428" .And. (Inclui == .T. .OR. Altera == .T.) .And. M->B1_MSBLQL <> "1"
			dbSelectArea("SZE")
			SZE->(dbSetOrder(1))
			SZE->(dbGoTop())
			
			aAreaSBM := SBM->(GetArea())
			
			dbSelectArea("SBM")
			SBM->(dbSetOrder(1))
			SBM->(dbGoTop())
			
			If !SZE->(DbSeek(xFilial("SB1") + Alltrim(M->B1_COD)))
				_cTitulo	:= "Cadastro de Produto - Matéria Prima"
				If Substr(cNumEmp,1,2) == "01"
					_cDestino	:= "doc.tec@masipack.com.br"
				Else
				EndIf
				_cMsg		:= "Código: " + Alltrim(M->B1_COD) + " - Descrição: " + M->B1_DESC + CRLF + CRLF
				_cMsg		+= "Descrição Prolongada: " + SB5->B5_CEME + CRLF + CRLF
				_cMsg		+= "Local: " + M->B1_LOCAL + CRLF + CRLF
				_cMsg		+= "Unidade Medida: " + M->B1_UM + CRLF + CRLF
				_cMsg		+= "Grupo: " + M->B1_GRUPO + CRLF + CRLF
				PswOrder(1)
				If PswSeek(RetCodUsr(),.T.)
					_cMsg += "Nome do usuário: " + PswRet()[1][4] + CRLF+CRLF
				EndIf
				
				If SBM->(DbSeek(xFilial("SBM") + Alltrim(M->B1_GRUPO)))
					_cMsg	+= " - " + SBM->BM_DESC + CRLF + CRLF
				Else
					_cMsg	+= CRLF + CRLF
				Endif
				
				If Inclui == .T.
					_cMsg 	+= "Foi INSERIDO no sistema e suas especificações devem ser cadastradas na Tabela de Tolerancia de MPs." + CRLF
				Else
					_cMsg 	+= "Foi ALTERADO no sistema e suas especificações devem ser cadastradas na Tabela de Tolerancia de MPs." + CRLF
				Endif
				
				oMail:= EnvMail():NEW(.F.)
				If oMail:ConnMail()
					oMail:SendMail(_ctitulo,_cDestino,_cCCo,,_cMsg)
				EndIf
				oMail:DConnMail()
			Endif
			
			SZE->(dbCloseArea())
			RestArea(aAreaSBM)
		Endif
		
		If Substr(M->B1_COD,1,2) == 'MP' .And. Altera == .T. .And. M->B1_MSBLQL == "1"
			dbSelectArea("SZE")
			SZE->(dbSetOrder(1))
			SZE->(dbGoTop())
			If SZE->(dbSeek(xFilial("SB1") + Alltrim(M->B1_COD)))
				If Found()
					RecLock("SZE",.F.)
					SZE->(dbDelete())
					SZE->(MsUnLock())
				Endif
			Endif	
			SZE->(dbCloseArea())	
		Endif
		RestArea(_aArea)
		dbGoto(_nRec)
	ENDIF

Return(.T.)

Static Function VerAcao()

Local oRadio

	DEFINE MSDIALOG oDlg FROM  094,1 TO 230,300 TITLE "Esta Modificação acarreta em:" PIXEL

	@ 05,07 TO 45, 145 OF oDlg  PIXEL
	@ 10,10 Radio oRadio VAR _nEscolha;
	ITEMS "Melhoria","Retrabalhar","Sucatear" 3D SIZE 125,10 OF oDlg PIXEL

	DEFINE SBUTTON FROM 048,055 TYPE 1 ENABLE OF oDlg ACTION oDlg:End()
	ACTIVATE MSDIALOG oDlg CENTERED

Return

Static function AtuPlotter()

Local I

	cPasta := "H:\PLOTTER\"
	If cPasta == "CL" .And. Substr(cNumEmp,1,2) == "01"
		cPasta += Substr(M->B1_COD,3,2)+"\"+Alltrim(M->B1_COD)
	Else
		cPasta += Substr(M->B1_COD,1,2)+"\"+Alltrim(M->B1_COD)
	EndIf

	For I := 1 To 27
		If Alltrim(aRev[I]) <> Alltrim(M->B1_REVATU)
			cArqPLT := cPasta + Alltrim(aRev[I]) + ".PLT"
			Ferase(cArqPLT)
			cArqPLT := cPasta + Alltrim(aRev[I]) + ".PRI"
			Ferase(cArqPLT)
			cArqPLT := cPasta + Alltrim(aRev[I]) + ".PRN"
			Ferase(cArqPLT)
		Else
			Exit
		EndIf
	Next I

Return
