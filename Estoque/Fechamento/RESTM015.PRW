#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RESTM015  �Autor  �Victor Dessunte     � Data �  09/20/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ajusta a quantidade de MOD de acordo com calculos da folha ���
�������������������������������������������������������������������������͹��
���Uso       � Grupo Masipack                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RESTM015()

	Local _cQry 	:= ""
	Local _cVer		:= ""
	Local _nStatus	:= 0
	Local dMvUlMes	:= SuperGetMv('MV_ULMES',.F.,date())
	Local dDatePar	:= ''

	If Pergunte("RESTM015",.T.)
		dDatePar :=	lastday(stod(MV_PAR02+'01'))
		If dDatePar > dMvUlMes
			_cQry := " 	UPDATE " + CRLF
			_cQry +=			RetSqlName("SD3")
			_cQry += "	SET " + CRLF
			_cQry += "		D3_QUANT = D3_QUANT * " + CRLF
			_cQry += "	(SELECT " + CRLF
			_cQry += 		ALLTRIM(STR(MV_PAR03))
			_cQry += "		/(	SELECT " + CRLF
			_cQry += "				ROUND(SUM(D3_QUANT) ,2) TOTAL " + CRLF
			_cQry += "			FROM " + CRLF
			_cQry += 				RetSqlName("SD3")
			_cQry += "			WHERE " + CRLF
			_cQry += "					D_E_L_E_T_	= ' ' " + CRLF
			_cQry += "			AND 	D3_ESTORNO	= ' ' " + CRLF
			_cQry += "			AND	D3_FILIAL	= '" + xFilial("SD3") + "' " + CRLF
			_cQry += "			AND 	D3_COD		LIKE '" + MV_PAR01 + "' " + CRLF
			_cQry += "			AND 	D3_EMISSAO	LIKE '" + MV_PAR02 + "%') AS 'COEF') " + CRLF
			_cQry += "	WHERE " + CRLF
			_cQry += "			D_E_L_E_T_	= ' ' " + CRLF
			_cQry += "	AND 	D3_FILIAL	= '" + xFilial("SD3") + "' " + CRLF
			_cQry += "	AND 	D3_COD		= '" + MV_PAR01 + "' " + CRLF
			_cQry += "	AND 	D3_ESTORNO	= '' " + CRLF
			_cQry += "	AND 	D3_EMISSAO	LIKE '" + MV_PAR02 + "%' "

			_nStatus := TCSQLEXEC(_cQry)

			If _nStatus < 0
				Alert("Aten��o, rotina n�o executada. " +  CRLF + "Erro: " + TCSQLERROR())
			Else
				_cVer	:= " SELECT " + CRLF
				_cVer += " 		ROUND(SUM(D3_QUANT) ,2) TOTAL " + CRLF
				_cVer += " FROM " + CRLF
				_cVer +=  		RetSqlName("SD3")
				_cVer += " WHERE " + CRLF
				_cVer += " 			D_E_L_E_T_	= ' ' " + CRLF
				_cVer += " AND 	D3_ESTORNO	= ' ' " + CRLF
				_cVer += " AND		D3_FILIAL	= '" + xFilial("SD3") + "' " + CRLF
				_cVer += " AND 	D3_COD		LIKE '" + MV_PAR01 + "' " + CRLF
				_cVer += " AND 	D3_EMISSAO	LIKE '" + MV_PAR02 + "%'

				If Select("TRB") > 0
					TRB->(dbCloseArea())
				EndIf

				TCQUERY _cVer NEW ALIAS "TRB"

				TRB->(dbGoTop())
				If TRB->TOTAL == MV_PAR03
					MessageBox("Atualiza��o conclu�da","",64)
				Else
					Alert("Divergencia na atualiza��o: " + ALLTRIM(STR(TRB->TOTAL - MV_PAR03)))
				EndIf

				If Select("TRB") > 0
					TRB->(dbCloseArea())
				EndIf
			EndIf
		Else
			Alert('Periodo selecionado j� se encontra fechado, n�o � possivel fazer as altera��es!')
		EndIF
	EndIf
Return
