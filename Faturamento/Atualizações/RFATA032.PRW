#Include "Rwmake.ch"
#Include "Topconn.ch"

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  砇FATA032  篈utor  砈olange Ap vezu                          罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北� Desc.    �  Verifica Produtos sem Estruturas nos Orcamentos de Vendas 罕�
北� Data     �  06/03/2008                                                罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�*/

User Function RFATA032()
  IF SUBSTR(SB1->B1_PROCED,1,15) == "1P" .AND. ! SG1->(DBSEEK(xFilial("SG1") + M->CK_PRODUTO))    
    MSGINFO("ATEN敲O, Produto sem Estrutura !")
  ENDIF
Return M->CK_PRODUTO