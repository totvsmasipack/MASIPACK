#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "Rwmake.ch"

/*/
------------------------------------------------------------------------
Programa  RCONR001       
Desc.     Conciliação de despesas
Autor     Lizandra Marques
Data      17/07/13
------------------------------------------------------------------------
/*/

User Function RCONR001()

lEnd     := .F.
cString  := "SFT"
cPerg    := "XRCONR001 "
NomeProg := "RCONR001"
wnrel    := "RCONR001"
cDesc1   := "Este relatorio tem a finalidade de imprimir os valores fiscais"
cDesc2   := "totalizando por TES."
cDesc3   := ""
aOrdem   := {}
Tamanho  := "P"
Limite   := 80
nLastKey := 0
aReturn  := {"Zebrado",1,"Administracao",1,2,1,"",1}
Titulo   := "CONCILIACAO DE DESPESAS "
cCabec1  := "Conferencia Contabil X Fiscal "
cCabec2  := "Despesas                            Fiscal           Contabil          Diferenca   "
//  xxxxxxxxxxxxxxxxxxxxxxxxxx  999,999,999.99     999,999,999.99     999,999,999.99
//  123456789d123456789v123456789t123456789q123456789c123456789s123456789s123456789o
cCabec3  := ""
_cNomTrb1:= ""
cNat     := ""
cConta   := ""
cCancel  := "***** CANCELADO PELO OPERADOR *****"
m_pag    := 1
cArqCSV  := "c:\relato_microsiga\conciliacao_contabil.csv"

//-----------------------------------------------------------------------------//
//                         Variaveis do Rodape                                 //
//-----------------------------------------------------------------------------//

cbCont := 0
cbTxt  := ""

//-----------------------------------------------------------------------------//
//           Verifica as Perguntas Selecionadas no SX1                         //
//-----------------------------------------------------------------------------//

fCriaSx1()

Pergunte(cPerg,.F.)

//-----------------------------------------------------------------------------//
//              Envia Controle para Funcao SetPrint                            //
//-----------------------------------------------------------------------------//

wnrel := Setprint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,.T.,Tamanho)
If LastKey() == 27 .Or. nLastKey == 27
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter To
	dbGotop()
	Return
EndIf

SetDefault(aReturn,cString)
If LastKey() == 27 .or. nLastKey == 27
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter To
	dbGotop()
	Return
EndIf

Processa( {|| RunProc() } )
RptStatus({|| RptDetail() })

Return

/*/
------------------------------------------------------------------------
Programa  RCONR001       
Desc.     Processamento do Arquivo
Sitaxe    Void RptDetail(Void)
Autor     Lizandra Marques
Data      17/07/13
------------------------------------------------------------------------
/*/

Static Function RunProc()  

Local aField	:= {}
Local oTable	:= Nil

	//RECEITAS
	AADD(aField,{"RECEITAS ","C",26,00})
	AADD(aField,{"VALFISCAL","N",12,02})
	AADD(aField,{"VALCONT"  ,"N",12,03})

	oTable := FWTemporaryTable():New("TRB2",aField)
	oTable:AddIndex( "IDX1", {"RECEITAS"} )
	oTable:Create()
	
	// DESPESAS
	aField := {}
	AADD(aField,{"DESPESAS ","C",26,00})
	AADD(aField,{"VALFISCAL","N",12,02})
	AADD(aField,{"VALCONT"  ,"N",12,03})

	oTable := FWTemporaryTable():New("TRB",aField)
	oTable:AddIndex( "IDX1", {"DESPESAS"} )
	oTable:Create()

	// TOTAL RECEITAS
	aField := {}
	AADD(aField,{"TOTAL"          ,"C",26,00})
	AADD(aField,{"VALFISCAL"      ,"N",12,02})
	AADD(aField,{"VALCONT"        ,"N",12,03})

	oTable := FWTemporaryTable():New("TRB3",aField)
	oTable:AddIndex( "IDX1", {"TOTAL"} )
	oTable:Create()

	IF MV_PAR03 == 2
		If (cArqCSV := FCreate("C:\Relato_Microsiga\conciliacao_contabil.csv")) == -1
			Alert("Arquivo para o Excel não pode ser criado - Avise o Depto. de TI")
		Else
			cRegCSV := "Conciliacao contabil x fiscal - Periodo: de " + DTOC(mv_par01)+ " à " + DTOC(mv_par02)
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)+chr(13)+chr(10))
			cRegCSV := "LIVRO;ENTRADA;DOCUMENTO;CFO/CTA.DEBITO;VALOR;VALOR ICMS;VALOR IPI;VALOR PIS;VALOR COFINS;TIPO/HISTORICO;SERIE/CTA.CREDITO"
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
		EndIf
	ENDIF	

	If Select("QR1") > 0
		DbSelectArea("QR1")
		QR1->(DbCloseArea())
	EndIf
	// QUERY PARA SELEÇÃO DOS MOVIMENTOS FISCAIS E CONTABEIS
	_cQuery := " SELECT 'SFT' AS LIVRO, FT_ENTRADA, FT_NFISCAL, FT_CFOP AS DEBITO,FT_TES AS CLASFIS, FT_VALCONT AS VALOR, 
	_cQuery += "                  CASE WHEN FT_VALICM > 0 THEN FT_VALICM ELSE FT_OBSICM END AS FT_VALICM,  
	_cQuery += "                  FT_VALIPI,FT_VALPIS, FT_VALCOF, FT_TIPO AS TPHIST, FT_SERIE AS CREDITO "
	_cQuery += " FROM " + RetSqlName("SFT") + " FT "
	_cQuery += " WHERE FT_ENTRADA BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
	_cQuery += "       AND FT_FILIAL = '" + xFilial("SFT") +"' AND FT.D_E_L_E_T_ = ' ' "
	_cQuery += "       AND FT_DTCANC = '      ' "
	_cQuery += " UNION ALL "
	_cQuery += " SELECT 'CT2' AS CONTABIL ,CT2_DATA, CT2_DOC, CT2_DEBITO AS DEBITO,CT2_LP AS CLASFIS, CT2_VALOR AS VALOR, CT2_VLR01, CT2_VLR02,
	_cQuery += "                  CT2_VLR03, CT2_VLR04, CT2_HIST AS TPHIST, CT2_CREDIT AS CREDITO "
	_cQuery += " FROM " + RetSqlName("CT2") + " CT2 "
	_cQuery += " WHERE CT2_DATA BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
	_cQuery += "       AND CT2_FILIAL = '" + xFilial("CT2")  + "' AND CT2.D_E_L_E_T_ = ' ' "
	_cQuery += " UNION ALL "
	_cQuery += " SELECT 'SD2' AS LIVRO, D2_EMISSAO, D2_DOC, D2_CF AS DEBITO,D2_TES AS CLASFIS, D2_VALBRUT AS VALOR, D2_VALICM, D2_VALIPI,D2_VALIMP6, D2_VALIMP5, "
	_cQuery += " 	D2_TIPO AS TPHIST, 	D2_SERIE AS CREDITO "
	_cQuery += " FROM " + RetSQLName("SD2") + " D2 "
	_cQuery += " WHERE D2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
	_cQuery += "       AND D2_FILIAL = '" + xFilial("SD2")  + "' "
	_cQuery += "       AND D2.D_E_L_E_T_ = ' ' "
	_cQuery += "       AND D2_CF IN ('5999','6999') "
	_cQuery += "       AND D2_SERIE = 'B' "
	_cQuery += "ORDER BY LIVRO, FT_ENTRADA "

	TcQuery _cQuery New Alias "QR1"

	TcSetField("QR1","FT_ENTRADA","D",08,00)
	TcSetField("QR1","FT_VALIPI" ,"N",12,02)
	TcSetField("QR1","FT_VALICM" ,"N",12,02)
	TcSetField("QR1","FT_VALPIS" ,"N",12,02)
	TcSetField("QR1","FT_VALCOF" ,"N",12,02)
	TcSetField("QR1","CT2_DATA"  ,"D",08,00)
	TcSetField("QR1","VALOR"     ,"N",12,02)
	TcSetField("QR1","CT2_VLR01" ,"N",12,02)
	TcSetField("QR1","CT2_VLR02" ,"N",12,02)
	TcSetField("QR1","CT2_VLR03" ,"N",12,02)
	TcSetField("QR1","CT2_VLR04" ,"N",12,02)


	QR1->(DbGoTop())
	Do While !QR1->(Eof())
		IF QR1->LIVRO == "CT2"
			
			//	RECEITAS CONTABILIZADAS
		
			If ALLTRIM(QR1->CREDITO) $ "440010001_440010010"
				If 	!TRB2->(dbSeek("VENDA DE PRODUTO"))
					RecLock("TRB2",.T.)
					TRB2->RECEITAS  	:= "VENDA DE PRODUTO"
					TRB2->VALCONT	:= QR1->VALOR
				Else
					RecLock("TRB2",.F.)
					TRB2->VALCONT	+= QR1->VALOR
				EndIf
			EndIf
			If ALLTRIM(QR1->CREDITO) $ "450010004"
				If 	!TRB2->(dbSeek("VENDA DE SUCATA"))
					RecLock("TRB2",.T.)
					TRB2->RECEITAS  	:= "VENDA DE SUCATA"
					TRB2->VALCONT	:= QR1->VALOR
				Else
					RecLock("TRB2",.F.)
					TRB2->VALCONT	+= QR1->VALOR
				EndIf
			EndIf
			If ALLTRIM(QR1->CREDITO) $ "440010002"
				If 	!TRB2->(dbSeek("REVENDA INSUMOS"))
					RecLock("TRB2",.T.)
					TRB2->RECEITAS  	:= "REVENDA INSUMOS"
					TRB2->VALCONT	:= QR1->VALOR
					
				Else
					RecLock("TRB2",.F.)
					TRB2->VALCONT	+= QR1->VALOR
				EndIf
			EndIf
			If ALLTRIM(QR1->CREDITO) $ "440010006"
				If 	!TRB2->(dbSeek("EXPORTACAO"))
					RecLock("TRB2",.T.)
					TRB2->RECEITAS  	:= "EXPORTACAO"
					TRB2->VALCONT	:= QR1->VALOR
				Else
					RecLock("TRB2",.F.)
					TRB2->VALCONT	+= QR1->VALOR
				EndIf
			EndIf
			If ALLTRIM(QR1->CREDITO) $ "440010005"
				If 	!TRB2->(dbSeek("EXPORTACOES INDIRETA"))
					RecLock("TRB2",.T.)
					TRB2->RECEITAS  	:= "EXPORTACOES INDIRETA"
					TRB2->VALCONT	:= QR1->VALOR
				Else
					RecLock("TRB2",.F.)
					TRB2->VALCONT	+= QR1->VALOR
				EndIf
			EndIf
			If ALLTRIM(QR1->CREDITO) $ "450010011"
				If 	!TRB2->(dbSeek("VENDA ATIVO FIXO"))
					RecLock("TRB2",.T.)
					TRB2->RECEITAS  	:= "VENDA ATIVO FIXO"
					TRB2->VALCONT	:= QR1->VALOR
				Else
					RecLock("TRB2",.F.)
					TRB2->VALCONT	+= QR1->VALOR
				EndIf
			EndIf
			If ALLTRIM(QR1->CREDITO) $ "440010003"
				If 	!TRB2->(dbSeek("SERVICOS"))
					RecLock("TRB2",.T.)
					TRB2->RECEITAS  	:= "SERVICOS"
					TRB2->VALCONT	:= QR1->VALOR
				Else
					RecLock("TRB2",.F.)
					TRB2->VALCONT	+= QR1->VALOR
				EndIf
			EndIf

			// TOTAL DAS RECEITAS CONTABILIZADAS
			If ALLTRIM(QR1->CREDITO) $ "440010003_450010011_440010005_440010006_440010002_450010004_440010001_440010010"
				If 	!TRB3->(dbSeek("TOTAL"))
					RecLock("TRB3",.T.)
					TRB3->TOTAL		:= "TOTAL"
					TRB3->VALCONT	:= QR1->VALOR
				Else
					RecLock("TRB3",.F.)
					TRB3->VALCONT	+= QR1->VALOR
				EndIf
			EndIf
			
			
			// DESPESAS CONTABILIZADAS
			IF (ALLTRIM(QR1->DEBITO) $ "330100002,112000010,112000011,112000006,112000005,330100001,112000001") .OR. (ALLTRIM(QR1->DEBITO) = "330100026" .AND. SUBSTR(QR1->TPHIST,11,9) = "FRETE NF.")
				IF 	!TRB->(dbSeek("MATERIA-PRIMA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "MATERIA-PRIMA"
					TRB->VALCONT	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALCONT	+= QR1->VALOR
				ENDIF
			ENDIF
			
			IF SUBSTR(cNumEmp,1,2) == "01"  // MASIPACK
				IF ALLTRIM(QR1->DEBITO) = "330100008"
					IF 	!TRB->(dbSeek("ENERGIA ELETRICA"))
						RecLock("TRB",.T.)
						TRB->DESPESAS  	:= "ENERGIA ELETRICA"
						TRB->VALCONT	:= QR1->VALOR
					ELSE
						RecLock("TRB",.F.)
						TRB->VALCONT	+= QR1->VALOR
					ENDIF
				ENDIF
				IF ALLTRIM(QR1->DEBITO) = "340100006" .AND. SUBSTR(QR1->TPHIST,11,3) = "NF."
					IF 	!TRB->(dbSeek("TELEFONE"))
						RecLock("TRB",.T.)
						TRB->DESPESAS  	:= "TELEFONE"
						TRB->VALCONT	:= QR1->VALOR
					ELSE
						RecLock("TRB",.F.)
						TRB->VALCONT	+= QR1->VALOR
					ENDIF
				ENDIF
				IF ALLTRIM(QR1->DEBITO) = "340100023" .AND. SUBSTR(QR1->TPHIST,11,3) = "NF."
					IF 	!TRB->(dbSeek("INFORMATICA"))
						RecLock("TRB",.T.)
						TRB->DESPESAS  	:= "INFORMATICA"
						TRB->VALCONT	:= QR1->VALOR
					ELSE
						RecLock("TRB",.F.)
						TRB->VALCONT	+= QR1->VALOR
					ENDIF
				ENDIF
				
			ELSE
				
				
				IF ALLTRIM(QR1->DEBITO) = "330400003"
					IF 	!TRB->(dbSeek("BENEFICAMENTO"))
						RecLock("TRB",.T.)
						TRB->DESPESAS  	:= "BENEFICAMENTO"
						TRB->VALCONT	:= QR1->VALOR
					ELSE
						RecLock("TRB",.F.)
						TRB->VALCONT	+= QR1->VALOR
					ENDIF
				ENDIF
				IF ALLTRIM(QR1->DEBITO) $ "330100008,340100026"
					IF 	!TRB->(dbSeek("ENERGIA ELETRICA"))
						RecLock("TRB",.T.)
						TRB->DESPESAS  	:= "ENERGIA ELETRICA"
						TRB->VALCONT	:= QR1->VALOR
					ELSE
						RecLock("TRB",.F.)
						TRB->VALCONT	+= QR1->VALOR
					ENDIF
				ENDIF
				IF ALLTRIM(QR1->DEBITO) $ "330100032,340100006" .AND. SUBSTR(QR1->TPHIST,11,3) = "NF."
					IF 	!TRB->(dbSeek("TELEFONE"))
						RecLock("TRB",.T.)
						TRB->DESPESAS  	:= "TELEFONE"
						TRB->VALCONT	:= QR1->VALOR
					ELSE
						RecLock("TRB",.F.)
						TRB->VALCONT	+= QR1->VALOR
					ENDIF
				ENDIF
			ENDIF
			// MASIPACK E FABRIMA
			IF ALLTRIM(QR1->DEBITO) $ "340100037,330100026" .AND. SUBSTR(QR1->TPHIST,11,2) = "NF"
				IF 	!TRB->(dbSeek("FRETES"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "FRETES"
					TRB->VALCONT	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALCONT	+= QR1->VALOR
				ENDIF
			ENDIF
			IF QR1->DEBITO >= "131                 " .AND. QR1->DEBITO <= "131ZZZZZZZZZZZZZZZZZ"
				IF 	!TRB->(dbSeek("ATIVO"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "ATIVO"
					TRB->VALCONT	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALCONT	+= QR1->VALOR
				ENDIF
			ENDIF
			IF QR1->DEBITO >= "1150                " .AND. QR1->DEBITO <= "1150ZZZZZZZZZZZZZZZZ" .OR. QR1->DEBITO >= "2220                " .AND. QR1->DEBITO <= "2220ZZZZZZZZZZZZZZZZ"
				IF 	!TRB->(dbSeek("COMPENSACAO ENTRADA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "COMPENSACAO ENTRADA"
					TRB->VALCONT	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALCONT	+= QR1->VALOR
				ENDIF
			ENDIF
			IF QR1->DEBITO >= "1140                " .AND. QR1->DEBITO <= "1140ZZZZZZZZZZZZZZZZ" .OR. QR1->DEBITO >= "2230                " .AND. QR1->DEBITO <= "2230ZZZZZZZZZZZZZZZZ"
				IF 	!TRB->(dbSeek("COMPENSACAO SAIDA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "COMPENSACAO SAIDA"
					TRB->VALCONT	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALCONT	+= QR1->VALOR
				ENDIF
			ENDIF
			IF SUBSTR(cNumEmp,1,2) $ '01_10'   // MASIPACK/FABRIMA
				IF ALLTRIM(QR1->DEBITO) = "220400001" .AND. !SUBSTR(QR1->TPHIST,1,11) = "ICMS S.NAC."
					IF 	!TRB->(dbSeek("ICMS ENTRADA"))
						RecLock("TRB",.T.)
						TRB->DESPESAS  	:= "ICMS ENTRADA"
						TRB->VALCONT	:= QR1->VALOR
					ELSE
						RecLock("TRB",.F.)
						TRB->VALCONT	+= QR1->VALOR
					ENDIF
				ENDIF
				///HELSIMPLAST
			ELSE
				IF (ALLTRIM(QR1->DEBITO) = "110800001" .Or. ALLTRIM(QR1->DEBITO) = "220400001") .AND. !SUBSTR(QR1->TPHIST,1,11) = "ICMS S.NAC."
					IF 	!TRB->(dbSeek("ICMS ENTRADA"))
						RecLock("TRB",.T.)
						TRB->DESPESAS  	:= "ICMS ENTRADA"
						TRB->VALCONT	:= QR1->VALOR
					ELSE
						RecLock("TRB",.F.)
						TRB->VALCONT	+= QR1->VALOR
					ENDIF
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->DEBITO) = "380010001" .OR. (ALLTRIM(QR1->DEBITO) ="330100026" .AND. SUBSTR(QR1->TPHIST,11,9) = "FRETE DEV")
				IF 	!TRB->(dbSeek("DEVOLUCAO DE VENDAS"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "DEVOLUCAO DE VENDAS"
					TRB->VALCONT	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALCONT	+= QR1->VALOR
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->CREDITO) = "220400001"
				IF 	!TRB->(dbSeek("ICMS SAIDA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "ICMS SAIDA"
					TRB->VALCONT	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALCONT	+= QR1->VALOR
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->CREDITO) = "220400003" .OR. ALLTRIM(QR1->CREDITO) = "220400009"
				IF 	!TRB->(dbSeek("ISS"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "ISS"
					TRB->VALCONT	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALCONT	+= QR1->VALOR
				ENDIF
			ENDIF
			IF SUBSTR(cNumEmp,1,2) $ '01_10'   // FABRIMA
				IF ALLTRIM(QR1->DEBITO) = "220400002" .AND. (!SUBSTR(QR1->TPHIST,1,4) = "DARF")
					IF 	!TRB->(dbSeek("IPI ENTRADA"))
						RecLock("TRB",.T.)
						TRB->DESPESAS  	:= "IPI ENTRADA"
						TRB->VALCONT	:= QR1->VALOR
					ELSE
						RecLock("TRB",.F.)
						TRB->VALCONT	+= QR1->VALOR
					ENDIF
				ENDIF
			ELSE
				IF ALLTRIM(QR1->DEBITO) = "110800002" .OR. ALLTRIM(QR1->DEBITO) = "220400002" .AND. (!SUBSTR(QR1->TPHIST,1,4) = "DARF")
					IF 	!TRB->(dbSeek("IPI ENTRADA"))
						RecLock("TRB",.T.)
						TRB->DESPESAS  	:= "IPI ENTRADA"
						TRB->VALCONT	:= QR1->VALOR
					ELSE
						RecLock("TRB",.F.)
						TRB->VALCONT	+= QR1->VALOR
					ENDIF
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->CREDITO) = "220400002"
				IF 	!TRB->(dbSeek("IPI SAIDA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "IPI SAIDA"
					TRB->VALCONT	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALCONT	+= QR1->VALOR
				ENDIF
			ENDIF
			IF (ALLTRIM(QR1->DEBITO) $ "220400004" .AND. !SUBSTR(QR1->TPHIST,1,4) = "DARF") .OR. (ALLTRIM(QR1->DEBITO) $ "110800013" .And. SUBSTR(cNumEmp,1,2) $ "15_40")
				IF 	!TRB->(dbSeek("PIS ENTRADA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "PIS ENTRADA"
					TRB->VALCONT	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALCONT	+= QR1->VALOR
				ENDIF
			ENDIF
			IF (ALLTRIM(QR1->DEBITO) $ "220400006" .AND. !SUBSTR(QR1->TPHIST,1,4) = "DARF") .OR. (ALLTRIM(QR1->DEBITO) $ "110800014" .And. SUBSTR(cNumEmp,1,2) $ "15_40")
				IF 	!TRB->(dbSeek("COFINS ENTRADA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "COFINS ENTRADA"
					TRB->VALCONT	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALCONT	+= QR1->VALOR
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->CREDITO) $ "220400004"
				IF 	!TRB->(dbSeek("PIS SAIDA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "PIS SAIDA"
					TRB->VALCONT	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALCONT	+= QR1->VALOR
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->CREDITO) $ "220400006" .AND. SUBSTR(QR1->TPHIST,1,15) <> "COFINS 1% CUSTO"
				IF 	!TRB->(dbSeek("COFINS SAIDA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "COFINS SAIDA"
					TRB->VALCONT	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALCONT	+= QR1->VALOR
				ENDIF
			ENDIF
		ELSE
			
			If ALLTRIM(QR1->DEBITO) $ "1401,1101,1651,2101,2401,2651,3101,1102,2102,3127,1124,1125,2124,2125,3101,3127" .OR. (ALLTRIM(QR1->DEBITO) $ "1949" .AND. ALLTRIM(QR1->CLASFIS) $ "13A,13B,12B,12C")
				IF !TRB->(dbSeek("MATERIA-PRIMA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "MATERIA-PRIMA"
					TRB->VALFISCAL	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALFISCAL	+= QR1->VALOR
				ENDIF
			//DEVOLUCAO DE COMPRAS MATERIA-PRIMA
			ElseIf ALLTRIM(QR1->DEBITO)>"4999" .AND. SUBSTR(QR1->TPHIST,1,1) == "D" .AND. !ALLTRIM(QR1->DEBITO) $ "5556,6556"
				IF !TRB->(dbSeek("MATERIA-PRIMA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "MATERIA-PRIMA"
					TRB->VALFISCAL	:= QR1->FT_VALICM+QR1->FT_VALIPI+QR1->FT_VALPIS+QR1->FT_VALCOF
				ELSE
					RecLock("TRB",.F.)
					TRB->VALFISCAL	+= QR1->FT_VALICM+QR1->FT_VALIPI+QR1->FT_VALPIS+QR1->FT_VALCOF
				ENDIF
			ENDIF
			
			// MASIPACK/FABRIMA/Labortube
			IF SUBSTR(cNumEmp,1,2) <> "01"
				IF ALLTRIM(QR1->DEBITO) $ "1124,1125,2124,2125"
					IF 	!TRB->(dbSeek("BENEFICAMENTO"))
						RecLock("TRB",.T.)
						TRB->DESPESAS  	:= "BENEFICAMENTO"
						TRB->VALFISCAL	:= QR1->VALOR
					ELSE
						RecLock("TRB",.F.)
						TRB->VALFISCAL	+= QR1->VALOR
					ENDIF
				ENDIF
				If ALLTRIM(QR1->DEBITO) $ "1124,1125,2124,2125"
					IF !TRB->(dbSeek("MATERIA-PRIMA"))
						RecLock("TRB",.T.)
						TRB->DESPESAS  	:= "MATERIA-PRIMA"
						TRB->VALFISCAL	:= QR1->VALOR
					ELSE
						RecLock("TRB",.F.)
						TRB->VALFISCAL	-= QR1->VALOR
					ENDIF
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->DEBITO) $ "1352,2352" .AND. QR1->TPHIST <> "S"
				IF 	!TRB->(dbSeek("FRETES"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "FRETES"
					TRB->VALFISCAL	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALFISCAL	+= QR1->VALOR
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->DEBITO) = "1252"
				IF 	!TRB->(dbSeek("ENERGIA ELETRICA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "ENERGIA ELETRICA"
					TRB->VALFISCAL	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALFISCAL	+= QR1->VALOR
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->DEBITO) $ "1302,2302"
				IF 	!TRB->(dbSeek("TELEFONE"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "TELEFONE"
					TRB->VALFISCAL	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALFISCAL	+= QR1->VALOR
				ENDIF
			ENDIF
			
			DbSelectArea("SFT")
			SFT->(DbSetOrder(2))
			If DbSeek(xFilial("SFT")+"E"+DTOS(QR1->FT_ENTRADA)+"E  "+QR1->FT_NFISCAL)
				cConta := SFT->FT_CONTA
			ElseIf DbSeek(xFilial("SFT")+"E"+DTOS(QR1->FT_ENTRADA)+"3  "+QR1->FT_NFISCAL)
				cConta := SFT->FT_CONTA
			EndIf

			IF ALLTRIM(QR1->DEBITO) $ "1933,2933" .AND. ALLTRIM(cConta) $ "340100023"
				IF 	!TRB->(dbSeek("INFORMATICA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "INFORMATICA"
					TRB->VALFISCAL	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALFISCAL	+= QR1->VALOR
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->DEBITO) $ "1551,2551,1406,2406"
				IF 	!TRB->(dbSeek("ATIVO"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "ATIVO"
					TRB->VALFISCAL	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALFISCAL	+= QR1->VALOR
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->DEBITO) $ "1901,2901,1902,2902,1912,2912,1913,2913,1915,2915,1916,2916,1925,2925" .OR. (ALLTRIM(QR1->DEBITO) $ "1949,2949,3949" .AND. ALLTRIM(QR1->CLASFIS) $ "00I,00P,01U,040,04A,04B,04V,372")
				IF 	!TRB->(dbSeek("COMPENSACAO ENTRADA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "COMPENSACAO ENTRADA"
					TRB->VALFISCAL	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALFISCAL	+= QR1->VALOR
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->DEBITO) $ "5901,6901,5902,6902,5912,6912,5913,6913,5915,6915,5916,6916,6917" .OR. (ALLTRIM(QR1->DEBITO) $ "5949,6949,7949" .AND. (ALLTRIM(cNat) $ "T03|T09|T15|T04.3|V04.2|T04|T09.1|X04|T17.1|T10"))
				IF 	!TRB->(dbSeek("COMPENSACAO SAIDA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "COMPENSACAO SAIDA"
					TRB->VALFISCAL	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALFISCAL	+= QR1->VALOR
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->DEBITO) <= "4999".AND. QR1->TPHIST <> "S"
				IF 	!TRB->(dbSeek("ICMS ENTRADA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "ICMS ENTRADA"
					TRB->VALFISCAL	:= QR1->FT_VALICM
				ELSE
					RecLock("TRB",.F.)
					TRB->VALFISCAL	+= QR1->FT_VALICM
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->DEBITO) $ "1201,1202,2201,2202,3201" .OR. (ALLTRIM(QR1->DEBITO) $ "1949,2949" .AND. QR1->TPHIST = "D")
				IF 	!TRB->(dbSeek("DEVOLUCAO DE VENDA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "DEVOLUCAO DE VENDA"
					TRB->VALFISCAL	:= QR1->VALOR
				ELSE
					RecLock("TRB",.F.)
					TRB->VALFISCAL	+= QR1->VALOR
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->DEBITO) > "4999,5116,6116" .AND. QR1->TPHIST <> "S" .AND. !ALLTRIM(SUBSTR(QR1->DEBITO,2,3)) = "556"
				IF 	!TRB->(dbSeek("ICMS SAIDA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "ICMS SAIDA"
					TRB->VALFISCAL	:= QR1->FT_VALICM
				ELSE
					RecLock("TRB",.F.)
					TRB->VALFISCAL	+= QR1->FT_VALICM
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->CREDITO) = "E"
				IF 	!TRB->(dbSeek("ISS"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "ISS"
					TRB->VALFISCAL	:= QR1->FT_VALICM
				ELSE
					RecLock("TRB",.F.)
					TRB->VALFISCAL	+= QR1->FT_VALICM
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->DEBITO) <= "4999"
				IF 	!TRB->(dbSeek("IPI ENTRADA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "IPI ENTRADA"
					TRB->VALFISCAL	:= QR1->FT_VALIPI
				ELSE
					RecLock("TRB",.F.)
					TRB->VALFISCAL	+= QR1->FT_VALIPI
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->DEBITO) > "4999" //.AND. ALLTRIM(SUBSTR(QR1->DEBITO,2,3)) <> "910"
				IF 	!TRB->(dbSeek("IPI SAIDA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "IPI SAIDA"
					TRB->VALFISCAL	:= QR1->FT_VALIPI
				ELSE
					RecLock("TRB",.F.)
					TRB->VALFISCAL	+= QR1->FT_VALIPI
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->DEBITO) $ "1101,2101,3101,1124,1125,2124,2125,1401,2401,1651,2651,1252,2252,1352,2352,1202,2202,1201,2201,1102,2102,1122,2122" .OR. (ALLTRIM(QR1->DEBITO) $ "1949,2949" .AND. QR1->TPHIST = "D")
				IF 	!TRB->(dbSeek("PIS ENTRADA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "PIS ENTRADA"
					TRB->VALFISCAL	:= QR1->FT_VALPIS
				ELSE
					RecLock("TRB",.F.)
					TRB->VALFISCAL	+= QR1->FT_VALPIS
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->DEBITO) $ "1101,2101,3101,1124,1125,2124,2125,1401,2401,1651,2651,1252,2252,1352,2352,1202,2202,1201,2201,1102,2102,1122,2122" .OR. (ALLTRIM(QR1->DEBITO) $ "1949,2949" .AND. QR1->TPHIST = "D")
				IF 	!TRB->(dbSeek("COFINS ENTRADA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "COFINS ENTRADA"
					TRB->VALFISCAL	:= QR1->FT_VALCOF
				ELSE
					RecLock("TRB",.F.)
					TRB->VALFISCAL	+= QR1->FT_VALCOF
				ENDIF
			ENDIF
		
			IF ALLTRIM(QR1->DEBITO) $ "5101,6101,5102,6109,6102,5201,6201,5202,6202,5922,6922,5107,6107,5108,6108,5118,6118,5124,6123,5122,6122,5123,6124,5410,5405,5403,6405,6403,5116,6116,5401,6401";
				.OR. (ALLTRIM(QR1->DEBITO) $ "5999,6999,699,599,5933,6933" .AND. ALLTRIM(QR1->CREDITO) $ "E_B")
				IF 	!TRB->(dbSeek("PIS SAIDA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "PIS SAIDA"
					TRB->VALFISCAL	:= QR1->FT_VALPIS
				ELSE
					RecLock("TRB",.F.)
					TRB->VALFISCAL	+= QR1->FT_VALPIS
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->DEBITO) $ "5101,6101,5102,6109,6102,5201,6201,5202,6202,5922,6922,5107,6107,5108,6108,5118,6118,5124,6123,5122,6122,5123,6124,5410,,5405,5403,6405,6403,5116,6116,5401,6401";
				.OR. (ALLTRIM(QR1->DEBITO) $ "5999,6999,699,599,5933,6933" .AND. ALLTRIM(QR1->CREDITO) $ "E_B")
				
				IF 	!TRB->(dbSeek("COFINS SAIDA"))
					RecLock("TRB",.T.)
					TRB->DESPESAS  	:= "COFINS SAIDA"
					TRB->VALFISCAL	:= QR1->FT_VALCOF
				ELSE
					RecLock("TRB",.F.)
					TRB->VALFISCAL	+= QR1->FT_VALCOF
				ENDIF
			ENDIF

			// RECEITAS FISCAL
			DbSelectArea("SD2")
			SD2->(DbSetOrder(3))
			
			IF SUBSTR(cNumEmp,1,2) $ "01"	// masipack
				
				If DbSeek(xFilial("SD2")+QR1->FT_NFISCAL+"3")
					DbSelectArea("SC5")
					SC5->(DbSetOrder(1))
					If DbSeek(xFilial("SC5")+SD2->D2_PEDIDO)
						cNat := SC5->C5_NATUREZ
					EndIf
				Endif
				
			ElseIF SUBSTR(cNumEmp,1,2) $ "10_40_15" //Fabrima / Labortube
				If DbSeek(xFilial("SD2")+QR1->FT_NFISCAL+"1")
					DbSelectArea("SC5")
					SC5->(DbSetOrder(1))
					If DbSeek(xFilial("SC5")+SD2->D2_PEDIDO)
						cNat := SC5->C5_NATUREZ
					EndIf
				Endif
			EndIf
			
			IF ALLTRIM(QR1->DEBITO) $ "5118,6118,6107,5109,6109,5122,6122,6403,5116,6116,5401,6401,5922,6922" .OR. (ALLTRIM(QR1->DEBITO) $ "5101,6101" .AND. !(ALLTRIM(cNat) $ "V04_V04.1"))
				IF 	!TRB2->(dbSeek("VENDA DE PRODUTO"))
					RecLock("TRB2",.T.)
					TRB2->RECEITAS  	:= "VENDA DE PRODUTO"
					TRB2->VALFISCAL	:= QR1->VALOR
				ELSE
					RecLock("TRB2",.F.)
					TRB2->VALFISCAL	+= QR1->VALOR
				ENDIF
			ENDIF			
			
			IF  (ALLTRIM(QR1->DEBITO) $ "5949,6949,5101,6101" .AND. (ALLTRIM(cNat) $ "V04_V04.1"))
				IF 	!TRB2->(dbSeek("VENDA DE SUCATA"))
					RecLock("TRB2",.T.)
					TRB2->RECEITAS  	:= "VENDA DE SUCATA"
					TRB2->VALFISCAL	:= QR1->VALOR
				ELSE
					RecLock("TRB2",.F.)
					TRB2->VALFISCAL	+= QR1->VALOR
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->DEBITO) $ "5102,6102,5110,6110,6108"
				IF 	!TRB2->(dbSeek("REVENDA INSUMOS"))
					RecLock("TRB2",.T.)
					TRB2->RECEITAS  	:= "REVENDA INSUMOS"
					TRB2->VALFISCAL	:= QR1->VALOR
				ELSE
					RecLock("TRB2",.F.)
					TRB2->VALFISCAL	+= QR1->VALOR
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->DEBITO) $ "7101,7102,7127"
				IF 	!TRB2->(dbSeek("EXPORTACAO"))
					RecLock("TRB2",.T.)
					TRB2->RECEITAS  	:= "EXPORTACAO"
					TRB2->VALFISCAL	:= QR1->VALOR
				ELSE
					RecLock("TRB2",.F.)
					TRB2->VALFISCAL	+= QR1->VALOR
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->DEBITO) $ "7501"
				IF 	!TRB2->(dbSeek("EXPORTACOES INDIRETA"))
					RecLock("TRB2",.T.)
					TRB2->RECEITAS  	:= "EXPORTACOES INDIRETA"
					TRB2->VALFISCAL	:= QR1->VALOR
				ELSE
					RecLock("TRB2",.F.)
					TRB2->VALFISCAL	+= QR1->VALOR
				ENDIF
			ENDIF
			IF ALLTRIM(QR1->DEBITO) $ "5551,6551"
				IF 	!TRB2->(dbSeek("VENDA ATIVO FIXO"))
					RecLock("TRB2",.T.)
					TRB2->RECEITAS  	:= "VENDA ATIVO FIXO"
					TRB2->VALFISCAL	:= QR1->VALOR
				ELSE
					RecLock("TRB2",.F.)
					TRB2->VALFISCAL	+= QR1->VALOR
				ENDIF
			ENDIF
		
			IF ALLTRIM(QR1->CREDITO) $ "E_B" .AND. ALLTRIM(QR1->DEBITO) $ "5999,6999,5933,6933"
				IF 	!TRB2->(dbSeek("SERVICOS"))
					RecLock("TRB2",.T.)
					TRB2->RECEITAS  	:= "SERVICOS"
					TRB2->VALFISCAL	:= QR1->VALOR
				ELSE
					RecLock("TRB2",.F.)
					TRB2->VALFISCAL	+= QR1->VALOR
				ENDIF
			ENDIF

			//TOTAL RECEITAS FISCAL
			IF ALLTRIM(QR1->DEBITO) $ "5118,6118,6107,5109,6109,5122,6122,6403,5116,6116,5401,6401,5922,6922" .OR. (ALLTRIM(QR1->DEBITO) $ "5101,6101" .AND. !(ALLTRIM(cNat) $ "V04_V04.1"));
				.OR. (ALLTRIM(QR1->DEBITO) $ "5949,6949,5101,6101" .AND. (ALLTRIM(cNat) $ "V04_V04.1"));
				.OR. (ALLTRIM(QR1->DEBITO) $ "5102,6102,5110,6110,6108");
				.OR. (ALLTRIM(QR1->DEBITO) $ "7101,7102,7127");
				.OR. (ALLTRIM(QR1->DEBITO) $ "7501");
				.OR. (ALLTRIM(QR1->DEBITO) $ "5551,6551");
				.OR. (ALLTRIM(QR1->CREDITO) $ "E_B" .AND. ALLTRIM(QR1->DEBITO) $ "5999,6999,5933,6933")
				IF 	!TRB3->(dbSeek("TOTAL"))
					RecLock("TRB3",.T.)
					TRB3->TOTAL	:= "TOTAL"
					TRB3->VALFISCAL	:= QR1->VALOR
				ELSE
					RecLock("TRB3",.F.)
					TRB3->VALFISCAL	+= QR1->VALOR
				ENDIF
			ENDIF

		ENDIF
		IF MV_PAR03 == 2
			cRegCSV := QR1->LIVRO+";"+DTOC(QR1->FT_ENTRADA)+";"+QR1->FT_NFISCAL+";"+QR1->DEBITO+";"+TRANSFORM(QR1->VALOR,"@E 999,999,999.99")+";"+TRANSFORM(QR1->FT_VALICM,"@E 999,999,999.99")+";"+TRANSFORM(QR1->FT_VALIPI,"@E 999,999,999.99")+";"+TRANSFORM(QR1->FT_VALPIS,"@E 999,999,999.99")+";"+TRANSFORM(QR1->FT_VALCOF,"@E 999,999,999.99")+";"+QR1->TPHIST+";"+QR1->CREDITO
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
			
		ENDIF
		QR1->(dbSkip())
	ENDDO
	
	FClose(cArqCSV)

	QR1->(DbCloseArea())

Return(.T.)


/*/
------------------------------------------------------------------------
Funcao    RptDetail       
Desc.     Impressao do Corpo do Relatorio 
Sitaxe    Void RptDetail(Void)
Autor     Lizandra Marques
Data      18/07/13
------------------------------------------------------------------------
/*/

Static Function RptDetail()

Titulo  := "CONCILIACAO - De " + DTOC(MV_PAR01) + " ate " + DTOC(MV_PAR02)
cCabec1 := "Conferencia Contabil X Fiscal  - Despesas"
cCabec2 := "Despesas                            Fiscal           Contabil          Diferenca   "
//  xxxxxxxxxxxxxxxxxxxxxxxxxx  999,999,999.99     999,999,999.99     999,999,999.99
//  123456789d123456789v123456789t123456789q123456789c123456789s123456789s123456789o
cCabec3 := ""

TRB->(dbGoTop())
TRB2->(dbGoTop())
TRB3->(dbGoTop())
wln := Cabec(Titulo,cCabec1,cCabec2,NomeProg,Tamanho)
wln := wln + 1

// DESPESAS
While !TRB->(Eof())
	
	If lEnd
		@ wln,000 PSAY cCancel
		Exit
	Endif
	
	If wln > 60
		wln := Cabec(Titulo,cCabec1,cCabec2,NomeProg,Tamanho)
		wln += 1
	EndIf
	@ wln,01 PSAY TRB->DESPESAS
	@ wln,29 PSAY TRANSFORM(TRB->VALFISCAL,"@E 999,999,999.99")
	@ wln,48 PSAY TRANSFORM(TRB->VALCONT  ,"@E 999,999,999.99")
	@ wln,66 PSAY TRANSFORM(TRB->VALFISCAL - TRB->VALCONT,"@E 999,999,999.99")
	wln += 1
	TRB->(dbSkip())
ENDDO
wln += 1  

cCabec1 := "Conferencia Contabil X Fiscal  - Despesas"
cCabec2 := "Despesas                            Fiscal           Contabil          Diferenca   "  
nCheck  := 1
wln += 1 
@ wln,000 Psay __PrtFatLine() 
wln += 1

// RECEITAS
While !TRB2->(Eof())
	
	If lEnd
		@ wln,000 PSAY cCancel
		Exit
	Endif
	
	If wln > 60
		wln := Cabec(Titulo,cCabec1,cCabec2,NomeProg,Tamanho)
		wln += 1 
	ElseIf nCheck = 1
		@ wln,01 PSAY "Conferencia Contabil X Fiscal  - Receitas"
		wln += 1
		@ wln,01 PSAY "Receitas                            Fiscal           Contabil          Diferenca   "
		wln += 3
		
	EndIf
	nCheck := 0
	@ wln,01 PSAY TRB2->RECEITAS
	@ wln,29 PSAY TRANSFORM(TRB2->VALFISCAL,"@E 999,999,999.99")
	@ wln,48 PSAY TRANSFORM(TRB2->VALCONT  ,"@E 999,999,999.99")
	@ wln,66 PSAY TRANSFORM(TRB2->VALFISCAL - TRB2->VALCONT,"@E 999,999,999.99")
	wln += 1
	TRB2->(dbSkip())
ENDDO
wln += 1
@ wln,000 Psay __PrtFatLine()
wln += 1

//TOTAL DAS RECEITAS
While !TRB3->(Eof())
	
	If lEnd
		@ wln,000 PSAY cCancel
		Exit
	Endif
	
	If wln > 60
		wln := Cabec(Titulo,cCabec1,cCabec2,NomeProg,Tamanho)
		wln += 1 
	ElseIf nCheck = 0
		@ wln,01 PSAY "Conferencia Contabil X Fiscal  - Receitas"
		wln += 1
		@ wln,01 PSAY "Total Receitas                      Fiscal           Contabil          Diferenca   "
		wln += 2
		nCheck := 1	
	EndIf

	wln += 1
	@ wln,01 PSAY TRB3->TOTAL
	@ wln,29 PSAY TRANSFORM(TRB3->VALFISCAL,"@E 999,999,999.99")
	@ wln,48 PSAY TRANSFORM(TRB3->VALCONT  ,"@E 999,999,999.99")
	@ wln,66 PSAY TRANSFORM(TRB3->VALFISCAL - TRB3->VALCONT,"@E 999,999,999.99")
	wln += 1
	TRB3->(dbSkip())

ENDDO

Roda(CbCont,CbTxt)
TRB2->(dbCloseArea())
TRB->(dbCloseArea())
TRB3->(dbCloseArea())

cDelArq := _cNomTrb1+GetDBExtension()
fErase(cDelArq)
fErase(_cNomTrb1+OrdBagExt())

Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

//-----------------------------------------------------------------------------//
// Programa   fCriaSx1                                                         //
// Autor      Lizandra Marques                                                 //
// Data       17/07/13                                                         //
// Desc.      Funcao para a criacao das perguntas                              //
//-----------------------------------------------------------------------------//

Static Function fCriaSx1()

//--------------------------//
// MV_PAR01 = De emissao ?  //
// MV_PAR02 = Ate Emissao ? //
//--------------------------//

PutSx1(cPerg,"01","De Emissao"        ,"De Emissao"        ,"De Emissao"        ,"mv_ch1","D",08,0,0,"G","","","","","MV_PAR01","","","","","","","","","","","","","","","","",,,)
PutSx1(cPerg,"02","Ate Emissao"       ,"Ate Emissao"       ,"Ate Emissao"       ,"mv_ch2","D",08,0,0,"G","","","","","MV_PAR02","","","","","","","","","","","","","","","","",,,)
PutSx1(cPerg,"03","Tipo do relatorio" ,"Tipo do relatorio" ,"Tipo do relatorio" ,"mv_ch3","N",01,0,0,"C","","","","","MV_PAR03","Sintetico","Sintetico","Sintetico","","Analitico","Analitico","Analitico","","","","","","","","","",,,)

Return
