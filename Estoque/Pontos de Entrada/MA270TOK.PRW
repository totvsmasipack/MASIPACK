#Include "totvs.ch"

/*/{Protheus.doc} User Function Ma270TOk
LOCALIZAÇÃO : Function A270TudoOk() - Responsável por validar se o produto ja esta cadastrado na data informada.
EM QUE PONTO : O ponto de entrada 'MA270TOK' é executado no final da função TUDOOK(), permitido validar os dados informados pelo usuário, quando executado o botão de confirmação.
@type  Function
@author Masipack
@since 04/08/2020
@return _lRet, Logical, .T. or .F.
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6087624
/*/
User Function Ma270TOk()

	If !(cEmpAnt $ '15')

		If INCLUI
			M->B7_QTSEGUM := M->B7_QUANT
			IF SubStr(M->B7_COD,1,2) == "MP"
				SB1->(dbSeek(xFilial("SB1") + M->B7_COD))
				IF SB1->(FOUND()) .And. SB1->B1_UM == "KG"
					M->B7_QTSEGUM	:= ROUND(M->B7_QUANT * M->B7_MSFATR1 * M->B7_MSFATR2,2)
					M->B7_QUANT		:= ROUND(M->B7_QUANT * M->B7_MSFATR1 * M->B7_MSFATR2,2)
				ENDIF
			ENDIF
		ENDIF

		IF ALTERA .AND. SUBSTR(M->B7_COD,1,2) == "MP"
			SB1->(DBSETORDER(1))
			SB1->(dbSeek(xFilial("SB1") + M->B7_COD))
			IF SB1->(FOUND()) .And. SB1->B1_UM == "KG"
				IF !(M->B7_QUANT == M->B7_QTSEGUM)
					M->B7_QUANT := ROUND(M->B7_QTSEGUM,2)
				ENDIF
			ENDIF
		ENDIF

	Endif

Return .T.
