#include "protheus.ch" 
#INCLUDE "rwmake.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหออออออออออออออออออออออออออออหออออออัออออออออออออออออออปฑฑ
ฑฑบPrograma  ณRESTR020  บ Ana Paula QFaustino        บ Data ณ 04/12/2012       บฑฑ
ฑฑฬออออออออออุออออออออออสออออออออออออออออออออออออออออสออออออฯออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de Impressao de Etiquetas p/Identificar Pecas - NF.Saida บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Alterado em 23/07/2013 por Ana Paula QF - estava com problema na impressao da quantidade pedida
*/

User Function RESTR020()

Private _cUsuario  := RetCodUsr()
Private _aUsuario  := {}
Private _cUsuSenha := ""
Private _cDeptoUsu := ""
Private nLastKey   := 0
Private cNum       := ""
Private cItem      := ""
Private cProd      := ""
Private cRev       := ""
Private cProdAux   := ""
Private nQtdEtiq   := 0
Private nEtiq      := 0
Private cNFiscal   := ""
Private dDtSai     := CTOD("")
Private cArqPRN    := "C:\relato_microsiga\EtiqPcTer.PRN"
Private cRegPRN    := ""
Private cTipo      := ""
Private cCli       := ""
Private _nLin      := 0
Private _nCol      := 0
Private _fInicio   := .T.
Private _fImpEtiq  := .F.
Private _lProc     := .T.
Private cArqTrab   := ""
Private cFilTrab   := ""

_cUsuario  := RetCodUsr()
_cUsuSenha := UsrRetname(_cUsuario)

PswOrder(1)
If PswSeek(_cUsuario,.T.)
	_aUsuario  := PswRet()
	_cUsuSenha := UsrRetName(_cUsuario)
	_cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
EndIf

//aModelo  := {"1-Branca (5 Etiquetas)","2-Amarela (3 Etiquetas)"}
aModelo  := {"2-Verde (3 Etiquetas)"}
aTipo    := {"Pedido","NFiscal"}

dDtSai   := CTOD("")
cNFiscal := Space(06)
cModelo  := Space(20)
nNrEtiq := 0

cModelo := "2-Verde (3 Etiquetas)"

Do While _lProc
	
	cNum     := Space(06)
	cItem    := Space(02)
	cProd    := Space(15)
	nQtdEtiq := 1
	nEtiq 	:= 0
	fImpEtiq := .F.
	fRet     := .F.
	
	If Select("QR1") > 0
		DbSelectArea("QR1")
		DbCloseArea()
	EndIf
	
	@ 089,185 To 500,600 Dialog _oDlg1 Title OemToAnsi("Etiquetas - Identificar Pe็as")
	@ 009,011 To 035,188
	@ 030,011 To 180,188
	@ 015,064 Say OemToAnsi("Etiqueta para Pe็as")					Size 151,010
	
	@ 055,020 Say OemToAnsi("Modelo:")									Size 070,008
	@ 070,020 Say OemToAnsi("Pedido / Nota Fiscal.:")				Size 070,008
	@ 085,020 Say OemToAnsi("Nr.Documento:")							Size 070,008
	@ 085,125 Say OemToAnsi("Item:")										Size 070,008
	@ 100,020 Say OemToAnsi("Data Saida:")								Size 070,008
	@ 115,020 Say OemToAnsi("Qtde de etiquetas:")					Size 070,008
	@ 115,110 Say OemToAnsi("Qtde Prod:")								Size 070,008
	
	@ 052,075 ComboBox cModelo Items aModelo							Size 075,010 OBJECT oModelo
	@ 070,075 ComboBox cTipo  Items aTipo								Size 075,010 OBJECT oTipo
	@ 085,075 Get cNum														Size 030,008 OBJECT oNum
	@ 085,140 Get cItem    Valid ValidaNum()							Size 020,008 OBJECT oItem
	@ 100,075 Get dDtSai														Size 035,008 // Valid dDtSai <= Date()
	@ 115,075 Get nQtdEtiq Picture "@E 999"							Size 030,008
	@ 115,140 Get nEtiq	  Picture "@E 999"							Size 030,008
	
	@ 150,110 BmpButton Type 1 Action Processa( { || ImpEtiq(),_oDlg1:End() })
	@ 150,145 BmpButton Type 2 Action _fFinaliza()
	
	If Alltrim(cNum) <> ""
		cTipo:=Space(1)
		oItem:SetFocus()
	EndIf
	
	Activate Dialog _oDlg1 Centered
End

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTR020  บAutor  ณMicrosiga           บ Data ณ  05/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fFinaliza()

_lProc := .F.
FClose(cArqPRN)
FErase("c:\relato_microsiga\EtiqPcTer.prn")
_oDlg1:End()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTR020  บAutor  ณMicrosiga           บ Data ณ  05/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidaNum()

fRet := .T.

If Substr(cTipo,1,1) == 'P'   // Por Pedidos
	
	//VICTOR DESSUNTE - 31/05/2017
	//INICIO - TICKET:2017052937000168
	
	/*_cQry := "SELECT SC5.C5_NUM, SC5.C5_EMISSAO, SC5.C5_CLIENTE, SC5.C5_LOJAENT, SA1.A1_NREDUZ, SC6.C6_ITEM, SC6.C6_PRODUTO, SC6.C6_DESCRI, "
	_cQry += "       SD2.D2_DOC, SD2.D2_EMISSAO, SD2.D2_QUANT, SC6.C6_PEDCLI, SB1.B1_LOCAL "
	_cQry += "FROM "+RetSqlName("SC5")+" SC5 "
	_cQry += "INNER JOIN "+RetSqlName("SC6")+" SC6 ON SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND SC6.C6_NUM = SC5.C5_NUM AND SC6.D_E_L_E_T_ = ' ' "
	_cQry += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJAENT AND SC5.D_E_L_E_T_ = ' ' "
	_cQry += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SC6.C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
	_cQry += "LEFT OUTER JOIN "+RetSqlName("SD2")+" SD2 ON SD2.D2_FILIAL = '"+xFilial("SD2")+"' AND SD2.D2_PEDIDO = SC5.C5_NUM AND SD2.D2_ITEM = SC6.C6_ITEM AND SD2.D_E_L_E_T_ = ' ' "
	_cQry += "WHERE SC5.C5_FILIAL = '"+xFilial("SC5")+"' "
	_cQry += "AND   SC5.C5_NUM = '"+cNum+"' "
	If cItem <> '  '
	_cQry += "AND   SC6.C6_ITEM = '"+cItem+"' "
	EndIF
	_cQry += "AND   SC5.D_E_L_E_T_ = ' ' "
	_cQry += "ORDER BY SC5.C5_NUM, SC6.C6_ITEM "*/
	
	_cQry := " SELECT " + CRLF
	_cQry += "		SC5.C5_NUM, " + CRLF
	_cQry += "		SC5.C5_EMISSAO, " + CRLF
	_cQry += "		SC5.C5_CLIENTE, " + CRLF
	_cQry += "		SC5.C5_LOJAENT, " + CRLF
	_cQry += "		SA1.A1_NREDUZ, " + CRLF
	_cQry += "		SC6.C6_ITEM, " + CRLF
	_cQry += "		SC6.C6_PRODUTO, " + CRLF
	_cQry += "		SC6.C6_DESCRI, " + CRLF
	_cQry += "		C9_QTDLIB, " + CRLF
	_cQry += "		SC6.C6_PEDCLI, " + CRLF
	_cQry += "		SB1.B1_LOCAL " + CRLF
	_cQry += " FROM  " + CRLF
	_cQry += 		RetSqlName("SC5") + " SC5 INNER JOIN " + RetSqlName("SC6") + " SC6 " + CRLF
	_cQry += "		ON		SC6.C6_FILIAL	= '" + xFilial("SC6") + "' " + CRLF
	_cQry += "		AND 	SC6.C6_NUM		= SC5.C5_NUM " + CRLF
	_cQry += "		AND 	SC6.D_E_L_E_T_	= ' ' " + CRLF
	_cQry += "		INNER JOIN " + RetSqlName("SA1") + " SA1  " + CRLF
	_cQry += "		ON		SA1.A1_FILIAL	= '" + xFilial("SA1") + "' " + CRLF
	_cQry += "		AND 	SA1.A1_COD		= SC5.C5_CLIENTE  " + CRLF
	_cQry += "		AND 	SA1.A1_LOJA		= SC5.C5_LOJAENT  " + CRLF
	_cQry += "		AND 	SC5.D_E_L_E_T_	= ' '		 " + CRLF
	_cQry += "		INNER JOIN " + RetSqlName("SB1") + " SB1  " + CRLF
	_cQry += "		ON		SB1.B1_FILIAL	= '" + xFilial("SB1") + "' " + CRLF
	_cQry += "		AND 	SB1.B1_COD		= SC6.C6_PRODUTO  " + CRLF
	_cQry += "		AND 	SB1.D_E_L_E_T_	= ' ' " + CRLF
	_cQry += "		INNER JOIN " + RetSqlName("SC9") + " C9 " + CRLF
	_cQry += "		ON		C9.D_E_L_E_T_	= '' " + CRLF
	_cQry += "		AND 	C9_FILIAL		= '" + xFilial("SC9") + "' " + CRLF
	_cQry += "		AND 	C9_PEDIDO		= C5_NUM " + CRLF
	_cQry += "		AND 	C9_ITEM			= C6_ITEM " + CRLF
	_cQry += "		AND 	C9_NFISCAL		= '' " + CRLF
	_cQry += "		AND 	C9_BLEST			= '' " + CRLF
	_cQry += "		WHERE  " + CRLF
	_cQry += "				SC5.C5_FILIAL	= '" + xFilial("SC5") + "' " + CRLF
	_cQry += "		AND 	SC5.C5_NUM		= '" + cNum + "' " + CRLF
	
	If !Empty(cItem)
		_cQry += "		AND 	SC6.C6_ITEM		= '" + cItem + "' " + CRLF
	EndIf
	
	_cQry += "		AND 	SC5.D_E_L_E_T_	= ' ' " + CRLF
	_cQry += "		ORDER BY SC5.C5_NUM,SC6.C6_ITEM "
	
	If Select("QR1") > 0
		DbSelectArea("QR1")
		DbCloseArea()
	EndIf

	TcQuery _cQry New Alias "QR1"
	
	QR1->(dbGoTop())
	If QR1->(EOF())
		fRet := .F.
		Alert("Pedido e Item nใo encontrado")
		QR1->(DbCloseArea())
	EndIf
Else         // Por Nota Fiscal
	
	_cQry := "SELECT SD2.D2_FILIAL,  SD2.D2_DOC,    SD2.D2_ITEM, SD2.D2_EMISSAO, SD2.D2_QUANT,  SC6.C6_FILIAL, SC6.C6_NUM, SC6.C6_ITEM,  "
	_cQry += "       SC6.C6_PRODUTO, SC6.C6_DESCRI, SC6.C6_CLI,  SA1.A1_NREDUZ, SC6.C6_PEDCLI, SB1.B1_LOCAL "
	_cQry += "FROM "+RetSqlName("SD2")+" SD2 "
	_cQry += "INNER JOIN "+RetSqlName("SC6")+" SC6 ON SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND SC6.C6_NUM = SD2.D2_PEDIDO AND SC6.C6_ITEM = SD2.D2_ITEMPV AND SD2.D_E_L_E_T_ = ' ' "
	_cQry += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND SA1.A1_COD = SC6.C6_CLI AND SA1.A1_LOJA = SC6.C6_LOJA AND SC6.D_E_L_E_T_ = ' ' "
	_cQry += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SC6.C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
	_cQry += "WHERE SD2.D2_FILIAL = '"+xFilial("SD2")+"' "
	_cQry += "  AND SD2.D2_DOC = '"+cNum+"' "
	If cItem <> '  '
		_cQry += "  AND SD2.D2_ITEM = '"+cItem+"' "
	EndIf
	_cQry += "  AND  D2_SERIE NOT LIKE '000' "
	_cQry += "  AND SD2.D_E_L_E_T_ = ' ' "
	_cQry += "ORDER BY SD2.D2_DOC, SD2.D2_ITEM "
	
	If Select("QR1") > 0
		DbSelectArea("QR1")
		DbCloseArea()
	EndIf

	TcQuery _cQry New Alias "QR1"

	QR1->(dbGoTop())
	If QR1->(EOF())
		fRet := .F.
		Alert("NF e Item nใo encontrado")
		QR1->(DbCloseArea())
	EndIf
Endif

Return fRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTR020  บAutor  ณMicrosiga           บ Data ณ  05/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpEtiq()

Local aCampos := {}
Local _nX
Local oTable

AADD(aCampos,{ "TB_PRODUTO","C",15,0 } )
AADD(aCampos,{ "TB_NUM"    ,"C",06,0 } )
AADD(aCampos,{ "TB_ITEM"   ,"C",03,0 } )
AADD(aCampos,{ "TB_NREDUZ" ,"C",11,0 } )
AADD(aCampos,{ "TB_DESCPRO","C",25,0 } )
AADD(aCampos,{ "TB_EMISSAO","D",08,0 } )
AADD(aCampos,{ "TB_PEDCLI" ,"C",15,0 } )
AADD(aCampos,{ "TB_DOC"    ,"C",06,0 } )
AADD(aCampos,{ "TB_LOCAL"  ,"C",08,0 } )
AADD(aCampos,{ "TB_QTDE"   ,"N",12,2 } )

oTable := FWTemporaryTable():New("TRB",aCampos)
oTable:Create()

dbSelectArea("QR1")
QR1->(dbGoTop())
Do While !QR1->(Eof())
	For _nX:=1 To nQtdEtiq
		RecLock("TRB",.T.)
		TRB->TB_PRODUTO := Alltrim(QR1->C6_PRODUTO)
		TRB->TB_NUM     := IIF(Substr(cTipo,1,1) == 'P',Alltrim(QR1->C5_NUM),Alltrim(QR1->D2_DOC))
		TRB->TB_DESCPRO := Alltrim(QR1->C6_DESCRI)
		TRB->TB_ITEM    := IIF(Substr(cTipo,1,1) == 'P',QR1->C6_ITEM,QR1->D2_ITEM)
		TRB->TB_NREDUZ  := Substr(QR1->A1_NREDUZ,1,11)
		TRB->TB_EMISSAO := dDtSai
		TRB->TB_PEDCLI  := Alltrim(QR1->C6_PEDCLI)
		TRB->TB_DOC     := IIF(Substr(cTipo,1,1) == 'P',Alltrim(QR1->C5_NUM),Alltrim(QR1->D2_DOC))
		TRB->TB_LOCAL   := Alltrim(QR1->B1_LOCAL)
		TRB->TB_QTDE    := IIF(nEtiq > 0,nEtiq,IIF(Substr(cTipo,1,1) == 'P',QR1->C9_QTDLIB,QR1->D2_QUANT))
		TRB->(MsUnlock())
	Next _nX
	QR1->(dbSkip())
EndDo

If Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
EndIf

If _fInicio
	IniEtiq()   // Grava as informacoes iniciais no arquivo
EndIf

_cEXE2  := "cmd /c net use lpt1: /delete"
WaitRun(_cEXE2)// Deleta mapeamento LPT1
If cResp1:=msgbox("Impressora LPT1?","Aten็ใo...","YESNO")
	MSCBPRINTER("OS 214","LPT1",NIL,)
Else
	MSCBPRINTER("OS 214","COM1",NIL,)
EndIf

MSCBCHKSTATUS(.F.)

TRB->(dbGoTop())
DO WHILE !TRB->(EOF())
	
	MSCBBEGIN(1,4)
	
	
	MSCBSAY(05,03,(TRB->TB_PRODUTO) ,"B","2","01,01")
	MSCBSAY(09,03,(TRB->TB_DESCPRO) ,"B","2","01,01")
	MSCBSAY(13,03,"LOCAL: " + SUBSTR(TRB->TB_LOCAL,1,1)+ "-" + SUBSTR(TRB->TB_LOCAL,2,3) + "-" + SUBSTR(TRB->TB_LOCAL,5),"B","2","01,01")
	MSCBSAY(17,03,"Pedcli: " + TRB->TB_PEDCLI,"B","2","01,01")
	If Substr(cTipo,1,1) == 'N'
		MSCBSAY(21,03,"NF: "+ TRB->TB_DOC + " - "+TRB->TB_NREDUZ    ,"B","2","01,01")
	Else
		MSCBSAY(21,03,"Ped.: "+ TRB->TB_NUM + " - "+TRB->TB_NREDUZ    ,"B","2","01,01")
	EndIf
	
	MSCBSAY(24,03,"Data Saida: " + DTOC(TRB->TB_EMISSAO)      ,"B","2","01,01")
	MSCBSAY(27,03,"Quantidade: " + TRANSFORM(TRB->TB_QTDE,"@E 999.999")      ,"B","2","01,01")
	
	TRB->(dbSkip())
	IF !TRB->(EOF())
		
		MSCBSAY(35,03,(TRB->TB_PRODUTO) ,"B","2","01,01")
		MSCBSAY(39,03,(TRB->TB_DESCPRO) ,"B","2","01,01")
		MSCBSAY(43,03,"LOCAL: " + SUBSTR(TRB->TB_LOCAL,1,1)+ "-" + SUBSTR(TRB->TB_LOCAL,2,3) + "-" + SUBSTR(TRB->TB_LOCAL,5),"B","2","01,01")
		MSCBSAY(47,03,"Pedcli: " + TRB->TB_PEDCLI,"B","2","01,01")
		If Substr(cTipo,1,1) == 'N'
			
			MSCBSAY(51,03,"NF: "+ TRB->TB_DOC + " - "+TRB->TB_NREDUZ    ,"B","2","01,01")
		Else
			MSCBSAY(51,03,"Ped.: "+ TRB->TB_NUM + " - "+TRB->TB_NREDUZ    ,"B","2","01,01")
			
		EndIf
		
		MSCBSAY(54,03,"Data Saida: " + DTOC(TRB->TB_EMISSAO)      ,"B","2","01,01")
		MSCBSAY(57,03,"Quantidade: " + TRANSFORM(TRB->TB_QTDE,"@E 999.999")      ,"B","2","01,01")
		
		TRB->(dbSkip())
		IF !TRB->(EOF())
			
			MSCBSAY(65,03,(TRB->TB_PRODUTO) ,"B","2","01,01")
			MSCBSAY(69,03,(TRB->TB_DESCPRO) ,"B","2","01,01")
			MSCBSAY(73,03,"LOCAL: " + SUBSTR(TRB->TB_LOCAL,1,1)+ "-" + SUBSTR(TRB->TB_LOCAL,2,3) + "-" + SUBSTR(TRB->TB_LOCAL,5) ,"B","2","01,01")
			MSCBSAY(77,03,"Pedcli: " + TRB->TB_PEDCLI,"B","2","01,01")
			
			If Substr(cTipo,1,1) == 'N'
				
				MSCBSAY(81,03,"NF: "+ TRB->TB_DOC + " - "+TRB->TB_NREDUZ    ,"B","2","01,01")
			Else
				MSCBSAY(81,03,"Ped.: "+ TRB->TB_NUM + " - "+TRB->TB_NREDUZ    ,"B","2","01,01")
				
			EndIf
			
			MSCBSAY(84,03,"Data Saida: " + DTOC(TRB->TB_EMISSAO)      ,"B","2","01,01")
			MSCBSAY(87,03,"Quantidade: " + TRANSFORM(TRB->TB_QTDE,"@E 999.999")      ,"B","2","01,01")
			
			TRB->(dbSkip())
		ELSE
			MSCBEND() //Fim da Imagem da Etiqueta
			EXIT
		ENDIF
	ELSE
		MSCBEND() //Fim da Imagem da Etiqueta
		EXIT
	ENDIF
	MSCBEND() //Fim da Imagem da Etiqueta
ENDDO

MSCBEND() //Fim da Imagem da Etiqueta

MSCBCLOSEPRINTER()

	oTable:Delete()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTR020  บAutor  ณMicrosiga           บ Data ณ  05/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IniEtiq()

If SubStr(cModelo,1,1) == "1"
	_nLin := 13
Else
	_nLin := 20
EndIf

If (cArqPRN := FCreate("C:\Relato_Microsiga\EtiqPcTer.PRN")) == -1
	Alert("Arquivo de Etiquetas nใo pode ser criado - Avise o Depto. de Informแtica")
	Return
EndIf

cRegPRN := CHR(2) + "c0000"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := CHR(2) + "KI503"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := CHR(2) + "o0220"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := CHR(2) + "f220"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
If SubStr(cModelo,1,1) == "1"
	cRegPRN := CHR(2) + "KW0400"
Else
	cRegPRN := CHR(2) + "KW0358"
EndIf
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := CHR(2) + "KI7" + CHR(1)
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := CHR(2) + "V0"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := CHR(2) + "L"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
If SubStr(cModelo,1,1) == "1"
	cRegPRN := "H13"
Else
	cRegPRN := "H12"
EndIf
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := "PC"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := "A2"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN :=  "D11"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
_fInicio := .F.

Return
