#Include "Rwmake.ch"
#Include "Topconn.ch"
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA410LEG  บAutor  ณLizandra Marques    บ Data ณ  16/10/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Nova legenda para pedidos de vendas (cor de rosa)          บฑฑ
ฑฑบ          ณ pedido parcialmente faturado                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - Masipack                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MA410LEG()

Local _aRet		:= {}
//Local lFldAprov	:= !Empty(FWSX3Util():GetFieldType( "C5_MSAPROV" ))
Local lFldPrior	:= !Empty(FWSX3Util():GetFieldType( "C5_MSPRIOR" ))
Local lFldLibPv	:= !Empty(FWSX3Util():GetFieldType( "C5_MSLIBPV" ))
Local lFldCateg	:= !Empty(FWSX3Util():GetFieldType( "C5_MSCATEG" ))

    AADD(_aRet,{'ENABLE'	,'Pedido de Venda em aberto'			})
	AADD(_aRet,{'DISABLE'	,'Pedido de Venda encerrado'			})
	AADD(_aRet,{'BR_AMARELO','Pedido de Venda liberado'				})
	AADD(_aRet,{'BR_AZUL'	,'Pedido de Venda com Bloqueio de Regra'})
	AADD(_aRet,{'BR_LARANJA','Pedido de Venda com Bloqueio de Verba'})
/*
	If lFldAprov
		AADD(_aRet,{'BR_CINZA'	,'Pedido de Venda aguardando libera็ใo do Fiscal'})
	Endif
*/
	If lFldLibPv .And. lFldCateg .And. lFldPrior
		AADD(_aRet,{'BR_BRANCO'			,'Pedido de Venda aguardando lib PCP Categ: 2/3'		})			  
		AADD(_aRet,{'BR_MARROM'			,'Pedido de Venda aguardando lib Almox Categ: 2/3'		})			  
		AADD(_aRet,{'BR_PRETO'			,'Pedido de Venda aguardando lib PCP Categ: 0'			})			  
		AADD(_aRet,{'BR_VERDE_ESCURO'	,'Pedido de Venda aguardando lib Almox Categ: 0'		})
	Endif

Return _aRet
