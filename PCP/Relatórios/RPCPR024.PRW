#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหออออออออออออออออออออออออออออหออออออัออออออออออออออออออปฑฑ
ฑฑบPrograma  ณRPCPR024  บ Ana Paula QFaustino        บ Data ณ 27/09/2013       บฑฑ
ฑฑฬออออออออออุออออออออออสออออออออออออออออออออออออออออสออออออฯออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de Impressao de Etiquetas p/Labortub                     บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RPCPR024()

Private _cUsuario  := RetCodUsr()
Private _aUsuario  := {}
Private _cUsuSenha := ""
Private _cDeptoUsu := ""
Private nLastKey   := 0
Private cArqPRN    := "C:\relato_microsiga\EtiqLabor.PRN"
Private cRegPRN    := ""
Private cArqTrab   := ""
Private cFilTrab   := ""
Private cPedido    := ""
Private cItem      := ""
Private nQtdEtiq   := 0
Private nEtiq      := 0
Private nPesol	   := 0
Private nPesob	   := 0
Private _nLin      := 0
Private _nCol      := 0
Private _fInicio   := .T.
Private _fImpEtiq  := .F.
Private _lProc     := .T.
Private cOBS       := "                    "
Private aMeses     := {"Janeiro","Fevereiro","Mar็o","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}

_cUsuario  := RetCodUsr()
_cUsuSenha := UsrRetname(_cUsuario)

PswOrder(1)
If PswSeek(_cUsuario,.T.)
   _aUsuario  := PswRet()
   _cUsuSenha := UsrRetName(_cUsuario)
   _cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
EndIf

Do While _lProc 

   cPedido  := Space(06)
	cItem    := Space(02)
	nQtdEtiq := 0
	//dData    := CtoD("  /  /    ")
	dData    := Date()
	nQtdEtiq := 0
	nPesol   := 0
	nPesob   := 0
	fImpEtiq := .F.
	fRet     := .F.

	@ 089,185 To 500,600 Dialog _oDlg1 Title OemToAnsi("Etiquetas - Identificar Caixas")
	@ 009,011 To 035,188
	@ 030,011 To 180,188
	@ 015,064 Say OemToAnsi("Etiquetas para Identificar Caixas")  Size 151,010
	
	@ 070,020 Say OemToAnsi("Pedido................:")         Size 070,008
    @ 070,125 Say OemToAnsi("Item:")                           Size 070,008
	@ 085,020 Say OemToAnsi("Qtde........................:")   Size 070,008
	@ 100,020 Say OemToAnsi("Peso Liq....................:")   Size 070,008
	@ 115,020 Say OemToAnsi("Peso Bruto..................:")   Size 070,008
	@ 130,020 Say OemToAnsi("Data Produ็ใo...:")               Size 100,008
	@ 145,020 Say OemToAnsi("Observa็ใo...:")                  Size 070,008

	@ 070,075 Get cPedido                                      Size 030,008 OBJECT oNum
    @ 070,140 Get cItem    Valid ValidaNum()                   Size 020,008 OBJECT oItem
	@ 085,075 Get nQtdEtiq Picture "@E 999"                    
	@ 100,075 Get nPesol   Picture "@E 999,99"
	@ 115,075 Get nPesob   Picture "@E 999,99"
	@ 130,075 Get dData    picture "99/99/9999"
	@ 145,075 Get cOBS                                         Size 100,008
	@ 160,110 BmpButton Type 1 Action Processa( { || ImpEtiq() })
	@ 160,145 BmpButton Type 2 Action _fFinaliza()

	If Alltrim(cPedido) <> ""
		oItem:SetFocus()
	EndIf 
   
	Activate Dialog _oDlg1 Centered
End

Return

*********************************
Static Function _fFinaliza()
*********************************
	_lProc := .F.
	FClose(cArqPRN)
	//FErase("c:\relato_microsiga\EtiqLabor.prn")
	_oDlg1:End()

Return

//******************************
Static Function ValidaNum()
//******************************

Local aCampos := {}
Local oTable

// Cria array para gerar arquivo de trabalho
AADD(aCampos,{ "TB_CLIENTE","C",35,0 } )
AADD(aCampos,{ "TB_DESCPRD","C",30,0 } )
AADD(aCampos,{ "TB_PRODUTO","C",15,0 } )
AADD(aCampos,{ "TB_PEDIDO" ,"C",06,0 } )
AADD(aCampos,{ "TB_ITEM"   ,"C",02,0 } )
AADD(aCampos,{ "TB_QTDE"   ,"N",05,0 } )
   
// Cria arquivo de trabalho
If Select("TRB") > 0 
   DbSelectArea("TRB")
   TRB->(DbCloseArea())
EndIf

oTable := FWTemporaryTable():New("TRB",aCampos)
oTable:Create()

fRet := .T.

If Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
EndIf
    
_cQuery := "SELECT SC5.C5_NUM,    SC5.C5_CLIENTE, SC5.C5_LOJAENT, SC5.C5_PESOL, SC5.C5_PBRUTO, SA1.A1_CGC,  "
_cQuery += "       SA1.A1_NREDUZ, SC6.C6_ITEM,	  SC6.C6_PRODUTO, SB1.B1_LOCAL, SB1.B1_DESC,   SB5.B5_QE1   "
_cQuery += "FROM "+RetSqlName("SC5")+" SC5 "
_cQuery += "INNER JOIN "+RetSqlName("SC6")+" SC6 ON SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND SC6.C6_NUM = SC5.C5_NUM AND SC6.D_E_L_E_T_=' ' "		
_cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND SA1.A1_COD = SC5.C5_CLIENTE "
_cQuery += "                                 AND SA1.A1_LOJA = SC5.C5_LOJAENT AND SA1.D_E_L_E_T_ = ' ' "
_cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SC6.C6_PRODUTO AND SB1.D_E_L_E_T_=' ' "
_cQuery += "LEFT OUTER JOIN "+RetSqlName("SB5")+" SB5 ON SB5.B5_FILIAL = '"+xFilial("SB5")+"' AND SB5.B5_COD=SC6.C6_PRODUTO AND SB5.D_E_L_E_T_=' ' "
_cQuery += "WHERE SC5.C5_FILIAL = '"+xFilial("SC5")+"' AND   SC5.D_E_L_E_T_ = ' ' "
_cQuery += "AND   SC5.C5_NUM = '"+cPedido+"' "
If cItem <> '  ' 
	_cQuery += "AND   SC6.C6_ITEM = '"+cItem+"' "
EndIF
_cQuery += "ORDER BY SC5.C5_NUM, SC6.C6_ITEM "

TcQuery _cQuery New Alias "QR1"

Do While !QR1->(Eof())
    
	RecLock("TRB",.T.)
	TRB->TB_CLIENTE := Substr(QR1->A1_NREDUZ,1,35)   
	TRB->TB_DESCPRD := QR1->B1_DESC
	TRB->TB_PRODUTO := Alltrim(QR1->C6_PRODUTO)
	TRB->TB_PEDIDO  := Alltrim(QR1->C5_NUM)
	TRB->TB_ITEM    := QR1->C6_ITEM
	TRB->TB_QTDE    := QR1->B5_QE1
    TRB->(MsUnlock())
    
	QR1->(dbSkip()) 	            

EndDo
			                                                  
QR1->(DbCloseArea())
   
Return fRet

*******************************
Static Function ImpEtiq()
*******************************

nMes := Month(dData)
nAno := Year(dData)                 

MontaEtiq()    // Monta etiqueta de acordo com o modelo

_oDlg1:End()

Return        

*******************************
Static Function MontaEtiq()
*******************************

Local I       := 0 
Local x			:= 0
Local nSalto  := 0

dDtEnt  := Date()
nSalto  := 28
nEtiq   := 5

If cResp1:=msgbox("Impressora LPT1?","Aten็ใo...","YESNO") 
	MSCBPRINTER("OS 214","LPT1",NIL,)
Else
	MSCBPRINTER("OS 214","COM1",NIL,)	
EndIf   
   
//MSCBPRINTER("OS 214","USB001",NIL,)  
MSCBCHKSTATUS(.F.)
   
For x:= 1 To nQtdEtiq

	MSCBBEGIN(1,4)                            
		                   
	MSCBSAY(07,45,"HELSIMPLAST IND. E COM. LTDA","N","3","01","01") 
	If cOBS == "                    "
			MSCBSAY(07,35,"CLIENTE...: "+AllTRIM(TRB->TB_CLIENTE) ,"N","3","01","01")	
	Else
		MSCBSAY(07,35,"CLIENTE...: "+AllTRIM(TRB->TB_CLIENTE) +"/OBS: "+AllTRIM(SUBSTR(cOBS,1,20)),"N","3","01","01")
	EndIf
	
	MSCBSAY(07,30,"CODIGO....: "+AllTRIM(TRB->TB_PRODUTO),"N","3","01","01")
	MSCBSAY(07,25,"PRODUTO...: "+AllTRIM(TRB->TB_DESCPRD),"N","3","01","01")
	MSCBSAY(07,20,"PED/LOTE  : "+AllTRIM(TRB->TB_PEDIDO),"N","3","01","01")
	MSCBSAY(07,15,"QTDE PECAS: "+AllTRIM(Transform(TRB->TB_QTDE,"@E 99999")),"N","3","01","01")
	MSCBSAY(07,10,"PRODUCAO  : "+AllTRIM(aMeses[nMes] +"/"+Transform(nAno,"@E 9999")),"N","3","01","01")
//	MSCBSAY(55,10,"VALIDADE  : "+AllTRIM(aMeses[nMes] +"/"+Transform(nAno+2,"@E 9999")),"N","3","01","01")
	MSCBSAY(07,05,"VALIDADE  : "+AllTRIM(aMeses[nMes] +"/"+Transform(nAno+2,"@E 9999")),"N","3","01","01")
	If nPesol > 0
//		MSCBSAY(07,05,"PESO LIQ  : "+AllTRIM(Transform(nPesol,"@E 999,99"))+" KG","N","3","01","01")
		MSCBSAY(55,05,"PESO LIQ  : "+AllTRIM(Transform(nPesol,"@E 999,99"))+" KG","N","3","01","01")
//		MSCBSAY(55,05,"PESO BRUTO: "+AllTRIM(Transform(nPesob,"@E 999,99"))+" KG","N","3","01","01")
	EndIf

	//cResult := MSCBEND()
	//MemoWrit('INP701',cResult)
	MSCBEND()
Next

MSCBCLOSEPRINTER()

Return