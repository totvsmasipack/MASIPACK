#include 'totvs.ch'

/*/{Protheus.doc} User Function RFATG063
Função utilizada no X3_RELACAO do campo C5_MSCATEG
Função utilizada no gatilho do campo C5_LOJACLI Seq.: 002
@type  Function
@author E.DINIZ
@since 10/02/2022
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
	Opções do campo: 0=Engenharia;1=Comercial;2=Comex;3=Pecas de Reposicao;4=Outros;5=Terceiros;6=Assist.Tecnica
@see (links_or_references)
/*/
User Function RFATG063()

Local aUsrInf	:= FWSFALLUSERS({ RetCodUsr() }, { "USR_DEPTO" })
Local aGroup	:= UsrRetGrp(RetCodUsr())
Local cRet		:= ''

	DO CASE

		CASE FWCodEmp() $ '01|10' .And. ( "PROJETOS" $ aUsrInf[1,3] .OR. "ENGENHARIA" $ aUsrInf[1,3] )
			cRet := '0'

		CASE FWCodEmp() $ '01|10' .And. "COMERCIAL" == aUsrInf[1,3]
			cRet := '1'

		CASE FWCodEmp() $ '01|10' .And. ( aScan(aGroup,'000211') > 0 .Or. "COMEX/COMERCIAL" == aUsrInf[1,3] )
			cRet := IIF( M->C5_TIPOCLI == "X", "2", "3" )

		CASE FWCodEmp() $ '01|10' .And. 	"VENDA DE PECAS" == aUsrInf[1,3] 
			cRet := IIF( M->C5_TIPOCLI == "X", "2", "3" )
		
		CASE FWCodEmp() $ '01|10' .And. "203-MAKLASER" == aUsrInf[1,3]
			cRet := '5'
		
		CASE FWCodEmp() $ '01|10' .And. ( aScan(aGroup,'000212') > 0 .Or. "ASSIST TECNICA" $ aUsrInf[1,3] )
			cRet := '6'

		CASE FWCodEmp() $ '01|10'
			cRet := '4'

	ENDCASE

Return cRet
