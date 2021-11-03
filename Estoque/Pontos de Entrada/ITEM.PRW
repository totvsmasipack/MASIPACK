#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'FWMVCDEF.CH'
#include "topconn.ch"

/*/{Protheus.doc} ITEM
//TODO Descrição P.E. para gravar a descrição no componente da estrutura (campo G1_MSDESCC).
@author ivandro.santos
@since 21/03/2018
@version 1.0
@return xRet, lógico

@type User function
/*/
User Function ITEM()

	Local aParam := PARAMIXB
	Local xRet 		 := .T.
	Local oObj 		 := ''
	Local cIdPonto 	 := ''
	Local cIdModel 	 := ''
	Local lIsGrid 	 := .F.
	Local nLinha 	 := 0
	Local nQtdLinhas := 0
	Local cDescr	 := ''
	Local cQuery	 := ''
	Local _aAreaB1	 := SB1->(GetArea())
	Local _aAreaG1	 := SG1->(GetArea())

	If aParam <> NIL
		oObj := aParam[1]
		cIdPonto := aParam[2]
		cIdModel := aParam[3]
		lIsGrid := ( Len( aParam ) > 3 )

		If cIdPonto == 'MODELCOMMITTTS'
			cDescr := Alltrim(M->B1_DESC)
			cQuery := "SELECT G1.R_E_C_N_O_ 'nRecnoSG1' FROM "+RetSQLName("SG1")+" G1 WHERE G1.D_E_L_E_T_ = '' AND G1.G1_FILIAL = '"+xFilial("SG1")+"' AND G1_COMP = '"+M->B1_COD+"'"
			If Select("QRY") > 0
				DbSelectArea("QRY")
				DbCloseArea()
			Endif            

			TcQuery cQuery new Alias "QRY"
			DbSelectArea("QRY")
			DbGoTop()
			DbSelectArea("SG1")
			DbSetOrder(2)
			While !(QRY->(Eof()))
				SG1->( dbGoTo( QRY->nRecnoSG1 ) )
				Begin Transaction
					Reclock("SG1",.F.)
					SG1->G1_MSDESCC := cDescr
					SG1->(MsUnLock())
				End Transaction
				QRY->(DbSkip())
			EndDo		
			SG1->(DbCloseArea())
		ElseIF  cIdPonto == 'MODELPOS'
			//xRet	:= ValCeme(xRet)
		EndIF	
	Endif

	RestArea(_aAreaB1)
	RestArea(_aAreaG1)
return xRet


/*/{Protheus.doc} ValCeme
//TODO Valida o nome cientifico
@author alison.goncalves
@since 06/07/2018
@version 1.0
@return Logico
@param xRet, , descricao
@type function
/*/
Static Function ValCeme(xRet)
	Default xRet := .F.
		If xRet	
			If Select('SB5') >= 0
				If Empty(M->B5_CEME)
					xRet := .F.
					Alert('Nome ciêntifico esta em branco!, Por favor Preencher!')
				EndIf
			EndIf	
		EndIf 
Return xRet		
