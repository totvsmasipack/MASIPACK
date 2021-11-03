#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT440VLD  ºAutor  ³Victor Dessunte     º Data ³  08/23/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para liberacao do pedido de forma         º±±
±±º          ³ automatica                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION MT440VLD()
	
Local _nCli, _nNat, _nEmG
Local _aArea	:= GetArea()
Local aNomEmp	:= {"",""}
Local aEmpGru   := {"MASIPACK","FABRIMA","HELSIMPLAST"}
Local aDadosEmp	:= {}
Local _aClI 	:= {}
Local _lRet 	:= .T.
Private _lGrp 	:= IIF(SC5->C5_CLIENTE$GetMv("MS_GRUPO"),.T.,.F.)

	IF SC5->C5_TIPO == "N"
		_aNaturez := {'V02.1' ,'V01', 'V02.3','V02.4'}
		aNomEmp[1] := Alltrim(SM0->M0_NOME)
		For _nEmG := 1 to len(aEmpGru)
			If !(aEmpGru[_nEmG] == aNomEmp[1])
				aNomEmp[2] := aEmpGru[_nEmG]
				aDadosEmp := U_MSACHAEM(aNomEmp,cNumEmp)
				_aCli := U_MSCODCLI(aDadosEmp)
				For _nNat := 1 to len(_aNaturez)
					For _nCli := 1 to len(_aCli)
						If _aCli[_nCli] == SC5->C5_CLIENTE+SC5->C5_LOJACLI .And. Alltrim(SC5->C5_NATUREZ) == Alltrim(_aNaturez[_nNat])
							_lRet := U_RFATA071(SC5->C5_NUM,aDadosEmp)
						Endif
					Next _nCli
				Next _nNat
			Endif
		Next _nEmG
		
		If _lRet
			SA1->(DbSetOrder(1))
			If SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)) .And. !_lGrp
				If SA1->A1_RISCO $ "B|C|D|E" .And. !(SA1->A1_MSBLQL == '1')
					FwAlertError("Cliente possui restrição financeira. Contate o Depto. Financeiro.")
					_lRet := .F.
				EndIf
			EndIf
		Endif
	EndIf
/*
	IF _lRet .And. ExistCpo("SX3","C5_MSAPROV",2)
		IF SC5->C5_MSAPROV == 'N'
			FwAlertError("Pedido aguardando liberação fiscal.")
			_cTitulo2 := "Pedido aguardando liberação fiscal "+SC5->C5_NUM
			_cMsg2    := "Pedido  : " + SC5->C5_NUM + CHR(13)+CHR(10)
			_cMsg2    += "Cliente : " + Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NREDUZ") + CHR(13)+CHR(10)
			_cMsg2    += "Natureza: " + Posicione("SED",1,xFilial("SED")+SC5->C5_NATUREZ,"ED_DESCRIC") + CHR(13)+CHR(10)
			_cDestino2 :="contabil@masipack.com.br"
			oMail:= EnvMail():NEW(.F.)
			If oMail:ConnMail()
				oMail:SendMail(_cTitulo2,_cDestino2,,,_cMsg2)
			EndIf
			oMail:DConnMail()
			_lRet:= .F.
		ENDIF
	ENDIF
*/
	RestArea(_aArea)

RETURN _lRet
