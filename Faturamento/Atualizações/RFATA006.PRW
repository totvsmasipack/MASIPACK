#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATA006  ºAutor  ³Lizandra Marques    º Data ³  31/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Alteração da data de conclusao                             º±±
±±º          ³ Alteração da data prevista de entrega 18/11/13             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION RFATA006

Local cDesc1       := "Este programa tem como objetivo alterar a data de  "
Local cDesc2       := "conclusão dos PV´s."
Local cDesc3       := "Processamento de Pedidos"
Local cPict        := ""
Local titulo       := "Processamento de Pedidos"
Local nLin         := 80
Local cString	   :="SC5"

Local Cabec1        := "Ocorrencias"
Local Cabec2        := ""
Local imprime       := .T.
Local aOrd          := {}

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "M"
Private nomeprog    := "RFATA006"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
//Private cPerg     := "RFATA5"
Private cPerg       := "XRFATA006"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RFATA006"

Private _cUsuario   := RetCodUsr()
Private _cNomeUsu   := UsrRetName(_cUsuario)
Private _aUsuario   := {}
Private _aGrupos    := {}
Private _cDeptoUsu  := ""
Private _cGrupo     := ""

SC5->(dbSetOrder(1))

pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)
If nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif
nTipo := If(aReturn[4]==1,15,18)
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RunReport ºAutor  ³Lizandra            º Data ³  31/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Chamada do processamento do PV                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local I

_lRet := .T.

PswOrder(1)
If PswSeek(_cUsuario,.T.)
	_aUsuario := PswRet()
	_cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
	For I := 1 to Len(_aGrupos)
		_cGrupo += Upper(Alltrim(GrpRetName(_aGrupos[I]))) + "_"
	Next I
	_cGrupo := SubStr(_cGrupo,1,Len(_cGrupo)-1)
EndIf


SC5->(dbSetOrder(1))

IF SC5->(dbSeek(xFilial("SC5")+MV_PAR01))
	IF MV_PAR03 == 1
		_dData := SC5->C5_MSCONCLU
		
		IF _cUsuario == "000153"
			RecLock("SC5",.F.)
			SC5->C5_MSCONCLU := MV_PAR02
			SC5->(MsUnlock())
		ELSE
			apmsgStop("Rotina executada exclusivamente pelo colaborador Vagner (Montagem)")
			_lRet := .F.
		ENDIF
		IF _lRet
			nLin := 9
			@ nLin,00 PSAY "--> PEDIDO PROCESSADO COM SUCESSO " + MV_PAR01
			nLin++
			@ nLin,00 PSAY "--> Data anterior: " + DTOC(_dData)
			nLin++
			@ nLin,00 PSAY "--> Data atual   : " + DTOC(MV_PAR02)
		ELSE
			nLin := 9
			@ nLin,00 PSAY "--> PEDIDO NAO PROCESSADO. VERIFIQUE ! " + MV_PAR01
			nLin++
		ENDIF
	ELSE
		_dAnt := SC5->C5_MSDTPEN
		IF "QUALIDADE" $ 	_cDeptoUsu .OR. "TI" $ 	_cDeptoUsu
			If (SUBSTR(cNumEmp,1,2) $ '01')   // Masipack
				
				_dDtPen		 := CTOD("")
				_dData		 := CTOD("")
				_nDias		 := 0
				_dDATA1		 := CTOD("")
				_dDATA2		 := CTOD("")
				_dDATA3 		 := CTOD("")
				_dDATA4 		 := CTOD("")
				_dDATA5		 := CTOD("")
				_dDATA6		 := CTOD("")
				_dDATA7		 := CTOD("")
				_dDATA8		 := CTOD("")
				_dDATA9		 := CTOD("")
				_dDATAA		 := CTOD("")
				_dDATAB		 := CTOD("")
				
				dbSelectArea("SC5")
				
				_dDtPen := SC5->C5_MSDTPEN
				
				// MV_NUMPARC = 11 NÚMERO DE PARCELAS
				
				IF SC5->C5_CONDPAG == 'V91' .AND. SC5->C5_MSCATEG == '1' .AND. SC5->C5_MSDTPEN > _dDtPen
					
					_dData := M->C5_MSDTPEN
					
					IF !EMPTY(SC5->C5_DATA1)
						_nDias := SC5->C5_DATA1 - SC5->C5_MSDTENT
						_dDATA1 := _dData + _nDias
					ENDIF
					IF !EMPTY(SC5->C5_DATA2)
						_nDias 		:= SC5->C5_DATA2 - SC5->C5_MSDTENT
						_dDATA2 := _dData + _nDias
					ENDIF
					IF !EMPTY(SC5->C5_DATA3)
						_nDias 		:= SC5->C5_DATA3 - SC5->C5_MSDTENT
						_dDATA3 := _dData + _nDias
					ENDIF
					IF !EMPTY(SC5->C5_DATA4)
						_nDias 		:= SC5->C5_DATA4 - SC5->C5_MSDTENT
						_dDATA4 := _dData + _nDias
					ENDIF
					IF !EMPTY(SC5->C5_DATA5)
						_nDias 		:= SC5->C5_DATA5 - SC5->C5_MSDTENT
						_dDATA5 := _dData + _nDias
					ENDIF
					IF !EMPTY(SC5->C5_DATA6)
						_nDias 		:= SC5->C5_DATA6 - SC5->C5_MSDTENT
						_dDATA6 := _dData + _nDias
					ENDIF
					IF !EMPTY(SC5->C5_DATA7)
						_nDias 		:= SC5->C5_DATA7 - SC5->C5_MSDTENT
						_dDATA7 := _dData + _nDias
					ENDIF
					IF !EMPTY(SC5->C5_DATA8)
						_nDias 		:= SC5->C5_DATA8 - SC5->C5_MSDTENT
						_dDATA8 := _dData + _nDias
					ENDIF
					IF !EMPTY(SC5->C5_DATA9)
						_nDias 		:= SC5->C5_DATA9 - SC5->C5_MSDTENT
						_dDATA9 := _dData + _nDias
					ENDIF
					IF !EMPTY(SC5->C5_DATAA)
						_nDias 		:= SC5->C5_DATAA - SC5->C5_MSDTENT
						_dDATAA := _dData + _nDias
					ENDIF
					IF !EMPTY(SC5->C5_DATAB)
						_nDias 		:= SC5->C5_DATAB - SC5->C5_MSDTENT
						_dDATAB := _dData + _nDias
					ENDIF
					
					
				ENDIF
			ENDIF
			RecLock("SC5",.f.)
			SC5->C5_MSDTPEN  := MV_PAR02 
			SC5->C5_DATA1 := _dDATA1
			SC5->C5_DATA2 := _dDATA2
			SC5->C5_DATA3 := _dDATA3
			SC5->C5_DATA4 := _dDATA4
			SC5->C5_DATA5 := _dDATA5
			SC5->C5_DATA6 := _dDATA6
			SC5->C5_DATA7 := _dDATA7
			SC5->C5_DATA8 := _dDATA8
			SC5->C5_DATA9 := _dDATA9
			SC5->C5_DATAA := _dDATAA
			SC5->C5_DATAB := _dDATAB
			SC5->(MsUnlock())
			
		ELSE
			_lRet := .F.
		ENDIF
		IF _lRet
			nLin := 9
			@ nLin,00 PSAY "--> PEDIDO PROCESSADO COM SUCESSO " + MV_PAR01
			nLin++
			@ nLin,00 PSAY "--> Data Anterior: " + DTOC(_dAnt)
			nLin++
			@ nLin,00 PSAY "--> Data Atual   : " + DTOC(MV_PAR02)
		ELSE
			nLin := 9
			@ nLin,00 PSAY "--> PEDIDO NAO PROCESSADO. VERIFIQUE ! " + MV_PAR01
			nLin++
		ENDIF
	ENDIF
ENDIF

SET DEVICE TO SCREEN

DbSelectArea("SC5")
RetIndex("SC5")

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

RETURN