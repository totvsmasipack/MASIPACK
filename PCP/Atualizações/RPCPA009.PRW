/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  砇PCPA009  篈utor  矹ose Roberto Funari                      罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北� Desc.    �  Verifica Produtos sem Estruturas em Pedidos de Vendas     罕�
北� Data     �  20/11/2006                                                罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � AP - MASIPACK.                                             罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/
#Include "Rwmake.ch"

User Function RPCPA009()
  IF SUBSTR(SB1->B1_PROCED,1,15) == "1P" .AND. ! SG1->(DBSEEK(xFilial("SG1") + M->C6_PRODUTO))    
    MSGINFO("ATEN敲O, Produto sem Estrutura !")
  ENDIF
Return M->C6_PRODUTO