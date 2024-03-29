
#include "Topconn.ch"
#include "Protheus.ch"  


/* 

�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCOMR029()  �Autor  �Eduardo Mantoan    � Data � 13/02/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Previs�o de entrada de material       		 				     ���
���          � 															  				  ���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                              ���
�������������������������������������������������������������������������ͼ��                                       
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

*/   
   

User Function RCOMR029()

Private titulo		:= "Previs�o de entrada de material "
Private cDesc1		:=	"Previs�o de entrada de material "
Private cDesc2		:=	""
Private cDesc3		:=	""
Private aLinha		:=	{ }
Private nomeprog	:=	"RCOMR029"
Private nLastkey	:=	0
Private cPerg		:= "XRCOMR029"
Private aReturn  	:= { "Zebrado",1,"Administracao",2,2,1,"",1 } 
Private aOrd     	:= {}                                                                  
Private nVal1 	 	:= 0
Private nVal2 	 	:= 0
Private nVal3 	 	:= 0
Private nVal4 	 	:= 0
Private nVal5 	 	:= 0 


//��������������������������������������������������������������Ŀ
//�Variaveis utlizadas para Impressao do Cabecalho e Rodape      �
//����������������������������������������������������������������

Private cabec2  := ""//"Fornecedor                   Pedido      Total do Pedido       Parcelas ->"
Private cabec1  := "Previs�o de entrada de material"
Private tamanho := "M"
Private cString := "SC7"
Private Li      := 100
Private m_pag   := 1
Private wnrel   := "RCOMR029"  

//��������������������������������������������������������������Ŀ
//�Ajuste dos parametros da impressao via funcao SETPRINT        �
//����������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//�Aceita Parametros e faz ajustes necessarios                   �
//�MV_PAR01 = DATA INICIAL                                       �
//�MV_PAR02 = DATA FINAL                                         �
//��������������������������������������������������������������Ŀ

Pergunte(cPerg,.F.)

//wnrel  :=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.T.)
wnrel  :=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,.F.,.F.)
If LastKey()==27.Or.nLastKey==27
	SET FILTER TO
	Return
Endif

SetDefault(aReturn,cString)
If LastKey()==27.Or.nLastKey==27
	SET FILTER TO
	Return
Endif

RptStatus({|| ImpRel()}) 

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImpRel  �Autor  �Eduardo Mantoan    � Data �  13/02/15		  ���
�������������������������������������������������������������������������͹��
���Desc.     �																		        ���
���          �                      					                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 

Static FUNCTION ImpRel()        

If Select("QR1") > 0 
   DbSelectArea("QR1")
   DbCloseArea()
EndIf  


 

_cQuery := " SELECT C7_NUM,C7_ITEM,C7_PRODUTO,C7_FORNECE,C7_DATPRF,C7_UM,C7_QUANT,C7_PRECO,C7_TOTAL,C7_OBS,C7_LOJA,B1_DESC,C7_QUJE,C7_COND  "
If SUBSTR(cNumEmp,1,2) <> "15"    
	_cQuery += " ,B1_MSCONF AS CONF,B1_MSCERT AS CERT
EndIf
_cQuery += " FROM " + RetSqlName("SC7") + "  SC7  "   
_cQuery += " INNER JOIN " + RetSqlName("SB1") + "  SB1 ON B1_COD = C7_PRODUTO AND B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_='' "
_cQuery += " WHERE C7_DATPRF BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"'   "
_cQuery += " AND C7_QUANT > C7_QUJE   "
_cQuery += " AND C7_RESIDUO <> 'S'    "
_cQuery += " AND SC7.D_E_L_E_T_='' AND C7_FILIAL = '" + xFilial("SC7") + "'  "
If MV_PAR01 = 2
	_cQuery += " Order By C7_FORNECE,C7_NUM,C7_ITEM    "
Else
	_cQuery += " Order By C7_DATPRF,C7_FORNECE,C7_NUM,C7_ITEM    "
EndIf 
TcQuery _cQuery New Alias "QR1" 
TcSetField("QR1","C7_DATPRF","D",8,2)  
    
DbSelectArea("QR1")
QR1->(DBGOTOP())
cabec1:= "Previs�o do dia: "+DTOC(Date() - 30)+" at� "+DTOC(Date() + 7)
cabec2:= "PC     Item/Produto          Descri��o            Qtd/UM      Val.Unit       Total      Dat. Prev. de Ent.    Con.Pagamento"
cPC:= QR1->C7_NUM 
nTot:=0 
nQuantR := 0
Do While !QR1->(EOF())  
    
	nQuantR := QR1->C7_QUANT 
	If Select("QR2") > 0 
   	DbSelectArea("QR2")
   	DbCloseArea()
	EndIf
	_cQuery := " SELECT *  "
	_cQuery += " FROM " + RetSqlName("SD1") + "  SD1  "   
	_cQuery += " WHERE D1_PEDIDO = '"+QR1->C7_NUM+"'    "
	_cQuery += " AND D1_ITEMPC = '"+QR1->C7_ITEM+"'   "
	_cQuery += " AND SD1.D_E_L_E_T_='' AND D1_FILIAL = '" + xFilial("SD1") + "'  "
	_cQuery += " Order By D1_DOC    "
 
	TcQuery _cQuery New Alias "QR2" 
 
    
	DbSelectArea("QR2")
	QR2->(DBGOTOP()) 
	nTotquant := 0
	Do While !QR2->(EOF())
		nTotquant += QR2->D1_QUANT
		QR2->(DBSKIP()) 	
	EndDo	
	QR2->(DBGOTOP()) 
	If nTotquant = QR1->C7_QUANT .AND. !QR2->(EOF())
		QR1->(DBSKIP())
			LOOP 
	Else 
		nQuantR :=  QR1->C7_QUANT - nTotquant
	EndIf 
	   
	DBSELECTAREA("QR1")
	If QR1->C7_NUM == cPC  
	
		If li > 45
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
			li := 8
			li++
		EndIf
		@ li, 000 PSAY "For.: "+QR1->C7_FORNECE+"/"+ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+QR1->C7_FORNECE+QR1->C7_LOJA,"A2_NREDUZ"))
	   li++
		@ li, 000 PSAY QR1->C7_NUM
		@ li, 007 PSAY QR1->C7_ITEM+"/"+QR1->C7_PRODUTO 
	  //	@ li, 017 PSAY QR1->C7_NUM+"/"+QR1->C7_ITEM 
		@ li, 030 PSAY SUBSTR(ALLTRIM(QR1->B1_DESC),1,12)      
	
		@ li, 043 PSAY nQuantR   PICTURE "@E 999,999.999"
		
		@ li, 053 PSAY "/"+QR1->C7_UM   
		@ li, 055 PSAY QR1->C7_PRECO   PICTURE "@E 9,999,999.999"
		@ li, 069 PSAY nQuantR * QR1->C7_PRECO   PICTURE "@E 9,999,999.999" 
		@ li, 089 PSAY QR1->C7_DATPRF  
		@ li, 110 PSAY POSICIONE("SE4",1,xFilial("SE4")+QR1->C7_COND,"E4_COND")   
						  //	Posicione("SB1",1,xFilial("SB1")+M->C1_PRODUTO,"B1_REVATU")
		nTot+= QR1->C7_TOTAL
		If LEN(ALLTRIM(QR1->B1_DESC)) > 12
			li++
			@ li, 030 PSAY SUBSTR(ALLTRIM(QR1->B1_DESC),13,11)
		Else
			li++	
		EndIf
		If LEN(ALLTRIM(QR1->B1_DESC)) > 24
			li++
			@ li, 030 PSAY SUBSTR(ALLTRIM(QR1->B1_DESC),25,10)
		Else
			li++	
		EndIf 
		li++   	
		@ li, 000 PSAY "OBS: "+QR1->C7_OBS
		li++
		li++ 
		@ li, 000 PSAY "Quantidade original: "+STR(QR1->C7_QUANT) +"  Quantidade entregue: "+	STR(QR1->C7_QUJE)
		li++
		li++
	
		If SUBSTR(cNumEmp,1,2) <> "15"
			
			If ALLTRIM(QR1->CERT)=="S" 
				@ li, 000 PSAY "CERTIFICADO/LAUDO DE AN�LISE � NECESS�RIO"
				li++ 
		   EndIf
		   If ALLTRIM(QR1->CONF)=="S" 
		   	@ li, 000 PSAY "DECLARA��O DE CONFORMIDADE CE � NECESS�RIA"
		   	li++ 
		   EndIf
		EndIF 
		@ li,000 PSAY Replicate("-  - ",20)
		li++ 
		QR1->(DBSKIP())			
	Else
		li++
		@ li, 001 PSAY "Total do Pedido --------> "
		@ li, 050 PSAY nTot   PICTURE "@E 9,999,999.999" 
		li++ 
		li++
		@ Li,000 Psay __PrtFatLine()
		li++
		nTot := 0
		cPC:= QR1->C7_NUM
	EndIf
	
	
EndDo

SET FILTER TO
Set Device To Screen

QR1->(DbCloseArea())

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel) //Chamada do Spool de Impressao
Endif

MS_FLUSH() //Libera fila de relatorios em spool

	If Select("QR2") > 0 
   	DbSelectArea("QR2")
   	DbCloseArea()
	EndIf
	
Return(.T.)
