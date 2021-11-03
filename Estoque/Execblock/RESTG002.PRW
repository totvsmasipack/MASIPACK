#Include "PROTHEUS.ch"
#INCLUDE "RWMAKE.CH"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑณFuncao	 ณ RESTG002ณ Autor ณ Aparecida de F.StevanatoณData ณ 10.07.08 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ-ฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Gera Arquivo para o Almoxarifado Vertical             	  ณฑฑ
ฑฑณ          ณ Saidas  - Requisicoes e N. Fiscal de Saida                 ณฑฑ
ฑฑณ          | Ressuprimento - Entrada de Nota Fiscal                     ณฑฑ
ฑฑณ          | Alterado para realizar grava็ใo de registros na tabela SD3 ณฑฑ
ฑฑณ          | compilado com nome RESTA020 para avalicao - 13/12/2010 por ณฑฑ
ฑฑณ          | Fabio Marcelo Dias                                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
*/

User Function RESTG002()

Local I

Private _cUsuario   := ""
Private cUsuarioSX5 := ""
Private cUsuarioSZS	:= ""
Private _cGrupo     := ""
Private _cUsuSenha  := ""
Private _cDeptoUsu  := ""
Private _aUsuario   := {}
Private _aGrupos    := {}
Private titulo      := ""
Private nomeprog    := "RESTG002"
Private cArqTrab    := ""
Private cFilTrab    := ""
Private nLastKey    := 0
Private I           := 0
Private aFaltantes  := {}
Private nLote       := 0
Private cLote       := ""
Private cNovoLote   := ""
Private nFalta      := 0
Private lAtuaFalta  := .F.
Private lNovoLote   := .F.
Private lAcesso     := .F.
Private nRessuprir  := 0
Private nRegistro   := 0
Private cArqCSV     := ""
Private cRegCSV     := ""
Private cArq        := ""
//Private cGerOP      := GetMV("MV_MSGEROP")
Private cAlias      := ""
Private nEmpVD      := 0
Private nEstq       := 0

//Variaveis criadas para atender a funcao GravaSD3() - somente para realizar saida de produtos
Private lSaida		:= .F.
Private cOpSai		:= ""
Private cProSai		:= ""
Private nQtdSai		:= 0
Private cMsRefer	:= ""
Private cMSTRT      := ""
Private cMsNred		:= ""
Private cLoteVs		:= ""
Private aAreaSB2	:= {}
PRIVATE	LMSERROAUTO	:= .F.	// INDICA SE GEROU ERRO NA TRANSACAO

//Variaveis criadas para validacao do diretorio de gravacao
Private cPath := "J:\VS"
Private lChangeCase := .F.

_cUsuario  := RetCodUsr()
_cUsuSenha := UsrRetname(_cUsuario)

PswOrder(1)

If PswSeek(_cUsuario,.T.)
	_aUsuario	:= PswRet()
	_cUsuSenha	:= UsrRetName(_cUsuario)
	cUsuarioSX5	:= Upper(Alltrim(_aUsuario[1][2]))
	cUsuarioSZS	:= Upper(Alltrim(_aUsuario[1][4]))
	_cDeptoUsu	:= Upper(Alltrim(_aUsuario[1][12]))
	_aGrupos     := PswRet(1)[1][10]
	For I := 1 to Len(_aGrupos)
		_cGrupo += Upper(Alltrim(GrpRetName(_aGrupos[I]))) + "_"
	Next I
	_cGrupo := SubStr(_cGrupo,1,Len(_cGrupo)-1)
EndIf

If Alltrim(_cDeptoUsu) $ "VS_RECEBIMENTO"
	lAcesso   := .T.
Else
	If _cGrupo $ "ADMINISTRADORES|INFORMATICA"
		_lAcesso := .T.
	EndIf
EndIf

If !MayIUseCode("RESTA008")
	Alert("Bloqueado por outro usuแrio.")
	Return
EndIf

//WaitRun("NET USE I:\\MSSRV-FSV01\DEPTOS\VS")
//WaitRun("NET USE I: \\MSCLD-FSV01\DEPTOS\VS")

If (ExistDir(cPath,nil,lChangeCase) == .F.)
    Alert("Diret๓rio nใo existe ou nใo estแ mapeado.")
    Return
Endif

//aGera    := {"Ressuprimento","Saidas"}
aGera    := {"Saidas"}
cGera    := Space(15)
aLista	 := {"Nao","Sim"}		// Incluido por FMD para gerar pergunta se deseja baixar lista automaticamente (16/02/11).
cLista   := Space(03)			// Incluido por FMD para gerar pergunta se deseja baixar lista automaticamente (16/02/11).
dDtMov   := CTOD("")
fRet     := .F.

@ 089,185 To 500,600 Dialog _oDlg1 Title OemToAnsi("Estoque - Gera Movimento (VS)")
@ 009,011 To 035,188
@ 030,011 To 180,188
@ 015,034 Say OemToAnsi("Gera Movimento - Almoxarifado Vertical")   Size 151,010

@ 065,020 Say OemToAnsi("Gera Movimento de................:")       Size 080,008
@ 085,020 Say OemToAnsi("Data do Movimento................:")       Size 080,008
@ 062,095 ComboBox cGera Items aGera                                Size 055,010 object oGera
@ 085,095 Get dDtMov Valid ValidaData()                             Size 045,008

@ 110,020 Say OemToAnsi("Baixar Lista Automaticamente? ")           Size 080,008				// Incluido por rFMD para gerar pergunta se deseja baixar lista automaticamente (16/02/11).
@ 108,095 ComboBox cLista Items aLista                              Size 055,010 object oLista	// Incluido por FMD para gerar pergunta se deseja baixar lista automaticamente (16/02/11).

@ 140,110 BmpButton Type 1 Action GeraMovVS()
@ 140,145 BmpButton Type 2 Action _oDlg1:End()
Activate Dialog _oDlg1 Centered

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTG002  บAutor  ณMicrosiga           บ Data ณ  06/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidaData()

fRet := .T.
If Empty(dDtMov) .Or. dDtMov < Date() - 20
	ApMsgStop("Data Fora do Perํodo previsto")
	fRet := .F.
EndIf

Return fRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTG002  บAutor  ณMicrosiga           บ Data ณ  06/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraMovVS()

If ! fRet
	ApMsgStop("Processamento serแ cancelado - Verifique as informa็๕es")
	dDtMov     := CTOD("")
	cGera      := Space(15)
	lNovoLote  := .F.
	lAtuaFalta := .F.
	Return
EndIf

//PutMV("MV_MSGEROP","S")
nFalta := GetMv("MV_MSFALTA") + 1

Saidas()

// Atualiza os parametros

If lNovoLote
	PutMV("MV_MSVSLOT",nLote)
EndIf

If lAtuaFalta
	PutMV("MV_MSFALTA",nFalta)
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Deleta arquivos de trabalho.                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Ferase(cArqTrab+GetDBExtension())
Ferase(cArqTrab+OrdBagExt())
Ferase(cFilTrab+OrdBagExt())

// Inicializa campos para uma nova geracao

dDtMov     := CTOD("")
cGera      := Space(15)
lNovoLote  := .F.
lAtuaFalta := .F.

MS_FLUSH()

_oDlg1:End()   // Este comando executa a rotina uma unica vez

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTG002  บAutor  ณVictor Dessunte     บ Data ณ  05/25/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera arquivo para efetuar as saidas do almoxarifado VS     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Saidas()
Local _nX		:= 0
Local _cQry 	:= ""
Local _cLote	:= ""
Local _cCod		:= ""
Local _cLoteAux	:= ""
Local _cArq		:= ""
Local _cText	:= ""
Local _aArq		:= {}
Local _aAux		:= {}
Local _nItem	:= 0
Local _nSoma	:= 0

_cQry := " SELECT " + CRLF
_cQry += "		LTRIM(RTRIM(CASE " + CRLF
_cQry += "			WHEN D3_OP = '' THEN " + CRLF
_cQry += "				CASE " + CRLF
_cQry += "					WHEN D3_MSREFER <> '' THEN " + CRLF
_cQry += "						'52' + D3_MSREFER " + CRLF
_cQry += "					ELSE " + CRLF
_cQry += "						'52' + D3_DOC " + CRLF
_cQry += "				END " + CRLF
_cQry += "			ELSE  " + CRLF
_cQry += "				CASE " + CRLF
_cQry += "					WHEN D3_MSREFER <> '' THEN " + CRLF
_cQry += "						'51' + D3_MSREFER " + CRLF
_cQry += "					ELSE " + CRLF
_cQry += "						'51' + D3_DOC " + CRLF
_cQry += "				END " + CRLF
_cQry += "		END)) AS 'LOTE', " + CRLF
_cQry += "		LTRIM(RTRIM(D3_COD)) D3_COD, " + CRLF
_cQry += "		D3_QUANT, " + CRLF
_cQry += "		R_E_C_N_O_ " + CRLF
_cQry += "	FROM  " + CRLF
_cQry += 		RetSqlName("SD3") + " D3 " + CRLF
_cQry += "	WHERE " + CRLF
_cQry += "			D3.D_E_L_E_T_	= '' " + CRLF
_cQry += "	AND 	D3_ESTORNO		= '' " + CRLF
_cQry += "	AND 	D3_FILIAL		= '" + xFilial("SD3") + "' " + CRLF
_cQry += "	AND 	D3_EMISSAO		= '" + DTOS(dDtMov) + "' " + CRLF
_cQry += "	AND 	D3_TM				> '499' " + CRLF
_cQry += "	AND 	D3_MSVLOTE		= '' " + CRLF
_cQry += "	AND	D3_MSREFER		<> '' " + CRLF //DESTA FORMA NAO IRA GERAR REQUISICOES AVULSAS
_cQry += "	AND 	D3_MSLOCAL		LIKE '1%' " + CRLF
_cQry += "	ORDER BY 1,2"

If Select("TRBS") > 0
	TRBS->(dbCloseArea())
EndIf

TCQUERY _cQry NEW ALIAS "TRBS"

TRBS->(dbGoTop())
While TRBS->(!EOF())
	dbSelectArea("SD3")
	SD3->(dbGoTo(TRBS->R_E_C_N_O_))
	If SD3->(Recno()) == TRBS->R_E_C_N_O_
		RecLock("SD3",.F.)
		SD3->D3_MSVLOTE := ALLTRIM(TRBS->LOTE)
		SD3->(MsUnlock())
	EndIf
	
	AADD(_aArq,{ALLTRIM(TRBS->LOTE),ALLTRIM(TRBS->D3_COD),TRBS->D3_QUANT})

	TRBS->(dbSkip())
End

If Len(_aArq) > 0
	AADD(_aArq,{'','',0})
EndIf

//Aglutina itens iguais do Array
For _nX:=1 To Len(_aArq)
	If _aArq[_nX,1]+_aArq[_nX,2] <> _cLote+_cCod
		//Verifica se itens foram inclusos
		If !Empty(_cLote)
			AADD(_aAux,{_cLote,_cCod,_nSoma})
		EndIf
		
		_cLote := _aArq[_nX,1]
		_cCod  := _aArq[_nX,2]
		_nSoma := _aArq[_nX,3]
	Else
		_nSoma := _nSoma + _aArq[_nX,3]
	EndIf
Next _nX

If Len(_aAux) > 0
	AADD(_aAux,{'','',0})
EndIf

//Cria arquivo para o VS
For _nX:=1 To Len(_aAux)
	If _aAux[_nX,1] <> _cLoteAux
		If !Empty(_cLoteAux)
			FClose(_cArq)
		EndIf
		
		If Len(_aAux) == _nX
			Exit
		EndIf
		
		_nItem := 0
		_cLoteAux := _aAux[_nX,1]
		If (_cArq := FCreate("J:\VS\"+_aAux[_nX,1]+".CSV")) == -1
			apmsgStop("Arquivo para o VS nใo pode ser criado - Avise o Depto. de Informแtica")
		EndIf
	EndIf
	
	_cText := _aAux[_nX,1]+";1;1;"+_aAux[_nX,1]+";"+Strzero(_nItem++,3,0)+";PRODUCAO;MOVIMENTO INTERNO;1;"+_aAux[_nX,2]+";;"+Alltrim(Str(_aAux[_nX,3],12,0))+";;;;;"+_aAux[_nX,1]+";"
	FWrite(_cArq,_cText+chr(13)+chr(10))
Next _nX

If Select("TRBS") > 0
	TRBS->(dbCloseArea())
EndIf

Return
