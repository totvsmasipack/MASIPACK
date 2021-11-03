#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR005  ºAutor  ³Adriano Luis Brandaoº Data ³  27/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de impressao das etiquetas de serie.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK.                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR005()

Local cDesc1         := "Este programa tem como objetivo imprimir etiquetas "
Local cDesc2       	:= "de series dos produtos de venda."
Local cDesc3       	:= ""
Local cPict    	  	:= ""
Local titulo       	:= "Etiqueta Series"
Local nLin         	:= 80
Local Cabec1       	:= ""
Local Cabec2       	:= ""
Local imprime      	:= .T.
Local aOrd           := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "RFATR005" 
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "RFATR005" 
Private cPerg        := "XRFATR005 " 
Private cString := "AA3"

dbSelectArea("AA3")
dbSetOrder(1)                           

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| _fImpEtiq() })

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_fImpEtiq ºAutor  ³Adriano Luis Brandaoº Data ³  27/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de impressao de etiquetas.                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK.                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _fImpEtiq()

_nCont   := 0
_nLin		:= 80

// Montagem da regua de impressao
DbOrderNickName("AA3_PEDPRO")
   
AA3->(DbSeek(xFilial("AA3")+MV_PAR01,.T.))
Do While ! AA3->(Eof()) .And. MV_PAR01 == AA3->AA3_MSPED
   _nCont++
   AA3->(DbSkip())
EndDo
SetRegua(_nCont*2)

AA3->(DbSeek(xFilial("AA3")+MV_PAR01,.T.))

// Primeira etiqueta
While ! AA3->(Eof()) .And. MV_PAR01 == AA3->AA3_MSPED

   IncRegua()
   If lEnd
      @ _nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
   
//	_aEtiq := Array(2,4)
	_aEtiq := Array(2,5)
	_cDesc := Posicione("SB1",1,xFilial("SB1")+AA3->AA3_CODPRO,"B1_DESC")
   _aEtiq[1,1] := AA3->AA3_CODPRO
//   _aEtiq[1,1] := SUBSTR(_cDesc,1,18)
   _aEtiq[1,2] := AA3->AA3_MSPED
   _aEtiq[1,3] := Left(AA3->AA3_NUMSER,4)
   _aEtiq[1,4] := Alltrim(AA3->AA3_NUMSER)
   _aEtiq[1,5] := SUBSTR(_cDesc,1,25) 
   
	AA3->(DbSkip())
	
	If ! AA3->(Eof()) .And. MV_PAR01 == AA3->AA3_MSPED

	   IncRegua()
		_cDesc := Posicione("SB1",1,xFilial("SB1")+AA3->AA3_CODPRO,"B1_DESC")
//   	_aEtiq[2,1] := SUBSTR(_cDesc,1,18)
	   _aEtiq[2,1] := AA3->AA3_CODPRO
	   _aEtiq[2,2] := AA3->AA3_MSPED
	   _aEtiq[2,3] := Left(AA3->AA3_NUMSER,4)
	   _aEtiq[2,4] := Alltrim(AA3->AA3_NUMSER)
	   _aEtiq[2,5] := SUBSTR(_cDesc,1,25) 
	
		AA3->(DbSkip())  
		
	Else
	   _aEtiq[2,1] := ""
	   _aEtiq[2,2] := ""
	   _aEtiq[2,3] := ""
	   _aEtiq[2,4] := ""
	   _aEtiq[2,5] := ""
	EndIf                            

// XXXXXXXXXXXXXXX  XXXXXX      XXXXXXXXXXXXXXX  XXXXXX
//
// XXXX         XXXXXXXXXX      XXXX         XXXXXXXXXX
//
// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16
   If _nLin > 52
      _nLin := 0
   EndIf
   
   If _nLin > 0
      _nLin++
	   @ _nLin,000 Psay "|"                                   
	   @ _nLin,031 Psay "|"
       @ _nLin,063 Psay "|"
   EndIf

   _nLin++ 	
   @ _nLin,000 Psay "| "
	@ _nLin,002 Psay _aEtiq[1,1]
	@ _nLin,021 Psay _aEtiq[1,2]
	@ _nLin,031 Psay "|"
	@ _nLin,033 Psay _aEtiq[2,1]
	@ _nLin,052 Psay _aEtiq[2,2]
	@ _nLin,063 Psay "|"
	
	_nLin++
	@ _nLin,000 Psay "|"
	@ _nLin,002 Psay _aEtiq[1,5]
	@ _nLin,031 Psay "|"
	@ _nLin,033 Psay _aEtiq[2,5]
	@ _nLin,063 Psay "|" 
	
	_nLin++
	@ _nLin,000 Psay "|"
	@ _nLin,031 Psay "|"
	@ _nLin,063 Psay "|"
	
   _nLin++
	@ _nLin,000 Psay "|"
	@ _nLin,002 Psay _aEtiq[1,3]
	@ _nLin,019 Psay _aEtiq[1,4]
	@ _nLin,031 Psay "| " 
	@ _nLin,033 Psay _aEtiq[2,3]
	@ _nLin,050 Psay _aEtiq[2,4]
	@ _nLin,063 Psay "|" 
	
   _nLin++
   @ _nLin,000 Psay "|------------------------------"
   @ _nLin,031 Psay "|-------------------------------|" 
   
EndDo            

//
// Segunda Etiqueta.
//
SC5->(DbSetOrder(1))

AA3->(DbSeek(xFilial("AA3")+MV_PAR01,.T.))

While ! AA3->(Eof()) .And. MV_PAR01 == AA3->AA3_MSPED

   IncRegua()
   If lEnd
      @ _nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
   
	_aEtiq := Array(2,6)

	SC5->(DbSeek(xFilial("SC5")+MV_PAR01))
	SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJAENT))
	
   _aEtiq[1,1] := SA1->A1_NREDUZ
   _aEtiq[1,2] := AA3->AA3_MSPED
   _aEtiq[1,3] := Alltrim(AA3->AA3_NUMSER)
   _aEtiq[1,4] := SC5->C5_VOLTAGE
   _aEtiq[1,5] := SC5->C5_HZ
   _aEtiq[1,6] := Left(AA3->AA3_NUMSER,4) 
   
	AA3->(DbSkip())
	
	If ! AA3->(Eof()) .And. MV_PAR01 == AA3->AA3_MSPED

	   IncRegua()
	   _aEtiq[2,1] := SA1->A1_NREDUZ
       _aEtiq[2,2] := AA3->AA3_MSPED
	   _aEtiq[2,3] := Alltrim(AA3->AA3_NUMSER)
   	   _aEtiq[2,4] := SC5->C5_VOLTAGE
	   _aEtiq[2,5] := SC5->C5_HZ
   	   _aEtiq[2,6] := Left(AA3->AA3_NUMSER,4) 
	
		AA3->(DbSkip())
   Else
	   _aEtiq[2,1] := ""
   	   _aEtiq[2,2] := ""
	   _aEtiq[2,3] := ""
   	   _aEtiq[2,4] := ""
	   _aEtiq[2,5] := ""
   	   _aEtiq[2,6] := ""
	EndIf                            

// XXXXXXXXXXXXXXXXXXXX         XXXXXXXXXXXXXXXXXXXX
// PED:XXXXXX  SER: XXXXXXXXXX  PED:XXXXXX  SER: XXXXXXXXXX  
// XXX    XX                    XXX    XX
// XXXX                         XXXX
// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16
	
   If _nLin > 52
      _nLin := 0
   EndIf
   
   If _nLin > 0 
      _nLin++
	   @ _nLin,000 Psay "|"
	   @ _nLin,031 Psay "|"
	   @ _nLin,063 Psay "|"
	EndIf   
   
	_nLin++
	@ _nLin,000 Psay "|"
	@ _nLin,002 Psay _aEtiq[1,1]
	@ _nLin,031 Psay "|"
	@ _nLin,033 Psay  _aEtiq[2,1]
	@ _nLin,063 Psay "|"
	
	_nLin++
	@ _nLin,000 Psay "| PED: " + _aEtiq[1,2]
	@ _nLin,014 Psay "SER: " + _aEtiq[1,3]
	If ! Empty(_aEtiq[2,1])
		@ _nLin,031 Psay "| PED: "  + _aEtiq[2,2]
		@ _nLin,045 Psay "SER: "  + _aEtiq[2,3]
	EndIf
	@ _nLin,063 Psay "|"
	
	_nLin++
	@ _nLin,000 Psay "|"
	@ _nLin,002 Psay _aEtiq[1,4]
	@ _nLin,009 Psay _aEtiq[1,5]
	@ _nLin,031 Psay "|"
	@ _nLin,033 Psay _aEtiq[2,4]
	@ _nLin,040 Psay _aEtiq[2,5]
	@ _nLin,063 Psay "|"
	
	_nLin++
	@ _nLin,000 Psay "|"
	@ _nLin,002 Psay _aEtiq[1,6]
	@ _nLin,031 Psay "|"
	@ _nLin,033 Psay _aEtiq[2,6]
	@ _nLin,063 Psay "|"
	
	_nLin++  
	@ _nLin,000 Psay "|------------------------------"
   @ _nLin,031 Psay "|-------------------------------|" 
EndDo            

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return