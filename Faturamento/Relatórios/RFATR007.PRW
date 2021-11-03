#Include "Rwmake.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} RFATR007
//TODO Adriano Luis Brandao
@author Adriano Luis Brandao
@since 29/10/03	
@version 1.0
@return Nil

@type function
/*/
User Function RFATR007()

	Private cString     := "AA3"
	Private nomeprog    := "RFATR007" 
	Private cPerg		  := "XRFATR007 "
	Private wnrel       := "RFATR007" 
	Private Titulo      := "Relatorio de Maquinas Vendidas"
	Private cDesc1      := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2      := "de Maquinas vendidas"
	Private cDesc3      := ""
	Private aOrd        := {"Pedido","Produto","Cliente"}
	Private tamanho     := "M"
	Private aReturn     := { "Zebrado",1,"Administracao",2,2,1,"",1}

	Private cPict       := ""
	Private _nLin       := 80
	Private Cabec1      := ""
	Private Cabec2      := ""
	Private imprime     := .T.
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private limite      := 132
	Private nTipo       := 18
	Private nLastKey    := 0
	Private cbtxt       := Space(10)
	Private cbcont      := 00
	Private CONTFL      := 01
	Private m_pag       := 01
	Private nOrdem      := 0
	Private cProdAnt    := ""
	Private cCliAnt     := ""
	Private dDtIni      := CTOD("01/01/1900")
	Private dDtFin      := CTOD(Space(10))
	Private nQtdProd    := 0
	Private nTotProd    := 0
	Private cArqCSV     := ""
	Private cRegCSV     := ""

	Pergunte(cPerg,.F.)

	If (cArqCSV := FCreate("C:\Relato_Microsiga\Maquinas_vendidas.csv")) == -1
		apmsgStop("Arquivo para o Excel nใo pode ser criado - Avise o Depto. de Informแtica")
	Else
		cRegCSV := ";;Maquinas Vendidas no Periodo: " + DTOC(mv_par01) + " a " + DTOC(mv_par02)
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)+chr(13)+chr(10)) 
		cRegCSV := "Serie;Cod. Cliente;Cliente;Municipio;UF;Pais;Produto;Descri็ใo;Modelo;Mแquina;Pedido;Faturado;Valor do PV; Contrato;Nota Fiscal"
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
		cRegCSV := ""
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	EndIf   	           

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	RptStatus( { |lEnd| _fImpr007() })

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fImpr007 บAutor  ณAdriano Luis Brandaoบ Data ณ  29/10/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de impressao do relatorio.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - MASIPACK.                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fImpr007()

	nOrdem := aReturn[8]

	If nOrdem < 3
		Cabec1 := "Pedido     Cliente                                                       Pais UF   Serie        Data de    Data de     Modelo"
	Else
		Cabec1 := "Pedido  Produto                                                          Pais UF   Serie        Data de    Data de     Modelo"
	EndIf   

	Cabec2 := "                                                                                                Emissใo    Expedi็ใo"                                            
	//         XXXXXX/XX  XXXXXX/XX-XXXXXXXXXXXXXXXXXXXX  XX   XXXXXXXXXX   XXXXXXXX  XXXXXXXX
	//         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	//                   1         2         3         4         5         6         7         8         9        10        11        12        13

	If Select("QR1") > 0 
		DbSelectArea("QR1")
		DbCloseArea()
	EndIf

	_cQuery := " SELECT AA3_CODPRO, AA3_DTVEND, AA3_MSPED, C5_MSVLPED, C5_COTACAO, "
	_cQuery += "        AA3_CODCLI, AA3_LOJA, AA3_MODELO, AA3_MSITEM, AA3_NUMSER, AA3_MSEMI,  "
	_cQuery += "        A1_PAIS, A1_EST, A1_NREDUZ, A1_TEL, A1_CONTATO, A1_EMAIL2, A1_MUN, " 
	_cQuery += "        B1_DESC,C5_NOTA "
	_cQuery += " FROM " + RetSqlName("AA3") + " AA3 "
	_cQuery += " INNER JOIN " + RetSqlName("SB1") + " B1 ON AA3_CODPRO = B1_COD "
	_cQuery += " INNER JOIN " + RetSqlName("SC5") + " C5 ON AA3_MSPED = C5_NUM "
	_cQuery += " LEFT  JOIN " + RetSqlName("SA1") + " A1 ON AA3_CODCLI = A1_COD AND "
	_cQuery += " 											AA3_LOJA = A1_LOJA AND "
	_cQuery += "       										A1_FILIAL = '" + xFilial("SA1") + "' AND" 
	_cQuery += "											A1.D_E_L_E_T_ = ' ' "
	_cQuery += " WHERE		AA3_FILIAL = '" + xFilial("AA3") + "' AND AA3.D_E_L_E_T_ = ' ' "
	_cQuery += "       AND 	B1_FILIAL = '" + xFilial("SB1") + "' AND B1.D_E_L_E_T_ = ' ' "
	_cQuery += "       AND 	C5_FILIAL = '" + xFilial("SC5") + "' AND C5.D_E_L_E_T_ = ' ' "
	_cQuery += "       AND 	AA3_CODPRO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	_cQuery += "       AND 	AA3_CODCLI BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR09 + "' "
	_cQuery += "       AND 	AA3_DTVEND BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "

	IF MV_PAR10 <> "      " .AND. UPPER(SUBSTR(MV_PAR10,1,2)) <> "ZZ" 
		_cQuery += " AND AA3_MODELO = '" + MV_PAR10 + "' "
	ENDIF

	IF MV_PAR05 == "BR "
		_cQuery += " AND A1_EST BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "' "
	ELSEIF MV_PAR05 <> "   " .AND. UPPER(SUBSTR(MV_PAR05,1,2)) <>  "ZZ"	
		_cQuery += " AND A1_PAIS = '" + MV_PAR05 + "' "
	ENDIF

	IF  !Empty(MV_PAR11)
		_cQuery += " AND A1_MSAREA >= '" + MV_PAR11 + "' "
		_cQuery += " AND A1_MSAREA <= '" + MV_PAR12 + "' "
	EndIf

	IF MV_PAR13 == 2
		_cQuery += " AND C5.C5_LIBEROK='' AND C5.C5_NOTA='' AND C5.C5_BLQ='' "
	ElseIF MV_PAR13 == 3
		_cQuery += " AND (C5.C5_NOTA <> '' OR C5.C5_LIBEROK = 'E') AND C5.C5_BLQ= ''  "	
	EndIf

	IF nOrdem == 1
		_cQuery += " ORDER BY AA3_MSPED, AA3_MSITEM "
	ELSEIF nOrdem == 2	
		_cQuery += " ORDER BY AA3_CODPRO " 
	ELSE
		_cQuery += " ORDER BY AA3_CODCLI "
	ENDIF


	TcQuery _cQuery New Alias "QR1"

	TcSetField("QR1","AA3_DTVEND","D",08,0)
	TcSetField("QR1","AA3_MSEMI" ,"D",08,0)

	QR1->(dbGoTop())

	SetRegua(QR1->(Lastrec()))

	Do While !QR1->(EOF())

		If lEnd
			@ _nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif


		If nOrdem < 3
			If cProdAnt <> QR1->AA3_CODPRO
				If nQtdProd > 0
					_nLin++
					@ _nLin,000 Psay "Total do Produto => " + Str(nQtdProd,6)
					_nLin++
				EndIf   
				If _nLin > 55 
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					_nLin := 9
				EndIf  
				If cProdAnt <> "" .And. _nLin > 9
					@ _nLin,000 Psay Replicate("-",Limite)
					_nLin++
				EndIf   
				@ _nLin,000 Psay "Produto :" + QR1->AA3_CODPRO
				@ _nLin,037 Psay Alltrim(QR1->B1_DESC)
				_nLin+= 2                   
				cProdAnt := QR1->AA3_CODPRO
				nQtdProd := 0
			EndIf   
		Else
			If cCliAnt <> QR1->AA3_CODCLI
				If _nLin > 55 
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					_nLin := 9
				EndIf
				If cCliAnt <> "" .And. _nLin > 9
					@ _nLin,000 Psay Replicate("-",Limite)
					_nLin++
				EndIf   
				@ _nLin,000 Psay "Cliente: " + QR1->AA3_CODCLI + "/" + QR1->AA3_LOJA + "-" + SubStr(QR1->A1_NREDUZ,1,13)
				@ _nLin,033 Psay "Tel.: " + Alltrim(QR1->A1_TEL)
				@ _nLin,055 Psay "Contato: " + Alltrim(QR1->A1_CONTATO)
				@ _nLin,081 Psay "EMail: " + SubStr(QR1->A1_EMAIL2,1,38)  
				_nLin += 2                   
				cCliAnt := QR1->AA3_CODCLI
			EndIf   
		EndIf

		If _nLin > 58 
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) 
			_nLin := 9                                                                          
		EndIf  

		@ _nLin,000 Psay QR1->AA3_MSPED
		If !Empty(QR1->AA3_MSITEM)
			@ _nLin,006 Psay "/" + QR1->AA3_MSITEM
		Endif
		If nOrdem < 3
			@ _nLin,012 Psay QR1->AA3_CODCLI + "/" + QR1->AA3_LOJA + "-" + Alltrim(QR1->A1_NREDUZ)
		Else
			@ _nLin,012 Psay Alltrim(AA3->AA3_CODPRO) + "-" + Alltrim(QR1->B1_DESC)
		EndIf
		@ _nLin,073 Psay QR1->A1_PAIS
		If Alltrim(QR1->A1_PAIS) == "BR"
			@ _nLin,078 Psay QR1->A1_EST
		EndIf   
		@ _nLin,083 Psay SubStr(QR1->AA3_NUMSER,1,13)
		@ _nLin,097 Psay QR1->AA3_MSEMI
		@ _nLin,108 Psay QR1->AA3_DTVEND
		@ _nLin,120 Psay SubStr(QR1->AA3_MODELO,1,11)   
		_nLin++
		If nOrdem == 2
			nTotProd++
			nQtdProd++
		EndIf 
		cRegCSV := QR1->AA3_NUMSER+";_"+QR1->AA3_CODCLI+";"+Alltrim(QR1->A1_NREDUZ)+";"+QR1->A1_MUN+";"+QR1->A1_EST+";"+QR1->A1_PAIS+";_"+QR1->AA3_CODPRO+";"+Alltrim(QR1->B1_DESC)+";"+QR1->AA3_MODELO+";;"+QR1->AA3_MSPED+";"+DTOC(QR1->AA3_DTVEND)+";"+TRANSFORM(QR1->C5_MSVLPED,"@E 999,999,999.99")+";"+QR1->C5_COTACAO+";"+QR1->C5_NOTA
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))                                               
		QR1->(DbSkip())
	EndDo

	QR1->(dbCloseArea())

	FClose(cArqCSV)  

	apmsgInfo("A planilha foi gerada => c:\Relato_microsiga\Maquinas_vendidas")

	If nOrdem == 2
		If nQtdProd > 0
			_nLin++
			@ _nLin,000 Psay "Total do Produto => " + Str(nQtdProd,6)
		EndIf 

		If nTotProd > 0
			@ _nLin,030 Psay "Total de Maquinas => " + Str(nTotProd,6)
		EndIf   
	EndIf 

	Set Device to Screen

	If aReturn[5]==1
		dbCommitAll()
		Set Printer To
		OurSpool(wnrel)
	Endif

	MS_FLUSH() 

Return