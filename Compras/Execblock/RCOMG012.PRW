#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} RCOMG012
//TODO Descrição: Validação de usuário para os campos A1_EST, A2_EST, A1_TIPO e A2_TIPO
@author Everton Diniz - DS2U
@since 04/04/2018
@version 1.0
@type User function
/*/

User Function RCOMG012()
Local cErro	:= ""
Local lRet	:= .T.

	Do Case
		
		//***************************
		//* Valida Fornecedor		*
		//***************************
		Case "MATA020" $ FUNNAME()
			
			//Verifica se o Fornecedor 
			If "EX" $ M->A2_EST .And. !Empty(M->A2_TIPO)
				
				If !M->A2_TIPO == "X"
					cErro	:= 'O campo "Tipo do Fornecedor" não está informado como "Outros" '
					lRet	:= .F.
					Help(Nil, Nil, "FORNEX", Nil, cErro, 1, 0, Nil, Nil, Nil, Nil, Nil, {""} )
				Endif
			
			ElseIf M->A2_TIPO == "X" .And. !Empty(M->A2_EST)
				
				If !"EX" $ M->A2_EST
					cErro	:= 'O campo "Estado" não está informado como "EX" '
					lRet	:= .F.
					Help(Nil, Nil, "FORNEX", Nil, cErro, 1, 0, Nil, Nil, Nil, Nil, Nil, {""} )
				Endif

			Endif
		
		//***************************
		//* Valida Cliente			*
		//***************************
		Case "MATA030" $ FUNNAME()

			If "EX" $ M->A1_EST .And. !Empty(M->A1_TIPO)
				
				If !M->A1_TIPO == "X"
					cErro	:= 'O campo "Tipo do Cliente" não está definido como "Outros" '
					lRet	:= .F.
					Help(Nil, Nil, "CLIEX", Nil, cErro, 1, 0, Nil, Nil, Nil, Nil, Nil, {""} )
				Endif
			
			ElseIf M->A1_TIPO == "X" .And. !Empty(M->A1_EST)
		
				If !"EX" $ M->A1_EST
					cErro	:= 'O campo "Estado" não está informado como "EX" '
					lRet	:= .F.
					Help(Nil, Nil, "CLIEX", Nil, cErro, 1, 0, Nil, Nil, Nil, Nil, Nil, {""} )
				Endif

			Endif

	EndCase

Return lRet
