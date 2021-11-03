#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} RSCHG004
//TODO Descrição: Programa criado para atualização de Grupo Tributário e alíquotas de IPI, ICMS nos produtos conforme NCM.
@author ivandro.santos
@since 22/06/2018
@version 1.0
@return NIL
@type function
/*/

User Function RSCHG004()

	Local _nX		:= 0
	Local _aEmps	:= {'01','10'}

	If SubStr(Time(),1,5) <> '22:00' .OR. DOW(DATE()) == 7 .OR. DOW(DATE()) == 1 //SABADO E DOMINGO
		Return
	EndIf

	For _nX:=1 To Len(_aEmps)	
		RSCH4ABRE(_aEmps[_nX])
	Next _nX

Return

/*/{Protheus.doc} RSCH4ABRE
//TODO Descrição: Abre as empresas.
@author ivandro.santos
@since 22/06/2018
@version 1.0
@return NIL
@param _cNEmp, caracter, descricao: empresa que será aberta para a alteração
@type function
/*/

Static Function RSCH4ABRE(_cNEmp)

	Local _cEmail	 := ""
	Local _cSenha	 := ""
	Local _cRegAlt	 := ""
	Local _cEmpAlt	 := ""

	RPCSETTYPE(3)
	RpcSetEnv( _cNEmp, '01',,,)

	_cEmpAlt := 'Empresa ' + Alltrim(SM0->M0_NOME) + ': ajuste de alíquotas NCM - Data ' + DTOC(ddataBase) + ' Hora: ' + SubStr(Time(),1,5) + ''

	CONOUT(_cEmpAlt)

	nRegA := RSCH4QRY()

	_cRegAlt := 'Alterado(s) '+ Alltrim(Str(nRegA)) +' registro(s) de alíquotas IPI/ICMS ou Grupo Tributário'

	CONOUT(_cRegAlt)

	RSCH4MAIL(_cEmpAlt,_cRegAlt)

	CONOUT('Empresa: ' + Alltrim(SM0->M0_NOME) + '. Fim do ajuste alíquotas NCM as ' + SubStr(Time(),1,5) + '.')

	RpcClearEnv()

Return


/*/{Protheus.doc} RSCH4QRY
//TODO Descrição auto-gerada.
@author ivandro.santos
@since 22/06/2018
@version 1.0
@return nRegA, numeric, quantidade de registros alterados 
@type function
/*/

Static Function RSCH4QRY()

	Local nRegA		 := 0
	Local cAliasYDB1 := ""

	cAliasYDB1 := GetNextAlias()

	BeginSQL Alias cAliasYDB1
		SELECT 	B1_COD, 
				B1_DESC, 
				B1_POSIPI,
				B1.R_E_C_N_O_ 'REGISTRO', 
				CASE WHEN B1_IPI = YD_PER_IPI THEN 0 ELSE YD_PER_IPI END 'IPI',
				CASE WHEN B1_PICM = YD_ICMS_RE THEN 0 ELSE YD_ICMS_RE END 'ICM',
				CASE WHEN B1_GRTRIB = '' AND YD_BICMS = 'S' AND YD_ICMS_RE < 18 THEN '001' ELSE 
					 CASE WHEN B1_GRTRIB = '' AND YD_BICMS = 'S' AND YD_ICMS_RE >= 18 THEN '002' ELSE '' 
				END END 'GRUPO'
		FROM %table:SB1% B1
		LEFT JOIN %table:SYD% YD ON YD_FILIAL	= %xFilial:SYD% AND 
									YD_TEC 		= B1_POSIPI 	AND 
									YD.%notdel%
		WHERE 	B1_FILIAL = %xFilial:SB1% AND 
				(
					B1_IPI <> YD_PER_IPI 
					OR 
					B1_PICM <> YD_ICMS_RE OR
						(
							YD_BICMS = 'S' AND 
							B1_GRTRIB = ''
						)
				) AND B1.%notdel%
	EndSQL

	DbSelectArea("SB1")
	DbGoTop()
	While !((cAliasYDB1)->(EOF()))
		
		DbGoto((cAliasYDB1)->REGISTRO)
		
		Begin Transaction
		
			Reclock("SB1",.F.)
			
			If (cAliasYDB1)->IPI > 0
				SB1->B1_IPI := (cAliasYDB1)->IPI
			Endif
			
			If (cAliasYDB1)->ICM > 0
				SB1->B1_PICM := (cAliasYDB1)->ICM
			EndIf
			
			If !Empty(Alltrim((cAliasYDB1)->GRUPO))
				SB1->B1_GRTRIB := (cAliasYDB1)->GRUPO
			EndIf
			
			SB1->(MsUnlock())
		
		End Transaction
		
		(cAliasYDB1)->(DbSkip())
		nRegA++
	
	EndDo
	
	If select(cAliasYDB1) > 0
		(cAliasYDB1)->(DbCloseArea())
	EndIf
	
	SB1->(DbCloseArea())
	
Return nRegA

/*/{Protheus.doc} RSCH4MAIL
//TODO Descrição: prepara informações para enviar email.
@author ivandro.santos
@since 22/06/2018
@version 1.0
@return NIL
@param _cEmpAlt, caracter, descricao: informação sobre a empresa alterada
@param _cRegAlt, caracter, descricao: informação de quantos registros alterados
@type function
/*/

Static Function RSCH4MAIL(_cEmpAlt,_cRegAlt)

	Local _cEmail	 := GetMV("MV_WFMAIL")
	Local _cSenha	 := GetMV("MV_WFPASSW")
	Local _cDestino	 := "fiscal@masipack.com.br"
	Local _cMensagem := ""
	Local _cTitulo	 := 'Ajuste grupo tributário ou alíquotas IPI e ICMS'

	_cMensagem +=  _cEmpAlt + '. <br>' 
	_cMensagem += _cRegAlt

	oMail:= EnvMail():NEW(.T.)
	If oMail:ConnMail()
		oMail:SendMail(_cTitulo,_cDestino,,,_cMensagem)
	EndIf
	oMail:DConnMail()

Return