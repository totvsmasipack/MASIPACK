
#INCLUDE "PROTHEUS.CH"
#Include "Rwmake.ch"
#include "TOPCONN.CH"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±³Funcao	 ³ RPCPR008³ Autor ³ Aparecida de F.Stevanato ³Data ³  09.12.08 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descricao ³ Relacao de Alteracoes Estruturas X OPs (UPD_SG1)           ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±³Alteração : 11/07/12 - criaçção de query para arquivo de trabalho      ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

User Function RPCPR008()

PRIVATE titulo      := "Alteracoes de Estruturas X OPs "
PRIVATE cString     := ""
PRIVATE wnrel       := "RPCPR008"
PRIVATE aReturn     := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }     
PRIVATE nomeprog    := "RPCPR008"
PRIVATE cPerg	    := "XRPCPR008 "
PRIVATE cArqTrab    := ""
PRIVATE cFilTrab    := ""
PRIVATE nLastKey    := 0
PRIVATE Li          := 99
PRIVATE cabec1      := ""
PRIVATE cabec2      := ""
PRIVATE tamanho     := "M"
PRIVATE limite      := 132
PRIVATE CbCont      := 0
Private cUsuario    := ""
Private cCod        := ""
Private cComp       := ""
Private cCodAnt     := ""
Private nEmpenho    := 0
Private nEmpenhado  := 0
Private nReq        := 0
Private nQuant      := 0
Private lPrim       := .F.
Private _fDel       := .F.
Private nAlt        := 0
Private cArqTXT     := "c:\relato_microsiga\RPCPR008.txt"
Private cArqTXT2    := "c:\relato_microsiga\Estruturas_alteradas.txt"
Private cRegTXT     := ""
Private cQtde       := ""
Private cGrvVen     := ""
Private DtRevManual := CTOD("")
Private dDtIni      := CTOD("")

Pergunte(cPerg,.F.)

wnrel :=SetPrint(cString,wnrel,cPerg,@titulo,,,,.F.,,,Tamanho)

If nLastKey==27
	Set Filter to
	Return
Endif

If mv_par05 == 1
	tamanho := "P"
	limite  := 80
	titulo  := "Estruturas Alteradas" // - Periodo de: " + DTOC(mv_par01) + " ate: " + DTOC(Date())
	cabec2  :=  "COMPONENTE/REV      DESCRIÇÃO                                QTDE UM    DATA"
	Cabec1  := "Periodo de: " + DTOC(mv_par01) + " ate: " + DTOC(Date())
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif



GeraTrab()

If mv_par05 == 1
	RptStatus({|lEnd| ImpEstru(@lEnd,wnRel,cString)},titulo)
Else
	RptStatus({|lEnd| ImpRel(@lEnd,wnRel,cString)},titulo)
EndIf

dbSelectArea("TRB")
dbCloseArea()
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta arquivos de trabalho.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Ferase(cArqTrab+GetDBExtension())
Ferase(cArqTrab+OrdBagExt())
Ferase(cFilTrab+OrdBagExt())
*/
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif


MS_FLUSH()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraTrab  ºAutor  ³Lizandra Marques    º Data ³  11/07/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geração do arquivo de trabalho                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraTrab()

Local aCampos  := {}
Local oTable

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{ "COD"      ,"C",15,0 } )
AADD(aCampos,{ "COMP"     ,"C",15,0 } )
AADD(aCampos,{ "INI"      ,"D",8,0 } )
AADD(aCampos,{ "TRT"      ,"C",3,0 } )
AADD(aCampos,{ "QUANT"    ,"N",14,3 } )
AADD(aCampos,{ "QTDANT"   ,"N",14,3 } )
AADD(aCampos,{ "USUARIO"  ,"C",10,0 } )
AADD(aCampos,{ "FANTASM"  ,"C",1,0 } )
AADD(aCampos,{ "DELETADO" ,"C",1,0 } )

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Select("TRB") > 0
	DbSelectArea("TRB")
	TRB->(DbCloseArea())
EndIf

oTable := FWTemporaryTable():New("TRB",aCampos)
oTable:AddIndex( "IND1", {'COD','COMP'} )
oTable:Create()

If Select("QR1") > 0 
	DbSelectArea("QR1")
	QR1->(DbCloseArea())
EndIf

_cQuery := " SELECT G1_COD, G1_COMP, G1_MSDTINI, G1_TRT, G1_QUANT, G1.D_E_L_E_T_ AS DELETADO, "
_cQuery += "        G1_MSUSER, B1_FANTASM, B1_UM "
_cQuery += " FROM " + RetSqlName("SG1") + " G1 "
_cQuery += " INNER JOIN " + RetSqlName("SB1") + " B1 "
_cQuery += "       ON B1_COD = G1_COMP AND B1_FILIAL = '" + xFilial("SB1") + "' AND B1.D_E_L_E_T_ = ' '  "
_cQuery += " WHERE G1_FILIAL = '" + xFilial("SG1") + "' AND G1_MSATUOP <> 'N' "

IF MV_PAR03 == 2
	_cQuery += "  AND SUBSTRING(G1_COMP,1,3) <> 'MOD' AND  SUBSTRING(G1_COMP,1,2) NOT IN ('TS','MP') "
ENDIF

//VICTOR DESSUNTE - 04/04/2016
//FILTRA USUARIO - SOLICITADO POR WADA
If !Empty(MV_PAR04)
	_cQuery += " AND G1_MSUSER LIKE '%" + ALLTRIM(MV_PAR04) + "%' "
EndIf

_cQuery += "  AND G1_MSDTINI BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "'" 

TcQuery _cQuery New Alias "QR1"

TcSetField("QR1","G1_MSDTINI","D",08,00)
TcSetField("QR1","G1_QUANT"  ,"N",12,02)



Do While QR1->(!EOF())
	If QR1->DELETADO == "*" //SG1->(Deleted())
		_fDel := .T.
		nQuant  := 0
	Else
		_fDel := .F.
		nQuant  := QR1->G1_QUANT
	EndIf
	
	If QR1->B1_FANTASM == "S" .And. Alltrim(QR1->B1_UM) == "CJ"
		cCod     := QR1->G1_COD
		cComp    := QR1->G1_COMP
		dDtIni   := QR1->G1_MSDTINI
		cUsuario := QR1->G1_MSUSER
		SG1->(DbSetOrder(1))
		SG1->(DbGotop())
		If SG1->(DbSeek(xFilial("SG1")+cComp))
			Do While SG1->(!EOF()) .And. SG1->G1_COD == cComp
				If SG1->(Deleted())
					_fDel   := .T.
					If SG1->G1_MSDTINI < mv_par01
						SG1->(DbSkip())
					Else
						nQuant := 0
					EndIf
				Else
					_fDel   := .F.
				EndIf
				dbSelectArea("TRB")
				If !TRB->(DbSeek(cCod+SG1->G1_COMP))
					RecLock("TRB",.T.)
					TRB->COD     := cCod
					TRB->COMP    := SG1->G1_COMP
					TRB->INI     := dDtIni
					TRB->TRT     := SG1->G1_TRT
					TRB->QTDANT  := SG1->G1_QUANT
					TRB->QUANT   := nQuant * SG1->G1_QUANT
					TRB->USUARIO := cUsuario
					TRB->FANTASM := "S"
					If _fDel
						TRB->DELETADO := "*"
					EndIf
				Else
					RecLock("TRB")
					TRB->QUANT   := nQuant * SG1->G1_QUANT
				EndIf
				TRB->(MsUnLock())
				SG1->(DbSkip())
			EndDo
		EndIf
	Else
		dbSelectArea("TRB")
		If !TRB->(DbSeek(QR1->G1_COD+QR1->G1_COMP))
			RecLock("TRB",.T.)
			TRB->COD     := QR1->G1_COD
			TRB->COMP    := QR1->G1_COMP
			TRB->INI     := QR1->G1_MSDTINI
			TRB->TRT     := QR1->G1_TRT
			TRB->QTDANT  := QR1->G1_QUANT
			TRB->QUANT   := nQuant
			TRB->USUARIO := QR1->G1_MSUSER
			TRB->FANTASM := "N"
		Else
			If QR1->DELETADO == " " //SG1->(Deleted())
				RecLock("TRB")
				TRB->QUANT   := nQuant
				_fDel := .F.
			Else
				RecLock("TRB")
				_fDel := .T.
				If TRB->FANTASM <> "S"
					TRB->QUANT   := nQuant
				Else
					TRB->QTDANT  := QR1->G1_QUANT
				EndIf
			EndIf
		EndIf
		If _fDel
			TRB->DELETADO := "*"
		EndIf
		TRB->(MsUnLock())
	EndIf
	QR1->(DbSkip())
	Loop
EndDo
QR1->(dbCloseArea())
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpEstru  ºAutor  ³Microsiga           º Data ³  11/07/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function ImpEstru(lEnd,WnRel,cString)

//Set Dele On

SG1->(DbSetOrder(1))
SG1->(DbGoTop())
SB1->(DbSetOrder(1))
SB1->(DbGoTop())
SZI->(DbSetOrder(1))
SZI->(DbGoTop()) 

dbSelectArea("TRB")
TRB->(dbGoTop())

IndRegua("TRB",cArqTrab,"COD+COMP",,,"Selecionando Registros...") //"Selecionando Registros..."

SetRegua(RecCount())           	              // TOTAL DE ELEMENTOS DA REGUA

m_pag  := 1
Li 	   := 80

mv_par07 := Upper(Alltrim(mv_par07))

Do While ! TRB->(EOF())
	
	If lEnd
		@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"
		Exit
	EndIf
	
	cDesc := ""
	
	If mv_par07 <> "" .And. SubStr(mv_par07,1,2) <> "ZZ" .And. mv_par07 <> Alltrim(TRB->COD)
		TRB->(DbSkip())
		Loop
	EndIf
	
	DtRevManual := CTOD("")
	If SZI->(DbSeek(xFilial("SZI")+TRB->COD))
		Do While ! SZI->(EOF()) .And. Alltrim(SZI->ZI_CODIGO) == Alltrim(TRB->COD)
			DtRevManual := SZI->ZI_DTREVIS
			SZI->(DbSkip())
			Loop
		EndDo
	EndIf
	
	If mv_par06 == 1
		If DtRevManual >= TRB->INI
			TRB->(DbSkip())
			Loop
		Endif
	EndIf
	
	If TRB->COD <> cCodAnt
		SB1->(DbSeek(xFilial("SB1")+TRB->COD))
		If Alltrim(SB1->B1_UM) == "CJ"
			TRB->(DbSkip())
			Loop
		EndIf
		cDesc   := SB1->B1_DESC
		cRev    := SB1->B1_REVATU
		cGrpVen := Alltrim(SB1->B1_MSGRVEN)
		If SG1->(DbSeek(xFilial("SG1")+TRB->COD))
			Do While ! SG1->(EOF()) .And. Alltrim(SG1->G1_COD) == Alltrim(TRB->COD)
				If SubStr(SG1->G1_COMP,1,3) == "MOD" .Or. SubStr(SG1->G1_COMP,1,2) $ "TS_MP"
					SG1->(DbSkip())
					Loop
				EndIf
				If !SG1->(Deleted())
					If Li > 65
						Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
						If !Empty(cRev)
							@Li,000 Psay "Produto: " + Alltrim(TRB->COD) + "/" + cRev + " - " + cDesc
						Else
							@Li,000 Psay "Produto: " + Alltrim(TRB->COD) + " - " + cDesc
						EndIf
						@Li,070 Psay "Grupo: " + cGrpVen
						Li++
						@Li,000 Psay "Revisão do Manual: "
						If !Empty(DtRevManual)
							@Li,020 Psay DTOC(DtRevManual)
						EndIf
						Li+=2
					Else
						If cCodAnt <> TRB->COD
							@Li,000 Psay Replicate("=",80)
							Li++
							If !Empty(cRev)
								@Li,000 Psay "Produto: " + Alltrim(TRB->COD) + "/" + cRev + " - " + cDesc
							Else
								@Li,000 Psay "Produto: " + Alltrim(TRB->COD) + " - " + cDesc
							EndIf
							@Li,070 Psay "Grupo: " + cGrpVen
							Li++
							@Li,000 Psay "Revisão do Manual: "
							If !Empty(DtRevManual)
								@Li,020 Psay DTOC(DtRevManual)
							EndIf
							Li+=2
						EndIf
					EndIf
					If SB1->(DbSeek(xFilial("SB1")+SG1->G1_COMP))
						If !Empty(Alltrim(SB1->B1_REVATU))
							@Li,000 Psay Alltrim(SG1->G1_COMP) + "/" + Alltrim(SB1->B1_REVATU)
						Else
							@Li,000 Psay Alltrim(SG1->G1_COMP)
						EndIf
						@Li,019 Psay SB1->B1_DESC
					Else
						@Li,000 Psay Alltrim(SG1->G1_COMP) + " - " + "Produto não cadastrado"
					EndIf
					@Li,058 Psay SG1->G1_QUANT Picture "@E 999.999"
					@Li,066 Psay SB1->B1_UM
					@Li,071 Psay SG1->G1_MSDTINI
					cCodAnt := TRB->COD
					Li++
				EndIf
				SG1->(DbSkip())
				Loop
			EndDo
		EndIf
	EndIf
	TRB->(IncRegua())
	TRB->(DbSkip())
	Loop
EndDo


Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±³Funcao	 ³ ImpRel	³     Impressao do Relatorio                        ³±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Static Function ImpRel(lEnd,WnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

m_pag   := 1
Li 	    := 80

If (cArqTXT := FCreate("C:\Relato_Microsiga\RPCPR008.TXT")) == -1
	Alert("Arquivo Texto não pode ser criado - Avise o Depto. de Informática")
EndIf

mv_par03 := Alltrim(mv_par03)

Cabec1 := "Periodo de: " + DTOC(mv_par01) + " ate: " + DTOC(MV_PAR02) + " - Usuario: "
If Empty(mv_par03) .Or. SubStr(mv_par03,1,2) == "ZZ"
	Cabec1 += "Todos"
Else
	Cabec1 += mv_par03
EndIf
dbSelectArea("TRB")
TRB->(dbGoTop())

IndRegua("TRB",cArqTrab,"DTOS(INI)+COD+COMP",,,"Selecionando Registros...") 

SetRegua(RecCount())           	              // TOTAL DE ELEMENTOS DA REGUA

SB1->(DbSetOrder(1))
SB1->(DbGoTop())
SC2->(DbSetOrder(2))
SC2->(DbGoTop())

Do While ! TRB->(EOF())
	
	If lEnd
		@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	If SubStr(mv_par03,1,2) <> "ZZ" .And. !Empty(mv_par03) .And. UPPER(mv_par03) <> UPPER(Alltrim(TRB->USUARIO))
		TRB->(DbSkip())
		Loop
	EndIf
	
	If SB1->(DbSeek(xFilial("SB1")+TRB->COMP))
		If Alltrim(SB1->B1_FANTASM) == "S"
			TRB->(DbSkip())
			Loop
		EndIf
	EndIf
	
	If !SC2->(DbSeek(xFilial("SC2")+TRB->COD))
		TRB->(DbSkip())
		Loop
	EndIf
	
	lPrim := .T.
	cCod  := TRB->COD
	Do While SC2->(!EOF()) .And. SC2->C2_PRODUTO == cCod
		
		If SC2->(Deleted())
			SC2->(DbSkip())
			Loop
		EndIf
		
		If !Empty(SC2->C2_DATRF)
			SC2->(DbSkip())
			Loop
		EndIf
		
		If SC2->C2_EMISSAO >= TRB->INI
			SC2->(DbSkip())
			Loop
		EndIf
		
		nReq       := 0
		nEmpenhado := 0
		nEmpenho   := SC2->C2_QUANT * TRB->QUANT
		//SD4->(DbSetOrder(7))
		SD4->(DBORDERNICKNAME("OPTRTCOD"))
		If SD4->(DbSeek(xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+Space(2)+TRB->TRT+TRB->COMP))
			Do While !SD4->(Eof()) .And. Alltrim(SD4->D4_OP)+SD4->D4_COD == SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+TRB->COMP
				If !SD4->(Deleted())
					nEmpenhado += SD4->D4_QTDEORI
					nReq       += SD4->D4_QTDEORI - SD4->D4_QUANT
				EndIf
				SD4->(DbSkip())
			EndDo
		EndIf
		
		If nEmpenhado == 0
			//VICTOR DESSUNTE - 24/03/2017
			//INICIO - TICKET:2016102737000172
			_cQry := "	SELECT " + CRLF
			_cQry += "		ISNULL(SUM(D3_QUANT),0) TOT " + CRLF
			_cQry += "	FROM " + CRLF
			_cQry += 		RetSqlName("SD3")
			_cQry += "	WHERE " + CRLF
			_cQry += "			D_E_L_E_T_	= ' ' " + CRLF
			_cQry += "	AND 	D3_FILIAL	= '" + xFilial("SD3") + "' " + CRLF
			_cQry += "	AND 	D3_CF			LIKE 'RE%' " + CRLF
			_cQry += "	AND 	D3_OP			= '" + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN + "' " + CRLF
			_cQry += "	AND 	D3_COD		= '" + Alltrim(TRB->COMP) + "' " + CRLF
			_cQry += "	AND 	D3_ESTORNO	= '' "
			
			If Select("TRBD3") > 0
				TRBD3->(dbCloseArea())
			EndIf
			
			TCQUERY _cQry NEW ALIAS "TRBD3"
			
			TRBD3->(dbGoTop())
			If TRBD3->(!EOF()) .AND. TRBD3->TOT > 0
				nReq += TRBD3->TOT
			EndIf
			
			If Select("TRBD3") > 0
				TRBD3->(dbCloseArea())
			EndIf
			//FIM - TICKET:2016102737000172
			
			nEmpenhado := nReq
		EndIf
		nEmpenho -= nEmpenhado
		
		If nEmpenho <> 0
			If lPrim
				lPrim := .F.
				If Li > 60
					Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
					cRegTxt := "RPCPR008 - Itens Incluidos/Alterados em estruturas e sua relação com as OP's"
					FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
					cRegTxt := ""
					FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
					cRegTxt := Cabec1
					FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
					cRegTxt := ""
					FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
					cRegTxt := Replicate("=",132)
					FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
					Li := 8
				Else
					cRegTxt := Replicate("-",132)
					@Li,000 Psay cRegTxt
					FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
					cRegTxt :=""
					FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
					Li+=2
				EndIf
				cQtde := Transform(TRB->QTDANT,"9999.999")
				cRegTxt := "Estrut.: " + TRB->COD + TRB->DELETADO + " Compon.: " + TRB->COMP + "-" +SubStr(SB1->B1_DESC,1,22) + " Local: " + SB1->B1_LOCAL + " Seq.: " + TRB->TRT + " Qtde:"+cQtde+" Usuario:"+TRB->USUARIO
				@Li,000 Psay cRegTxt
				Li+=2
				FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
				cRegTxt := ""
				FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
			EndIf
			If Li > 60
				Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
				cRegTxt := "RPCPR008 - Itens Incluidos/Alterados em estruturas e sua relação com as OP's - Data: "+DTOC(mv_par01)+ " Ate "+ DTOC(MV_PAR02)
				FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
				cRegTxt := ""
				FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
				cRegTxt := Replicate("=",132)
				FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
				Li := 8
			EndIf
			cRegTxt := Space(3)+SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + " - Qtde.: "+ Str(SC2->C2_QUANT,3)+ Space(1)
			If !Empty(SC2->C2_MSPOSIC)
				cRegTxt += "EM PROC. "
			Else
				If !Empty(SC2->C2_MSIMPR)
					cRegTxt += "IMPRESSA "
				Else
					cRegTxt += Space(9)
				EndIf
			EndIf
			cRegTxt += SC2->C2_MSREDUZ
			If SB1->(DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
				cRegTxt += Space(1) + SubStr(SB1->B1_DESC,1,33)
			Else
				cRegTxt += Space(1) + "Produto não cadastrado        "
			EndIf
			cRegTxt += Space(2) + DTOC(SC2->C2_EMISSAO)
			cRegTxt += Space(2) + SC2->C2_MSPED
			If nEmpenho < 0
				cQtde := Transform(nEmpenho * (-1),"9999")
			Else
				cQtde := Transform(nEmpenho,"9999")
			EndIf
			If nEmpenho < 0
				If nReq > 0
					cRegTxt += Space(2) + "DEVOLVER:  +" + Alltrim(cQtde)
				Else
					cRegTxt += Space(2) + "EMPENHAR:  -" + Alltrim(cQtde)
				EndIf
			Else
				cRegTxt += Space(2) +"EMPENHAR:  +" + Alltrim(cQtde)
			EndIf
			cRegTxt +=Space(3)+"("+DTOC(TRB->INI)+ ")"
			
			@Li,000 Psay cRegTxt
			FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
			cRegTxt := ""
			FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
			Li++
			nAlt++
		EndIf
		SC2->(DbSkip())
		Loop
	EndDo
	dbSelectArea("TRB")
	IncRegua()
	TRB->(DbSkip())
	Loop
EndDo

If nAlt > 0
	Li+=2
	If Li+20 > 65
		Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
		Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
		cRegTxt := "RPCPR008 - Itens Incluidos/Alterados em estruturas e sua relação com as OP's - Data: "+DTOC(mv_par01)+ " Ate "+ DTOC(MV_PAR02)
		FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
		cRegTxt := ""
		FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
		cRegTxt := Replicate("=",132)
		FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	EndIf
	cRegTxt := ""
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := Replicate("*",055) + "  L  E  G  E  N  D  A  "+ Replicate("*",054)
	@Li,000 Psay cRegTxt
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := ""
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	Li+=2
	cRegTxt := "EM PROCESSO   -> Lista foi separada - peças estão na Montagem"
	@Li,000 Psay cRegTxt
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := ""
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	Li+=2
	cRegTxt := "IMPRESSA      -> Lista foi apenas impressa - seus itens ainda não foram separados."
	@Li,000 Psay cRegTxt
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := ""
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	Li+=2
	cRegTxt := "DEVOLVER      -> Montagem deve devolver peças excedentes, que já foram separadas."
	@Li,000 Psay cRegTxt
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := ""
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	Li+=2
	cRegTxt := "EMPENHAR      -> Item foi adicionado ou teve sua qtde. alterada."
	@Li,000 Psay cRegTxt
	Li++
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := ""
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := Space(17) + "PCP deve ser avisado para adicionar ou subtrair esse item das listas."
	@Li,000 Psay cRegTxt
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := ""
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	Li++
	cRegTxt := Space(17) + "A data de inclusão/alteração de um item na estrutura e seu empenho tem relação direta com a data de entrega"
	@Li,000 Psay cRegTxt
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := ""
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	Li++
	cRegTxt := Space(17) + "do Pedido de Vendas."
	@Li,000 Psay cRegTxt
	Li++
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := ""
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := Space(17) + "Antes de gerar as listas, verifique como está a data de entrega do PV."
	@Li,000 Psay cRegTxt
	Li++
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := ""
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := Space(17) + "Isso Poupa Tempo: "
	@Li,000 Psay cRegTxt
	Li++
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := ""
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := Space(17) + "a) da Montagem (não é  necessário preencher Requisição Avulsa);"
	@Li,000 Psay cRegTxt
	Li++
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := ""
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := Space(17) + "b) do Almoxarifado (reduz o numero de paradas por peças que a Montagem solicita individualmente);"
	@Li,000 Psay cRegTxt
	Li++
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := ""
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := Space(17) + "c) do PCP (tem conhecimento antes que a peça falte e não precisa analisar a saída por Requisição Avulsa)."
	@Li,000 Psay cRegTxt
	Li++
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := ""
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := Space(17) + "d) do Almoxarifado (não precisa separar o item desnecessariamente);"
	@Li,000 Psay cRegTxt
	Li++
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := ""
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := Space(17) + "e) da Montagem (não precisarão devolver o item, preenchendo a Devolução Avulsa);"
	@Li,000 Psay cRegTxt
	Li++
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := ""
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := Space(17) + "f) da Engenharia (evita o preenchimento das Devoluções Avulsas exigidas pela Montagem);"
	@Li,000 Psay cRegTxt
	Li++
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := ""
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := Space(17) + "g) da Produção (eventualmente o item nem precisa ser fabricado)."
	@Li,000 Psay cRegTxt
	Li++
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
	cRegTxt := ""
	FWrite(cArqTXT,cRegTXT+chr(13)+chr(10))
EndIf

FClose(cArqTXT)

If apMsgYesNo("Deseja abrir o arquivo pelo Bloco de Notas ?")
	WinExec("NOTEPAD "+ "c:\relato_microsiga\RPCPR008.txt")
EndIf

Return
