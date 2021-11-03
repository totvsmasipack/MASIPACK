#Include "Rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"                              

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³RPCPA011  ºAutor  ³Aparecida de F.Stevanatoº Data  08/02/11 º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.     ³Manutencao na tabela SZU (Geracao automatica de OPs)        º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function RPCPA011()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro      := "Geração Automatica de OPs"
Private _cUsuario      := RetCodUsr()
Private _aUsuario      := {}
Private _cDeptoUsu     := ""
Private _cUsuSenha     := ""
Private _fRet          := .T.
Private _lRet          := .T.
Private _cFiltro       := ""
Private	lMsErroAuto    := .F.            	// Indica se gerou erro na Transacao
Private lMsHelpAuto    := .T.
Private lAutoErrNoFile := .F.
Private _aOpsSC2       := {}
Private _nNumOP        := 0
Private _nQtdOP        := 0
Private _lOK           := .F.
Private aAreaSZU       := {}
Private _cOPS          := ""
Private _cObs          := ""
Private _cObs2         := ""
Private _cStatus       := ""
Private _cPath         := "\system\"
Private _cArqLog       := ""
Private _cNumCI        := ""
Private _dDataCI       := CTOD("")
Private _c
Private cPerg          := "PCPA11" + Space(4)        // Parametros para gerar as OPs automaticamente
Private _cPerg         := "RPCPA011A "   // ROTEIRO DE OPERAÇÕES
Private _cTipo := ""
// mv_par01 -> Status
// mv_par02 -> Data do Arquivo
// mv_par03 -> Usuario
// mv_par04 -> Procedencia
// mv_par05 -> Unidade/Grupo  // Elimina os Conjuntos e Grupo 90

Private aRotina   := {{"Pesquisa" ,"AxPesqui"      ,0,1} ,;   // Pesquisa
{"Visualiza","AxVisual"      ,0,2} ,;   // Visualiza
{"Altera"   ,"AxAltera"      ,0,4} ,;   // Altera
{"Cancela OPs" ,"U_CancOPs()",0,6} ,;   // Gera OPs
{"Gera OPs" ,"U_GeraOPs()"   ,0,7}}     // Gera OPs

PswOrder(1)
If PswSeek(_cUsuario,.T.)
	_aUsuario := PswRet()
	_cUsuSenha := UsrRetName(_cUsuario)
	_cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
EndIf

If !Pergunte(cPerg,.T.)
	Return
EndIf

//_cArqLog := "LogOPs_"+_cUsuSenha

dbSelectArea("SZU")
SZU->(dbSetOrder(1))

_cFiltro := ""

// Filtra Status do APV
If mv_par01 == 1
	_cFiltro := '(Alltrim(SZU->ZU_STATUS) == "A")'
	_cTipo := "A"
ElseIf mv_par01 == 2
	_cFiltro := '(Alltrim(SZU->ZU_STATUS) == "G")'
	_cTipo := "G"
ElseIf mv_par01 == 3
	_cFiltro := '(Alltrim(SZU->ZU_STATUS) == "C")'
	_cTipo := "C"
ElseIf mv_par01 == 4
	_cFiltro := '(Alltrim(SZU->ZU_STATUS) == "R")'
	_cTipo := "R"
EndIf

// Filtra Data do Arquivo
If !Empty(mv_par02)
	If !Empty(Alltrim(_cFiltro))
		_cFiltro += ' .And. '
	EndIf
	_cFiltro += '(SZU->ZU_DATA == mv_par02)'
EndIf

// Filtra Usuario
If SubStr(mv_par03,1,2) <> "ZZ" .And. Alltrim(mv_par03) <> ""
	If !Empty(Alltrim(_cFiltro))
		_cFiltro += ' .And. '
	EndIf
	_cFiltro += '(SZU->ZU_USUARIO == mv_par03)'
EndIf

// Filtra Procendencia
If mv_par04 == 1
	If !Empty(Alltrim(_cFiltro))
		_cFiltro += ' .And. '
	EndIf
	_cFiltro += '(SZU->ZU_PROCED == "1P")'
ElseIf mv_par04 == 2
	If !Empty(Alltrim(_cFiltro))
		_cFiltro += ' .And. '
	EndIf
	_cFiltro += '(SZU->ZU_PROCED == "2P")'
EndIf

If mv_par05 == 1
	If !Empty(Alltrim(_cFiltro))
		_cFiltro += ' .And. '
	EndIf
	_cFiltro += '(Alltrim(SZU->ZU_GRUPO) <> "0090" .And. SZU->ZU_UM <> "CJ")'
EndIf

//Alert (_cFiltro)

SET FILTER TO &_cFiltro

mBrowse( 6,1,22,75,"SZU")

Return

User Function GeraOPs()

_dDataIni := CTOD("")
_dDataFin := CTOD("")
_dDataNec := CTOD("")
_cHoraIni := Space(8)
_cHoraFin := Space(8)
_cUsuario := Space(15)
_cOP      := Space(6)

DEFINE MSDIALOG _oDlg1 FROM  094,1 TO 360,360 TITLE "Geração Automatica de OPs" PIXEL

@ 010,030 SAY "Data do Arquivo Inicial.: "   SIZE 090,010 PIXEL COLOR CLR_HBLUE
@ 025,030 SAY "Data do Arquivo Final...: "   SIZE 090,010 PIXEL COLOR CLR_HBLUE
@ 040,030 SAY "Hora do Arquivo Inicial.: "   SIZE 090,010 PIXEL COLOR CLR_HBLUE
@ 055,030 SAY "Hora do Arquivo Final...: "   SIZE 090,010 PIXEL COLOR CLR_HBLUE
@ 070,030 SAY "Usuario...................................: " SIZE 090,010 PIXEL COLOR CLR_HBLUE
@ 085,030 SAY "Numero Inicial da OP.....: "  SIZE 090,010 PIXEL COLOR CLR_HBLUE
@ 100,030 SAY "Dt. Limite - Necessidade: "  SIZE 090,010 PIXEL COLOR CLR_HBLUE
@ 008,090 MSGET _dDataIni SIZE 050,008 PIXEL OF _oDlg1
@ 023,090 MSGET _dDataFin SIZE 050,008 PIXEL OF _oDlg1
@ 038,090 MSGET _cHoraIni Picture "99:99:99" SIZE 050,008 PIXEL OF _oDlg1
@ 053,090 MSGET _cHoraFin Picture "99:99:99" SIZE 050,008 PIXEL OF _oDlg1
@ 068,090 MSGET _cUsuario                    SIZE 050,008 PIXEL OF _oDlg1
@ 083,090 MSGET _cOP      Picture "999999"   SIZE 050,008 PIXEL OF _oDlg1
@ 098,090 MSGET _dDataNec SIZE 050,008 PIXEL OF _oDlg1
@ 115,095 BmpButton Type 1 Action Processa( { || AtuOPs() } )
@ 115,130 BmpButton Type 2 Action _oDlg1:End()
Activate Dialog _oDlg1 Centered

Return

Static Function AtuOPs()

If Empty(_dDataIni) .Or. Empty(_cHoraIni) .Or. Empty(_cUsuario) .Or. Empty(_cOP)
	apmsgStop("Data Inicial, Hora Inicial, Usuario ou Numero Inicial da OP não podem estar em Brancos - Verifique")
	_lRet := .F.
Else
	If Len(Alltrim(_cOP)) < 6
		apmsgStop("Numero Inicial da OP invalido - Verifique")
		_lRet := .F.
	Else
		If Empty(_dDataFin)
			_dDataFin := _dDataIni
		EndIf
		If Empty(_cHoraFin)
			_cHoraFin := _cHoraIni
		EndIf
		If SubStr(_cHoraIni,1,2) > "24" .Or. SubStr(_cHoraFin,1,2) > "24"
			apmsgStop("Hora Inicial ou Hora Final Invalida - Verifique")
			_lRet := .F.
		EndIf
		If _dDataIni > _dDataFin  .Or. _cHoraIni > _cHoraFin
			apmsgStop("Datas Inicial e Final ou Hora Inicial e Final Incoerentes - Verifique")
			_lRet := .F.
		EndIf
	EndIf
EndIf

SET FILTER TO

If _lRet
	SZU->(DbSetOrder(3))
	SZU->(DbGoTop())
	
	If Empty(_dDataNec)
		_dDataNec := CTOD("31/12/49")
	EndIf
	_nNumOP   := Val(_cOP)
	_lOK      := .T.
	_aOpsSC2  := {}
	
	SB1->(DbSetOrder(1))
	SG1->(DbSetOrder(1))
	SG2->(DbSetOrder(1))
	SG2->(DbGoTop())
	SC2->(DbSetOrder(1))
	SC2->(DbGoTop())
	SZU->(DbGoTop())
	SZA->(DbSetOrder(1))
	_cNumCI  := ""
	_dDataCI := CTOD("")
	If SZA->(DbSeek(xFilial("SZA")+DTOS(_dDataIni)+_cHoraIni+_cUsuario))
		If SubStr(SZA->ZA_OPCOES,1,1) $ "2_3"
			_cNumCI  := SZA->ZA_CI
			_dDataCI := SZA->ZA_DATACI
			
			//VICTOR DESSUNTE - 03/03/2017
			//INICIO - TICKET:2017030337000111
			_cObs2	:= SZA->ZA_OBS
			//FIM - TICKET:2017030337000111
		EndIf
		//Alert(_cNumCI)
	EndIf
	
	If Select("QR9") > 0
		DbSelectArea("QR9")
		DbCloseArea()
	EndIf
	
	_cQuery := "SELECT * FROM " + RetSqlName("SZU") + " ZU "
//	_cQuery += "WHERE ZU_FILIAL = '" + xFilial("SZU") + "' AND ZU_STATUS = 'A' AND ZU_PROCED = '1P' AND RTrim(LTrim(ZU_USUARIO)) = '" + RTrim(LTrim(_cUsuario)) +"' "
	_cQuery += "WHERE ZU_FILIAL = '" + xFilial("SZU") + "' AND ZU_STATUS = '" + _cTipo + "' AND ZU_PROCED = '1P' AND RTrim(LTrim(ZU_USUARIO)) = '" + RTrim(LTrim(_cUsuario)) +"' "
	_cQuery += " AND ZU_DATA Between '"+ Dtos(_dDataIni) + "' AND '" + Dtos(_dDataFin) + "' AND ZU_HORA Between '" + _cHoraIni + "' AND '" + _cHoraFin + "' "
	_cQuery += " AND ZU.D_E_L_E_T_ = ' '"
	
	//Alert(_cQuery)
	
	DbUseArea( .T., 'TOPCONN', TCGENQRY(NIL, NIL, _cQuery), "QR9", .T., .T.)
	
	Do While QR9->(!Eof())
		_cObs   := ""
		_cRot	:= "  "
		_cStatus:= ""
		//IF  SUBSTR(cNumEmp,1,2) == "01"		// empresa Masipack ou Makpecas - Lizandra
			IF SG2->(dbSeek(xFilial("SG2")+QR9->ZU_PRODUTO))
				_cCod	:= QR9->ZU_PRODUTO
				_nCont	:= 0
				_cRot	:= "01"
				DO WHILE !SG2->(EOF()) .AND. SG2->G2_PRODUTO == _cCod
					IF SG2->G2_CODIGO <> _cRot
						_nCont	+= 1
					ENDIF
					SG2->(dbSkip())
				ENDDO
				IF _nCont > 0                                
				
					ApMsgAlert("Produto " + Alltrim(_cCod) + CRLF + CRLF + "Descrição " + Posicione("SB1",1,xFilial("SB1")+_cCod,Alltrim("B1_DESC")) + CRLF + "Possui mais de um roteiro. Verifique.")

					DEFINE MSDIALOG _oDlg2 FROM  090,1 TO 300,300 TITLE "Verificação de Roteiro" PIXEL

					@ 025,020 SAY "Porduto : "   SIZE 090,010 PIXEL COLOR CLR_HBLUE
					@ 045,020 SAY "Roteiro.: "   SIZE 090,010 PIXEL COLOR CLR_HBLUE
					@ 023,070 MSGET _cCod F3 "SG2MAS" SIZE 050,008 PIXEL OF _oDlg2
					@ 043,070 MSGET _cRot VALID ValRot() SIZE 050,008 PIXEL OF _oDlg2
					@ 080,075 BmpButton Type 1 Action _oDlg2:END() 
					@ 080,110 BmpButton Type 2 Action _oDlg2:End()
					Activate Dialog _oDlg2 Centered
				ENDIF
			ENDIF	
		//ENDIF
		If SZU->(DbSeek(xFilial("SZU")+_cUsuario+QR9->ZU_DATA+QR9->ZU_HORA+QR9->ZU_PRODUTO))
			If QR9->ZU_DATAOP > Dtos(_dDataNec)
				_cStatus  := "C"
				_cObs     := "Cancelada por Analise do PCP - Data da Necessidade maior que " + DTOC(_dDataNec)
				_AtuSZU()
				QR9->(DbSkip())
				Loop
			EndIf
			_cObs := ""
			If SB1->(DbSeek(xFilial("SB1")+QR9->ZU_PRODUTO))
				If SB1->B1_UM == "CJ"
					_cStatus := "R"
					_cObs    := "CJ - Unidade do Produto - Conjunto"
					_AtuSZU()
					QR9->(DbSkip())
					Loop
				Else
					If Alltrim(SB1->B1_GRUPO) == "0090"
						_cStatus := "R"
						_cObs    := "90 - Grupo do Produto - Terceiros"
						_AtuSZU()
						QR9->(DbSkip())
						Loop
					Else
						If SG1->(DbSeek(xFilial("SG1")+QR9->ZU_PRODUTO))
							//Alert(SZU->ZU_PRODUTO)
							//aAreaSZU := SZU->(GetArea())
							MsgRun("Aguarde, Gerando OPs !!!!",, { || GeraOPs() })
							//RestArea(aAreaSZU)
							If Alltrim(_cOPs) <> ""
								_cStatus := "G"
								_cOPs    := SubStr(_cOPS,1,(Len(Alltrim(_cOps))-1))
								_cObs    := ""
							Else
								_cStatus := "R"
								_cObs    := "Ocorreu erro na Geração - Verifique Arquivo de Log"
							EndIf
							_AtuSZU()
						Else
							_cStatus := "R"
							_cObs    := "Produto sem Estrutura"
							_AtuSZU()
						EndIf
					EndIf
				EndIf
			Else
				_cStatus := "R"
				_cObs    := "Produto nao Cadastrado"
				_AtuSZU()
			EndIf
		EndIf
		QR9->(DbSkip())
	EndDo
	Alert("Ops Geradas: "+Str(_nQtdOP,6))
	//MostraErro(_cPath,_cArqLog)
	// Copia do Arquivo de Log para ser analisado pelo PCP
	//CPYS2T(_cPath + _cArqLog," C:\LIXO\")
	//WinExec("NOTEPAD "+ "C:\LIXO\"+ _cArqLog)
	SZU->(DbSetOrder(1))
	SZU->(DbGoTop())
EndIf

_oDlg1:End()

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraOPs   ºAutor  ³Microsiga           º Data ³  09/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraOPs()
Local	_nX			:= 0
Local I    := 0
Local _lOK := .F.
Local _dDataOP := CTOD("")   
Local _dDataIn := CTOD("") // CRIADA CVARIÁVEL DA DATA INICIO PARA QUANDO A DATA FIM FOR MENOR QUE A EMISSAO + B1_PE + 1 (Lizandra)
_cOPs      := ""

If SZU->ZU_DATAOP < Date() //- alterado dia 12/03/13 a pedido do pcp para não gerar op com data inicio anterior à emissao (Lizandra)
//If SZU->ZU_DATAOP < Date() + SB1->B1_PE + 1
//	_dDataIn := Date()+1  //alterado dia 12/03/13 a pedido do pcp para não gerar op com data inicio anterior à emissao (Lizandra)
//	_dDataOP := Date() + SB1->B1_PE + 1  //alterado dia 12/03/13 a pedido do pcp para não gerar op com data inicio anterior à emissao (Lizandra)
	_dDataOP := Date() 
Else
	_dDataOP := SZU->ZU_DATAOP
EndIf
For I := 1 to SZU->ZU_QTDEOP
	_lOK := .F.
	Do While !_lOK
		If !SC2->(DbSeek(xFilial("SC2")+StrZero(_nNumOP,6)))
			_lOK := .T.
		Else
			_nNumOP++
		EndIf
	EndDo
	//Alert("OP: "+Str(_nNumOP)+" - Produto: "+QR9->ZU_PRODUTO)
	_aOPsSC2 := {{"C2_FILIAL", xFilial("SC2")      , NIL},;
	{"C2_NUM"    , StrZero(_nNumOP,6) , NIL},;
	{"C2_ITEM"   , '01'              , NIL},;
	{"C2_SEQUEN" , '001'             , NIL},;
	{"C2_MSLISTA", 'N'               , NIL},;
	{"C2_PRODUTO", SZU->ZU_PRODUTO   , NIL},;
	{"C2_QUANT"  , SZU->ZU_QTDPOP    , NIL},;
	{"C2_DATPRI" , _dDataIn          , NIL},;
	{"C2_DATPRF" , _dDataOP          , NIL},;
	{"C2_LOCAL"  , '01'              , NIL},;
	{"C2_CC"     , '207'             , NIL},;
	{"C2_PRIOR"  , '500'             , NIL},;
	{"C2_UM"     , SB1->B1_UM        , NIL},;
	{"C2_REVISAO", SB1->B1_REVATU    , NIL},;
	{"C2_MSREDUZ", '.'               , NIL},;
	{"C2_MSPED"  , '.'               , NIL},;
	{"C2_EMISSAO", Date()            , NIL},;
	{"C2_OBS"    , 'RPCPA011 - ' + _cObs2, NIL},;
	{"C2_MSUSER" , _cUsuSenha        , NIL},;
	{"C2_STATUS" , 'N'               , NIL},;
	{"C2_TPOP"   , 'F'               , NIL},;
	{"C2_MSCI"   , _cNumCI           , NIL},;
	{"C2_MSDTCI" , _dDataCI          , NIL},;
	{"C2_ROTEIRO", _cRot			 		, NIL},;
	{"AUTEXPLODE", 'S'               , NIL}}

//	{"C2_DATPRI" , Date()            , NIL}, ;alterado dia 12/03/13 a pedido do pcp para não gerar op com data inicio anterior à emissao (Lizandra)
	
	Begin Transaction
	lMsErroAuto := .F.
	MsExecAuto({|x,y| MATA650(x,y)},_aOPsSC2, 3)
	_nX++
	If lMsErroAuto
		_cErro := 'ERRO'+ALLTRIM(STR(_nX))+".txt"
		MostraErro("C:\ERRO\",_cErro)

		DisarmTransaction()
	Else
		_cOPs += StrZero(_nNumOP,6) + "/"
	EndIf
	End Transaction
	_nNumOP++
	_nQtdOP++
Next I
Return

Static Function _AtuSZU()
RecLock("SZU",.F.)
SZU->ZU_STATUS  := _cStatus
SZU->ZU_USUGERA := _cUsuSenha
SZU->ZU_DTGERA  := Date()
SZU->ZU_OBS := _cObs
SZU->ZU_ROTEIRO := _cRot
SZU->(MsUnLock())
Return

User Function CancOPs()

_dDataFin := CTOD("")
_cHoraFin := Space(8)
_cUsuario := Space(15)

DEFINE MSDIALOG _oDlg2 FROM  090,1 TO 300,300 TITLE "Cancela Necessidades" PIXEL

@ 025,020 SAY "Cancela até a Data.: "   SIZE 090,010 PIXEL COLOR CLR_HBLUE
@ 045,020 SAY "Cancela até a Hora.: "   SIZE 090,010 PIXEL COLOR CLR_HBLUE
@ 065,020 SAY "Usuario......................: " SIZE 090,010 PIXEL COLOR CLR_HBLUE
@ 023,070 MSGET _dDataFin SIZE 050,008 PIXEL OF _oDlg2
@ 043,070 MSGET _cHoraFin Picture "99:99:99" SIZE 050,008 PIXEL OF _oDlg2
@ 063,070 MSGET _cUsuario                    SIZE 050,008 PIXEL OF _oDlg2
@ 080,075 BmpButton Type 1 Action Processa( { || CancelOPs() } )
@ 080,110 BmpButton Type 2 Action _oDlg2:End()
Activate Dialog _oDlg2 Centered

Return

Static Function CancelOPs()

If Empty(_dDataFin) .Or. Empty(_cUsuario)
	apmsgStop("Data ou Usuario não podem estar em Brancos - Verifique")
	_lRet := .F.
Else
	If Empty(_cHoraFin)
		_cHoraFin := "24:00:00"
	EndIf
	If SubStr(_cHoraFin,1,2) > "24"
		apmsgStop("Hora Invalida - Verifique")
		_lRet := .F.
	EndIf
EndIf

SET FILTER TO

If _lRet
	If Select("QR9") > 0
		DbSelectArea("QR9")
		DbCloseArea()
	EndIf
	
	_cQuery := "SELECT * FROM " + RetSqlName("SZU") + " ZU "
	_cQuery += "WHERE ZU_FILIAL = '" + xFilial("SZU") + "' AND ZU_STATUS = 'A' AND RTrim(LTrim(ZU_USUARIO)) = '" + RTrim(LTrim(_cUsuario)) +"'"
	_cQuery += " AND ZU_DATA <= '" + Dtos(_dDataFin) + "' AND ZU_HORA <= '" + _cHoraFin + "'"
	_cQuery += " AND ZU.D_E_L_E_T_ = ' '"
	
	//Alert(_cQuery)
	
	DbUseArea( .T., 'TOPCONN', TCGENQRY(NIL, NIL, _cQuery), "QR9", .T., .T.)
	
	SZU->(DbSetOrder(3))
	SZU->(DbGoTop())
	Do While QR9->(!Eof())
		If SZU->(DbSeek(xFilial("SZU")+_cUsuario+QR9->ZU_DATA+QR9->ZU_HORA+QR9->ZU_PRODUTO))
			_cStatus	:= "C"
			_cObs		:= "Cancelada por Geração posterior ou Fora dos parametros solicitados - " +DTOC(Date())  
			_cRot		:= SZU->ZU_ROTEIRO
			_AtuSZU()
		EndIf
		QR9->(DbSkip())
	EndDo
EndIf
SZU->(DbSetOrder(1))
SZU->(DbGoTop())

_oDlg2:End()

Return                                    



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValRot   ºAutor  ³Lizandra Marquesº Data ³  24/05/12       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida Roteiro de Operação                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP -  Masipack                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValRot()

_lRet := .T.

SG2->(dbSetOrder(1))
IF !SG2->(dbSeek(xFilial("SG2")+_cCod+_cRot))
	ApMsgAlert("ROTEIRO INVÁLIDO!")
	_lRet := .F.
ENDIF	
	 
RETURN _lRet    