#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA415COR  �Autor  �Lizandra Marques    � Data �  13/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Novas cores em or�amentos                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA415COR                                                                  

Local aRet := PARAMIXB

Local cStatusA := "(SCJ->CJ_STATUS == 'A') .AND. (SCJ->CJ_MSBLQ <> 1) .AND. (SCJ->CJ_MSLIBER <> 'S')"      

   If cEmpAnt $ '01|10'

      aRet := { { cStatusA, "ENABLE"	                                                },;   //Orcamento em Aberto - Dispon�vel para aprova��o
                  {"SCJ->CJ_STATUS=='B'" , "DISABLE"                                   },;   //Orcamento Baixado   
                  {"SCJ->CJ_STATUS $ 'C/P'" , "BR_PRETO"                               },;   //Orcamento Cancelado/Perdido   
                  {"SCJ->CJ_STATUS=='D'" , "BR_PINK"                                   },;   //Orcamento Adiado  
                  {"SCJ->CJ_STATUS=='A' .AND. SCJ->CJ_MSLIBER == 'S'  ","BR_BRANCO"    },;   //Or�amento Aprovado para se encaminhado para cliente e gera��o de pedido.
                  {"SCJ->CJ_STATUS=='F'" , "BR_AMARELO"                                },;   //Orcamento Baixa Possibilidade  
                  {"SCJ->CJ_STATUS=='X'" , "BR_VIOLETA"                                },;   //Orcamento Efetiva��o aglutinada 
                  {"SCJ->CJ_STATUS=='A' .AND. SCJ->CJ_MSBLQ = 1" , "BR_AZUL"           } }   //Orcamento Bloqueado 
   EndIf

Return aRet