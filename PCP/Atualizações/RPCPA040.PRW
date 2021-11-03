#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} RPCPA040
//TODO Descrição: Ajusta empenho da chapa de acordo com peso do software de corte da chapa.
@author Victor Dessunte
@since 07/14/2016
@version 1.0
@return NIL
@type function
/*/
User Function RPCPA040()
Local aFldSX3			:= FWSX3Util():GetAllFields("SD4",.F.)
Local	_lSair			:= .F.
Local 	_nX				:= 0
Private 	_cCodPrd	:= ""
Private 	_oDlg		:= Nil
Private 	_oGet1		:= Nil
Private 	_oGet2		:= Nil
Private 	_oGet3		:= Nil
Private 	_nGet1		:= 0
Private 	_nGet2		:= 0
Private 	_cGet3		:= SPACE(11)
Private 	_oMsNewGet	:= Nil
Private 	_aFields	:= {"D4_OP","D4_COD","D4_QUANT","D4_QTDEORI"}
Private 	_aHeader	:= {}
Private _aFieldFill		:= {}
Private _aCols			:= {}
lMsErroAuto 			:= .F.

While !_lSair
	_nX			:= 0
	_cCodPrd	:= ""
	_oDlg		:= Nil
	_oGet1		:= Nil
	_oGet2		:= Nil
	_oGet3		:= Nil
	_nGet1		:= 0
	_nGet2		:= 0
	_cGet3		:= SPACE(11)
	_oMsNewGet	:= Nil
	_aFields	:= {"D4_OP","D4_COD","D4_QUANT","D4_QTDEORI"}
	_aHeader	:= {}
	_aFieldFill	:= {}
	_aCols		:= {}
	lMsErroAuto := .F.
	
	//DEFINE PROPRIEDADES AFIELD
/*	
	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	For _nX := 1 To Len(_aFields)
		IF SX3->(dbSeek(_aFields[_nX]))
			AADD(_aHeader,{	AllTrim(X3TITULO())		,;
									ALLTRIM(SX3->X3_CAMPO)	,;
									SX3->X3_PICTURE			,;
									SX3->X3_TAMANHO			,;
									SX3->X3_DECIMAL			,;
									'ALLWAYSTRUE'	 			})
		EndIf
	Next _nX
*/
	For _nX := 1 To Len(aFldSX3)
		If aScan(_aFields, aFldSX3[_nX]) > 0
			AADD(_aHeader,{ RetTitle(aFldSX3[_nX]), aFldSX3[_nX], PesqPict('SD4',aFldSX3[_nX]), TamSX3(aFldSX3[_nX])[1], TamSX3(aFldSX3[_nX])[2] })
			AADD(_aFieldFill, CRIAVAR(aFldSX3[_nX],.F.))
		Endif
	Next _nX

	AADD(_aFieldFill, .F.)
	AADD(_aCols,_aFieldFill)
	
	DEFINE MSDIALOG _oDlg FROM 000,000 TO 430,550 PIXEL OF TITLE "Ajusta empenho de Chapa"
	
	@ 010,010 SAY "Peso calculado" 	SIZE 100,008 PIXEL OF _oDlg
	@ 020,010 SAY "pelo software"		SIZE 100,008 PIXEL OF _oDlg
	@ 030,010 SAY "de corte"			SIZE 100,008 PIXEL OF _oDlg
	
	@ 012,075 GET _oGet1 VAR _nGet1 	SIZE 040,010 PIXEL OF _oDlg PICTURE "999,999.999" VALID U_RPC40A(1)
	
	@ 014,140 SAY "Qtd. Empenhada:" 	SIZE 070,008 PIXEL OF _oDlg
	@ 012,185 GET _oGet2 VAR _nGet2	SIZE 040,010 PIXEL OF _oDlg WHEN .F. PICTURE "999,999.999"
	
	@ 050,010 SAY "OP:" 					SIZE 070,008 PIXEL OF _oDlg
	@ 048,060 GET _oGet3 VAR _cGet3	SIZE 100,010 PIXEL OF _oDlg VALID ValidaOP()
	
	_oMsNewGet1 := MsNewGetDados():New(070,010,190,270,1+GD_DELETE,"ALLWAYSTRUE","ALLWAYSTRUE",,,0,99,"ALLWAYSTRUE","ALLWAYSTRUE","U_RPC40A(2)",_oDlg,_aHeader,_aCols)
	
	DEFINE SBUTTON FROM 200,245 TYPE 1 ACTION (LjMsgRun("Efetuando alteração de empenho... ",,{||RPC40B()}),_oDlg:End()) ENABLE OF _oDlg
	DEFINE SBUTTON FROM 200,210 TYPE 2 ACTION (_lSair := .T.,_oDlg:End()) ENABLE OF _oDlg
	
	ACTIVATE MSDIALOG _oDlg CENTERED
EndDo

Return

/*/{Protheus.doc} ValidaOP
//TODO Descrição: Valida ordem de producao digitada.
@author Victor Dessunte
@since 07/15/2016
@version 1.0
@return _lRet
@type Static function
/*/
Static Function ValidaOP()

Local _nX

Local _cQry 	:= ""
Local _lRet 	:= IIF(Empty(_cGet3),.T.,.F.)
Local _nCoef	:= 0

If _nGet1 <= 0
	MsgStop("Digite um peso valido para a chapa!")
	_cGet3 := Space(11)
	_oGet3:Refresh()
	
	_oGet1:SetFocus()
	Return .T.
EndIf

dbSelectArea("SC2")
SC2->(dbSetOrder(1))
If SC2->(dbSeek(xFilial("SC2")+_cGet3))
	_cQry := " SELECT															" + CRLF
	_cQry += "		D4_QUANT,D4_COD										" + CRLF
	_cQry += " FROM															" + CRLF
	_cQry += 		RetSqlName("SD4")
	_cQry += " WHERE															" + CRLF
	_cQry += "		D_E_L_E_T_ 					= ' '						" + CRLF
	_cQry += " AND	D4_OP 						= '" + _cGet3 + "'	" + CRLF
	_cQry += " AND	SUBSTRING(D4_COD,1,4) 	= 'MP01'					" + CRLF
	_cQry += " AND	D4_QUANT 					> 0						"
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	
	TCQUERY _cQry NEW ALIAS "TRB"
	
	TRB->(dbGoTop())
	If TRB->(!EOF())
		_nQuant 	:= TRB->D4_QUANT
		If Empty(_cCodPrd)
			_cCodPrd := TRB->D4_COD
		Else
			If _cCodPrd <> TRB->D4_COD
				_cProd 	:= TRB->D4_COD
				_cMsg := "Códigos das chapas divergentes, deseja alterar o empenho da OP?" + CRLF + CRLF
				_cMsg += "Código da chapa corrente: " + CRLF
				_cMsg += _cCodPrd + "- " + POSICIONE("SB1",1,xFilial("SB1")+_cCodPrd,"B1_DESC") + CRLF + CRLF
				_cMsg += "Código da chapa empenhado: " + CRLF
				_cMsg += TRB->D4_COD + "- " + POSICIONE("SB1",1,xFilial("SB1")+TRB->D4_COD,"B1_DESC")
				
				If MsgYesNo(_cMsg)
					Begin Transaction
					LjMsgRun("Efetuando inclusão de empenho... ",,{||RPC40D(_cCodPrd,_cGet3,_nQuant)})
					If !lMsErroAuto
						LjMsgRun("Efetuando exclusão de empenho... ",,{||RPC40C(_cProd,_cGet3)})
					EndIf
					End Transaction
				Else
					If Select("TRB") > 0
						TRB->(dbCloseArea())
					EndIf
					Return .F.
				EndIf
			Else
				If aScan(_aCols,{|x|x[1]==_cGet3}) > 0
					MsgStop("Ordem de produção já adicionada!")
					If Select("TRB") > 0
						TRB->(dbCloseArea())
					EndIf
					Return .F.
				EndIf
			EndIf
		EndIf

		If Empty(SC2->C2_DATRF)
			If Empty(_aCols[1,1])
				_aCols := {{_cGet3,SC2->C2_PRODUTO,_nQuant,0,.F.}}
			Else
				AADD(_aCols,{_cGet3,SC2->C2_PRODUTO,_nQuant,0,.F.})
			EndIf
			
			_nGet2 := _nGet2 + _nQuant
			
			//Ajusta empenho de acordo com o coeficiente entre peso do software e empenho
			_nCoef := (_nGet1/_nGet2)
			For _nX:=1 To Len(_aCols)
				If !_aCols[_nX,5]
					_aCols[_nX,4] := _aCols[_nX,3] * _nCoef
				EndIf
			Next _nX
			
			_oMsNewGet1:ACOLS := _aCols
			_oMsNewGet1:OBROWSE:REFRESH()
			_oMsNewGet1:FORCEREFRESH()
			
			_cGet3 := Space(11)
			_oGet3:cCaption := _cGet3
			_oGet3:Refresh()
			_oGet3:SetFocus()
					
			_lRet := .T.
		Else
			MsgStop("Ordem de produção já finalizada!")
		EndIf
	Else
		MsgStop("Empenho já baixado ou inexistente!")
	EndIf
EndIf

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
Return _lRet

/*/{Protheus.doc} RPC40A
//TODO Descrição: Valida peso digitado e linhas deletadas no acols.
@author Victor Dessunte
@since 07/18/2016
@version 1.0
@return .T.
@param _nTp, descricao: variável com o peso da chapa
@type function
/*/
User Function RPC40A(_nTp)

Local _nX

If _nTp == 2
	If !_oMsNewGet1:ACOLS[_oMsNewGet1:nAt,5]
		_nGet2 := _nGet2 - _oMsNewGet1:ACOLS[_oMsNewGet1:nAt,3]
	Else
		_nGet2 := _nGet2 + _oMsNewGet1:ACOLS[_oMsNewGet1:nAt,3]
	EndIf
EndIf

//Ajusta empenho de acordo com o coeficiente entre peso do software e empenho
_nCoef := (_nGet1/_nGet2)
For _nX:=1 To Len(_oMsNewGet1:ACOLS)
	If _nTp == 1
		If !_oMsNewGet1:ACOLS[_nX,5]
			_oMsNewGet1:ACOLS[_nX,4] := _oMsNewGet1:ACOLS[_nX,3] * _nCoef
		EndIf
	Else
		If _nX <> _oMsNewGet1:nAt .AND. !_oMsNewGet1:ACOLS[_nX,5]
			_oMsNewGet1:ACOLS[_nX,4] := _oMsNewGet1:ACOLS[_nX,3] * _nCoef
		ElseIf _oMsNewGet1:ACOLS[_nX,5] .AND. _nX == _oMsNewGet1:nAt
			_oMsNewGet1:ACOLS[_nX,4] := _oMsNewGet1:ACOLS[_nX,3] * _nCoef
		EndIf
	EndIf
Next _nX

_oMsNewGet1:OBROWSE:REFRESH()
_oMsNewGet1:FORCEREFRESH()

_cGet3 := Space(11)
_oGet3:Refresh()
_oGet3:SetFocus()

Return .T.

/*/{Protheus.doc} RPC40B
//TODO Descrição: Grava informacoes no empenho das op's.
@author Victor Dessunte
@since 07/18/2016
@version 1.0
@return NIL
@type Static function
/*/
Static Function RPC40B()

Local _aVetor	:= {}
Local _cLocProd := ""
Local _nX

lMsErroAuto := .F.

dbSelectArea("SD4")
SD4->(dbSetOrder(1))
For _nX:=1 To Len(_oMsNewGet1:ACOLS)
	If !_oMsNewGet1:ACOLS[_nX,5]
		If SD4->(dbSeek(xFilial("SD4")+_cCodPrd+_oMsNewGet1:ACOLS[_nX,1]))
			_cLocProd := GetAdvFVal("SB1","B1_LOCPAD",xFilial("SB1")+_cCodPrd,1,"01")
			If _nGet1 < _nGet2
				_aVetor:={	{"D4_COD"     ,_cCodPrd							,Nil},; //01-CODIGO DO PRODUTO
							{"D4_LOCAL"   ,_cLocProd						,Nil},; //02-ALMOXARIFADO
				            {"D4_DATA"    ,SD4->D4_DATA						,Nil},; //03-DATA DO EMPENHO
							{"D4_OP"      ,SD4->D4_OP						,Nil},; //04-ORDEM DE PRODUCAO
							{"D4_QUANT"   ,_oMsNewGet1:ACOLS[_nX,4]			,Nil},; //06-SALDO DO EMPENHO
							{"D4_QTDEORI" ,_oMsNewGet1:ACOLS[_nX,4]			,Nil},; //05-QUANTIDADE ORIGINAL
							{"D4_TRT"     ,SD4->D4_TRT						,Nil},; //07-TRT
							{"D4_QTSEGUM" ,0								,Nil} } //08-QUANTIDADE NA SEGUNDA UNIDADE DE MEDIDA
			Else
				_aVetor:={	{"D4_COD"     ,_cCodPrd							,Nil},; //01-CODIGO DO PRODUTO
							{"D4_LOCAL"   ,_cLocProd						,Nil},; //02-ALMOXARIFADO
				            {"D4_DATA"    ,SD4->D4_DATA						,Nil},; //03-DATA DO EMPENHO
							{"D4_OP"      ,SD4->D4_OP						,Nil},; //04-ORDEM DE PRODUCAO
							{"D4_QTDEORI" ,_oMsNewGet1:ACOLS[_nX,4]			,Nil},; //05-QUANTIDADE ORIGINAL
							{"D4_QUANT"   ,_oMsNewGet1:ACOLS[_nX,4]			,Nil},; //06-SALDO DO EMPENHO
							{"D4_TRT"     ,SD4->D4_TRT						,Nil},; //07-TRT
							{"D4_QTSEGUM" ,0								,Nil} } //08-QUANTIDADE NA SEGUNDA UNIDADE DE MEDIDA
			EndIf
			
			MSExecAuto({|x,y| MATA380(x,y)},_aVetor,4)
			
			If lMsErroAuto
			    MostraErro()
			EndIf
		EndIf
	EndIf
Next _nX

Return

/*/{Protheus.doc} RPC40C
//TODO Descrição: Exclui empenho da materia prima.
@author Victor Dessunte
@since 07/19/2016
@version 1.0
@return NIL
@param _cCod, , descricao: produto a ser excluído
@param _cOp, , descricao: OP a ser eliminado o empenho
@type Static function
/*/
Static Function RPC40C(_cCod,_cOp)

Local _aVetor	:= {}
lMsErroAuto := .F.

dbSelectArea("SD4")
SD4->(dbSetOrder(1))
If SD4->(dbSeek(xFilial("SD4")+_cCod+_cOp))
	RecLock("SD4",.F.)
	SD4->(dbDelete())
	SD4->(MsUnlock())
EndIf

Return

/*/{Protheus.doc} RPC40D
//TODO Descrição: Inclui empenho da materia prima.
@author Victor Dessunte
@since 07/19/2016
@version 1.0
@return NIL
@param _cCod, , descricao: código do produto a incluir
@param _cOp, , descricao: OP a incluir
@param _nQuant, , descricao: Quantidade de M.P. a incluir
@type Static function
/*/
Static Function RPC40D(_cCod,_cOp,_nQuant)

Local _aVetor	:= {}
Local cLocProd	:= ""
lMsErroAuto := .F.

cLocProd := GetAdvFVal("SB1","B1_LOCPAD",xFilial("SB1")+_cCod,1,"01")
_aVetor:={	{"D4_FILIAL"	,'01'		,Nil},;//01-FILIAL
			{"D4_COD"		,_cCod		,Nil},;//02-CODIGO DO PRODUTO
			{"D4_LOCAL"		,cLocProd	,Nil},;//03-ALMOXARIFADO
            {"D4_DATA"		,dDataBase	,Nil},;//04-DATA DO EMPENHO
			{"D4_OP"		,_cOp		,Nil},;//05-ORDEM DE PRODUCAO
			{"D4_QTDEORI"	,_nQuant	,Nil},;//06-QUANTIDADE ORIGINAL
			{"D4_QUANT"		,_nQuant	,Nil},;//07-SALDO DO EMPENHO
			{"D4_TRT"		,"001"		,Nil},;//08-TRT
			{"D4_QTSEGUM"	,0			,Nil} }//09-QUANTIDADE NA SEGUNDA UNIDADE DE MEDIDA

MSExecAuto({|x,y| MATA380(x,y)},_aVetor,3)

If lMsErroAuto
    MostraErro()
EndIf

Return
