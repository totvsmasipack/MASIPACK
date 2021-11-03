#Include "Rwmake.ch"      
#Include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFATR048  ³ Autor ³ Aparecida F.Stevanato³ Data ³ 09.11.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±Ã³Descri‡…o ³ Emite Relação de Dan                                      ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFATR048()

LOCAL wnrel		  := "RFATR048"
LOCAL cDesc1	  := "Emissao Relação de DAN - Dados Adicionais Notas Fiscais"
LOCAL cDesc2      := ""  
LOCAL cDesc3      := ""
Private Cabec1    := "Data do    Nota Fiscal      Emitido por                     Setor                    Observações"
Private Cabec2    := "DAN/NF    Serie Numero" 
PRIVATE aOrd      := ""
PRIVATE Titulo	  := "Relação de DAN - Dados Adicionais das Notas Fiscais" 
PRIVATE aReturn   := {"Zebrado", 1,"Administracao", 1, 2, 1, "",1 }	
PRIVATE Tamanho   := "M"
PRIVATE Limite    := 132
PRIVATE nomeprog  := "RFATR048"
PRIVATE cPerg	  := "XRFATR048 " 
PRIVATE nLastKey  := 0
PRIVATE cString   := "SF2"
PRIVATE M_PAG	  := 1
PRIVATE Li        := 80
Private cNomeUsu  := ""
Private _aPortaria := {"01-Portaria MMDC","02-Portaria 31 de Março","03-Expedição"}
Private _cNomeUsu := ""

Pergunte(cPerg,.F.)
                                                 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³                                                              ³ 
//³ mv_par01    Da Data                                          ³
//³ mv_par02    Ate a Data                                       ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)  

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif                                                                                                            

RptStatus({|lEnd| ImpRel(@lEnd,wnrel,cString)},Titulo)

If Select("QR1") > 0 
   DbSelectArea("QR1")
   DbCloseArea()
EndIf 

Return .T.  

Static Function ImpRel(lEnd,wnrel,cString) 

_cQuery := "SELECT F2_MSDTCOL, F2_DOC, F2_SERIE, F2_MSDANUS, F2_MSPORT, F2_MSOBDAN, F2_CLIENTE, F2_LOJA, A1_NREDUZ, F2_EMISSAO "
_cQuery += "FROM " + RetSqlName("SF2") + " F2 "
_cQuery += "INNER JOIN " + RetSqlName("SA1") + " A1 " 
_cQuery += "      ON A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA "
_cQuery += "      AND A1.D_E_L_E_T_ = ' ' AND A1_FILIAL = '" + xFilial("SA1") + "' "  
_cQuery += "WHERE F2_FILIAL = '" + xFilial("SF2") + "' AND F2.D_E_L_E_T_ = ' ' "
_cQuery += "      AND F2_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
IF MV_PAR05 == 1
	_cQuery += " AND F2_MSDTCOL BETWEEN '"+ DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
ELSEIF MV_PAR05 == 2 	
	_cQuery += " AND F2_MSDTCOL = '        ' "
ENDIF
_cQuery += "ORDER BY F2_MSDTCOL, F2_DOC " 

TcQuery _cQuery New Alias "QR1"

Do While ! QR1->(Eof())
   PswOrder(2)
   If !Empty(QR1->F2_MSDANUS)
	   If PswSeek(Alltrim(QR1->F2_MSDANUS),.T.)
   	   _cNomeUsu := Alltrim(UsrFullName(PswRet(1)[1][1]))
	   EndIf
	Else
		_cNomeUsu := ""
	EndIf
   If Li > 60
      cabec(titulo,cabec1,cabec2,nomeprog,Tamanho)
   EndIf
   IF !EMPTY(QR1->F2_MSDTCOL)     
	   @ Li, 000 Psay STOD(QR1->F2_MSDTCOL)
	ELSE   
	   @ Li, 000 Psay STOD(QR1->F2_EMISSAO)
	ENDIF
   If !Empty(QR1->F2_SERIE)
      @ Li, 011 Psay Alltrim(QR1->F2_SERIE)
   EndIf   
   @ Li, 016 Psay Alltrim(QR1->F2_DOC)
   @ Li, 028 Psay SubStr(_cNomeUsu,1,30)
   If !Empty(QR1->F2_MSPORT)
      @ Li, 060 Psay Alltrim(_aPortaria[Val(QR1->F2_MSPORT)])
   EndIf
   IF !EMPTY(QR1->F2_MSDTCOL)     
	   @ Li, 085 Psay Alltrim(QR1->F2_MSOBDAN)
	ELSE   
	   @ Li, 085 Psay (QR1->A1_NREDUZ)
	ENDIF   
   Li++	
   QR1->(DbSkip())
EndDo

If Li > 58
   Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho)
Else
   Li++
   @ Li, 000 Psay Replicate("-",132)
   Li+=2 
EndIf   

If aReturn[5] = 1
	Set Printer TO
	Commit
	OurSpool(wnrel)
EndIf

QR1->(dbCloseArea())
                                                                                       
MS_FLUSH()

Return  .T.