#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA415COR  ºAutor  ³Lizandra Marques    º Data ³  13/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Novas cores em orçamentos                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA415COR                                                                  

Local aRet := PARAMIXB

Local cStatusA := "(SCJ->CJ_STATUS == 'A') .AND. (SCJ->CJ_MSBLQ <> 1) .AND. (SCJ->CJ_MSLIBER <> 'S')"      

   If cEmpAnt $ '01|10'

      aRet := { { cStatusA, "ENABLE"	                                                },;   //Orcamento em Aberto - Disponível para aprovação
                  {"SCJ->CJ_STATUS=='B'" , "DISABLE"                                   },;   //Orcamento Baixado   
                  {"SCJ->CJ_STATUS $ 'C/P'" , "BR_PRETO"                               },;   //Orcamento Cancelado/Perdido   
                  {"SCJ->CJ_STATUS=='D'" , "BR_PINK"                                   },;   //Orcamento Adiado  
                  {"SCJ->CJ_STATUS=='A' .AND. SCJ->CJ_MSLIBER == 'S'  ","BR_BRANCO"    },;   //Orçamento Aprovado para se encaminhado para cliente e geração de pedido.
                  {"SCJ->CJ_STATUS=='F'" , "BR_AMARELO"                                },;   //Orcamento Baixa Possibilidade  
                  {"SCJ->CJ_STATUS=='X'" , "BR_VIOLETA"                                },;   //Orcamento Efetivação aglutinada 
                  {"SCJ->CJ_STATUS=='A' .AND. SCJ->CJ_MSBLQ = 1" , "BR_AZUL"           } }   //Orcamento Bloqueado 
   EndIf

Return aRet