#include "rwmake.ch"

/*/
------------------------------------------------------------------------
{Protheus.doc} RESTA032()
Permitir que o usuário altere parametros específicos apos fechamento do
Estoque, para ajustes pontuais

@author  DS2U (THOMAS MORAES)
@since   Dez.2020
@version 1.0
@type    function
------------------------------------------------------------------------
/*/

User Function RESTA032()

Local xNomeEmp:= AllTrim(SM0->M0_NOME)
Local dDblQmov:= GetMV("MV_DBLQMOV")
Local dULMes  := GetMV("MV_ULMES")
Local dDataFis:= GetMV("MV_DATAFIS")

	@ 200,001 to 410,260 Dialog oDlg1 Title "Altera Parametros"
	@ 010,010 Say "Parametros "+xNomeEmp
	@ 030,020 Say "Bloq. Movim.: "
	@ 050,020 Say "ULMES: "
	@ 070,020 Say "Data Fis: "
	@ 030,060 Get dDblQmov Picture "@D" Size 40,20
	@ 050,060 Get dULMes   Picture "@D" Size 40,20
	@ 070,060 Get dDataFis Picture "@D" Size 40,20
	@ 090,020 Button "_Confirmar" Size 40,10 Action ConfParam(dDblQmov,dDataFis,dULMes)
	@ 090,070 Button "_Sair" Size 30,10 Action Close(oDlg1)
	Activate Dialog oDlg1 Centered

Return

Static Function ConfParam(dDblQmov,dDataFis,dULMes)

Local x

	//DbSelectArea("SX6")

	x:=GetMV("MV_DBLQMOV")
	PUTMV("MV_DBLQMOV",dtoc(dDblQmov))

	x:=GetMV("MV_DATAFIS")
	PUTMV("MV_DATAFIS",dtoc(dDataFis))
	
	x:=GetMV("MV_ULMES")
	PUTMV("MV_ULMES",dtoc(dULMes))

	MsgInfo("Alteracao Efetuada.", "Mensagem")

	Close(oDlg1)

Return
