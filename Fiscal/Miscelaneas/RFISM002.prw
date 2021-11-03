#include 'protheus.ch'
#include 'parmtype.ch'
#include 'totvs.ch'

/*/{Protheus.doc} RFISM002
// Função para atualizar os NCM's dos livros fiscais que estejam em branco.
// Esta função está designada para contorno do incidente relacionado ao SPED FISCAL - Registros 0200
@author Everton Diniz - DS2U
@since 12/08/2019
@version 1.0
@type function
/*/
User Function RFISM002()
Local cPerg		:= "RFISM002"
	
	If ! Pergunte(cPerg,.T.)
		Return
	Else
		Processa( {|| f_UpdNCM() }, "Aguarde", )
	Endif

Return

//Função para buscar os registros da SFT atualizar o NCM de acordo com o SB1
Static Function f_UpdNCM()
Local cAlsSFT	:= GetNextAlias()
Local nCont	:= 0
	BeginSQL Alias cAlsSFT
	
		SELECT FT.R_E_C_N_O_ AS FTRECNO, B1.R_E_C_N_O_ AS B1RECNO
		FROM %Table:SFT% FT, %Table:SB1% B1
		WHERE FT_FILIAL = %xFilial:SFT% AND
		B1_FILIAL = %xFilial:SB1% AND
		FT_ENTRADA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% AND
		FT_PRODUTO = B1_COD AND
		FT.%NotDel% AND
		B1.%NotDel%

	EndSql
	
	If (cAlsSFT)->(EOF())
		Alert("Não encontramos Notas Fiscais para atualização. ")
		Return
	EndIf
	
	(cAlsSFT)->(dbGoTop())
	
	While (cAlsSFT)->(!EOF())
		nCont++
		(cAlsSFT)->(dbSkip())
	Enddo
	
	ProcRegua(nCont)
	
	(cAlsSFT)->(dbGoTop())
	
	While (cAlsSFT)->(!EOF())
		
		INCPROC()
		
		SFT->(dbGoTo((cAlsSFT)->FTRECNO))
		
		If Empty(SFT->FT_POSIPI)
			SB1->(dbGoTo((cAlsSFT)->B1RECNO))
			Reclock("SFT",.F.)
			Replace SFT->FT_POSIPI	With	SB1->B1_POSIPI
			Replace SFT->FT_CONTA	With	SB1->B1_CONTA
			SFT->(MsUnlock())
		Endif
		
		(cAlsSFT)->(dbSkip())

	Enddo
	
	(cAlsSFT)->(dbCloseArea())
	
	MsgAlert("Processamento Concluído!")
	
Return