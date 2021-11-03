#include "protheus.ch"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATA073  บAutor  ณIvandro Santos      บ Data ณ  16/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma elaborado para importar arquivo tipo CSV gerado porบฑฑ
ฑฑบ          ณMacro da DS e preencher a tabela SZJ                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack - Comercial                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRevisใo   ณ 27/06/17 - Inclusใo da fun็ใo para exportar arquivo CSV    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RFATA073()
Static cArq 		:= ""
//Ivandro Santos - 24/05/17 - Inํcio da altera็ใo
//Ticket#2017051937000071 — IMPORTAR DADOS DS
//Ivandro Santos - Inํcio da altera็ใo
//Ticket#2017050337000126 — PLANILHA BINARIA 
//Local _lHabExc:= .T.

Static _cNumOrc	:= ""
Static cItem	:= "01"
Static _cModEmb := ""
Static _cMatEmb	:= ""
//Ticket#2017050337000126 — T้rmino da altera็ใo
Private cPerg  	:= "XPCPA37"
Private cPerg1 	:= "XRFATR050"
Private cPerg2 	:= "XFATR070"
Private _lHabExc:= .T.
//Ticket#2017051937000071 — Fim da altera็ใo
Private nLastKey:= 0
Private _lRet   := .T.
Private cArq	:= ""


//Altera็ใo feita para selecionar se serแ importado a DS ou exportado arquivo para atualizar o contrato
If ApMsgYesNo("Importa DS?")
	_lRet := Pergunte(cPerg1,.T.)
	_cNumOrc:= MV_PAR01
	_nIdioma:= MV_PAR02
	_lRet := Pergunte(cPerg,.T.)
	cArq 	:= MV_PAR01
Else
	_lRet := Pergunte(cPerg2,.T.)
	_cNumOrc:= Alltrim(MV_PAR01)
	
Endif

If LastKey() == 27 .Or. nLastKey == 27 .Or. !_lRet
	ApMsgAlert("Cancelado pelo usuแrio")
	Return
Endif

If !Empty(cArq)
	MsAguarde({|| RF73DSNA() }, OemToAnsi("Imortando dados, DS") )
Else
	MsAguarde({|| RF73DSEX() }, OemToAnsi("Exportando Dados, DS") )
Endif

Return


/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHฟ
//ณFun็ใo: RF73DSNA                                            ณ
//ณAutor: Ivandro Santos - Data: 27/06/17                      ณ
//ณGerar a query para incluir ou alterar os dados na tabela SZJณ
//ณDescritivo dos produtos                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHู
*/
Static Function RF73DSNA()

If !File(cArq)
	MsgStop("O arquivo " +cArq + " nใo foi encontrado. A importa็ใo serแ abortada!"," - ATENCAO")
	Return
EndIf

FT_FUSE(cArq)
nPos:= FT_FLASTREC()
FT_FGOTOP()
While !FT_FEOF()
	cLinha := FT_FREADLN()
	If cLinha == "        " .OR. cLinha = NIL
		ALERT("Fim de arquivo!")
		FT_FUSE()
		Return
	EndIf
	lOK := .F.
	aCampos := StrToKArr2(cLinha,",",.T.)
	DbSelectArea("SZJ")
	DbSetOrder(1)
	//Ivandro Santos - Inํcio da altera็ใo
	//Ticket#2017050337000126 — PLANILHA BINARIA
	If aCampos[1] <> "Nome Fantasia" .And. _lHabExc
		SZJ->(DbGoTop())
		While !SZJ->(EOF()) .And. SZJ->(dbSeek(xFilial("SZJ")+_cNumOrc))
			_lHabExc := .F.
			Begin Transaction
			RecLock("SZJ",.F.)
			SZJ->(DbDelete())
			SZJ->(MsUnLock())
			End Transaction
			SZJ->(DbSkip())
		Enddo
		MSRFATA73()
	ElseIf !SZJ->(dbSeek(xFilial("SZJ")+_cNumOrc+cItem)) .And. aCampos[1] <> "Nome Fantasia"
		MSRFATA73()
	Endif
	aCampos := {}
	FT_FSKIP()
	SZJ->(DbCloseArea())
EndDo


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMSRFATA73 บAutor  ณIvandro Santos      บ Data ณ  04/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma para incluir os dados do arquivo importado         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RFATA073                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MSRFATA73()

		_cQry := "select X5_CHAVE AS CHAVE from "+RetSQLName("SX5")+" WHERE X5_TABELA = 'Z2' AND D_E_L_E_T_ ='' and X5_DESCRI = '"+Alltrim(aCampos[7])+"'
		If Select("TSQL") > 0
			dbSelectArea("TSQL")
			DbCloseArea()
		EndIf
	
		//* Cria a Query e da Um Apelido
		TCQUERY _cQry NEW ALIAS "TSQL"
	
		dbSelectArea("TSQL")
		TSQL->(dbGotop())
		While TSQL->(!EOF())
			_cModEmb := TSQL->CHAVE    
			TSQL->(dbSkip())
		Enddo
		TSQL->(DbCloseArea())
		
		_cQry1 := "select X5_CHAVE AS CHAVE from "+RetSQLName("SX5")+" WHERE X5_TABELA = 'Z6' AND D_E_L_E_T_ ='' and X5_DESCRI = '"+Alltrim(aCampos[10])+"'
		If Select("ZJSQL") > 0
			dbSelectArea("ZJSQL")
			DbCloseArea()
		EndIf
	
		//* Cria a Query e da Um Apelido
		TCQUERY _cQry1 NEW ALIAS "ZJSQL"
	
		dbSelectArea("ZJSQL")
		ZJSQL->(dbGotop())
		While ZJSQL->(!EOF())
			_cMatEmb := ZJSQL->CHAVE    
			ZJSQL->(dbSkip())
		Enddo
		ZJSQL->(DbCloseArea())
		
		Begin Transaction
		RecLock("SZJ",.T.)
		SZJ->ZJ_FILIAL 	:= xFilial("SZJ")
		SZJ->ZJ_NUM		:= _cNumOrc
		SZJ->ZJ_ITEM	:= cItem
		SZJ->ZJ_PRODUTO := Alltrim(aCampos[2])
		SZJ->ZJ_FPROD 	:= aCampos[3]
		SZJ->ZJ_DIMENSA	:= aCampos[4]
		SZJ->ZJ_EMPACOT	:= Substr(aCampos[5],1,1)
		SZJ->ZJ_PESOVOL	:= Alltrim(aCampos[6])
		SZJ->ZJ_MODEMB	:= _cModEmb
		SZJ->ZJ_DIMEMB	:= Alltrim(aCampos[8])
		SZJ->ZJ_PASSO	:= Alltrim(aCampos[9])
		SZJ->ZJ_MATEMB	:= _cMatEmb
		SZJ->ZJ_FALIM	:= Alltrim(aCampos[11])
		SZJ->ZJ_DIMALIM	:= Alltrim(aCampos[12])
		SZJ->ZJ_FILLARG	:= Alltrim(aCampos[13])
		SZJ->ZJ_FILMIN	:= Alltrim(aCampos[14])
		SZJ->ZJ_RENDESP	:= Alltrim(aCampos[15])
		SZJ->(MsUnLock())
		End Transaction
		cItem := Soma1(cItem)
		//Ticket#2017051937000071 — IMPORTAR DADOS DS
		_lHabExc := .F.                                
		////Ticket#2017051937000071 — Fim da altera็ใo
Return
//Ticket#2017050337000126 — Fim da altera็ใo

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHฟ
//ณFun็ใo: RF73DSEX                                            ณ
//ณAutor: Ivandro Santos - Data: 27/06/17                      ณ
//ณFun็ใo para exportar dados da tabela SZG quando hแ revisใo  ณ
//ณdos or็amentos e o Departamento Comercial precisa copiar as ณ
//ณinforma็๕es para o novo or็amento a enviar para o cliente e ณ
//ณnใo tem cadastro dos produtos no Microsiga                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHู
*/
Static Function RF73DSEX()
Local cCaminho 	:= "C:\RELATO_MICROSIGA\DS_EXPORTA.CSV"
Local cNomTrb	:= FCreate(cCaminho,0)
Local _nD                
Local oExcel	:= FWMSEXCEL():New()

If Select("TSQL") > 0
    dbSelectArea("TSQL")
    TSQL->(DbCloseArea())
Endif

_cQuery := "SELECT CJ_ORCAM,CK_NUM,CK_ITEM,ZG_CODIGO,ZG_MSDESC, "+CRLF
_cQuery += "ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),ZG_DESCPOR)),'') AS 'DESPOR', "+CRLF
_cQuery += "ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),ZG_DESCESP)),'') AS 'DESCES', "+CRLF
_cQuery += "ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),ZG_DESCING)),'') AS 'DESCIN'  "+CRLF
_cQuery += "FROM "+RetSQLName("SCK")+" CK "+CRLF
_cQuery += "INNER JOIN "+RetSQLName("SCJ")+" CJ ON CJ_NUM = CK_NUM AND CJ.D_E_L_E_T_ = '' AND CJ_FILIAL = '"+xFilial("SCJ")+"' "+CRLF
_cQuery += " LEFT JOIN "+RetSQLName("SZG")+" ZG ON ZG_CODIGO = CK_PRODUTO AND ZG.D_E_L_E_T_ = '' AND ZG_FILIAL = '"+xFilial("SZG")+"' "+CRLF
_cQuery += "WHERE CJ_ORCAM = '"+_cNumOrc+"' AND CK.D_E_L_E_T_ = '' AND CK_FILIAL = '"+xFilial("SCK")+"' "

TcQuery _cQuery New Alias "TSQL"

_clinha := "MBE;ORCAMENTO;ITEM;Produto;Desc_Produto;"+IIF(MV_PAR02==1,"DESCRITIVO_POR",IIF(MV_PAR02==3,"DESCRITIVO_ESP","DESCRITIVO_IN"))+""

FWrite(cNomTrb,_cLinha)

DbSelectArea("SZG")
SZG->(DbSetOrder(1))
While TSQL->(!EOF())
	 If MV_PAR02 == 1
		_cDESC := TSQL->DESPOR
		_cDESC := Alltrim(StrTran(_cDESC,Chr(12),""))
		_cDESC := Alltrim(StrTran(_cDESC,Chr(13),"!@# "))
		_cDESC := Alltrim(StrTran(_cDESC,Chr(10),""))
	ElseIf MV_PAR02 == 3
		_cDESC := TSQL->DESCES
		_cDESC := Alltrim(StrTran(_cDESC,Chr(12),""))
		_cDESC := Alltrim(StrTran(_cDESC,Chr(13),"!@# "))
		_cDESC := Alltrim(StrTran(_cDESC,Chr(10),""))
	ElseIf MV_PAR02 == 4
		_cDESC := TSQL->DESCIN
		_cDESC := Alltrim(StrTran(_cDESC,Chr(12),""))
		_cDESC := Alltrim(StrTran(_cDESC,Chr(13),"!@# "))
		_cDESC := Alltrim(StrTran(_cDESC,Chr(10),""))
	Endif
	nPos := AT("!@# ",_cDESC)
	If nPos > 0
		_aDesc  := StrToKArr2(_cDESC,"!@# ",.T.)
		For _nD := 1 to len(_aDesc)
			_aDesc[_nD] := StrTran(_aDesc[_nD],"!@#","")
			_nTamDes := Len(_aDesc[_nD])
			If _nD == 1
				If _nTamDes > 254                                                                                                                     
					_cLinha := Alltrim(TSQL->CJ_ORCAM)+";"+TSQL->CK_NUM+";"+TSQL->CK_ITEM+";"+TSQL->ZG_CODIGO+";"+TSQL->ZG_MSDESC+";"+Substr(_aDesc[_nD],1,254)
					FWrite(cNomTrb,CRLF+_cLinha)
					_cLinha := ";;;;;"+Substr(_aDesc[_nD],255,254)
					FWrite(cNomTrb,CRLF+_cLinha)
				Else
					_cLinha := Alltrim(TSQL->CJ_ORCAM)+";"+TSQL->CK_NUM+";"+TSQL->CK_ITEM+";"+TSQL->ZG_CODIGO+";"+TSQL->ZG_MSDESC+";"+Alltrim(_aDesc[_nD])
					FWrite(cNomTrb,CRLF+_cLinha)
				Endif
			Else
				If _nTamDes > 254
					_cLinha := Alltrim(TSQL->CJ_ORCAM)+";"+TSQL->CK_NUM+";"+TSQL->CK_ITEM+";"+TSQL->ZG_CODIGO+";"+TSQL->ZG_MSDESC+";"+Substr(_aDesc[_nD],1,254)
					FWrite(cNomTrb,CRLF+_cLinha)
					_cLinha := ";;;;;"+Substr(_aDesc[_nD],255,254)
					FWrite(cNomTrb,CRLF+_cLinha)
				Else	
					_cLinha := ";;;;;"+Alltrim(_aDesc[_nD])
					FWrite(cNomTrb,CRLF+_cLinha)
				Endif
			Endif	
		Next
	Else
		_cLinha := Alltrim(TSQL->CJ_ORCAM) +";"
		_cLinha += TSQL->CK_NUM+";"
		_cLinha += TSQL->CK_ITEM+";"
		_cLinha += TSQL->ZG_CODIGO+";"
		_cLinha += TSQL->ZG_MSDESC+";"
		_cLinha += Alltrim(_cDESC)
		FWrite(cNomTrb,CRLF+_cLinha)
	Endif
	TSQL->(DbSkip())
EndDo

FClose(cNomtrb)

Return
