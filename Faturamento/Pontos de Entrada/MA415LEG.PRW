#Include "Rwmake.ch"
#Include "Topconn.ch"
 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA415LEG  �Autor  �Lizandra Marques    � Data �  25/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Nova legenda para Or�amentos                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA415LEG
aLegenda := {}                              

aLegenda := {{"ENABLE"   ,"Orcamento em Aberto - Liberado para aprova��o"},;
            {"DISABLE"   ,"Orcamento Efetivado"   },;      
            {"BR_PRETO"  ,"Orcamento Cancelado/Perdido"  },;      
            {"BR_PINK"   ,"Orcamento Adiado"   },;     
            {"BR_BRANCO" ,"Aprovado"  },;   
            {"BR_AMARELO","Orcamento com Baixa Possibilidade"},;   
            {"BR_VIOLETA","Efetiva��o aglutinada"},;   
            {"BR_AZUL"   ,"Orcamento bloqueado pelo or�amentista"   } }   

Return(aLegenda)