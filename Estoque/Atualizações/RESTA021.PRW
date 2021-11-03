#Include "Rwmake.ch"
#Include "Topconn.ch"
#include "AP5MAIL.CH"

/*/{Protheus.doc} RESTA021
//TODO Descrição: Baixa das Devoluções.
@author Lizandra Marques
@since 08.02.2012
@version 1.0
@return NIL
@type function
/*/
User Function RESTA021()
Local cAlias		:= "SZP"
Local cFiltra		:= "ZP_QUJE=0"
Private aIndexSZP 	:= {}
Private bFiltraBrw	:= { || FilBrowse(cAlias,@aIndexSZP,@cFiltra) }

Private aCores 	:= {{"ZP_QUJE=0",'ENABLE' },;
				   { "ZP_QUJE=ZP_QUANT" ,'DISABLE'}}

Private aRotina := {{ "Pesquisar"	,"PesqBrw"		,0,1,0,.T.	},; 	//"Pesquisar"
					{ "Visualizar"	,"AxVisual" 	,0,2		},; 	//"Visualizar"
					{ "Baixar"   	,"U_ESTA021B" 	,0,3		},; 	//"Incluir"
					{ "Legenda"   	,"U_LEG020"   	,0,6		} }		//"LEGENDA"

Private cCadastro 	:= "Efetiva Devoluções "      

Eval(bFiltraBrw)
dbSelectArea(cAlias)
dbGoTop()

mBrowse(06,01,22,75,"SZP",,,,,,aCores)

EndFilBrw(cAlias,aIndexSZP)

Return

/*/{Protheus.doc} ESTA021B
//TODO Descrição: Tela com as informações sobre a baixa para a efetivação pelo usuário.
@author LIZANDRA MARQUES
@since 13/02/2012
@version 1.0
@return NIL
@type function
/*/
User Function ESTA021B()

_cDoc		:="DEV"+SZP->ZP_NUM
_cTM		:= "001"
_cCOD		:= SZP->ZP_PRODUTO
_cUM		:= SZP->ZP_UM
_cLOCALMS	:= SZP->ZP_LOCAL
_cDESCRI	:= SZP->ZP_DESCRI
_nQUANT 	:= SZP->ZP_QUANT
_cCC		:= SPACE(09)               
_cObs		:= "RESTA21 - " +SZP->ZP_OBS
@ 0,0 TO 200,500 DIALOG oDlg1 TITLE "Efetiva Devolução"
@ 10,10  SAY "Tipo Movimento	: " + _cTM
@ 10,100 SAY "Documento: "
@ 10,130 GET _cDoc SIZE 50,200
@ 30,10  SAY "Produto            : " + _cCOD
@ 30,100 SAY "C. Custo : "
@ 30,130 GET _cCC SIZE 50,200 VALID ExistCpo("CTT")
@ 40,10  SAY "Descrição         : " + _cDESCRI
@ 50,10  SAY "UM                    : " + _cUM
@ 60,10  SAY "Local                : " + _cLOCALMS
@ 70,10  SAY "Quantidade       : " + TRANSFORM(_nQUANT,"@E 999,999,999.99")


@ 80,90  BUTTON "_Ok"   SIZE 35,15 ACTION _fGrava()
@ 80,140 BUTTON "_Sair" SIZE 35,15 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER
Return

/*/{Protheus.doc} _fGrava
//TODO Descrição: Verifica se usuário pode efetuar a baixa, coleta dados e gera o movimento de devolução por execauto (MATA240).
@author LIZANDRA MARQUES
@since 13/02/2012
@version 1.0
@return .T.
@type function
/*/
Static Function _fGrava()

Local lRet			:= .T.
Local _aUsuario		:= {}
Local _aMov			:= {}
Local _nCM			:= 0
Local _cUsuario		:= ""
Local _cUsuSenha	:= ""
Local _cDeptoUsu	:= ""
Local _cLocal		:= "" 
Local _cTipo		:= ""
Local _cGrupo		:= ""
Private lMsErroAuto	:= .F.

_aArea 		:= GetArea()
_aAreaB1	:= SB1->(GetArea())
_aAreaD3	:= SD3->(GetArea())
_aAreaAI	:= SAI->(GetArea())
_aAreaX5	:= SX5->(GetArea())
_aAreaB2	:= SB2->(GetArea())

IF SZP->ZP_QUJE==SZP->ZP_QUANT
	apmsgSTOP("Registro já foi baixado, não pode ser alterado. Verifique")
	lRet := .F.
ENDIF

IF lRet
	DbSelectArea("SAI")
	SAI->(DbSetOrder(2))
	
	If !DbSeek(xFilial("SAI")+__CUSERID) .AND. !SAI->AI_MSMODUL $ "EST,*  "
		APMSGSTOP("USUÁRIO NÃO TEM PERMISSÃO PARA FAZER ESSE MOVIMENTO.")
		lRet := .F.
	ENDIF
ENDIF

DbSelectArea("SB1")
SB1->(dbSetOrder(1))
IF dbSeek(xFilial("SB1")+_cCOD)
	_cLocal		:=	SB1->B1_LOCPAD
	_nCM		:=  SB1->B1_CUSTD
	_cTipo      :=	SB1->B1_TIPO
	_cGrupo		:=  SB1->B1_GRUPO
	_cCContab	:=  SB1->B1_CONTA
ENDIF	
 

IF lRet
	_cUsuario	:= RetCodUsr()
	_cUsuSenha	:= UsrRetname(_cUsuario)
		
	PswOrder(1)
		
	If PswSeek(_cUsuario,.T.)
		_aUsuario	:= PswRet()
		_cUsuSenha	:= UsrRetName(_cUsuario)
		cUsuarioSX5	:= Upper(Alltrim(_aUsuario[1][2]))
		_cDeptoUsu	:= Upper(Alltrim(_aUsuario[1][12]))
	EndIf
		
		
	SX5->(dbSetOrder(1))
	SX5->(dbSeek(xFilial("SX5")+"ZD"+cUsuarioSX5))
	If !SubStr(SB1->B1_LOCAL,1,1) $ Rtrim(X5DESCRI())
		APMSGSTOP('Usuario não autorizado a Movimentar Item, Local: '+ SB1->B1_LOCAL)
		_lRet := .F.
	Endif
Endif
BEGIN TRANSACTION
If lRet

	_aMov	:= {{"D3_FILIAL"	,xFilial("SD3")	,NIL},;
				{"D3_TM"		,"402"			,NIL},;
				{"D3_COD"		,_cCOD			,NIL},;
				{"D3_UM"		,_cUM			,NIL},;
				{"D3_QUANT"		,_nQUANT		,NIL},;
				{"D3_CONTA" 	,_cCContab		,NIL},;
				{"D3_LOCAL" 	,_cLOCAL		,NIL},;
				{"D3_DOC"		,_cDOC			,NIL},;
				{"D3_EMISSAO"	,dDataBase		,NIL},;
				{"D3_GRUPO"		,_cGrupo		,NIL},;
				{"D3_CC"		,_cCC			,NIL},;
				{"D3_MSOBS"		,_cObs			,NIL},;
				{"D3_MSLOCAL"	,_cLocalMS		,NIL},;
				{"D3_MSREDUZ"	,_cDESCRI		,NIL},;
				{"D3_HORAS"		,TIME()			,NIL},;
				{"D3_TRT"		,"001"			,NIL} }
	
	LJMSGRUN("Efetuando Movimentação Interna " + _cCod,,{|| MSEXECAUTO({|X,Y|MATA240(X,Y)},_aMov,3)})
	
	If lMsErroAuto
		MostraErro()
	Else
		// GRAVA SZP
		dbSelectArea("SZP")
		RecLock("SZP",.F.)
		SZP->ZP_QUJE	+= _nQUANT
		MsUnlock()
	EndIf
Endif

END TRANSACTION

Close(oDlg1)
RestArea(_aAreaB2)
RestArea(_aAreaX5)
RestArea(_aAreaAI)
RestArea(_aAreaD3)
RestArea(_aAreaB1)
RestArea(_aArea)

return(.t.)
