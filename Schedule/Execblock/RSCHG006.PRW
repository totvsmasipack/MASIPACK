#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} User Function RSCHG006
Envio de pedidos de compras em atraso ao fornecedor
@type  Function
@author E.DINIZ - [ DS2U ]
@since 12/08/2021
@version version
/*/
User Function RSCHG006(aParam)

    CONOUT('=========================|RSCHG006|==========================')
    CONOUT('= INICIADO EM: ' + DTOC(DATE()) + ' - ' + TIME())

    Do Case
    Case Empty(aParam[1]) 
		CONOUT('= AVISO: CODIGO DA EMPRESA NAO INFORMADO PARA PROCESSAMENTO =')
		Return
        
    Case Empty(aParam[2]) 
		CONOUT('= AVISO: CODIGO DA FILIAL NAO INFORMADO PARA PROCESSAMENTO  =')
		Return

    EndCase

	RPCSetType(3)
	RPCSetEnv(aParam[1],aParam[2])

    GetSC7Data()

    RPCClearEnv()

	CONOUT('= FINALIZADO EM: ' + DTOC(DATE()) + ' - ' + TIME())
    CONOUT('=============================================================')

Return


/*/{Protheus.doc} GetSC7Data
Retorna a listagem do pedido de compras em atraso por fornecedor
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 12/08/2021
@version version
/*/
Static Function GetSC7Data()

Local cAlias	:= ''
Local cKey		:= ''
Local oMail     := Nil
Local oHtml		:= Nil

    cAlias := LoadSC7()
	
	While (cAlias)->(!EOF())

		cKey := (cAlias)->(C7_FORNECE + C7_LOJA + C7_NUM)

		oMail := TWFProcess():New( "RSCHG006", "Pedido de Compras em Atraso" )
		oMail:NewTask( "RSCHG006", "\WORKFLOW\MODELOS\PC\PCATRASO_1.htm" )
		
		oMail:cSubject	:= NoAcento(Alltrim(UPPER(SM0->M0_NOME))) + ' | Pedido de Compras em Atraso'
		oMail:cTo		:= Alltrim((cAlias)->A2_EMAIL2)
		oMail:bReturn	:= ''

		oHtml := oMail:oHtml
		oHtml:ValByName("cNomeEmp",Alltrim(UPPER(SM0->M0_NOME)))
        oHtml:ValByName("cNumPed",(cAlias)->C7_NUM)

        oHtml:ValByName("cNomeFor", NoAcento((cAlias)->FORNECEDOR))
        oHtml:ValByName("cDataEmis",DTOC(STOD((cAlias)->C7_EMISSAO)))
        oHtml:ValByName("cCNPJFor", Transform((cAlias)->A2_CGC,PesqPict('SA2','A2_CGC')))

        oHtml:ValByName("cNomeCli", Alltrim(NoAcento(UPPER(SM0->M0_NOMECOM))))
        oHtml:ValByName("cCNPJCli", Alltrim(Transform(SM0->M0_CGC,PesqPict('SA2','A2_CGC'))))
        oHtml:ValByName("cEndeCli", Alltrim(NoAcento(UPPER(SM0->M0_ENDENT))))
        oHtml:ValByName("cCepCli",  Alltrim(Transform(SM0->M0_CEPENT,PesqPict('SA2','A2_CEP'))))
        oHtml:ValByName("cFoneCli", Alltrim(SM0->M0_TEL))
		oHtml:ValByName("cContato", Alltrim(GetMv('MS_WFMAIL',.F.,'')))

		While (cAlias)->(!EOF()) .And. (cAlias)->(C7_FORNECE + C7_LOJA + C7_NUM) == cKey
			AADD((oHtml:ValByName('IT1.1')),NoAcento((cAlias)->C7_ITEM))
			AADD((oHtml:ValByName('IT1.2')),(cAlias)->C7_PRODUTO)
			AADD((oHtml:ValByName('IT1.3')),'-')
			AADD((oHtml:ValByName('IT1.4')),NoAcento((cAlias)->B1_DESC))
			AADD((oHtml:ValByName('IT1.5')),(cAlias)->B1_UM)
			AADD((oHtml:ValByName('IT1.6')),Alltrim(Transform((cAlias)->C7_QUANT,PesqPict('SD1','D1_QUANT'))))
			AADD((oHtml:ValByName('IT1.7')),Alltrim(Transform((cAlias)->C7_QUJE,PesqPict('SD1','D1_QUANT'))))
			AADD((oHtml:ValByName('IT1.8')),Alltrim(Transform((cAlias)->SALDO,PesqPict('SD1','D1_QUANT'))))
            AADD((oHtml:ValByName('IT1.9')),DTOC(STOD((cAlias)->C7_DATPRF)))

			(cAlias)->(dbSkip())
		Enddo

		oHtml:ValByName("cDtProc",DTOC(DATE()))
		oHtml:ValByName("cHrProc",ALLTRIM(TIME()))

		oMail:Start()
		oMail:Finish()
		Sleep(5000)
	Enddo

	(cAlias)->(dbCloseArea())

Return


/*/{Protheus.doc} LoadSC7
Retorna a listagem do pedido de compras em atraso
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 12/08/2021
@version version
/*/
Static Function LoadSC7()

Local cFilSel	:= GetPCInter()
Local cRet		:= GetNextAlias()

	BEGINSQL ALIAS cRet

		SELECT	A2_COD +'/'+ A2_LOJA + ' - ' + TRIM(A2_NOME) AS FORNECEDOR, A2_CGC, A2_EMAIL2, C7_NUM, C7_FORNECE, C7_LOJA,
				C7_ITEM, C7_PRODUTO, B1_DESC, C7_QUANT, C7_QUJE, C7_QUANT- C7_QUJE AS SALDO, B1_UM, C7_DATPRF, C7_EMISSAO

		FROM	%Table:SC7% C7
            
                INNER JOIN %Table:SA2% A2 ON
                A2_FILIAL	=	%xFilial:SA2%		AND
				A2_COD		=	C7_FORNECE			AND
				A2_LOJA		=	C7_LOJA				AND
				A2_CGC		NOT IN (%Exp:cFilSel%)	AND
				A2.%NOTDEL%		
                
                INNER JOIN %Table:SB1% B1 ON
                B1_FILIAL	=	%xFilial:SC7%		AND
				B1_COD		=	C7_PRODUTO			AND
				B1.%NOTDEL%

                LEFT JOIN  %Table:SA5% A5 ON
                A5_FILIAL	=	%xFilial:SC7%		AND
                A5_FORNECE  =   C7_FORNECE          AND
                A5_LOJA     =   C7_LOJA             AND
                A5_PRODUTO  =   C7_PRODUTO          AND
				A5.%NOTDEL%

		WHERE	C7_FILIAL	=	%xFilial:SC7%		AND
				C7_TIPO		IN	(%Exp:'1'%)			AND
				C7_QUANT	> 	C7_QUJE				AND
				C7_DATPRF	<	%Exp:DTOS(DATE())%	AND
				C7_RESIDUO	=	%Exp:''%			AND
				C7.%NOTDEL%							AND
				C7_NUM + C7_ITEM NOT IN (
					SELECT	D1_PEDIDO + D1_ITEMPC 
					FROM	%Table:SD1% D1, %Table:SF1% F1
					WHERE	D1_FILIAL		= %xFilial:SD1%	AND
							D1_PEDIDO		= C7_NUM		AND
							D1_ITEMPC		= C7_ITEM		AND
							D1.%NOTDEL%						AND
							F1_FILIAL		=	D1_FILIAL	AND
							F1_DOC			=	D1_DOC		AND
							F1_SERIE		=	D1_SERIE	AND
							F1_FORNECE		=	D1_FORNECE	AND
							F1_LOJA			=	D1_LOJA		AND
							F1_TIPO			=	D1_TIPO		AND
							F1_STATUS		=	%Exp:''%	AND
							F1.%NOTDEL%
				)

		ORDER BY C7_NUM, C7_ITEM

	ENDSQL
	
Return cRet

/*/{Protheus.doc} GetPCInter
Retorna os CNPJs Intercompany
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 12/08/2021
@version version
/*/
Static Function GetPCInter()

Local aFilial	:= FwLoadSM0()
Local cRet		:= ''

	AEval(aFilial,{|x| cRet += Alltrim(x[18])+';' })
	cRet := FormatIn(SubStr(cRet,1,Len(cRet)-1),";")
	cRet := '%'+ SubStr(cRet,2,Len(cRet)-2) +'%'

Return cRet
