#Include 'Protheus.ch'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "FWEVENTVIEWCONSTS.CH"
#INCLUDE 'FWLIBVERSION.CH'
#INCLUDE 'TOPCONN.ch'

/*--------------------------------------------------------------------------------------------------------------------------*
 | P.E.:  {Protheus.doc} MT131WF                                                                        					|
 | Desc:  customização de workflow baseado nas informações de cotações que estão sendo geradas pela rotina em execução		|
 |		  Ex.: Possibilita preparar um e-mail customizado para os fornecedores contendo os itens a serem cotados para que	| 
 |		  possa ser respondido pelo próprio fornecedor selecionado.  														|
 | Links: https://tdn.totvs.com/pages/releaseview.action?pageId=536709258													|
 |                                                                              	         				                |
 | @author  DS2U (THOMAS MORAES)																							|
 | @since   Abr.2023																										|
 | @version 1.0																												|
 | @type    function                                  																		|
 *-------------------------------------------------------------------------------------------------------------------------*/


USER FUNCTION MT131WF()

Local cNumCot    := ParamIXB[1] //Numero cotacao de compras

Local cMailAssun := "Solicitacao de Cotacao ["+cNumCot+"] | "+FWFilialName()
Local aItens	 := {}
Local aForns	 := {}
Local aCots	     := {}
Local nFind	     := 0
Local nFindF	 := 0
Local nCPos	     := 1
Local nI		 := 0
Local nJ		 := 0
Local cBody	     := ""

//Percorre todos itens da cotacao
SC8->(dbSetOrder(4))
SC8->(dbSeek(xFilial("SC8")+cNumCot))
While !SC8->(Eof()) .AND. SC8->C8_NUM == cNumCot
        
    //- Preeche array contendo informações para gerar e-mail solicitando cotacao.
    If !Empty(SC8->C8_FORMAIL)
        aItens := {}
        aAdd(aItens,allTrim(SC8->C8_PRODUTO))
        aAdd(aItens,SC8->C8_QUANT)
        aAdd(aItens,SC1->C1_DATPRF) //Atribui data de entrega do campo SC1->C1_DATPRF (Sol. Compras)
        aAdd(aItens,SC8->C8_IDENT)
                    
        aForns := {}
        aAdd(aForns,SC8->C8_FORNECE)
        aAdd(aForns,SC8->C8_LOJA)
        aAdd(aForns,allTrim(SC8->C8_FORMAIL))
        aAdd(aForns,{})
        aAdd(aForns[4],aItens)

        nFind := aScan(aCots,{|x| x[1] == SC8->C8_NUM })

        If  nFind == 0
            aAdd(aCots,{})
            aAdd(aCots[nCPos],allTrim(SC8->C8_NUM))
            aAdd(aCots[nCPos],SC8->C8_EMISSAO)
            aAdd(aCots[nCPos],{})
            aAdd(aCots[nCPos][3],aForns)
            nCPos++
        Else
            nFindF := aScan(aCots[nFind][3],{|x| x[1] + x[2] == allTrim(SC8->C8_FORNECE) + allTrim(SC8->C8_LOJA)})
            If nFindF == 0
                aAdd(aCots[nFind][3],aForns)
            Else
                aAdd(aCots[nFind][3][nFindF][4],aItens)
            EndIf
        EndIf
    EndIf
    SC8->(dbSkip())
EndDo

If File("samples/wf/MATA131_Mail001.html")
	For nI := 1 To Len(aCots)
		For nJ := 1 to Len(aCots[nI][3])
			If !Empty(aCots[nI][3][nJ][3])
				cBody := U_WFGerMail(aCots[nI][1],aCots[nI][2],aCots[nI][3][nJ])
				U_EnvMailWF({aCots[nI][3][nJ][3]},cMailAssun,cBody)
			EndIf
		Next nJ
	Next nI
EndIf

Return

//---------------------------------------------------------------------------
/*/{Protheus.doc} WFGerMail()
Gera corpo do e-mail enviado para o fornecedor informar os valores de itens
a serem cotados.

@author DS2U (THOMAS MORAES)
@since Jun.2023
@version P12
/*/
//---------------------------------------------------------------------------

User Function WFGerMail(cNumCot, cDtEmiCot, aForn)
	Local nI	:= 0
	Local nY	:= 0
	Local cRet	:= ""
	Local aArea := GetArea()
	Local cHTMLSrc 	:= "samples/wf/MATA131_Mail001.html"
	Local cHTMLDst	:= "samples/wf/MATA131_MTmp001.htm" //Destino deve ser .htm pois o metodo :SaveFile salva somente neste formato.
	Local oHTMLBody 	:= TWFHTML():New(cHTMLSrc)
	Local aItem := {}
	Local lMT131AI  := ExistBlock("MT131AI")
	Local nTamCot   := TamSX3("C1_COTACAO")[1]
	Local nTamProd  := TamSX3("C1_PRODUTO")[1]
	Local nTamIdent := TamSX3("C1_IDENT")[1]

	oHTMLBody:ValByName('cNumCot',cNumCot)

	//- Cabeçalho do informe.
	oHTMLBody:ValByName('cNomeCli'	, allTrim(SM0->M0_NOMECOM))
	oHTMLBody:ValByName('cDataEmis'	, cDtEmiCot)
	oHTMLBody:ValByName('cCNPJCli'	, SM0->M0_CGC)
	oHTMLBody:ValByName('cEndeCli'	, allTrim(SM0->M0_ENDENT)+" - "+allTrim(SM0->M0_CIDENT)+" - "+allTrim(SM0->M0_ESTENT))
	oHTMLBody:ValByName('cCepCli'	, SM0->M0_CEPENT)
	oHTMLBody:ValByName('cFoneCli'	, allTrim(SM0->M0_TEL))
	
	DbSelectArea("SA2")
	DbSetOrder(1)
	If(SA2->(DBSeek(xFilial("SA2")+aForn[1]+aForn[2])))
		oHTMLBody:ValByName('cNomeFor',allTrim(SA2->A2_NOME))
		oHTMLBody:ValByName('cCNPJFor',allTrim(SA2->A2_CGC))
		oHTMLBody:ValByName('cCondFor',"") //Condicao de pagamento do fornecedor - Campo livre
	EndIf
	
	//- Detalhamento dos itens
	For nI := 1 to Len(aForn[4])
		DbSelectArea("SB1")
		If (SB1->(DBSeek(xFilial("SB1")+aForn[4][nI][1])))
			aADD(oHTMLBody:ValByName('It.cProDesc')	,allTrim(SB1->B1_DESC))
			aADD(oHTMLBody:ValByName('It.cQuant')	,aForn[4][nI][2])
		EndIf
		If lMT131AI
			SC1->(DbSetOrder(5)) // C1_FILIAL+C1_COTACAO+C1_PRODUTO+C1_IDENT 
			If SC1->(DBSeek(xFilial("SC1")+PadR(cNumCot,nTamCot)+PadR(aForn[4][nI][1],nTamProd)+PadR(aForn[4][nI][4],nTamIdent))) // Posicionar em cada item da SC para carregar os dados do campo observação de acordo com o item. 
				aADD(oHTMLBody:ValByName('It.cDtEnt')	,SC1->C1_DATPRF) // Apos posicionar solicitacao de compras, atribui a data de entrega
				aItem := ExecBlock("MT131AI") // Ponto de Entrada para adicionar mais itens dos campos
				If ValType(aItem) == "A" .And. Len(aItem) > 0
					For nY := 1 to Len(aItem)
						If "It." $ aItem[nY,1]
							aADD(oHTMLBody:ValByName(aItem[nY,1]),aItem[nY,2])
						Else
							oHTMLBody:ValByName(aItem[nY,1],aItem[nY,2])
						EndIf 
					Next nY
				Endif
			EndIf
		EndIf
	Next 
	
	oHTMLBody:SaveFile(cHTMLDst)
	cRet:= MtHTML2Str(cHTMLDst)
	FErase(cHTMLDst)
	RestArea(aArea)
Return cRet

//-------------------------------------------------------------------------------
/*/{Protheus.doc} EnvMailWF()
Realiza o envio de e-mail considerando dados de conta dos parametros da empresa,
bem como utiliza o corpo HTML previamente montado para enviar aos fornecedores
da cotacao.

@author DS2U (THOMAS MORAES)
@since Jun.2023
@version P12
/*/
//-------------------------------------------------------------------------------

/********************************************************
Utilizando classe TMailMessage
********************************************************/
User Function EnvMailWF(aMailPara,cMailAssun,cMailTexto)
	Local cMsg := ""
	Local xRet
	Local oServer, oMessage
	Local lMailAuth	:= SuperGetMv("MV_RELAUTH",,.F.)		 // Servidor de email necessita de autenticacao?
	Local cMailConta :=SuperGetMv("ES_CNTWFEM",,.F.)         //Conta utilizada para envio do email
	Local cMailServer:=SuperGetMv("ES_SRVSMTP",,.F.)		 //Servidor SMTP
	Local cMailSenha :=SuperGetMv("ES_WFPSW",,.F.)           //Senha da conta de e-mail utilizada para envio
	Local nPorta := 0	 									 //informa a porta que o servidor SMTP irá se comunicar, podendo ser 465 ou 587
    Local _nI := 0
	Local cMailPara := ""
	Local nTimeOut     := GetMV("MV_RELTIME")

	cServer      := Iif(':' $ cMailServer, SubStr(cMailServer, 1, At(':', cMailServer)-1), cMailServer)
    nPorta        	 := Iif(':' $ cMailServer, Val(StrTran(substr(cMailServer,At(':', cMailServer)),":","")), 587)

   	oMessage:= TMailMessage():New()
	oMessage:Clear()
   
	oMessage:cDate	 := cValToChar( Date() )
	oMessage:cFrom 	 := cMailConta
    
    For _nI := 1 To Len(aMailPara)
    	If !Empty(aMailPara[_nI])
    		cMailPara += aMailPara[_nI]+"; "
    	EndIf
    Next
	cMailPara := SubStr(cMailPara,1,Len(cMailPara)-2)

	oMessage:cTo 	 := cMailPara
	oMessage:cSubject:= cMailAssun
	oMessage:cBody 	 := cMailTexto
	oMessage:cBCC 	 := cMailConta //conta utilizada para envio recebe como copia oculta o que foi enviado ao fornecedor
		
	   
	oServer := tMailManager():New()
	oServer:SetUseTLS( .T. ) //Indica se será utilizará a comunicação segura através de SSL/TLS (.T.) ou não (.F.)
   
	xRet := oServer:Init( "", cServer, cMailConta, cMailSenha, 0, nPorta ) //inicilizar o servidor
	if xRet != 0
		alert("O servidor SMTP não foi inicializado: " + oServer:GetErrorString( xRet ) )
		return
	endif
   
	xRet := oServer:SetSMTPTimeout( 60 ) //Indica o tempo de espera em segundos.
	if xRet != 0
		alert("Não foi possível definir o tempo limite para " + cValToChar( nTimeout ))
	endif
   
	//- Conexão com o servidor SMTP
	xRet := oServer:SMTPConnect()
	if xRet <> 0
		alert("Não foi possível conectar ao servidor SMTP: " + oServer:GetErrorString( xRet ))
		return
	endif
   
	if lMailAuth
		//O método SMTPAuth ao tentar realizar a autenticação do 
		//usuário no servidor de e-mail, verifica a configuração 
		//da chave AuthSmtp, na seção [Mail], no arquivo de 
		//configuração (INI) do TOTVS Application Server, para determinar o valor.

		//- Autenticacao da conta de e-mail
		xRet := oServer:SmtpAuth( cMailConta, cMailSenha )
		if xRet <> 0
			cMsg := "Could not authenticate on SMTP server: " + oServer:GetErrorString( xRet )
			alert( cMsg )
			oServer:SMTPDisconnect()
			return
		endif
   	Endif
	xRet := oMessage:Send( oServer )
	if xRet <> 0
		alert("Não foi possível enviar mensagem: " + oServer:GetErrorString( xRet ))
	Else
		alert("Cotacao enviada para fornecedores - E-mails " + cMailPara)
	endif
   
	xRet := oServer:SMTPDisconnect()
	if xRet <> 0
		alert("Não foi possível desconectar o servidor SMTP: " + oServer:GetErrorString( xRet ))
	endif
return
