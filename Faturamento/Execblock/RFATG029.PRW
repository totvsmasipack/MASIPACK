#Include "Protheus.ch"
#Include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATG029  ºAutor  ³Lizandra Marques    º Data ³  21/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se tes atualiza estoque para produtos produtivos   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATG029()

lRet        := .F.
_cProced	:="  "
_cAtuEst	:=" "                      
Areaant		:= GetArea()
_aAreaF4	:= SF4->(GetArea())            
_aAreaB1	:= SB1->(GetArea())            

npos	:= ascan(aheader,{|x|alltrim(x[2])=="C6_PRODUTO"})
_wPRO	:= acols[n,npos]   

_npos   := ascan(aheader,{|x|alltrim(x[2])=="C6_TES"})
_wTES   := acols[n,_npos]   


SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+_wPRO))
_cProced:= SB1->B1_PROCED


SF4->(DbSetOrder(1))
SF4->(dbSeek(xFilial("SF4")+_wTES))
_cAtuEst:=SF4->F4_ESTOQUE 

IF _cAtuEst == "N" .AND. SUBSTR(_cProced,2,1) == "P"
	ApMsgAlert("PRODUTO PRODUTIVO. TES DEVE ATUALIZAR ESTOQUE. ENTRE EM CONTATO COM DEPTO. FISCAL")             
ENDIF

RestArea(_aAreaB1)
RestArea(_aAreaF4)
RestArea(Areaant)

Return _wTES