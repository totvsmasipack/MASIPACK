#include "Protheus.ch"
#include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCOMR023  บAutor  ณLizandra Marques    บ Data ณ  29/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRanking de fornecedor                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - MASIPACK                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCOMR023()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis obrigatorias dos programas de relatorio            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

titulo:="Ranking Fornecedores"
cDesc1:="Esse programa tem por finalidade imprimir o relatorio de"
cDesc2:="Ranking de Fornecedores"
cDesc3:=""
cString:="SF1"
wnrel:="RCOMR023"
tamanho:="M"
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis padrao de todos os relatorios                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aReturn:={ "Zebrado", 1,"Compras", 1, 2, 1, "",1 }

nLastkey:=0
cPerg:="XRCOMR023"

nTipo:=15
m_pag:=0
cabec1:=""
cabec2:=""
nomeprog:="RCOMR023"
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica as perguntas selecionadas                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

fCriaSx1()	// Funcao para criacao das perguntas da rotina.


Pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Envia controle para a funcao SETPRINT                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.)
If nLastKey == 27
	set filter to
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	set filter to
	Return
Endif

RptStatus({|| ImpCom23()}, )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpCOM23   บAutor  ณLizandra	        บ Data ณ  29/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Chamada do relatorio                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - Masipack                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static FUNCTION ImpCom23

Local _aCampos	:= {}

IF Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
ENDIF

_cQuery := " SELECT " + CRLF
_cQuery += "	ISNULL(F1_DOC,'')			F1_DOC		, " + CRLF
_cQuery += "	ISNULL(F1_SERIE,'')		F1_SERIE		, " + CRLF
_cQuery += "	A2_COD										, " + CRLF
_cQuery += "	A2_LOJA										, " + CRLF
_cQuery += "	A2_NOME										, " + CRLF
_cQuery += "	ISNULL(F1_DTDIGIT,'')	F1_DTDIGIT	, " + CRLF
_cQuery += "	ISNULL(F1_ESPECIE,'')	F1_ESPECIE	, " + CRLF
_cQuery += "	ISNULL(D1_TOTAL,'')		D1_TOTAL		, " + CRLF
_cQuery += "	ISNULL(D1_VALIPI,'')		D1_VALIPI	, " + CRLF
_cQuery += "	ISNULL(D1_CF,'')			D1_CF			, " + CRLF
_cQuery += "	A2_MSFESPE									, " + CRLF
_cQuery += "	A2_MSBLQL									, " + CRLF
_cQuery += "	A2_NATUREZ " + CRLF
_cQuery += " FROM " + CRLF
_cQuery += 		RetSqlName("SA2") + " A2 " + CRLF

_cQuery += "	LEFT JOIN " + RetSqlName("SF1") + " F1 " + CRLF
_cQuery += "	ON	F1.D_E_L_E_T_	= ' ' " + CRLF
_cQuery += "	AND F1_FILIAL		= '" + xFilial("SF1") + "' " + CRLF
_cQuery += "	AND F1_FORNECE		= A2_COD " + CRLF
_cQuery += "	AND F1_LOJA			= A2_LOJA " + CRLF
_cQuery += "	AND F1_DTDIGIT		BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' " + CRLF
_cQuery += "	AND F1_ESPECIE		<> 'FATUR' " + CRLF
_cQuery += "	AND F1_TIPO			= 'N'  " + CRLF

_cQuery += "	LEFT JOIN " + RetSqlName("SD1") + " D1 " + CRLF
_cQuery += "	ON	D1.D_E_L_E_T_	= ' ' " + CRLF
_cQuery += "	AND D1_DOC			= F1_DOC  " + CRLF
_cQuery += "	AND D1_SERIE		= F1_SERIE " + CRLF
_cQuery += "	AND D1_FORNECE		= F1_FORNECE " + CRLF
_cQuery += "	AND D1_LOJA			= F1_LOJA " + CRLF
_cQuery += "	AND D1_DTDIGIT		= F1_DTDIGIT " + CRLF
_cQuery += "	AND D1_FILIAL		= '" + xFilial("SD1") + "' " + CRLF
IF MV_PAR04 == 1
	_cQuery += "        AND D1_PEDIDO <> '      ' " + CRLF 
ELSEIF MV_PAR04 == 2	
	_cQuery += "        AND D1_PEDIDO = '      ' " + CRLF
ENDIF	

_cQuery += "	LEFT JOIN " + RetSqlName("SF4") + " F4 " + CRLF
_cQuery += "	ON	F4.D_E_L_E_T_	= ' ' " + CRLF
_cQuery += "	AND F4_DUPLIC		= 'S' " + CRLF
_cQuery += "	AND F4_FILIAL		= '" + xFilial("SF4") + "' " + CRLF
_cQuery += "	AND F4_CODIGO		= D1_TES " + CRLF
_cQuery += " WHERE " + CRLF
_cQuery += "		A2.D_E_L_E_T_	= ' ' " + CRLF
_cQuery += " AND 	A2_FILIAL		= '" + xFilial("SA2") + "' " + CRLF

IF MV_PAR05 == 2        
	_cQuery += " AND 	A2_NATUREZ IN('A01','A05') " + CRLF
ELSEIF MV_PAR05 == 3	
	_cQuery += " AND A2_NATUREZ NOT IN ('A01','A05') " + CRLF
ENDIF	

_cQuery += " ORDER BY A2_COD,A2_LOJA " + CRLF


/*
_cQuery := " SELECT F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, A2_NOME, F1_DTDIGIT, F1_ESPECIE, "
_cQuery += "        D1_TOTAL, D1_VALIPI, D1_CF, A2_MSFESPE "
_cQuery += " FROM " + RetSqlName("SF1") + " F1 "
_cQuery += " INNER JOIN " + RetSqlName("SA2") + " A2 "
_cQuery += "       ON A2_COD = F1_FORNECE AND A2_LOJA = F1_LOJA "
_cQuery += " INNER JOIN " + RetSqlName("SD1") + " D1 "
_cQuery += "       ON D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE "
_cQuery += "       AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND D1_DTDIGIT = F1_DTDIGIT "
_cQuery += " INNER JOIN " + RetSqlName("SF4") + " F4 "
_cQuery += "       ON F4_CODIGO = D1_TES "
_cQuery += " WHERE F1_TIPO = 'N' AND F1_DTDIGIT BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
_cQuery += "       AND F4_DUPLIC = 'S' AND F1_ESPECIE <> 'FATUR' "
IF MV_PAR04 == 1
	_cQuery += "        AND D1_PEDIDO <> '      ' " 
ELSEIF MV_PAR04 == 2	
	_cQuery += "        AND D1_PEDIDO = '      ' " 
ENDIF	
IF MV_PAR05 == 2        
	_cQuery += " AND (A2_NATUREZ = 'A01' OR A2_NATUREZ = 'A05') "
ELSEIF MV_PAR05 == 3	
	_cQuery += " AND A2_NATUREZ NOT IN ('A01','A05') "          
ENDIF	

_cQuery += "       AND F1_FILIAL = '" + xFilial("SF1") + "' AND F1.D_E_L_E_T_ = ' ' "
_cQuery += "       AND A2_FILIAL = '" + xFilial("SA2") + "' AND A2.D_E_L_E_T_ = ' ' "
_cQuery += "       AND F4_FILIAL = '" + xFilial("SF4") + "' AND F4.D_E_L_E_T_ = ' ' "
_cQuery += " ORDER BY F1_FORNECE, F1_LOJA "*/

TcQuery _cQuery New Alias "QR1"

TcSetField("QR1","F1_DTDIGIT","D",08,00)
TcSetField("QR1","D1_TOTAL"  ,"N",12,2)
TcSetField("QR1","D1_VALIPI" ,"N",12,2)

//_aCampos := { 	{"TM_CLIENTE"		,"C",06,00 	},;
//{"TM_LOJA"		,"C",02,00 	},;
//{"TM_NOME"		,"C",30,00	},;
//{"TM_ESPEC"		,"C",01,00	},;
//{"TM_TOTAL"		,"N",12,02	},;
//{"TM_BLQL"		,"C",03,00	} }

//_cArqTmp	:= Criatrab(_aCampos,.t.)
//_cIndTmp	:= Criatrab(,.f.)

//DbUseArea(.t.,,_cArqTmp,"TMP",.f.,.f.)

AADD(_aCampos,{ "TM_CLIENTE"	,"C", 06,0,"@!" } )
AADD(_aCampos,{ "TM_LOJA"    ,"C", 02,0,"@!" } )
AADD(_aCampos,{ "TM_NOME"    ,"C", 30,0,"@!" } )
AADD(_aCampos,{ "TM_ESPEC"   ,"C", 01,0,"@!" } )
AADD(_aCampos,{ "TM_TOTAL"   ,"N", 12,2,"@E 9.999.999.999,99" } )
AADD(_aCampos,{ "TM_BLQL"    ,"C", 03,0,"@!" } )

oTable := FWTemporaryTable():New("TMP",_aCampos)
oTable:Create()

cUM := "  "

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para Impressao do Cabecalho e Rodape  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cbtxt    := Space(10)
cbcont   := 00
li       := 80
m_pag    := 01

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Definicao dos cabecalhos                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
titulo := "RANKING DE FORNECEDORES "+DTOC(MV_PAR01) + " ate " + DTOC(MV_PAR02)
//*********0        1         2         3         4         5         6         7         8         9       100       110       120         
//*********123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
cabec1 := "CODIGO    RAZAO SOCIAL                           BLOQUEADO             VALOR     %PARTIC.     ACUMULADO      CLASS."
//         999999/99 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx            xxx       999,999,999,99       99.99                       X
cabec2 := ""
nFat:=0

QR1->(dbGoTop())

_nServ := 0
_nMP	 := 0
_nOut	 := 0
_nRK	 := 0
_nMPI	 := 0
_nTotG := 0

DO WHILE ! QR1->(Eof())
	_cFornece := QR1->A2_COD + QR1->A2_LOJA
	_lPrimeiro := .t.
	Do WHILE ! QR1->(Eof()) .And. _cFornece == QR1->A2_COD + QR1->A2_LOJA
		IF _lPrimeiro
			RecLock("TMP",.T.)
			TMP->TM_CLIENTE := QR1->A2_COD
			TMP->TM_LOJA    := QR1->A2_LOJA
			TMP->TM_ESPEC	 := QR1->A2_MSFESPE
			TMP->TM_NOME    := SUBSTR(QR1->A2_NOME,1,30)
			TMP->TM_BLQL    := IIF(QR1->A2_MSBLQL=='1','SIM','NAO')
			_lPrimeiro 		 := .f.
		ELSE
			RecLock("TMP",.F.)
		ENDIF
		
		TMP->TM_TOTAL += QR1->D1_TOTAL + QR1->D1_VALIPI
		TMP->(MsUnLock())

		IF QR1->D1_CF $ "1101 ,2101 ,1401 ,2401 ,1124 ,2124 ,1651 ,2651 " 
			_nMP	 += QR1->D1_TOTAL + QR1->D1_VALIPI
//		ELSEIF QR1->F1_ESPECIE $ "NFPS" 	
//			_nServ += QR1->D1_TOTAL + QR1->D1_VALIPI
		ELSEIF QR1->D1_CF $ "3127 ,3101 " 	
			_nMPI += QR1->D1_TOTAL + QR1->D1_VALIPI
		ELSE 	
	  		_nOut	 += QR1->D1_TOTAL + QR1->D1_VALIPI
	  	ENDIF	
		_nTotG += QR1->D1_TOTAL + QR1->D1_VALIPI

		QR1->(DbSkip())

	ENDDO
ENDDO

QR1->(DbCloseArea())

_nRK	 := 0
_nCont := 0

//IndRegua("TMP",_cIndTmp,"((TMP->TM_TOTAL)*-1)",,,"Indexando...")
TMP->(DbGotop())
_nCurva := 0
_cClas  := ""	
While _nCont <= MV_PAR03 .AND. !TMP->(EOF())
	
	IF li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	@li, 001 PSAY TMP->TM_CLIENTE + "/" + TMP->TM_LOJA
	@li, 011 PSAY TMP->TM_NOME 
	@li, 053 PSAY TMP->TM_BLQL
	@li, 063 PSAY TRANSFORM(TMP->TM_TOTAL,"@E 999,999,999.99")
	@li, 084 PSAY TRANSFORM((TMP->TM_TOTAL/_nTotG)*100,"@E 99.99")    
	_nCurva += (TMP->TM_TOTAL/_nTotG)*100
	@li, 097 PSAY TRANSFORM(_nCurva,"@E 999.99")    
	IF _nCurva <= 80 	
		@li, 112 PSAY "A"                 
		_cClas  := "A"	
	ELSE	
		IF TMP->TM_ESPEC == "S"
			@li, 112 PSAY "A"                 
			_cClas  := "A"	
		ELSE	
			@li, 112 PSAY "B"
			_cClas  := "B"	
		ENDIF	
	ENDIF	          

	IF MV_PAR06 == 2  // RECLASSIFICA TODOS OS FORNECEDORES COMO "B" PARA DEPOIS ATUALIZAR A CLASSIFICAวรO - 08/05/15 - LIZANDRA
		dbSelectArea("SA2")
		SA2->(dbGoTop())
		//DO WHILE !EOF()
		//	RecLock("SA2",.f.)
		//	SA2->A2_RISCO := "B"
		//	SA2->(MsUnLock())
		//	dbSkip()
		//ENDDO
		// ATUALIZA A CLASSIFICAวรO DE ACORDO COM A INSTRUวรO DE TRABALHO - 08/05/15 - LIZANDRA				
		dbSeek(xFilial("SA2") +TMP->TM_CLIENTE + TMP->TM_LOJA)
		RecLock("SA2",.f.)
		SA2->A2_RISCO := _cClas
		SA2->(MsUnLock())

	ENDIF	
	
	Li++
	_nCont++
	_nRK += TMP->TM_TOTAL
	
	dbSelectArea("TMP")
	TMP->(DBSKIP())

ENDDO

IF li > 55
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
ENDIF
@ Li,000 PSAY __PrtFatLine()
Li:=li+1
@li,001 PSAY "TOTAL GERAL: " + TRANSFORM((_nMP+_nServ+_nOut+_nMPI),"@E 999,999,999.99")
@li,041 PSAY "TOTAL RANKING: " + TRANSFORM(_nRK,"@E 999,999,999.99")
Li +=2 
IF li > 55
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
ENDIF
@li,001 PSAY "PRODUTIVOS: " + TRANSFORM(_nMP,"@E 999,999,999.99")
li++
//@li,001 PSAY "SERVICOS  : " + TRANSFORM(_nServ,"@E 999,999,999.99")
//li++
@li,001 PSAY "OUTROS    : " + TRANSFORM(_nOut,"@E 999,999,999.99")
li++
@li,001 PSAY "IMPORTACAO: " + TRANSFORM(_nMPI,"@E 999,999,999.99")

TMP->(DbCloseArea())

//Ferase(_cArqTmp+".DBF")
//Ferase(_cIndTmp+OrdBagExt())

Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCriaSx1  บAutor  ณLizandra            บ Data ณ  29/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณcriacao de perguntas.                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fCriaSx1()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMV_PAR01 = Data Inicial          ณ
//ณMV_PAR02 = Data final            ณ
//ณMV_PAR03 = Ranking               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

PutSx1(cPerg,"01","Data Inicial" ,"Data Inicial","Data Inicial" ,"mv_ch1","D",08,0,0,"G","","","","","MV_PAR01","","","","","","","","","","","","","","","","",,,)
PutSx1(cPerg,"02","Data Final" ,"Data Final","Data Final" ,"mv_ch2","D",08,0,0,"G","","","","","MV_PAR02","","","","","","","","","","","","","","","","",,,)
PutSx1(cPerg,"03","Ranking" ,"Ranking","Ranking" ,"mv_ch3","N",6,0,0,"G","","","","","MV_PAR03","","","","","","","","","","","","","","","","",,,)
PutSx1(cPerg,"04","NF com PC" ,"NF com PC","NF com PC","mv_ch4","N",01,0,0,"C","","","","","MV_PAR04","Sim","Sim","Sim","","Nao","Nao","Nao","Todos","Todos","Todos","","","","","","",,,)
PutSx1(cPerg,"05","Tipo fornecedor" ,"Tipo fornecedor","Tipo fornecedor","mv_ch5","N",01,0,0,"C","","","","","MV_PAR05","Todos","Todos","Todos","","Produtivos","Produtivos","Produtivos","Improdutivos","Improdutivos","Improdutivos","","","","","","",,,)
PutSx1(cPerg,"06","Atualiza fornecedor" ,"Atualiza fornecedor","Atualiza fornecedor","mv_ch6","N",01,0,0,"C","","","","","MV_PAR06","Nao","Nao","Nao","","Sim","Sim","Sim","","","","","","","","","",,,)

Return
