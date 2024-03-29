#include "totvs.ch"
#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#include "rwmake.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCOMR035  �Autor  �Ivandro Santos      � Data �  18/01/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio para listar pedidos de compras com restri��o finan���
���          �ceira. Ticket#2017011837000141 � CRIA��O DE ROTINA          ���
�������������������������������������������������������������������������͹��
���Uso       � PCP                                                        ���
�������������������������������������������������������������������������ͼ��
���Revis�es  � 31/03/17-Cria��o fun��o MSRE35PG - Ticket#2017033137000041 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RCOMR035()
Private CLRF      := CHR(13)+CHR(10)
Private cPerg     := "XCOMR35"
Private cFilCust  := SUPERGETMV( "ES_MSPENDF",,'01|10' )

Pergunte(cPerg,.T.)

MsAguarde({|| MSRE35QR() }, OemToAnsi("Analisando Pedidos com Pend�ncia, Financeiro_Entrega") )
//Ticket#2017033137000041 � RELAT�RIO DE PC�S EM ABERTO
MsAguarde(IIF(MV_PAR01==1,{|| MSRE35PF() },{|| MSRE35PG() }), OemToAnsi("Gerando arquivo XML dos pedidos, Financeiro_Entrega") )
//MsAguarde({|| MSRE35PF() }, OemToAnsi("Gerando arquivo XML dos pedidos, Financeiro") )
//Ticket#2017033137000041 � Fim da altera��o

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MSRE35QR  �Autor  �Microsiga           � Data �  18/01/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Monta a query para an�lise do relat�rio                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � RCOMR035                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MSRE35QR()

If Select("QRPCF") > 0
	DbSelectArea("QRPCF")
	DbCloseArea()
EndIf
_cQuery := "SELECT                                                                                          "+CLRF
_cQuery += "	C7_NUM, 																					"+CLRF
_cQuery += "	C7_ITEM, 																					"+CLRF
_cQuery += "	C7_FORNECE,																					"+CLRF
_cQuery += "	A2_NREDUZ, 																					"+CLRF
If cEmpAnt $ cFilCust
	_cQuery += "	CASE 																					"+CLRF
	_cQuery += "	WHEN A2_XPENDFI = '1' THEN 'Sim'														"+CLRF
	_cQuery += "		ELSE 'Nao'																			"+CLRF
	_cQuery += "		END PEND_FIN, 																		"+CLRF
EndIf 
_cQuery += "	C7_PRODUTO, 																				"+CLRF
_cQuery += "	C7_DESCRI, 																					"+CLRF
_cQuery += "	C7_QUANT, 																					"+CLRF
_cQuery += "	C7_QUJE, 																					"+CLRF
//Ivandro Santos
//Ticket#2017033137000041 � RELAT�RIO DE PC�S EM ABERTO
If MV_PAR01 = 2
	_cQuery += "	C7_QUANT-C7_QUJE-C7_QTDACLA AS 'SALDO',													"+CLRF
	_cQuery += "	C7_PRECO, 																				"+CLRF
	_cQuery += "	C7_TOTAL, 																				"+CLRF
Endif
//Ticket#2017033137000041 - Fim da altera��o
//Ivandro Santos - 07/02/18 - in�cio da altera��o: Ticket#2018020737000033 � Relat�rio
_cQuery += "	CASE WHEN C7_RETFOR = 'N' THEN 'N�O' ELSE 'SIM' END 'RETFOR',								"+CLRF
_cQuery += "	SUBSTRING(C7_EMISSAO,7,2)+'/'+SUBSTRING(C7_EMISSAO,5,2)+'/'+SUBSTRING(C7_EMISSAO,1,4) 'C7_EMISSAO',	"+CLRF
_cQuery += "	SUBSTRING(C7_DATPRF,7,2)+'/'+SUBSTRING(C7_DATPRF,5,2)+'/'+SUBSTRING(C7_DATPRF,1,4) 'PRAZO',	"+CLRF
_cQuery += "	C7_NUMSC,																					"+CLRF
//Fim da altera��o - Ticket#2018020737000033
_cQuery += "	C7_OBS 																						"+CLRF
_cQuery += "FROM "+RetSQLName("SC7")+" C7																	"+CLRF
_cQuery += "LEFT JOIN "+RetSQLName("SA2")+" A2 ON A2_COD+A2_LOJA = C7_FORNECE+C7_LOJA AND A2_MSBLQL <> '1'	"+CLRF
_cQuery += "WHERE 																							"+CLRF
_cQuery += "	C7_RESIDUO <> 'S' 																			"+CLRF
_cQuery += "	AND C7.D_E_L_E_T_ = '' 																		"+CLRF
_cQuery += "	AND C7_ENCER = '' 																			"+CLRF
//Ivandro Santos - 22/02/17
//Ticket#2017022237000211 � GERA��O RELAT�RIO
If MV_PAR01 = 1
	_cQuery += "	AND RTRIM(LTRIM(C7_OBS)) <> ''		 													"+CLRF
Endif
_cQuery += "	AND SUBSTRING(C7_PRODUTO,1,2) <> 'TS'														"+CLRF
//_cQuery += "	AND C7_OBS LIKE ('%FIN%')																	"+CLRF
//Ticket#2017022237000211 � Fim da altera��o                                                                      
//Ivandro Santos
//Ticket#2017033137000041 � RELAT�RIO DE PC�S EM ABERTO
_cQuery += "	AND C7_QUANT-C7_QUJE-C7_QTDACLA > 0															"+CLRF
//Ticket#2017033137000041 � Fim da altera��o

_cQuery	+= " ORDER BY C7_NUM, C7_ITEM"

DbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery), "QRPC", .T., .F. )

Return                  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MSRE35Pl  �Autor  �Ivandro Santos      � Data �  18/01/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera planilha com os dados filtrados                       ���
�������������������������������������������������������������������������͹��
���Uso       � RCOMR035                                                   ���
�������������������������������������������������������������������������ͼ��
���Revis�es  � 31/03/17 - Alterado nome da fun��o                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Ivandro Santos
//Ticket#2017033137000041 � RELAT�RIO DE PC�S EM ABERTO
Static Function MSRE35PF()                             
//Static Function MSRE35Pl()                             
//Ticket#2017033137000041 � Fim da altera��o

Local oExcel	:= FWMSEXCEL():New()


oExcel:AddWorkSheet("PC PEND�NCIA FINANCEIRA")
oExcel:AddTable ("PC PEND�NCIA FINANCEIRA","PEDIDOS")
oExcel:AddColumn("PC PEND�NCIA FINANCEIRA","PEDIDOS","Pedido"		 ,2,1,.F.)
oExcel:AddColumn("PC PEND�NCIA FINANCEIRA","PEDIDOS","Item_PC"	 ,2,1,.F.)
oExcel:AddColumn("PC PEND�NCIA FINANCEIRA","PEDIDOS","Cod_Fornec",2,1,.F.)
oExcel:AddColumn("PC PEND�NCIA FINANCEIRA","PEDIDOS","Nome_Fornecedor",2,1,.F.)
If cEmpAnt $ cFilCust
	oExcel:AddColumn("PC PEND�NCIA FINANCEIRA","PEDIDOS","Pendencia",2,1,.F.)
End
oExcel:AddColumn("PC PEND�NCIA FINANCEIRA","PEDIDOS","Produto",2,1,.F.)
oExcel:AddColumn("PC PEND�NCIA FINANCEIRA","PEDIDOS","Desc_Produto",2,1,.F.)
oExcel:AddColumn("PC PEND�NCIA FINANCEIRA","PEDIDOS","Qtde",2,1,.F.)
oExcel:AddColumn("PC PEND�NCIA FINANCEIRA","PEDIDOS","Qt_Ent",2,1,.F.)
oExcel:AddColumn("PC PEND�NCIA FINANCEIRA","PEDIDOS","Ret_Fornecedor",2,1,.F.)
oExcel:AddColumn("PC PEND�NCIA FINANCEIRA","PEDIDOS","Emiss�o",2,1,.F.)
oExcel:AddColumn("PC PEND�NCIA FINANCEIRA","PEDIDOS","Entrega",2,1,.F.)
oExcel:AddColumn("PC PEND�NCIA FINANCEIRA","PEDIDOS","Num_Sol_Com",2,1,.F.)
oExcel:AddColumn("PC PEND�NCIA FINANCEIRA","PEDIDOS","Observa��o",2,1,.F.)

DbSelectArea("QRPC")
If Select("QRPC") > 0
	QRPC->(DBGotop())
	While QRPC->(!Eof())
		If cEmpAnt $ cFilCust
			oExcel:AddRow("PC PEND�NCIA FINANCEIRA","PEDIDOS" ,{	QRPC->C7_NUM,;
			QRPC->C7_ITEM														,;
			QRPC->C7_FORNECE													,;
			QRPC->A2_NREDUZ														,;
			QRPC->PEND_FIN														,;
			QRPC->C7_PRODUTO													,;
			QRPC->C7_DESCRI														,;
			QRPC->C7_QUANT														,;
			QRPC->C7_QUJE														,;
			QRPC->RETFOR														,;
			QRPC->C7_EMISSAO													,;
			QRPC->PRAZO															,;
			QRPC->C7_NUMSC														,;
			QRPC->C7_OBS})
			QRPC->(dbSkip())
		Else 
			oExcel:AddRow("PC PEND�NCIA FINANCEIRA","PEDIDOS" ,{	QRPC->C7_NUM,;
			QRPC->C7_ITEM														,;
			QRPC->C7_FORNECE													,;
			QRPC->A2_NREDUZ														,;
			QRPC->C7_PRODUTO													,;
			QRPC->C7_DESCRI														,;
			QRPC->C7_QUANT														,;
			QRPC->C7_QUJE														,;
			QRPC->RETFOR														,;
			QRPC->C7_EMISSAO													,;
			QRPC->PRAZO															,;
			QRPC->C7_NUMSC														,;
			QRPC->C7_OBS})
			QRPC->(dbSkip())
		EndIf 
	End
EndIf



oExcel:Activate()
oExcel:GetXMLFile("C:/RELATO_MICROSIGA/RCOMR035.xml")

If File("C:/RELATO_MICROSIGA/RCOMR035.xml")
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open("C:/RELATO_MICROSIGA/RCOMR035.xml")
	oExcelApp:SetVisible(.T.)
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MSRE35PG  �Autor  �Ivandro Santos      � Data �  31/03/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera planilha com os dados filtrados                       ���
�������������������������������������������������������������������������͹��
���Uso       � RCOMR035                                                   ���
�������������������������������������������������������������������������ͼ��
���Revis�es  � 31/03/17 - Cria��o de fonte - Ticket#2017033137000041      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MSRE35PG()

Local oExcel	:= FWMSEXCEL():New()

oExcel:AddWorkSheet("PC PEND�NCIAS GERAIS")
oExcel:AddTable ("PC PEND�NCIAS GERAIS","PEDIDOS")
oExcel:AddColumn("PC PEND�NCIAS GERAIS","PEDIDOS","Pedido"		 ,2,1,.F.)
oExcel:AddColumn("PC PEND�NCIAS GERAIS","PEDIDOS","Item_PC"	 ,2,1,.F.)
oExcel:AddColumn("PC PEND�NCIAS GERAIS","PEDIDOS","Cod_Fornec",2,1,.F.)
oExcel:AddColumn("PC PEND�NCIAS GERAIS","PEDIDOS","Nome_Fornecedor",2,1,.F.)
If cEmpAnt $ cFilCust
	oExcel:AddColumn("PC PEND�NCIAS GERAIS","PEDIDOS","Pendencia",2,1,.F.)
End
oExcel:AddColumn("PC PEND�NCIAS GERAIS","PEDIDOS","Produto",2,1,.F.)
oExcel:AddColumn("PC PEND�NCIAS GERAIS","PEDIDOS","Desc_Produto",2,1,.F.)
oExcel:AddColumn("PC PEND�NCIAS GERAIS","PEDIDOS","Qtde",2,1,.F.)
oExcel:AddColumn("PC PEND�NCIAS GERAIS","PEDIDOS","Saldo",2,1,.F.)
oExcel:AddColumn("PC PEND�NCIAS GERAIS","PEDIDOS","Valor_Unit",2,1,.F.)
oExcel:AddColumn("PC PEND�NCIAS GERAIS","PEDIDOS","Valor_Total",2,1,.F.)
oExcel:AddColumn("PC PEND�NCIAS GERAIS","PEDIDOS","Ret_Fornecedor",2,1,.F.)
oExcel:AddColumn("PC PEND�NCIAS GERAIS","PEDIDOS","Emiss�o",2,1,.F.)
oExcel:AddColumn("PC PEND�NCIAS GERAIS","PEDIDOS","Entrega",2,1,.F.)
oExcel:AddColumn("PC PEND�NCIAS GERAIS","PEDIDOS","Num_Sol_Com",2,1,.F.)
oExcel:AddColumn("PC PEND�NCIAS GERAIS","PEDIDOS","Observa��o",2,1,.F.)

DbSelectArea("QRPC")
If Select("QRPC") > 0
	QRPC->(DBGotop())
	While QRPC->(!Eof())
		If  cEmpAnt $ cFilCust
			oExcel:AddRow("PC PEND�NCIAS GERAIS","PEDIDOS" ,{	QRPC->C7_NUM,;
			QRPC->C7_ITEM														,;
			QRPC->C7_FORNECE													,;
			QRPC->A2_NREDUZ														,;
			QRPC->PEND_FIN														,;
			QRPC->C7_PRODUTO													,;
			QRPC->C7_DESCRI														,;
			QRPC->C7_QUANT														,;
			QRPC->SALDO															,;
			QRPC->C7_PRECO														,;
			QRPC->C7_TOTAL														,;
			QRPC->RETFOR														,;
			QRPC->C7_EMISSAO													,;
			QRPC->PRAZO															,;
			QRPC->C7_NUMSC														,;
			QRPC->C7_OBS})
			QRPC->(dbSkip())
		Else 
			oExcel:AddRow("PC PEND�NCIAS GERAIS","PEDIDOS" ,{	QRPC->C7_NUM,;
			QRPC->C7_ITEM														,;
			QRPC->C7_FORNECE													,;
			QRPC->A2_NREDUZ														,;
			QRPC->C7_PRODUTO													,;
			QRPC->C7_DESCRI														,;
			QRPC->C7_QUANT														,;
			QRPC->SALDO															,;
			QRPC->C7_PRECO														,;
			QRPC->C7_TOTAL														,;
			QRPC->RETFOR														,;
			QRPC->C7_EMISSAO													,;
			QRPC->PRAZO															,;
			QRPC->C7_NUMSC														,;
			QRPC->C7_OBS})
			QRPC->(dbSkip())
		EndIf 
	End
EndIf



oExcel:Activate()
oExcel:GetXMLFile("C:/RELATO_MICROSIGA/RCOMR035.xml")

If File("C:/RELATO_MICROSIGA/RCOMR035.xml")
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open("C:/RELATO_MICROSIGA/RCOMR035.xml")
	oExcelApp:SetVisible(.T.)
EndIf

Return
