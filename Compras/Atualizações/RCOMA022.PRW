#include "totvs.ch"
#include "protheus.ch"

/*/{Protheus.doc} RCOMA022
//TODO Descri��o: Programa que faz a leitura do arquivo txt e gera as solicita��es de compra.
@author ivandro.santos
@since 30/05/2016
@version 1.0
@return NIL
@type function
/*/
User Function RCOMA022()

Local cArq    := "C:\Relato_Microsiga\IMPORTA_SC.csv"
Local cLinha  := ""
Local _cMsgSC := ""
Local _cProdF := ""
Local _cInfo  := ""
Local lOK     := .F.
Local aCampos := {}
Local aCab    := {}
Local aLinha  := {}
Local aItens  := {}
Local _aMsg	  := {"Solicitacao de Compra Gerada. Numero SC : ","Solicita��es de Compras Geradas. Numeros SCs : ","Importa��o conclu�da"}
Local _aMsg2  := {"O Produto abaixo � ","Os produtos abaixo s�o ","fantasma e n�o pode ser comprado","fantasma e n�o podem ser comprados","Falha na importa��o"}
Local _nSC 	  := 0
Local nSC	  := 0
Local _nFant  := 0


Private _aNumSC	:= {}
Private _nQtSC	:= 0
	
If !File(cArq)
	MsgStop("O arquivo " +cArq + " n�o foi encontrado. A importa��o ser� abortada!"," - ATENCAO")
	Return
EndIf


FT_FUSE(cArq)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()
_cNumSC	:= GetSX8Num("SC1","C1_NUM")
fCheckNum(@_cNumSC)
While !FT_FEOF()
	
	IncProc("Lendo arquivo texto...")
	
	cLinha := FT_FREADLN()
	If cLinha == "        " .OR. cLinha = NIL
		ALERT("Fim de arquivo!")
		FT_FUSE()
		Return
	EndIf
	lOK := .F.
	aCampos := StrToKArr(cLinha,";")
	
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	IF SB1->(dbSeek(xFilial("SB1")+Alltrim(Substr(aCampos[1],2,15))))
		If !(SB1->B1_FANTASM == "S")
			_nSC++
	
			SC1->(dbSetOrder(1))
			aLinha := {}                  
			                  
			
			aadd(aLinha,{"C1_ITEM"   ,StrZero(_nSC,len(SC1->C1_ITEM))	,Nil})
			aadd(aLinha,{"C1_PRODUTO",Alltrim(Substr(aCampos[1],2,15))	,Nil})
			aadd(aLinha,{"C1_QUANT"  ,Val(Alltrim(aCampos[3]))		   	,Nil})
			aadd(aLinha,{"C1_MSINTER","S"								,Nil})
			aadd(aLinha,{"C1_DATPRF" ,DataValida(dDataBase+90)			,Nil})
			aadd(aItens,aLinha)
			
			If _nSC == 99
				MsAguarde({|| U_MSSolCom(_cNumSC,aItens) }, OemToAnsi("Gerando Solicita��o de compra: "+_cNumSC) )
				_nSC 		:= 0                   
				_cNumSC	:= GetSX8Num("SC1","C1_NUM")
				aItens 	:= {}                      
			Endif
		Else
			_nFant++
			_cProdF += IIF(_nFant>1,CRLF+Alltrim(Substr(aCampos[1],2,15)),Alltrim(Substr(aCampos[1],2,15)))
		EndIf
	ENDIF
	FT_FSKIP()
	aCampos := {}
EndDo

If Len(aItens) > 0
	MsAguarde({|| U_MSSolCom(_cNumSC,aItens) }, OemToAnsi("Gerando Solicita��o de compra: "+_cNumSC) )
Endif

FT_FUSE()
For nSC := 1 to len(_aNumSC)
	_cMsgSC += IIF(nSC>1," | "+_aNumSC[nSC],_aNumSC[nSC])
Next

If len(_aNumSC) > 0
	_cInfo:= IIF(_nQtSC>1,_aMsg[2]+_cMsgSC+CRLF+_aMsg[3],_aMsg[1]+_cMsgSC+CRLF+_aMsg[3])
EndIf
If _nFant > 0 
	_cInfo+= CRLF+CRLF+IIF(_nFant>1,_aMsg2[2]+_aMsg2[4]+CRLF+_cProdF+CRLF+_aMsg2[5],_aMsg2[1]+_aMsg2[3]+CRLF+_cProdF+CRLF+_aMsg2[5])
EndIf
If !Empty(_cInfo)
	MSGINFO(_cInfo)
Else
	MSGINFO("SC n�o foi gerada. Verifique o arquivo IMPORTA_SC.csv no diret�rio C:\relato_microsiga")
EndIf

Return  

/*/{Protheus.doc} MSSolCom
//TODO Descri��o: Gera as solicita��es de compras baseado no array enviado por par�metro.
@author ivandro.santos
@since 01/06/2016
@version 1.0
@return NIL
@param _cNumSC, caracter, descricao: N�mero fornecido pela fun��o GetSX8Num para gerar a SC
@param aItens, array, descricao: Array com os dados do produto, quantidade, Intercompany e Data de t�rmino prevista
@type function
/*/
User Function MSSolCom(_cNumSC,aItens)
Private lMsErroAuto := .F.

	_nQtSC ++
	aCab   := {}
	aadd(aCab,{"C1_NUM"    ,_cNumSC})
	aadd(aCab,{"C1_SOLICIT",cUserName})
	aadd(aCab,{"C1_EMISSAO",dDataBase})
	lMSHelpAuto := .F.
	lMSErroAuto := .F.
	MSExecAuto({|x,y| mata110(x,y)},aCab,aItens)
	If lMSErroAuto
		RollBackSX8()
		MostraErro()
	Else
		ConfirmSX8()
		aAdd(_aNumSC,_cNumSC)
	Endif
Return
Static Function fCheckNum(cNumSC)
Local aAreaSC1 	:= SC1->(GetArea())

dBSelectArea("SC1")
SC1->(DBSETORDER(1))
if SC1->(DBSEEK(XFILIAL("SC1")+cNumSC))
	ConfirmSX8()
	cNumSC:= GetSX8Num("SC1","C1_NUM")
	fCheckNum(@cNumSC)
endIf

RestArea(aAreaSC1)
Return
