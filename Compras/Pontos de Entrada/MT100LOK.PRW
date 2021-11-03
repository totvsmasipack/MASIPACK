#include 'totvs.ch'
#include 'FwMVCDef.ch'


/*/{Protheus.doc} User Function MT100LOK
Validação na linha do item da NF.
@type  Function
@author Masipack
@since 08/05/2020
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see https://centraldeatendimento.totvs.com/hc/pt-br/articles/360019809012-MP-ADVPL-MT100LOK
/*/
User Function MT100LOK()

Local aArea    := GetArea()
Local lRet     := .T.
Local nPosCod  := 0
Local nPoscc   := 0

   nPosCod := aScan(aHeader,{|x| UPPER(AllTrim(x[2])) == "D1_COD" })

   SB1->(dbSetOrder(1))
   If SB1->(dbSeek(FWxFilial("SB1") + PadR(aCols[n][nPosCod], TamSX3("B1_COD")[1])))
      If Empty(SB1->B1_POSIPI)
         lRet := .F.
         FwAlertError("Produto não possui NCM.")
      Endif
   Else
      lRet := .F.
      FwAlertError("Produto não cadastrado.")
   Endif

   //Validação se no item foi informado a conta contabil

   nPosCc := aScan(aHeader,{|x| UPPER(AllTrim(x[2])) == "D1_CONTA" })

    //If Empty(SD1->D1_CONTA)
	   If Empty(aCols[n,nPosCc]).and.l103Class
    	   lRet := .F.
    	   FwAlertError("Item não possui conta contabil.")
    Endif

   RestArea(aArea)

Return lRet
