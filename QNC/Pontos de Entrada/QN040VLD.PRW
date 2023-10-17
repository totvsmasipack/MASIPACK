#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} User Function QN040VLD
P.E. Ajusta a Matrícula do Digitador e do Responsavel
https://tdn.totvs.com/pages/releaseview.action?pageId=6801049
@type  Function
@author Masipack
@since 25/02/2020
@return lRet
/*/

User Function QN040VLD()

Local _aArea := GetArea()
Local _lRet  := .F.

	If (!Empty(M->QI2_MAT) .OR. !EMPTY(M->QI2_MATRES)) .OR. (AllTrim(M->QI2_MAT) <> AllTrim(M->QI2_MATRES))
		M->QI2_MATRES := M->QI2_MAT
		_lRet := .T.
	EndIf
	//If M->QI2_CONREA < dDataBase
	//	MsgAlert("A data de conclusão não pode ser menor do que a data de hoje!", "Atenção")
	//EndIf
	RestArea(_aArea)

Return _lRet
