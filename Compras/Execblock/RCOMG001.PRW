#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCOMG001  �Autor  �Adriano Luis Brandao� Data �  29/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao utilizada em um gatilho no campo C1_PRODUTO, onde   ���
���          � ira replicar diversos campos do primeiro item para os itens���
���          � abaixo.                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                            

User Function RCOMG001()

Local _nI := 0

_cRet := M->C1_PRODUTO

_nPosPlano	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "C1_MSPLANO" 	})
_nPosApro	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "C1_MSAPRO"		})
_nPosCC		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "C1_CC"			})

For _nI := 1 To Len(aCols)
   aCols[_nI,_nPosPlano] 	:= aCols[1,_nPosPlano]
   aCols[_nI,_nPosApro]		:= aCols[1,_nPosApro	]
   aCols[_nI,_nPosCC]		:= aCols[1,_nPosCC	]
Next _nI

Return(_cRet)
