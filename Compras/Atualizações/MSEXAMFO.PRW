#INCLUDE "TOPCONN.CH"

User Function MSEXAMFO()
Local nLastKey	:= 0
Static cFornec	:= ""
Static cLoja		:= ""
Static cProduto	:= ""
Static _nEx := 0
Private PARAMIXB1 := {}
Private PARAMIXB2 := 5
PRIVATE lMsErroAuto := .F.
Private cPerg 	:= "XMT160    "
Private _cQuery := ""

_lRet := Pergunte(cPerg,.T.)

If nLastKey == 27 .Or. nLastKey == 27 .Or. !_lRet .Or. Empty(MV_PAR01)
 	Return
Endif

cFornec := MV_PAR01
cNomFor := GetAdvFval("SA2","A2_NREDUZ",xFilial("SA2")+MV_PAR01+"00",1," ")

_lRet := ApMsgYesNo("Deseja realmente exluir a amarração para o o fornecedor "+cFornec+" - "+cNomFor+" ?")

If _lRet
	If Select("QRY") > 0
		DbSelectArea("QRY")
		DbCloseArea()
	EndIf
	
	_cQuery := "SELECT A5_FORNECE,A5_LOJA,A5_PRODUTO,A5_NOMEFOR FROM "+RetSQLName("SA5")+" WHERE A5_FORNECE = '"+MV_PAR01+"' AND D_E_L_E_T_ = '' AND A5_FILIAL = '"+xFilial("SA5")+"'
	
	TcQuery _cQuery New Alias "QRY"
	
	MsAguarde({|| MSEAMFOR() }, OemToAnsi("Atualizando Cadastro, Exclusão") )
	
	If _nEx > 0
		ApMsgAlert("Foram excluídas "+Alltrim(cValtoChar(_nEx))+" amarrações para o "+CHR(13)+CHR(10)+" fornecedor "+cFornec+" - "+cNomFor+" ")
	Else
		ApMsgAlert("Não há amarração para o o fornecedor "+cFornec+" - "+cNomFor+" ")
	Endif
Endif

Return

Static Function MSEAMFOR()
DbSelectArea("QRY")
QRY->(DbGoTop())
Do While !QRY->(Eof())
	aadd(PARAMIXB1,{"A5_FORNECE",QRY->A5_FORNECE,})
	aadd(PARAMIXB1,{"A5_LOJA",QRY->A5_LOJA,})
	aadd(PARAMIXB1,{"A5_PRODUTO",QRY->A5_PRODUTO,})
	Begin Transaction
	
	MSExecAuto({|x,y| mata060(x,y)},PARAMIXB1,PARAMIXB2)
	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
		lMsErroAuto := .F.
	Else
		_nEx++
	EndIf
	
	End Transaction
	PARAMIXB1 := {}
	
	QRY->(DbSkip())
	
EndDo

Return
