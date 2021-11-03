#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} RFINCNAB
//TODO Descrição: Programa utilizado para corrigir a chave única do título (IDCNDAB) nos títulos do Banco Sicredi.
@author ivandro.santos
@since 03/08/2018
@version 1.0
@return NIL
@type function
/*/
User function RFINCNAB()
Local cPerg	:= "XPCPA37"
Local cArq	:= ""
	
Pergunte(cPerg,.T.)
cArq := MV_PAR01

If !File(cArq)
	MsgStop("O arquivo " +cArq + " não foi encontrado. A importação será abortada!"," - ATENCAO")
	Return
EndIf

MsAguarde({||MSLEARQRET(cArq)}, OemToAnsi("Manutenção do arquivo de retorno, Atualização"))

Return

/*/{Protheus.doc} MSLEARQRET
//TODO Descrição: Faz a leitura do arquivo e abre um novo arquivo com as alterações.
@author ivandro.santos
@since 03/08/2018
@version 1.0
@return NIL
@param cArq, characters, descricao: nome do arquivo que sofrerá a manutenção 
@type function
/*/
Static Function MSLEARQRET(cArq)
Local _cNomArq  := StrTran(UPPER(cArq),".TXT","A.TXT")
Local _cCaminho := _cNomArq
Local cNomTrb	:= FCreate(_cCaminho,0)
	
//Exclui arquivo criado anteriormente
fErase(_cCaminho)

FT_FUSE(cArq)
FT_FGOTOP()

While !FT_FEOF()
	
	cLinha := FT_FREADLN()
	If cLinha == "        " .OR. cLinha = NIL
		ALERT("Fim de arquivo!")
		FT_FUSE()
		Return
	EndIf
	
	MSATUCNAB(cLinha,cNomTrb)
	
	FT_FSKIP()   

EndDo

FT_FUSE()

Fclose(cNomTrb)

Return

/*/{Protheus.doc} MSATUCNAB
//TODO Descrição: faz as alterações no novo arquivo texto
@author ivandro.santos
@since 03/08/2018
@version 1.0
@return NIL
@param cLinha, characters, descricao: traz a linha com as informações do arquivo de retorno do banco 
@param cNomTrb, characters, descricao: nome do arquivo texto de manutenção
@type function
/*/
Static Function MSATUCNAB(cLinha,cNomTrb)
Local cPref		:= ""
Local cTit		:= ""
Local cParc		:= ""
Local cCorrige	:= ""

cChvTit	:= Substr(cLinha,117,10)
cCompe	:= Substr(cLinha,127,5)

If cCompe == "COMPE" 
	cPref	:= PADR(Substr(cLinha,117,1),TAMSX3("E1_PREFIXO")[1])
	cTit	:= PADR(Substr(cLinha,118,6),TAMSX3("E1_NUM")[1])
	cParc	:= PADR(Substr(cLinha,124,2),TAMSX3("E1_PARCELA")[1])
	cIDCnab	:= GetAdvFVal("SE1","E1_IDCNAB",xFilial("SE1")+cPref+cTit+cParc,1," ")

	cCorrige:= STRTRAN(cLinha,cChvTit,cIDCnab)
	FWrite(cNomTrb,cCorrige+CRLF)
Else
	FWrite(cNomTrb,cLinha+CRLF)
EndIf

Return