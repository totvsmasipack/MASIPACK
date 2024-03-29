#include 'totvs.ch'

/*/{Protheus.doc} User Function RESTG007
	UF utilizado no X3_RELACAO para habilitar ou n�o a edi��o de campos espec�ficos apenas para as empresas: Masipack e Fabrima
@type  Function
@author E.DINIZ - [ DS2U ]
@since 28/04/2022
/*/
User Function RESTG007(cField)

Local lRet	:= .F.
Local nPos	:= 0

Default cField := ''

	If FWCodEmp() $ '01|10'
		
		DO CASE

			CASE cField $ 'B1_UM|B1_PICM|B1_IPI' .And. INCLUI
				lRet := .T.

			CASE Empty(FWSFUsrGrps(RetCodUsr())) // Valida se o usu�rio possui grupo
				lRet := .F.
			
			CASE FwIsAdmin()	//Acesso Administradores
				lRet := .T.
			
			CASE cField $ 'B1_UM|B1_PICM|B1_IPI' .And. ALTERA
				
				For nPos := 1 To Len(UsrRetGrp(RetCodUsr()))
					If UsrRetGrp(RetCodUsr())[nPos] $ "000235|000215|000216"	//Acesso Cont�bil
						lRet := .T.
						Exit
					ElseIf UsrRetGrp(RetCodUsr())[nPos] $ "000214|000219"		//Acesso PCP/Engenharia
						lRet := .T.
						Exit
					Endif
				Next nPos
				
		ENDCASE

	EndIf

Return lRet
