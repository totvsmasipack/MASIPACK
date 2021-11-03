#Include "Rwmake.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} MT415EFT
// Validação da Efetivação do Orçamento
@author Everton Diniz - DS2U
@since 12/08/2019
@version 1.0
@return ${return}, ${return_description}
@type function
/*/
User Function MT415EFT()
Local lRet := .T.

	If PARAMIXB[1] == 1	//Opção: Efetivar
   
		If ALLTRIM(SA1->A1_RISCO) $ "D|E"
			Alert("Cliente possui restrição financeira. Favor verificar com Depto. Financeiro!!!") 
			lRet  := .F.
	    EndIf
	   
	    //Validação da Inconsistência dos campos CJ_CLIENTE e CJ_CLIENT. 
	    If M->CJ_CLIENTE <> M->CJ_CLIENT
	   		Help( , , "MT415EFT_1", , "O campo Cliente Entr. é DIFERENTE do campo Cliente.", 1, 0, Nil, Nil, Nil, Nil, Nil, {"Preencha os dois campos com o Código do Mesmo Cliente"} ) 
			lRet  := .F.
	    Endif
	
	Endif

Return lRet
