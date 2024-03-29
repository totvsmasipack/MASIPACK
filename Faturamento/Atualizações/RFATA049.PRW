#Include "protheus.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} RFATA049
	//TODO Convertido fonte j� existente para objeto. 
	@author Alison Gon�alves
	@since 05/07/11
	@version 1.0
	@return cTexto
	@type User function
/*/
User Function RFATA049()
	Local cVar		:= ReadVar()
	local oMdl   := nil 
	local oMaster:= nil 
	Local cReturn:=	''
	
	oMdl := fwModelActive()
	If oMdl <> nil // Verifica se e rotina MVC

		oMaster := oMdl:getModel(oMdl:aModelStruct[1][2])

		if oMaster <> nil // Verifica se e rotina MVC
			If cVar=="M->B1_COD"
				oMaster:loadValue(Substr(cVar,4,10), B1CODAcent(&cVar))
			ElseIf cVar == "M->B1_DESC"	
				oMaster:loadValue(Substr(cVar,4,10), B1DSCAcent(&cVar))	
			ElseIf cVar == "M->C1_OBS" // Solicitacao de Compras - MATA110
				cReturn	:= C7ObsAcent(&cVar)
			EndIf
		EndIf

	Else // Rotina comum
		If cVar == "M->C7_OBS" //Pedido de Compras - MATA121
			cReturn	:= C7ObsAcent(&cVar)
		EndIf
	EndIf
	
return cReturn


/*/{Protheus.doc} B1DSCAcent
	//TODO Remove acentos da descri��o.
	@author alison.goncalves
	@since 14/03/2018
	@version 1.0
	@return ${return}, ${return_description}
	@param cTexto, characters, descricao
	@type function
/*/
Static Function B1DSCAcent(cTexto)
	Default cTexto	:=	''

	cTexto := StrTran(cTexto,"�","A")                          
		cTexto := StrTran(cTexto,"�","A")
		cTexto := StrTran(cTexto,"�","A")
		cTexto := StrTran(cTexto,"�","A")
		cTexto := StrTran(cTexto,"�","A")
		cTexto := StrTran(cTexto,"�","A")
		cTexto := StrTran(cTexto,"�","A")
		cTexto := StrTran(cTexto,"�","A")
		cTexto := StrTran(cTexto,"�","O")
		cTexto := StrTran(cTexto,"�","O")
		cTexto := StrTran(cTexto,"�","O")
		cTexto := StrTran(cTexto,"�","O")
		cTexto := StrTran(cTexto,"�","O")
		cTexto := StrTran(cTexto,"�","O")
		cTexto := StrTran(cTexto,"�","U")
		cTexto := StrTran(cTexto,"�","U")
		cTexto := StrTran(cTexto,"�","U")
		cTexto := StrTran(cTexto,"�","U")
		cTexto := StrTran(cTexto,"�","I")
		cTexto := StrTran(cTexto,"�","I")
		cTexto := StrTran(cTexto,"�","C")
		cTexto := StrTran(cTexto,"�","C")
		cTexto := StrTran(cTexto,"�","E")
		cTexto := StrTran(cTexto,"�","E")
		cTexto := StrTran(cTexto,"�","E")
		cTexto := StrTran(cTexto,"�","E")
		cTexto := StrTran(cTexto,"?","")
		cTexto := StrTran(cTexto,"!","")
		cTexto := StrTran(cTexto,"*","")
		cTexto := StrTran(cTexto,"\","")
		cTexto := StrTran(cTexto,"'","")
		cTexto := StrTran(cTexto,'�',"")
		cTexto := StrTran(cTexto,'^',"")
		cTexto := StrTran(cTexto,'~',"")
		cTexto := StrTran(cTexto,';',"")
		cTexto := StrTran(cTexto,'#',"")
		cTexto := StrTran(cTexto,'$',"")
		cTexto := StrTran(cTexto,'�',"")
		cTexto := StrTran(cTexto,'&',"")
		cTexto := StrTran(cTexto,'_',"")
		cTexto := StrTran(cTexto,'|',"")
		cTexto := StrTran(cTexto,'�',"")
		cTexto := StrTran(cTexto,'�',"")
		cTexto := StrTran(cTexto,'�',"")
		cTexto := StrTran(cTexto,'<',"")
		cTexto := StrTran(cTexto,'>',"")

Return cTexto

/*/{Protheus.doc} B1CODAcent
	//TODO Remove os acentos do campo descri��o do B1_CODE
	@author alison.goncalves
	@since 05/03/2018
	@version 1.0
	@return Sem retorno
	@type function
/*/

Static function B1CODAcent(cTexto)
	Default cTexto := ''
		
		cTexto := StrTran(cTexto,"�","A")
		cTexto := StrTran(cTexto,"�","A")
		cTexto := StrTran(cTexto,"�","A")
		cTexto := StrTran(cTexto,"�","A")
		cTexto := StrTran(cTexto,"�","A")
		cTexto := StrTran(cTexto,"�","A")
		cTexto := StrTran(cTexto,"�","A")
		cTexto := StrTran(cTexto,"�","A")
		cTexto := StrTran(cTexto,"�","O")
		cTexto := StrTran(cTexto,"�","O")
		cTexto := StrTran(cTexto,"�","O")
		cTexto := StrTran(cTexto,"�","O")
		cTexto := StrTran(cTexto,"�","O")
		cTexto := StrTran(cTexto,"�","O")
		cTexto := StrTran(cTexto,"�","U")
		cTexto := StrTran(cTexto,"�","U")
		cTexto := StrTran(cTexto,"�","U")
		cTexto := StrTran(cTexto,"�","U")
		cTexto := StrTran(cTexto,"�","I")
		cTexto := StrTran(cTexto,"�","I")
		cTexto := StrTran(cTexto,"�","C")
		cTexto := StrTran(cTexto,"�","C")
		cTexto := StrTran(cTexto,"�","E")
		cTexto := StrTran(cTexto,"�","E")
		cTexto := StrTran(cTexto,"�","E")
		cTexto := StrTran(cTexto,"�","E")
		cTexto := StrTran(cTexto,".","")
		cTexto := StrTran(cTexto,"?","")
		cTexto := StrTran(cTexto,"!","")
		cTexto := StrTran(cTexto,"�","")
		cTexto := StrTran(cTexto,"�","")
		cTexto := StrTran(cTexto,"*","")
		cTexto := StrTran(cTexto,"/","")
		cTexto := StrTran(cTexto,"\","")
		cTexto := StrTran(cTexto,"'","")
		cTexto := StrTran(cTexto,'"',"")
		cTexto := StrTran(cTexto,'�',"")
		cTexto := StrTran(cTexto,'^',"")
		cTexto := StrTran(cTexto,'~',"")
		cTexto := StrTran(cTexto,'{',"")
		cTexto := StrTran(cTexto,'}',"")
		cTexto := StrTran(cTexto,'(',"")
		cTexto := StrTran(cTexto,')',"")
		cTexto := StrTran(cTexto,'[',"")
		cTexto := StrTran(cTexto,']',"")
		cTexto := StrTran(cTexto,',',"")
		cTexto := StrTran(cTexto,';',"")
		cTexto := StrTran(cTexto,'#',"")
		cTexto := StrTran(cTexto,'$',"")
		cTexto := StrTran(cTexto,'%',"")
		cTexto := StrTran(cTexto,'�',"")
		cTexto := StrTran(cTexto,'&',"")
		cTexto := StrTran(cTexto,'+',"")
		//cTexto := StrTran(cTexto,'-',"") //este aqui pois tem protudos que cont�m hifen no seu c�digo
		cTexto := StrTran(cTexto,'_',"")
		cTexto := StrTran(cTexto,'|',"")
		cTexto := StrTran(cTexto,':',"")
		cTexto := StrTran(cTexto,'=',"")
		cTexto := StrTran(cTexto,'�',"")
		cTexto := StrTran(cTexto,'�',"")
		cTexto := StrTran(cTexto,'�',"")
		cTexto := StrTran(cTexto,'<',"")
		cTexto := StrTran(cTexto,'>',"")

Return cTexto

/*/{Protheus.doc} C7_ObsAcent
	//TODO remove os acentos da observa��o do pedido / solicita��o de compra
	@author alison.goncalves
	@since 14/03/2018
	@version 1.0
	@return ${return}, ${return_description}
	@param cTexto, characters, descricao
	@type function
/*/

Static function C7ObsAcent(cTexto)
	Default cTexto := ''
		
		cTexto := StrTran(cTexto,"'","")
		cTexto := StrTran(cTexto,'"',"")
		cTexto := StrTran(cTexto,';',"")

Return cTexto
