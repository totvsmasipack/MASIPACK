#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCOMG002  �Autor  �Adriano Luis Brandao� Data �  29/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para replicar alguns campos do primeiro item do    ���
���          � pedido de compras para os itens abaixo, assim que for      ���
���          � digitado o codigo do produto C7_PRODUTO.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RCOMG002()

Local _nI := 0

_cRet := M->C7_PRODUTO

_nPosTxt1 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "C7_MSTXT1" 	})
_nPosTxt2	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "C7_MSTXT2" 	})
_nPosTxt3	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "C7_MSTXT3" 	})
_nPosCompr	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "C7_MSCOMPR"	})
_nPosPrf	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "C7_DATPRF"		})
_nPosMsNat	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "C7_MSNAT"		})

For _nI := 1 To Len(aCols)
   aCols[_nI,_nPosTxt1	] 	:= aCols[1,_nPosTxt1		]
   aCols[_nI,_nPosTxt2	] 	:= aCols[1,_nPosTxt2		]
   aCols[_nI,_nPosTxt3	]	:= aCols[1,_nPosTxt3		]
   aCols[_nI,_nPosCompr	]	:=	aCols[1,_nPosCompr	]
   aCols[_nI,_nPosPrf	]	:= aCols[1,_nPosPrf		]
   aCols[_nI,_nPosMsNat	]	:= aCols[1,_nPosMsNat	]
Next _nI

Return(_cRet)
