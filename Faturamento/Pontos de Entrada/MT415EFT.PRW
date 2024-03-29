#Include "Rwmake.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} MT415EFT
// Valida��o da Efetiva��o do Or�amento
@author Everton Diniz - DS2U
@since 12/08/2019
@version 1.0
@return ${return}, ${return_description}
@type function
/*/
User Function MT415EFT()
Local lRet := .T.

	If PARAMIXB[1] == 1	//Op��o: Efetivar
   
		If ALLTRIM(SA1->A1_RISCO) $ "D|E"
			Alert("Cliente possui restri��o financeira. Favor verificar com Depto. Financeiro!!!") 
			lRet  := .F.
	    EndIf
	   
	    //Valida��o da Inconsist�ncia dos campos CJ_CLIENTE e CJ_CLIENT. 
	    If M->CJ_CLIENTE <> M->CJ_CLIENT
	   		Help( , , "MT415EFT_1", , "O campo Cliente Entr. � DIFERENTE do campo Cliente.", 1, 0, Nil, Nil, Nil, Nil, Nil, {"Preencha os dois campos com o C�digo do Mesmo Cliente"} ) 
			lRet  := .F.
	    Endif
	
	Endif

Return lRet
