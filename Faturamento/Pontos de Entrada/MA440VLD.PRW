#include "totvs.ch"

/*/{Protheus.doc} MA440VLD
	O ponto de entrada Ma440VLD será executado na confirmação da liberação de um pedido de vendas e 
	será utilizado para que o usuário possa realizar validações antes de efetuar a autorização de liberação.
@type  Function
@author Masipack
@since 21/04/2020
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see https://tdn.totvs.com.br/pages/releaseview.action?pageId=6784532
/*/
User Function MA440VLD()

Local _aNaturez := {'V02.1' ,'V01', 'V02.3','V02.4'}
Local aEmpGru   := {"MASIPACK","FABRIMA","HELSIMPLAST"}
Local aNomEmp	:= {"",""}
Local aDadosEmp	:= {}
Local cSubject	:= ""
Local cMessage	:= ""
Local cTo		:= ""

Local lRet		:= .T.
Local lGrp		:= IF(SC5->C5_CLIENTE $ GetMV('MS_GRUPO'),.T.,.F.)

Local _nEmG		:= 0
Local _nNat		:= 0
Local _nCli		:= 0

Default cEmpAnt	:= "01"
Default cNumEmp	:= "0101"

	IF SC5->C5_TIPO == "N"
		
		aNomEmp[1] := Alltrim(SM0->M0_NOME)
		For _nEmG := 1 to len(aEmpGru)
			If !(aEmpGru[_nEmG] == aNomEmp[1])
				aNomEmp[2] := aEmpGru[_nEmG]
				aDadosEmp := U_MSACHAEM(aNomEmp,cNumEmp)
				_aCli := U_MSCODCLI(aDadosEmp)
				For _nNat := 1 to len(_aNaturez)
					For _nCli := 1 to len(_aCli)
						If _aCli[_nCli] == SC5->C5_CLIENTE+SC5->C5_LOJACLI .And. Alltrim(SC5->C5_NATUREZ) == Alltrim(_aNaturez[_nNat])
							lRet := U_RFATA071(SC5->C5_NUM,aDadosEmp)
						Endif
					Next _nCli
				Next _nNat
			Endif
		Next _nEmG
		
		SA1->(DbSetOrder(1))
		If SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)) .And. !lGrp
			If AllTrim(SA1->A1_RISCO) $ "B|C|D|E"
				lRet := .F.
				FwAlertError("Cliente possui restrição financeira. Favor verificar com Depto. Financeiro!!!")
			EndIf
		EndIf
	
	EndIf
/*	
	IF lRet .And. ExistCpo("SX3","C5_MSAPROV",2)

		If SC5->C5_MSAPROV == 'N'
			lRet := .F.
			Help('',1,'PEDBLOQ', ,'O pedido está aguardando a liberação do departamento Fiscal', 1)

			cTo		 := "contabil@masipack.com.br"
			cSubject := "Pedido Pendente Liberação - Fiscal "+M->C5_NUM
			cMessage := "Pedido  : " + SC5->C5_NUM + CHR(13)+CHR(10)
			cMessage += "Cliente : " + Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NREDUZ") + CHR(13)+CHR(10)
			cMessage += "Natureza: " + Posicione("SED",1,xFilial("SED")+SC5->C5_NATUREZ,"ED_DESCRIC") + CHR(13)+CHR(10)
			
			oMail:= EnvMail():NEW(.F.)
			If oMail:ConnMail()
				oMail:SendMail(cSubject,cTo,,,cMessage)
			EndIf
			oMail:DConnMail()
		Endif

	ENDIF
*/
	If lRet .And. cEmpAnt == '10' .And. (SC5->C5_PESOL == 0 .OR. SC5->C5_PBRUTO == 0 .OR. SC5->C5_VOLUME1 == 0)
		lRet := .F.
		Help('',1,'PEDVOLPESO', ,'As informações de Peso/Volume são de prenchimento obrigatório!', 1)
	Endif

Return lRet
