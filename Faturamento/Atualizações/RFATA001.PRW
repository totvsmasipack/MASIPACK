/*
Programa: RFATA001.PRW
Busca o preco de venda do cadastro de produtos
*/

#Include "Rwmake.ch"
#Include "Topconn.ch"

User Function RFATA001()

If M->CK_PRCVEN == 0
   RETURN SB1->B1_PRV1
ELSE
   RETURN M->CK_PRCVEN
Endif
