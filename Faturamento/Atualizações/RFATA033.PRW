#Include "Rwmake.ch"
#Include "Topconn.ch"
/*
***********************************************************************************
* RFATA033.PRW - EXIBE O NOME DO CLIENTE/FORNECEDOR NO BROWSE DO PEDIDO DE VENDAS *
*********************************************************************************** 
*/
User Function RFATA033()

cCliFor := ""

IF sc5->c5_tipo $ "NIPC"  // trata-se de codigo de cliente
   IF sa1->(DBSEEK(XFILIAL("SA1") + sc5->c5_cliente+sc5->c5_lojaent))
      cCliFor := sa1->a1_nreduz
   ENDIF
ELSE
   IF sa2->(DBSEEK(XFILIAL("SA2") + sc5->c5_cliente+sc5->c5_lojaent))
      cCliFor := sa2->a2_nreduz
   ENDIF
ENDIF

RETURN cCliFor           