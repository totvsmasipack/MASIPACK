#include "totvs.ch"
#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#include "rwmake.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOMR035  ºAutor  ³Ivandro Santos      º Data ³  18/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório para listar pedidos de compras com restrição finanº±±
±±º          ³ceira. Ticket#2017011837000141 — CRIAÇÃO DE ROTINA          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRevisões  ³ 31/03/17-Criação função MSRE35PG - Ticket#2017033137000041 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RCOMR035()
Private CLRF      := CHR(13)+CHR(10)
Private cPerg     := "XCOMR35"
Private cFilCust  := SUPERGETMV( "ES_MSPENDF",,'01|10' )

Pergunte(cPerg,.T.)

MsAguarde({|| MSRE35QR() }, OemToAnsi("Analisando Pedidos com Pendência, Financeiro_Entrega") )
//Ticket#2017033137000041 — RELATÓRIO DE PC´S EM ABERTO
MsAguarde(IIF(MV_PAR01==1,{|| MSRE35PF() },{|| MSRE35PG() }), OemToAnsi("Gerando arquivo XML dos pedidos, Financeiro_Entrega") )
//MsAguarde({|| MSRE35PF() }, OemToAnsi("Gerando arquivo XML dos pedidos, Financeiro") )
//Ticket#2017033137000041 — Fim da alteração

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSRE35QR  ºAutor  ³Microsiga           º Data ³  18/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta a query para análise do relatório                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RCOMR035                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
//Ticket#2017033137000041 — RELATÓRIO DE PC´S EM ABERTO
If MV_PAR01 = 2
	_cQuery += "	C7_QUANT-C7_QUJE-C7_QTDACLA AS 'SALDO',													"+CLRF
	_cQuery += "	C7_PRECO, 																				"+CLRF
	_cQuery += "	C7_TOTAL, 																				"+CLRF
Endif
//Ticket#2017033137000041 - Fim da alteração
//Ivandro Santos - 07/02/18 - início da alteração: Ticket#2018020737000033 — Relatório
_cQuery += "	CASE WHEN C7_RETFOR = 'N' THEN 'NÃO' ELSE 'SIM' END 'RETFOR',								"+CLRF
_cQuery += "	SUBSTRING(C7_EMISSAO,7,2)+'/'+SUBSTRING(C7_EMISSAO,5,2)+'/'+SUBSTRING(C7_EMISSAO,1,4) 'C7_EMISSAO',	"+CLRF
_cQuery += "	SUBSTRING(C7_DATPRF,7,2)+'/'+SUBSTRING(C7_DATPRF,5,2)+'/'+SUBSTRING(C7_DATPRF,1,4) 'PRAZO',	"+CLRF
_cQuery += "	C7_NUMSC,																					"+CLRF
//Fim da alteração - Ticket#2018020737000033
_cQuery += "	C7_OBS 																						"+CLRF
_cQuery += "FROM "+RetSQLName("SC7")+" C7																	"+CLRF
_cQuery += "LEFT JOIN "+RetSQLName("SA2")+" A2 ON A2_COD+A2_LOJA = C7_FORNECE+C7_LOJA AND A2_MSBLQL <> '1'	"+CLRF
_cQuery += "WHERE 																							"+CLRF
_cQuery += "	C7_RESIDUO <> 'S' 																			"+CLRF
_cQuery += "	AND C7.D_E_L_E_T_ = '' 																		"+CLRF
_cQuery += "	AND C7_ENCER = '' 																			"+CLRF
//Ivandro Santos - 22/02/17
//Ticket#2017022237000211 — GERAÇÃO RELATÓRIO
If MV_PAR01 = 1
	_cQuery += "	AND RTRIM(LTRIM(C7_OBS)) <> ''		 													"+CLRF
Endif
_cQuery += "	AND SUBSTRING(C7_PRODUTO,1,2) <> 'TS'														"+CLRF
//_cQuery += "	AND C7_OBS LIKE ('%FIN%')																	"+CLRF
//Ticket#2017022237000211 — Fim da alteração                                                                      
//Ivandro Santos
//Ticket#2017033137000041 — RELATÓRIO DE PC´S EM ABERTO
_cQuery += "	AND C7_QUANT-C7_QUJE-C7_QTDACLA > 0															"+CLRF
//Ticket#2017033137000041 — Fim da alteração

_cQuery	+= " ORDER BY C7_NUM, C7_ITEM"

DbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery), "QRPC", .T., .F. )

Return                  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSRE35Pl  ºAutor  ³Ivandro Santos      º Data ³  18/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera planilha com os dados filtrados                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RCOMR035                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRevisões  ³ 31/03/17 - Alterado nome da função                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//Ivandro Santos
//Ticket#2017033137000041 — RELATÓRIO DE PC´S EM ABERTO
Static Function MSRE35PF()                             
//Static Function MSRE35Pl()                             
//Ticket#2017033137000041 — Fim da alteração

Local oExcel	:= FWMSEXCEL():New()


oExcel:AddWorkSheet("PC PENDÊNCIA FINANCEIRA")
oExcel:AddTable ("PC PENDÊNCIA FINANCEIRA","PEDIDOS")
oExcel:AddColumn("PC PENDÊNCIA FINANCEIRA","PEDIDOS","Pedido"		 ,2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIA FINANCEIRA","PEDIDOS","Item_PC"	 ,2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIA FINANCEIRA","PEDIDOS","Cod_Fornec",2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIA FINANCEIRA","PEDIDOS","Nome_Fornecedor",2,1,.F.)
If cEmpAnt $ cFilCust
	oExcel:AddColumn("PC PENDÊNCIA FINANCEIRA","PEDIDOS","Pendencia",2,1,.F.)
End
oExcel:AddColumn("PC PENDÊNCIA FINANCEIRA","PEDIDOS","Produto",2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIA FINANCEIRA","PEDIDOS","Desc_Produto",2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIA FINANCEIRA","PEDIDOS","Qtde",2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIA FINANCEIRA","PEDIDOS","Qt_Ent",2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIA FINANCEIRA","PEDIDOS","Ret_Fornecedor",2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIA FINANCEIRA","PEDIDOS","Emissão",2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIA FINANCEIRA","PEDIDOS","Entrega",2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIA FINANCEIRA","PEDIDOS","Num_Sol_Com",2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIA FINANCEIRA","PEDIDOS","Observação",2,1,.F.)

DbSelectArea("QRPC")
If Select("QRPC") > 0
	QRPC->(DBGotop())
	While QRPC->(!Eof())
		If cEmpAnt $ cFilCust
			oExcel:AddRow("PC PENDÊNCIA FINANCEIRA","PEDIDOS" ,{	QRPC->C7_NUM,;
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
			oExcel:AddRow("PC PENDÊNCIA FINANCEIRA","PEDIDOS" ,{	QRPC->C7_NUM,;
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSRE35PG  ºAutor  ³Ivandro Santos      º Data ³  31/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera planilha com os dados filtrados                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RCOMR035                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRevisões  ³ 31/03/17 - Criação de fonte - Ticket#2017033137000041      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MSRE35PG()

Local oExcel	:= FWMSEXCEL():New()

oExcel:AddWorkSheet("PC PENDÊNCIAS GERAIS")
oExcel:AddTable ("PC PENDÊNCIAS GERAIS","PEDIDOS")
oExcel:AddColumn("PC PENDÊNCIAS GERAIS","PEDIDOS","Pedido"		 ,2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIAS GERAIS","PEDIDOS","Item_PC"	 ,2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIAS GERAIS","PEDIDOS","Cod_Fornec",2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIAS GERAIS","PEDIDOS","Nome_Fornecedor",2,1,.F.)
If cEmpAnt $ cFilCust
	oExcel:AddColumn("PC PENDÊNCIAS GERAIS","PEDIDOS","Pendencia",2,1,.F.)
End
oExcel:AddColumn("PC PENDÊNCIAS GERAIS","PEDIDOS","Produto",2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIAS GERAIS","PEDIDOS","Desc_Produto",2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIAS GERAIS","PEDIDOS","Qtde",2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIAS GERAIS","PEDIDOS","Saldo",2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIAS GERAIS","PEDIDOS","Valor_Unit",2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIAS GERAIS","PEDIDOS","Valor_Total",2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIAS GERAIS","PEDIDOS","Ret_Fornecedor",2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIAS GERAIS","PEDIDOS","Emissão",2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIAS GERAIS","PEDIDOS","Entrega",2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIAS GERAIS","PEDIDOS","Num_Sol_Com",2,1,.F.)
oExcel:AddColumn("PC PENDÊNCIAS GERAIS","PEDIDOS","Observação",2,1,.F.)

DbSelectArea("QRPC")
If Select("QRPC") > 0
	QRPC->(DBGotop())
	While QRPC->(!Eof())
		If  cEmpAnt $ cFilCust
			oExcel:AddRow("PC PENDÊNCIAS GERAIS","PEDIDOS" ,{	QRPC->C7_NUM,;
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
			oExcel:AddRow("PC PENDÊNCIAS GERAIS","PEDIDOS" ,{	QRPC->C7_NUM,;
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
