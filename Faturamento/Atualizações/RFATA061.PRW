#include "rwmake.ch"
#include "TopConn.ch"

User Function RFATA061()

MSGBOX("CLICAR EM OK E AGUARDAR SELECAO DE DADOS","USUARIO "+rtrim(CUSERNAME),"INFO")
DBSELECTAREA("SA3")
DBSETORDER(7)
IF DBSEEK(XFILIAL()+__CUSERID)
   cFiltro := SA3->A3_COD
ELSE
   MSGBOX("USUÁRIO NÃO É UM REPRESENTANTE COMERCIAL","ATENÇÃO","INFO")
   RETURN
ENDIF

DbSelectArea("SA1")
DbSetOrder(1)
Set Filter to SA1->A1_FILIAL==xFilial("SA1") .And. SA1->A1_VEND==cFiltro
dbGoTop()

DbSelectArea("SA3")
DbSetOrder(1)
Set Filter to SA3->A3_FILIAL==xFilial("SA3") .And. SA3->A3_COD==cFiltro
dbGoTop()

DbSelectArea("SCJ")
DbSetOrder(1)
Set Filter to SCJ->CJ_FILIAL==xFilial("SCJ") .And. SCJ->CJ_MSVEND==cFiltro
dbGoTop()

MATA415()

DbSelectArea("SC5")
DbSetOrder(1)
Set Filter to

DbSelectArea("SA1")
DbSetOrder(1)
Set Filter to

DbSelectArea("SA3")
DbSetOrder(1)
Set Filter to
Return(nil)