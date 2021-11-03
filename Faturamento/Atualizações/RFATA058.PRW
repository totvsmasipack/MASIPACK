#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATA058  ºAutor  ³Lizandra Marques    º Data ³  28/02/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Transferência de Pedidos                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION RFATA058

Local cDesc1       := "Este programa tem como objetivo transferir de área "
Local cDesc2       := "os pedidos de vendas."
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
Private nomeprog    := "RFATA058"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
//Private cPerg     := "RFATA5"
Private cPerg       := "XRFATA058"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RFATA058"

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
	±±ºPrograma  ³RunReport ºAutor  ³Lizandra            º Data ³  28/02/12   º±±
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

	IF SUBSTR(cNumEmp,1,2) $ "01"
		IF SC5->(dbSeek(xFilial("SC5")+MV_PAR01))
//			IF SC5->C5_MSCATEG $ "0|4|2|3"	//Ivandro Santos - 02/03/18 - alteração: Ticket#2018030237000111
				_cExUsu := SC5->C5_MSNOUSU
				RecLock("SC5",.f.)
				SC5->C5_MSNOUSU := _cNomeUsu
				SC5->C5_MSUSER  := _cUsuario
				If "PROJETOS" $ _cGrupo .OR."ENG" $ _cGrupo
					SC5->C5_MSCATEG := "0"
				Else
					If _cDeptoUsu == "COMERCIAL"
						SC5->C5_MSCATEG := "1"
					ElseIf _cDeptoUsu $ "COMEX/COMERCIAL"
						If SC5->C5_TIPOCLI == "X"
							SC5->C5_MSCATEG := "2"
						Else
							SC5->C5_MSCATEG := "3"
						EndIf
					ElseIf _cDeptoUsu == "VENDA DE PECAS"
						If SC5->C5_TIPOCLI == "X"
							SC5->C5_MSCATEG := "2"
						Else
							SC5->C5_MSCATEG := "3"
						EndIf
					ElseIf _cDeptoUsu == "203-MAKLASER"
						SC5->C5_MSCATEG := "5"
					ElseIf _cDeptoUsu == "ASSIST.TECNICA"
						SC5->C5_MSCATEG := "6"
					Else
						SC5->C5_MSCATEG := "4"
					EndIf
				EndIf
				SC5->(MsUnlock())
//			ELSE
//				_lRet := .F.
//			ENDIF
		ELSE
			_lRet := .F.
		ENDIF
	ELSEIF 	SUBSTR(cNumEmp,1,2) $ "10"
		IF SC5->(dbSeek(xFilial("SC5")+MV_PAR01))
			IF SC5->C5_MSCATEG $ "0|4"
				_cExUsu := SC5->C5_MSNOUSU
				RecLock("SC5",.F.)
	//			SC5->C5_MSNOUSU := _cNomeUsu
				SC5->C5_MSUSER  := _cUsuario
				IF "INFORMATICA" $ _cDeptoUsu .OR. "AT" $ _cDeptoUsu 
					IF SC5->C5_MSCATEG == "4"		
						SC5->C5_MSCATEG := "0"
					ELSE	
						SC5->C5_MSCATEG := "4"
					ENDIF	
				ELSE
					_lRet := .F.
				ENDIF  
				SC5->(MsUnlock())
			ELSE
				_lRet := .F.
			ENDIF
		ELSE
			_lRet := .F.
		ENDIF	
	ENDIF
	IF _lRet
		nLin := 9
		@ nLin,00 PSAY "--> PEDIDO PROCESSADO COM SUCESSO " + MV_PAR01
		nLin++
		@ nLin,00 PSAY "--> Usuario anterior: " + _cExUsu
		nLin++
		@ nLin,00 PSAY "--> Usuario atual   : " + _cNomeUsu
		nLin++ 
		If SUBSTR(cNumEmp,1,2) $ '01_10'   // Masipack/Fabrima 
			@ nLin,00 PSAY "--> Categoria atual : " + SC5->C5_MSCATEG
		EndIf
	ELSE
		nLin := 9
		@ nLin,00 PSAY "--> PEDIDO NAO PROCESSADO. VERIFIQUE ! " + MV_PAR01
		nLin++
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
