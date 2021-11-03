#Include "Rwmake.ch"
#Include "Topconn.ch"

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³RFATA032  ºAutor  ³Solange Ap vezu                          º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±º Desc.    ³  Verifica Produtos sem Estruturas nos Orcamentos de Vendas º±±
±±º Data     ³  06/03/2008                                                º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function RFATA032()
  IF SUBSTR(SB1->B1_PROCED,1,15) == "1P" .AND. ! SG1->(DBSEEK(xFilial("SG1") + M->CK_PRODUTO))    
    MSGINFO("ATENÇÃO, Produto sem Estrutura !")
  ENDIF
Return M->CK_PRODUTO