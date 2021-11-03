#Include "protheus.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} Rfata049
	//TODO Convertido fonte já existente para objeto. 
	@author Alison Gonçalves
	@since 05/07/11
	@version 1.0
	@return cTexto
	@type User function
/*/
User Function Rfata049()
	Local cVar		:= ReadVar()
	local oMdl   := nil 
	local oMaster:= nil 
	Local cReturn:=	''
	
	oMdl := fwModelActive()
	If oMdl <> nil
		oMaster := oMdl:getModel(oMdl:aModelStruct[1][2])
		if oMaster <> nil 
			If cVar=="M->B1_COD"
				oMaster:loadValue(Substr(cVar,4,10), B1CODAcent(&cVar))
			ElseIf cVar == "M->B1_DESC"	
				oMaster:loadValue(Substr(cVar,4,10), B1DSCAcent(&cVar))	
			EndIf
		EndIf
	Else
		If cVar == "M->C7_OBS"	 
				cReturn	:= C7ObsAcent(&cVar)
		ElseIf cVar == "M->C1_OBS"	
				cReturn	:= C7ObsAcent(&cVar)
		EndIf
	EndIF	
	
return cReturn


/*/{Protheus.doc} B1DSCAcent
	//TODO Remove acentos da descrição.
	@author alison.goncalves
	@since 14/03/2018
	@version 1.0
	@return ${return}, ${return_description}
	@param cTexto, characters, descricao
	@type function
/*/
Static Function B1DSCAcent(cTexto)
	Default cTexto	:=	''

	cTexto := StrTran(cTexto,"Ã","A")                          
		cTexto := StrTran(cTexto,"ã","A")
		cTexto := StrTran(cTexto,"Á","A")
		cTexto := StrTran(cTexto,"á","A")
		cTexto := StrTran(cTexto,"Â","A")
		cTexto := StrTran(cTexto,"â","A")
		cTexto := StrTran(cTexto,"À","A")
		cTexto := StrTran(cTexto,"à","A")
		cTexto := StrTran(cTexto,"Ô","O")
		cTexto := StrTran(cTexto,"ô","O")
		cTexto := StrTran(cTexto,"Ó","O")
		cTexto := StrTran(cTexto,"ó","O")
		cTexto := StrTran(cTexto,"Õ","O")
		cTexto := StrTran(cTexto,"õ","O")
		cTexto := StrTran(cTexto,"Ú","U")
		cTexto := StrTran(cTexto,"ú","U")
		cTexto := StrTran(cTexto,"Ü","U")
		cTexto := StrTran(cTexto,"ü","U")
		cTexto := StrTran(cTexto,"Í","I")
		cTexto := StrTran(cTexto,"í","I")
		cTexto := StrTran(cTexto,"Ç","C")
		cTexto := StrTran(cTexto,"ç","C")
		cTexto := StrTran(cTexto,"É","E")
		cTexto := StrTran(cTexto,"é","E")
		cTexto := StrTran(cTexto,"Ê","E")
		cTexto := StrTran(cTexto,"ê","E")
		cTexto := StrTran(cTexto,"?","")
		cTexto := StrTran(cTexto,"!","")
		cTexto := StrTran(cTexto,"*","")
		cTexto := StrTran(cTexto,"\","")
		cTexto := StrTran(cTexto,"'","")
		cTexto := StrTran(cTexto,'´',"")
		cTexto := StrTran(cTexto,'^',"")
		cTexto := StrTran(cTexto,'~',"")
		cTexto := StrTran(cTexto,';',"")
		cTexto := StrTran(cTexto,'#',"")
		cTexto := StrTran(cTexto,'$',"")
		cTexto := StrTran(cTexto,'¨',"")
		cTexto := StrTran(cTexto,'&',"")
		cTexto := StrTran(cTexto,'_',"")
		cTexto := StrTran(cTexto,'|',"")
		cTexto := StrTran(cTexto,'§',"")
		cTexto := StrTran(cTexto,'¬',"")
		cTexto := StrTran(cTexto,'¢',"")
		cTexto := StrTran(cTexto,'<',"")
		cTexto := StrTran(cTexto,'>',"")

Return cTexto

/*/{Protheus.doc} B1CODAcent
	//TODO Remove os acentos do campo descrição do B1_CODE
	@author alison.goncalves
	@since 05/03/2018
	@version 1.0
	@return Sem retorno
	@type function
/*/

Static function B1CODAcent(cTexto)
	Default cTexto := ''
		
		cTexto := StrTran(cTexto,"Ã","A")
		cTexto := StrTran(cTexto,"ã","A")
		cTexto := StrTran(cTexto,"Á","A")
		cTexto := StrTran(cTexto,"á","A")
		cTexto := StrTran(cTexto,"Â","A")
		cTexto := StrTran(cTexto,"â","A")
		cTexto := StrTran(cTexto,"À","A")
		cTexto := StrTran(cTexto,"à","A")
		cTexto := StrTran(cTexto,"Ô","O")
		cTexto := StrTran(cTexto,"ô","O")
		cTexto := StrTran(cTexto,"Ó","O")
		cTexto := StrTran(cTexto,"ó","O")
		cTexto := StrTran(cTexto,"Õ","O")
		cTexto := StrTran(cTexto,"õ","O")
		cTexto := StrTran(cTexto,"Ú","U")
		cTexto := StrTran(cTexto,"ú","U")
		cTexto := StrTran(cTexto,"Ü","U")
		cTexto := StrTran(cTexto,"ü","U")
		cTexto := StrTran(cTexto,"Í","I")
		cTexto := StrTran(cTexto,"í","I")
		cTexto := StrTran(cTexto,"Ç","C")
		cTexto := StrTran(cTexto,"ç","C")
		cTexto := StrTran(cTexto,"É","E")
		cTexto := StrTran(cTexto,"é","E")
		cTexto := StrTran(cTexto,"Ê","E")
		cTexto := StrTran(cTexto,"ê","E")
		cTexto := StrTran(cTexto,".","")
		cTexto := StrTran(cTexto,"?","")
		cTexto := StrTran(cTexto,"!","")
		cTexto := StrTran(cTexto,"º","")
		cTexto := StrTran(cTexto,"ª","")
		cTexto := StrTran(cTexto,"*","")
		cTexto := StrTran(cTexto,"/","")
		cTexto := StrTran(cTexto,"\","")
		cTexto := StrTran(cTexto,"'","")
		cTexto := StrTran(cTexto,'"',"")
		cTexto := StrTran(cTexto,'´',"")
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
		cTexto := StrTran(cTexto,'¨',"")
		cTexto := StrTran(cTexto,'&',"")
		cTexto := StrTran(cTexto,'+',"")
		//cTexto := StrTran(cTexto,'-',"") //este aqui pois tem protudos que contém hifen no seu código
		cTexto := StrTran(cTexto,'_',"")
		cTexto := StrTran(cTexto,'|',"")
		cTexto := StrTran(cTexto,':',"")
		cTexto := StrTran(cTexto,'=',"")
		cTexto := StrTran(cTexto,'§',"")
		cTexto := StrTran(cTexto,'¬',"")
		cTexto := StrTran(cTexto,'¢',"")
		cTexto := StrTran(cTexto,'<',"")
		cTexto := StrTran(cTexto,'>',"")

Return cTexto

/*/{Protheus.doc} C7_ObsAcent
	//TODO remove os acentos da observação do pedido / solicitação de compra
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
