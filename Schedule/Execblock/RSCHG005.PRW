#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} User Function RSCHG005
Envio da relação de pedidos de compras com data de entrega em atraso
@type  Function
@author E.DINIZ - [ DS2U ]
@since 12/08/2021
@version version
/*/
User Function RSCHG005(aParam)

Local cAlias	:= ''
Local oMail     := Nil
Local oHtml		:= Nil

	CONOUT('=========================|RSCHG005|==========================')
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

    cAlias := GetSC7Data()
	
	If (cAlias)->(!EOF())

		oMail := TWFProcess():New( "RSCHG005", "Relação de Pedido de Compras em Atraso" )
		oMail:NewTask( "RSCHG005", "\WORKFLOW\MODELOS\PC\PCATRASO.htm" )
		
		oMail:cSubject	:= NoAcento(Alltrim(UPPER(SM0->M0_NOME))) + ' | Pedido de Compras em Atraso'
		oMail:cTo		:= GetUsrMail('MS_WFPCATR',';')
		oMail:bReturn	:= ''

		oHtml := oMail:oHtml
		oHtml:ValByName("cNomeEmp",NoAcento(Alltrim(UPPER(SM0->M0_NOME))))
		While (cAlias)->(!EOF())
			AADD((oHtml:ValByName('IT1.1')),NoAcento((cAlias)->FORNECEDOR))
			AADD((oHtml:ValByName('IT1.2')),(cAlias)->C7_NUM)
			AADD((oHtml:ValByName('IT1.3')),(cAlias)->C7_ITEM)
			AADD((oHtml:ValByName('IT1.4')),(cAlias)->C7_PRODUTO)
			AADD((oHtml:ValByName('IT1.5')),NoAcento((cAlias)->B1_DESC))
			AADD((oHtml:ValByName('IT1.6')),Alltrim(Transform((cAlias)->C7_QUANT,PesqPict('SD1','D1_QUANT'))))
			AADD((oHtml:ValByName('IT1.7')),(cAlias)->B1_UM)
			AADD((oHtml:ValByName('IT1.8')),DTOC(STOD((cAlias)->C7_DATPRF)))

			(cAlias)->(dbSkip())
		Enddo

		oHtml:ValByName("cDtProc",DTOC(DATE()))
		oHtml:ValByName("cHrProc",ALLTRIM(TIME()))

		oMail:Start()
		oMail:Finish()
			
		Sleep(5000)

	Endif

	(cAlias)->(dbCloseArea())

	RPCClearEnv()

	CONOUT('= FINALIZADO EM: ' + DTOC(DATE()) + ' - ' + TIME())
    CONOUT('=============================================================')

Return


/*/{Protheus.doc} GetSC7Data()
Retorna a listagem do pedido de compras em atraso
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 12/08/2021
@version version
/*/
Static Function GetSC7Data()

Local cFilSel	:= GetPCInter()
Local cRet		:= GetNextAlias()

	BEGINSQL ALIAS cRet

		SELECT	A2_COD +'/'+ A2_LOJA + ' - ' + TRIM(A2_NOME) AS FORNECEDOR,
				C7_NUM,	C7_ITEM, C7_PRODUTO, B1_DESC, C7_QUANT, B1_UM, C7_DATPRF

		FROM	%Table:SC7% C7, %Table:SA2% A2, %Table:SB1% B1


		WHERE	C7_FILIAL	=	%xFilial:SC7%		AND
				C7_TIPO		IN	(%Exp:'1'%)			AND
				C7_QUANT	> 	C7_QUJE				AND
				C7_DATPRF	<=	%Exp:DTOS(DATE())%	AND
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
				)	AND

				A2_FILIAL	=	%xFilial:SA2%		AND
				A2_COD		=	C7_FORNECE			AND
				A2_LOJA		=	C7_LOJA				AND
				A2_CGC		NOT IN (%Exp:cFilSel%)	AND
				A2.%NOTDEL%							AND

				B1_FILIAL	=	%xFilial:SC7%		AND
				B1_COD		=	C7_PRODUTO			AND
				B1.%NOTDEL%

		ORDER BY 1,8,2,3

	ENDSQL
	
Return cRet

/*/{Protheus.doc} GetPCInter()
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

/*/{Protheus.doc} GetUsrMail()
Retorna os e-mails de usários através de parâmetro
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 12/08/2021
@version version
/*/
Static Function GetUsrMail(xParam,xSeprator)

Local aUsrMail	:= {}
Local cRet		:= ''

	aUsrMail := StrToKarr2(GetMV(xParam),xSeprator,.F.)
	AEval(aUsrMail,{|x| IF( IsEmail( UsrRetMail(x)), cRet += Alltrim(UsrRetMail(x)) + ';', .F. ) })
	cRet := SubStr(cRet,1,Len(cRet)-1)

Return cRet
