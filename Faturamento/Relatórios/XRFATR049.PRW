#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

#DEFINE  CRLF  CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXRFATR049 บAutor  ณPedro Vilas Boas    บ Data ณ  11/11/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Reescrito - Faturamento por dia                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - Grupo Masipack                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function XRFATR049()
Local oReport
   
Private cPerg := "XRFATR049B"
 	
pergunte(cPerg,.F.)  
 
oReport := reportDef()
oReport:printDialog()
	
If Select("TMPSF2") <> 0
	TMPSF2->(dbCloseArea())
Endif

Return


Static Function reportDef()
Local oReport
Local oSection
Local cTitulo := 'Faturamento por dia'
 
oReport := TReport():New("XRFATR049", cTitulo,cPerg, {|oReport| PrintReport(oReport)},"Este relatorio ira imprimir a relacao de alunos.")
oReport:SetLandScape()
//oReport:SetTotalInLine(.F.)
oReport:ShowHeader()
 
oSection := TRSection():New(oReport,"TMPSF2")
//oSection:SetTotalInLine(.F.)
 
TRCell():new(oSection, "F2_EMISSAO"  , "TMPSF2", "Emissao",X3Picture("F2_EMISSAO"),TamSX3("F2_EMISSAO")[1]+4,/*lPixel*/,{|| DTOC(STOD(TMPSF2->F2_EMISSAO)) })
TRCell():new(oSection, "D2_GRUPO"    , "TMPSF2", 'Grupo',X3Picture("D2_GRUPO"),TamSX3("D2_GRUPO")[1]+1,/*lPixel*/,{|| TMPSF2->D2_GRUPO })
TRCell():new(oSection, "BM_DESC"     , "TMPSF2", 'Desc',X3Picture("BM_DESC"),TamSX3("BM_DESC")[1]+1,/*lPixel*/,{|| TMPSF2->BM_DESC })
TRCell():new(oSection, "D2_PEDIDO"   , "TMPSF2", 'Pedido',X3Picture("D2_PEDIDO"),TamSX3("D2_PEDIDO")[1]+1,/*lPixel*/,{|| TMPSF2->D2_PEDIDO })
TRCell():new(oSection, "F2_CLIENTE"  , "TMPSF2", 'Cliente',X3Picture("F2_CLIENTE"),TamSX3("F2_CLIENTE")[1]+1,/*lPixel*/,{|| TMPSF2->F2_CLIENTE })
TRCell():new(oSection, "F2_LOJA"     , "TMPSF2", 'Loja',"",TamSX3("F2_LOJA")[1]+1,/*lPixel*/,{|| TMPSF2->F2_LOJA })
TRCell():new(oSection, "A1_NREDUZ"   , "TMPSF2", 'N. Fantasia',X3Picture("A1_NREDUZ"),TamSX3("A1_NREDUZ")[1]+1,/*lPixel*/,{|| TMPSF2->A1_NREDUZ })
TRCell():new(oSection, "D2_VALBRUT"  , "TMPSF2", 'Valor',X3Picture("D2_VALBRUT"),TamSX3("D2_VALBRUT")[1]+3,/*lPixel*/,{|| TMPSF2->D2_VALBRUT })
TRCell():new(oSection, "F2_DOC"      , "TMPSF2", 'N. Fiscao',X3Picture("F2_DOC"),TamSX3("F2_DOC")[1]+1,/*lPixel*/,{|| TMPSF2->F2_DOC })
TRCell():new(oSection, "F2_EST"      , "TMPSF2", 'UF',X3Picture("F2_EST"),TamSX3("F2_EST")[1]+1,/*lPixel*/,{|| TMPSF2->F2_EST })
TRCell():new(oSection, "A1_PAIS"     , "TMPSF2", 'Pais',X3Picture("A1_PAIS"),TamSX3("A1_PAIS")[1]+1,/*lPixel*/,{|| TMPSF2->A1_PAIS })
TRCell():new(oSection, "C5_MSTPVEN"  , "TMPSF2", 'Tipo',"@!",IIF( SubStr(cNumEmp,1,2) <> "15",TamSX3("C5_MSTPVEN")[1]+1,5),/*lPixel*/,{|| IIF( SubStr(cNumEmp,1,2) <> "15",TMPSF2->C5_MSTPVEN,"") })
 
Return (oReport)


Static Function PrintReport(oReport)
Local i
Local oSection := oReport:Section(1) 
Local sData    := ""
Local cGrupo   := ""
Local nTtDia   := 0
Local nTtGrp   := 0
Local aTtlGrp  := {}
Local nPos     := 0
Local nTtl := 0
Local nBisnaga := 0
	
MontaQuery()
	
oSection:Init()
oSection:SetHeaderSection(.T.)
 
DbSelectArea('TMPSF2')
dbGoTop()
oReport:SetMeter(TMPSF2->(RecCount()))

sData  := TMPSF2->F2_EMISSAO
cGrupo := TMPSF2->D2_GRUPO

While TMPSF2->(!Eof())
	If oReport:Cancel()
		Exit
	EndIf
	 
	oReport:IncMeter()
 	oSection:PrintLine()
 	
 	nTtGrp += TMPSF2->D2_VALBRUT
 	nTtDia += TMPSF2->D2_VALBRUT
 	
	IF TMPSF2->D2_GRUPO >= '0200' .AND.  TMPSF2->D2_GRUPO <= '0300'
 		nBisnaga += TMPSF2->D2_VALBRUT 
	ELSE
		nPos := aScan(aTtlGrp,{|X| X[1] = TMPSF2->D2_GRUPO})
 		IF nPos = 0
 			AADD(aTtlGrp,{TMPSF2->D2_GRUPO,TMPSF2->D2_VALBRUT,TMPSF2->BM_DESC})
 		ELSE
 			aTtlGrp[nPos][2] += TMPSF2->D2_VALBRUT
 		ENDIF
	ENDIF
 	
 	TMPSF2->(dbSkip())
 	
 	IF cGrupo <> TMPSF2->D2_GRUPO .OR. sData <> TMPSF2->F2_EMISSAO
 		oSection:Cell("F2_EMISSAO"):SetValue(DTOC(STOD(sData)))
 		oSection:Cell("D2_GRUPO"):SetValue(cGrupo)
 		oSection:Cell("BM_DESC"):SetValue("")
 		oSection:Cell("D2_PEDIDO"):SetValue("")
 		oSection:Cell("F2_CLIENTE"):SetValue("")
 		oSection:Cell("F2_LOJA"):SetValue("")
 		oSection:Cell("A1_NREDUZ"):SetValue("TOTAL VENDA "+cGrupo)
 		oSection:Cell("D2_VALBRUT"):SetValue(nTtGrp)
 		oSection:Cell("F2_DOC"):SetValue("")
 		oSection:Cell("F2_EST"):SetValue("")
 		oSection:Cell("A1_PAIS"):SetValue("")
 		oSection:Cell("C5_MSTPVEN"):SetValue("")
 		
 		oSection:PrintLine()
 		oReport:SkipLine()
 		
 		oSection:Cell("F2_EMISSAO"):SetBlock({|| DTOC(STOD(TMPSF2->F2_EMISSAO)) })
 		oSection:Cell("D2_GRUPO"):SetBlock({|| TMPSF2->D2_GRUPO })
 		oSection:Cell("BM_DESC"):SetBlock({|| TMPSF2->BM_DESC })
 		oSection:Cell("D2_PEDIDO"):SetBlock({|| TMPSF2->D2_PEDIDO })
 		oSection:Cell("F2_CLIENTE"):SetBlock({|| TMPSF2->F2_CLIENTE })
 		oSection:Cell("F2_LOJA"):SetBlock({|| TMPSF2->F2_LOJA })
 		oSection:Cell("A1_NREDUZ"):SetBlock({|| TMPSF2->A1_NOME })
 		oSection:Cell("D2_VALBRUT"):SetBlock({|| TMPSF2->D2_VALBRUT })
 		oSection:Cell("F2_DOC"):SetBlock({|| TMPSF2->F2_DOC })
 		oSection:Cell("F2_EST"):SetBlock({|| TMPSF2->F2_EST })
 		oSection:Cell("A1_PAIS"):SetBlock({|| TMPSF2->A1_PAIS })
 		oSection:Cell("C5_MSTPVEN"):SetBlock({|| IIF( SubStr(cNumEmp,1,2) <> "15",TMPSF2->C5_MSTPVEN,"") })
 		
 		cGrupo := TMPSF2->D2_GRUPO
 		nTtGrp := 0
 	ENDIF
 	
 	IF sData <> TMPSF2->F2_EMISSAO
 		oSection:Cell("F2_EMISSAO"):SetValue(DTOC(STOD(sData)))
 		oSection:Cell("D2_GRUPO"):SetValue("")
 		oSection:Cell("BM_DESC"):SetValue("")
 		oSection:Cell("D2_PEDIDO"):SetValue("")
 		oSection:Cell("F2_CLIENTE"):SetValue("")
 		oSection:Cell("F2_LOJA"):SetValue("")
 		oSection:Cell("A1_NREDUZ"):SetValue("TOTAL DIA "+DTOC(STOD(sData)))
 		oSection:Cell("D2_VALBRUT"):SetValue(nTtDia)
 		oSection:Cell("F2_DOC"):SetValue("")
 		oSection:Cell("F2_EST"):SetValue("")
 		oSection:Cell("A1_PAIS"):SetValue("")
 		oSection:Cell("C5_MSTPVEN"):SetValue("")
 		
 		oSection:PrintLine()
 		oReport:SkipLine()
 		oReport:ThinLine()
 		
 		oSection:Cell("F2_EMISSAO"):SetBlock({|| DTOC(STOD(TMPSF2->F2_EMISSAO)) })
 		oSection:Cell("D2_GRUPO"):SetBlock({|| TMPSF2->D2_GRUPO })
 		oSection:Cell("BM_DESC"):SetBlock({|| TMPSF2->BM_DESC })
 		oSection:Cell("D2_PEDIDO"):SetBlock({|| TMPSF2->D2_PEDIDO })
 		oSection:Cell("F2_CLIENTE"):SetBlock({|| TMPSF2->F2_CLIENTE })
 		oSection:Cell("F2_LOJA"):SetBlock({|| TMPSF2->F2_LOJA })
 		oSection:Cell("A1_NREDUZ"):SetBlock({|| TMPSF2->A1_NOME })
 		oSection:Cell("D2_VALBRUT"):SetBlock({|| TMPSF2->D2_VALBRUT })
 		oSection:Cell("F2_DOC"):SetBlock({|| TMPSF2->F2_DOC })
 		oSection:Cell("F2_EST"):SetBlock({|| TMPSF2->F2_EST })
 		oSection:Cell("A1_PAIS"):SetBlock({|| TMPSF2->A1_PAIS })
 		oSection:Cell("C5_MSTPVEN"):SetBlock({|| IIF( SubStr(cNumEmp,1,2) <> "15",TMPSF2->C5_MSTPVEN,"") })
 		
 		sData  := TMPSF2->F2_EMISSAO
 		nTtDia := 0
 	ENDIF
EndDo

oReport:SkipLine()

ASort(aTtlGrp, , , {|x,y|x[1] < y[1]})

oSection:Cell("F2_EMISSAO"):SetValue("")

IF nBisnaga > 0
	oSection:Cell("D2_GRUPO"):SetValue("")
	oSection:Cell("BM_DESC"):SetValue("BISNAGAS")
	oSection:Cell("A1_NREDUZ"):SetValue("TOTAL")	
	oSection:Cell("D2_VALBRUT"):SetValue(nBisnaga )
	oSection:PrintLine()
	nTtl += nBisnaga  
ENDIF

For i := 1 To Len(aTtlGrp)
	oSection:Cell("D2_GRUPO"):SetValue(aTtlGrp[i][1])
	oSection:Cell("BM_DESC"):SetValue(aTtlGrp[i][3])
	oSection:Cell("A1_NREDUZ"):SetValue("TOTAL")	
	oSection:Cell("D2_VALBRUT"):SetValue(aTtlGrp[i][2])
	oSection:PrintLine()
	nTtl += aTtlGrp[i][2] 
Next

oSection:Cell("D2_GRUPO"):SetValue('')
oSection:Cell("BM_DESC"):SetValue('')
oSection:Cell("A1_NREDUZ"):SetValue("TOTAL GERAL")	
oSection:Cell("D2_VALBRUT"):SetValue(nTtl)
oSection:PrintLine()

oSection:Finish()
TMPSF2->(DbCloseArea())
Return


Static Function MontaQuery()
Local cQuery    := ""

cQuery := " SELECT F2_EMISSAO,D2_GRUPO,BM_DESC,D2_PEDIDO,F2_CLIENTE,F2_LOJA,A1_NREDUZ,A1_NOME,D2_VALBRUT,F2_DOC,F2_EST,A1_PAIS,C5_MSTPVEN " + CRLF
cQuery += " FROM " + RetSqlName("SF2") + " SF2  " + CRLF
cQuery += " INNER JOIN " + RetSqlName("SD2") + " SD2 ON F2_FILIAL+F2_SERIE+F2_DOC = D2_FILIAL+D2_SERIE+D2_DOC AND SD2.D_E_L_E_T_ <> '*' " + CRLF
cQuery += " INNER JOIN " + RetSqlName("SC5") + " SC5 ON D2_FILIAL+D2_PEDIDO = C5_FILIAL+C5_NUM AND SC5.D_E_L_E_T_ <> '*' " + CRLF
cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD+A1_LOJA=F2_CLIENTE+F2_LOJA AND SA1.D_E_L_E_T_ <> '*' "+ CRLF
cQuery += " INNER JOIN " + RetSqlName("SBM") + " SBM ON BM_FILIAL = '"+xFilial("SBM")+"' AND BM_GRUPO = D2_GRUPO AND SBM.D_E_L_E_T_ <> '*' " + CRLF
cQuery += " INNER JOIN " + RetSqlName("SF4") + " SF4 ON F4_FILIAL = '"+xFilial("SF4")+"' AND D2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ <> '*' " + CRLF  
cQuery += " WHERE F2_FILIAL = '" + xFilial("SF2") + "' AND F2_TIPO = 'N' AND SF2.D_E_L_E_T_ <> '*'  " + CRLF  
cQuery += " AND F2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' " + CRLF  
cQuery += "	AND D2_GRUPO   BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + CRLF   
cQuery += "	AND F2_CLIENTE BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " + CRLF   
If  SubStr(cNumEmp,1,2) <> "15"
	cQuery += " AND C5_MSTPVEN BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR09 + "' " + CRLF   
EndIf
IF MV_PAR07 == 1
	cQuery += " AND F4_DUPLIC = 'S' " + CRLF  
ELSE	
	cQuery += " AND F4_DUPLIC = 'N' " + CRLF  
ENDIF	
cQuery  += " ORDER BY F2_EMISSAO, D2_GRUPO "

If Select("TMPSF2") <> 0
	TMPSF2->(dbCloseArea())
Endif

TCQuery cQuery Alias "TMPSF2" New

Return
