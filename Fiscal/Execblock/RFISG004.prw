#include "totvs.ch"
#include "fwmvcdef.ch"

/*/
@Program: RFISG004
@Description: Atualiza a descrição científica (SB5) após preenchida a descrição do produto (B1_DESC)
@Date: 14.10.2019
@Author: Específico Masipack
/*/

User Function RFISG004()

Local cRet      := SPACE(TamSX3('B5_CEME')[1])
Local oModel	:= FWModelActive()
Local oModelSB5 := oModel:GetModel("SB5DETAIL")

Default INLCUI := .T.
Default ALTERA := .T.

   	If !(oModelSB5 == Nil) .And. ( INCLUI .OR. ALTERA )

        If !( Empty(oModelSB5:GetValue("B5_CEME")) )
            If FwAlertYesNo('Deseja substituir o Nome Científico pela Descrição do produto?','Atenção')
                cRet := Mta010Ceme()
            Endif
        Else
            cRet := Mta010Ceme()
        Endif

    Endif
        
Return cRet
