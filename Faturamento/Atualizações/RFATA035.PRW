******************************************************************************
*                                                                            *
*   PROGRAMA: RFATA035.PRW                                                   *
*                                                                            *
* FINALIDADE: AJUSTAR A ALIQ DO IPI NO CADASTRO DE PRODUTOS DE ACORDO COM    *
*             A TABELA DE CLASSIFICACOES FISCAIS (SYD)                       *
*                                                                            *
****************************************************************************** 

#Include "Rwmake.ch"
#Include "Topconn.ch"

User Function RFATA035() 

sb1->(DbOrderNickName("B1CLAFISC"))

IF sb1->(DBSEEK(XFILIAL("SB1")+SYD->YD_TEC))
   WHILE sb1->b1_posipi == SYD->YD_TEC .AND. !sb1->(EOF())
      IF sb1->(RLOCK())
         IF sb1->b1_msmp66 == "S"
            sb1->b1_ipi := 0
         ELSE
            sb1->b1_ipi := syd->yd_per_ipi
         ENDIF
         sb1->(DBRUNLOCK())
      ENDIF
      sb1->(DBSKIP())
   ENDDO
ENDIF

RETURN .T.
