#Include "Topconn.ch"
#Include "Rwmake.ch"

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北矲un噮o    � RCOMR010  � Autor � Solange Ap.Vezu      � Data � 10.05.07 潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北矰escri噮o � Emissao da Rela玢o de Notas Fiscais com Impostos           潮�  
北�            ISS / INSS / IRRF / PIS / COFINS / CSLL                    潮�  
北�            Reescrito em 07/01/13 - Lizandra                           潮�  
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
/*/
User Function RCOMR010()
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Define Variaveis                                             �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁

LOCAL wnrel		   := "RCOMR010"
LOCAL aOrd        := {}
LOCAL cDesc1	   := "Emissao de Rela鏰o de Notas Fiscais com ISS/INSS/IRRF"    
PRIVATE Titulo	   := "Notas Fiscais"    
PRIVATE aReturn   := {"Zebrado", 1,"Administracao", 1, 2, 1, "",1 }	
PRIVATE Tamanho   := "M"
PRIVATE Limite    := 132
PRIVATE nomeprog  := "RCOMR010"
PRIVATE nLastKey  := 0
PRIVATE cString   := "SF1"
PRIVATE M_PAG	   := 1
PRIVATE Li        := 99
Private cPerg	   := "XRCOMR010 "
Private Cabec1    := ""
Private Cabec2    := ""  
Private _cForn    := ""
Private _cLoja    := ""
Private _NumDup   := ""
Private _QtdDup   := 0
Private nTotISS   := 0
Private nTotINS   := 0
Private nTotIRF   := 0
Private nTotPIS   := 0
Private nTotCOF   := 0
Private nTotCSL   := 0
Private nTotMer   := 0
Private nTotImp   := 0

Pergunte(cPerg,.F.)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Envia controle para a funcao SETPRINT                        �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁 

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,,,.F.,aOrd,.F.,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| RCOM10Imp(@lEnd,wnrel,cString,Tamanho)},Titulo) 

Return NIL


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  砇COM10Imp  篈utor  矻izandra           � Data �  07/01/13   罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     � Chamada do relatorio                                       罕�
北�          �                                                            罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � AP - Masipack                                              罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/

Static Function RCOM10Imp(lEnd,wnrel,cString,Tamanho)  
                                                            
If Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
EndIf

_cQuery := " SELECT F1_DOC, F1_SERIE, F1_DTDIGIT, F1_FORNECE, A2_NREDUZ, F1_VALMERC, "
_cQuery += "        F1_ISS, F1_INSS, F1_IRRF, F1_VALIMP6, F1_VALPIS, F1_VALIMP5, F1_VALCOFI, "
_cQuery += "        F1_VALIMP4, F1_VALCSLL "
_cQuery += " FROM " + RetSqlName("SF1") + " F1 " 
_cQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 ON A2_COD = F1_FORNECE
_cQuery += " WHERE F1_DTDIGIT BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
_cQuery += "       AND F1_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
_cQuery += "       AND F1_FORNECE BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
_cQuery += "       AND F1_DOC BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
_cQuery += "       AND F1_SERIE BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
//_cQuery += "       AND (F1_ISS + F1_INSS + F1_IRRF + F1_VALIMP4 + F1_VALIMP5 + F1_VALIMP6 + F1_VALPIS + F1_VALCOFI + F1_VALCSLL) > 0 "
_cQuery += "       AND (F1_VALCSLL > 0 OR F1_ISS > 0 OR F1_INSS > 0  OR F1_IRRF > 0) "
_cQuery += "       AND F1_FILIAL = '" + xFilial("SF1") + "' AND F1.D_E_L_E_T_ = ' ' "
_cQuery += "       AND A2_FILIAL = '" + xFilial("SA2") + "' AND SA2.D_E_L_E_T_ = ' ' "
_cQuery += " ORDER BY F1_DOC "      

TcQuery _cQuery New Alias "QR1"

TcSetField("QR1","F1_DTDIGIT" ,"D",08,00)
TcSetField("QR1","F1_VALMERC" ,"N",12,02)
TcSetField("QR1","F1_ISS"     ,"N",12,02)
TcSetField("QR1","F1_INSS"    ,"N",12,02)
TcSetField("QR1","F1_IRRF"    ,"N",12,02)
TcSetField("QR1","F1_VALIMP6" ,"N",12,02)
TcSetField("QR1","F1_VALPIS"  ,"N",12,02)
TcSetField("QR1","F1_VALIMP5" ,"N",12,02)
TcSetField("QR1","F1_VALIMP4" ,"N",12,02)
TcSetField("QR1","F1_VALCSLL" ,"N",12,02)

QR1->(DbGoTop())


Cabec1  := "N.F.     SER  DATA DE    FORNECEDOR               TOTAL DA                         I  M  P  O  S  T  O  S                   TOTAL DE"   
Cabec2  := "              DIGITA敲O                             N.F.        ISS       INSS      IRRF       PIS     COFINS      CSLL     IMPOSTOS"   
Titulo := "Rela玢o de Notas Fiscais com Impostos retidos  -  " + " De: "+dtoc(mv_par01)+" at�: "+dtoc(mv_par02)       
mv_par09 := UPPER(mv_par09)                  
mv_par10 := UPPER(mv_par10)                  

SetRegua(LastRec())                           


While QR1->(!EOF())
	If lEnd     
		@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"   
		Exit
	Endif
  	IncRegua() 
  	
   If Li > 62
      cabec(titulo,cabec1,cabec2,nomeprog,Tamanho)
   EndIf
   
   @ Li,000 PSAY QR1->F1_DOC
   @ Li,010 PSAY QR1->F1_SERIE
   @ Li,014 PSAY QR1->F1_DTDIGIT
   @ Li,025 PSAY SUBSTR(QR1->A2_NREDUZ,1,20)
   @ Li,047 PSAY QR1->F1_VALMERC 						Picture "@E 9,999,999.99"
   @ Li,060 PSay QR1->F1_ISS  							Picture "@E 99,999.99"                                                  
   @ Li,069 PSay QR1->F1_INSS 							Picture "@E 99,999.99"
   @ Li,079 PSay QR1->F1_IRRF 							Picture "@E 99,999.99"
   //If QR1->F1_VALIMP6 > 0
   //   @ Li,088 PSay QR1->F1_VALIMP6                   	Picture "@E 99,999.99"
   //Else   
      @ Li,089 PSay QR1->F1_VALPIS                     	Picture "@E 99,999.99"
   //EndIf
   //If QR1->F1_VALIMP5 > 0
   //   @ Li,098 PSay QR1->F1_VALIMP5                   	Picture "@E 99,999.99"
   //Else  
      @ Li,099 PSay QR1->F1_VALCOFI                    	Picture "@E 99,999.99"
   //EndIf 
   //If QR1->F1_VALIMP4 > 0
   //   @ Li,108 PSay QR1->F1_VALIMP4                   	Picture "@E 99,999.99"
   //Else    
      @ Li,109 PSay QR1->F1_VALCSLL                     Picture "@E 99,999.99"
   //EndIf   
   @ Li,121 PSay QR1->F1_ISS+QR1->F1_INSS+QR1->F1_IRRF+QR1->F1_VALPIS+QR1->F1_VALCOFI+QR1->F1_VALCSLL Picture "@E 99,999.99" 
   Li++
   nTotMer := nTotMer + QR1->F1_VALMERC
   nTotIss := nTotIss + QR1->F1_ISS
   nTotIns := nTotIns + QR1->F1_INSS
   nTotIrf := nTotIrf + QR1->F1_IRRF
   nTotPis := nTotPis + QR1->F1_VALPIS //+ QR1->F1_VALIMP6
   nTotCof := nTotCof + QR1->F1_VALCOFI //+ QR1->F1_VALIMP5
   nTotCsl := nTotCsl + QR1->F1_VALCSLL //+ QR1->F1_VALIMP4
   nTotImp := nTotImp + QR1->F1_ISS+QR1->F1_INSS+QR1->F1_IRRF+QR1->F1_VALPIS+QR1->F1_VALCOFI+QR1->F1_VALCSLL  

   QR1->(dbSkip())
   Loop
EndDo               

QR1->(dbCloseArea())
    
@ Li+2,045 Psay "-------------------------------------------------------------------------------------" 

@ Li+3,047 PSay nTotMer Picture "@E 9,999,999.99"
@ Li+3,059 PSay nTotIss Picture "@E 99,999.99"
@ Li+3,069 PSay nTotIns Picture "@E 99,999.99"
@ Li+3,079 PSay nTotIrf Picture "@E 99,999.99"
@ Li+3,089 PSay nTotPis Picture "@E 99,999.99"
@ Li+3,099 PSay nTotCof Picture "@E 99,999.99"
@ Li+3,109 PSay nTotCsl Picture "@E 99,999.99"
@ Li+3,121 PSay nTotImp Picture "@E 99,999.99"

Set Device To Screen
Set Filter To

If aReturn[5] = 1
	Set Printer To
	dbCommit()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return .t.	         
