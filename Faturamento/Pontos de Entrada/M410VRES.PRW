/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM410VRES  บAutor ณAparecida de F.Stevanato Data ณ16/03/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para validacao PV - Exclusใo por Residuo             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ01/02/2012ณAlterado por Ana Paula Q.Faustino                           บฑฑ
ฑฑบ          ณAltra็ใo na Exclusao por Resํduo - Se o pedido existir na   บฑฑ
ฑฑบ          ณtabela SZ1 - disparar (inserir) um registro na tabela SZM   บฑฑ
ฑฑบ          ณpara a Engenharia Eletronica                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

*/
#Include "rwmake.ch"

User Function M410VRES()

Private _lRet := .T.

//Alert("M410VRES "+SC5->C5_NUM)

SF4->(dbSetOrder(1))

If SC5->C5_TIPO == "N"
	SC6->(dbSetOrder(1))
	If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
		cPedCli  := SC6->C6_NUM
		cCodCli  := SC6->C6_CLI
		cLojaCli := SC6->C6_LOJA
		If SA1->(DbSeek(xFilial("SA1")+Alltrim(SA1->A1_COD)))
			cNomCli := SA1->A1_NREDUZ
		EndIf
		
		Do While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM
			SF4->(DbSeek(xFilial("SF4")+Alltrim(SC6->C6_TES)))
			If SF4->F4_ESTOQUE == "S"
				If SubStr(cNumEmp,1,2) == "01" .And. !Empty(SC6->C6_MSPCP) .And. DTOC(SC6->C6_MSPCP) <> "31/12/49" .AND. SC5->C5_MSCATEG $ "2,3"
					ApMsgStop("Altera็ใo Invalida - Fale com PCP: Este Item jแ foi Analisado")
					Return(.F.)
				Else
					If SubStr(cNumEmp,1,2) == "10" .And. !Empty(SC6->C6_MSPCP) .And.  DTOC(SC6->C6_MSPCP) <> "31/12/49" .And. SC6->C6_MSPCP < Date()
						ApMsgStop("Altera็ใo Invalida - Fale com PCP: Este Item jแ foi Analisado")
						Return(.F.)
					EndIf
				EndIf
			EndIf
			SC6->(dbSkip())
		EndDo
		IF SUBSTR(cNumEmp,1,2) <> "15"
			SZ1->(dbSetOrder(1))
			If SZ1->(DbSeek(xFilial("SZ1")+cPedCli))
				DbSelectArea("SZM")
				DbSetOrder(1)
				If !DbSeek(xFilial("SZM")+cPedCli)
					RecLock("SZM",.T.)
				Else
					RecLock("SZM",.F.)
				Endif
				SZM->ZM_FILIAL  := xFilial("SZ1")     // Filial do Arquivo
				SZM->ZM_PEDIDO  := cPedCli
				SZM->ZM_CODCLI  := cCodCli
				SZM->ZM_LOJACLI := cLojaCli
				SZM->ZM_CLIENTE := cNomCli
				SZM->ZM_DATA    := DATE()
				SZM->ZM_MSUSER  := cUserName
				SZM->ZM_DEPTO   := "ENG. ELETRONICA     "
				SZM->ZM_ASSUNTO := "ENG.EN"
				SZM->ZM_NOASSUN := "PENDENCIAS DA ENG.ELETRONICA"
				SZM->ZM_RESUMO  := ""
				SZM->ZM_EVENTO  := "PEDIDO ENCERRADO POR RESIDUO"
				SZM->ZM_CODDEPT := "AT"
				SZM->ZM_DEPTDES := ""
				SZM->ZM_DTPREV  := DATE()
				SZM->ZM_STATUS  := "A"
				SZM->ZM_ULTALT  := DATE()
				SZM->ZM_USUALTE := cUserName
				//SZM->ZM_COMENT  := memo
				SZM->ZM_LIDO    := .T.
				SZM->ZM_DTLIDO  := DATE()
				SZM->ZM_USULIDO := cUserName
				SZM->ZM_ACEITE  := .F.
				//SZM->ZM_DTACEIT :=
				//SZM->ZM_USUACEI :=
				//SZM->ZM_CODTEC  :=
				SZM->ZM_COPIA   := .F.
				//SZM->ZM_DTCOM   :=
				//SZM->ZM_LOGCOM  := memo
				//SZM->ZM_DTENG   :=
				//SZM->ZM_LOGENG  := memo
				//SZM->ZM_LOGPROD := memo
				//SZM->ZM_DTMONT  := memo
				//SZM->ZM_LOGMONT :=
				//SZM->ZM_DTTEST  := memo
				//SZM->ZM_LOGTEST :=
				//SZM->ZM_ENTLOG  :=
				//SZM->ZM_PREVLOG :=
				//SZM->ZM_INIMONT :=
				//SZM->ZM_OBS     := memo
				//SZM->ZM_DTPROD  :=
				//SZM->ZM_HORAALT :=
				MsUnlock("SZM")
			EndIf
		ENDIF
	EndIf
EndIf

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALIBPV    บAutor  ณLizandra Marques    บ Data ณ  17/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PONTO DE ENTRADA PARA GRAVAR MSLIBPV (STATUS DO PV)        บฑฑ
ฑฑบ          ณ - depois da ELIMINAวรO POR RESIDUO                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - MASIPACK                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


U_ALIBPV()

Return _lRet
