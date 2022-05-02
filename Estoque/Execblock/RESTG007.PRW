#include 'totvs.ch'

/*/{Protheus.doc} User Function RESTG007
	UF utilizado no X3_RELACAO para habilitar ou não a edição de campos específicos apenas para as empresas: Masipack e Fabrima
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
			
			CASE FwIsAdmin()	//Acesso Administradores
				lRet := .T.
			
			CASE cField == 'B1_UM' .And. ALTERA
				
				For nPos := 1 To Len(UsrRetGrp(RetCodUsr()))
					If UsrRetGrp(RetCodUsr())[nPos] $ "000235|000215|000216"	//Acesso Contábil
						lRet := .T.
						Exit
					ElseIf UsrRetGrp(RetCodUsr())[nPos] $ "000214|000219"		//Acesso PCP/Engenharia
						lRet := .T.
						Exit
					Endif
				Next nPos
			
			CASE cField == 'B1_UM' .And. INCLUI
				lRet := .T.
				
		ENDCASE

	EndIf

Return lRet
