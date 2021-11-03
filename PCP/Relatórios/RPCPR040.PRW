#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "shell.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Funcao	 ³ RPCPR040³ Autor ³ Ivandro Santos         ³Data  ³ 25/02/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Verificação dos produtos cadastrados conforme parâmetro do ³±±
±±³          | usuário                                                	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±± 
*/

User Function RPCPR040()
Static cPerg  := "XPCPR40"

Private cString  := "SB1"
Private Tamanho  := "M"
Private wnrel    := "RPCPR040"
Private Titulo   := "Verificação produtos incluídos"
Private cDesc1	 := "Este relatório irá gerar uma planilha para conferência "
Private cDesc2	 := "dos produtos cadastrados em um determinado período     "
Private aReturn  := { "Zebrado",1,"Administracao",2,2,1,"",1 }
Private cArq   	:="C:\Relato_Microsiga\Produtos_Incluídos.CSV"
              
Pergunte(cPerg,.F.)

wnrel := SetPrint(cString, wnrel,cperg,@titulo,cDesc1,cDesc2,,.F.,,,Tamanho)

MSAGUARDE({|| InclSB1(),"Selecioando Produtos"})

Return

Static Function InclSB1()
Local cArqCSV	:= ""
Local cAliasE	:= "SB1"
Local aCpoB1	:= {}
Local _lObrig	:= .F.
Local cQuery	:= ""
Local nB1		:= 0
Local aFldSX3	:= {}
Local nX		:= 0

/*
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek(cAliasE)
While !Eof() .And. SX3->X3_ARQUIVO == cAliasE
	_lObrig := X3OBRIGAT(SX3->X3_CAMPO)
	If _lObrig
		AAdd(aCpoB1,{SX3->X3_CAMPO,SX3->X3_TITULO})
	EndIf
	_lObrig := .F.
	DbSkip()
EndDo
*/
aFldSX3 := FWSX3Util():GetAllFields(cAliasE,.F.)
For nX := 1 To Len(aFldSX3)
	If X3Obrigat( aFldSX3[nX] )
		AADD(aCpoB1,{ aFldSX3[nX], RetTitle(aFldSX3[nX]) })
	Endif
Next nX

If (cArqCSV := FCreate(cArq)) == -1
	Alert("Arquivo para o Excel não pode ser criado - Verifique se o mesmo não está aberto - Avise o Depto. de Informática")
	Return
Else
	cRegCSV := ""
	For nB1 := 1 to len(aCpoB1)
			cRegCSV +=	""+Alltrim(aCpoB1[nB1][2])+"" + ";"
	Next
	cRegCSV +=	"Data Inclusão"  	+ ";"
	cRegCSV +=	"NCM" 			 	+ ";"
	cRegCSV +=	"Cta Contabil"   	+ ";"
	cRegCSV +=	"Desc Prolongada" 	+ ";"
	cRegCSV +=	"Usuario"
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIF
If Select("QRD") > 0
	dbSelectArea("QRD")
	dbCloseArea()
EndIf

cQuery += " SELECT "
For nB1 := 1 to len(aCpoB1)
		IF Alltrim(aCpoB1[nB1][2]) = "Garantia?"
			cQuery += "CASE WHEN "+Alltrim(aCpoB1[nB1][1])+" = '2' THEN 'N' ELSE 'S' END AS "+Alltrim(aCpoB1[nB1][1])+" , "
		Else
			cQuery += "	"+Alltrim(aCpoB1[nB1][1])+" , "
		Endif
Next
cQuery += "	B1_DATAC, B1_POSIPI, B1_CONTA, ISNULL(B5_CEME,B1_DESC) AS 'DESCP', B1_USERLGI "
cQuery += " FROM "+RetSqlName("SB1")+" B1 "
cQuery += "	LEFT  JOIN "+RetSqlName("SB5")+" B5 ON B5.B5_FILIAL = '"+xFilial("SB5")+"' AND B5.B5_COD = B1.B1_COD AND B5.D_E_L_E_T_ = ' ' " 
cQuery += " WHERE B1_DATAC BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND B1.D_E_L_E_T_ = '' AND B1_MSBLQL <> '1' " //'"+MV_PAR01+"'
cQuery += " ORDER BY B1_COD "


//-----------------------
//| Cria uma view no banco
//+-----------------------
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "QRD", .T., .F. )
TcSetField("QRD","B1_DATAC" ,"D",08,0)

dbSelectArea("QRD")

While QRD->(!Eof())
	cRegCSV := ""
	For nB1 := 1 to len(aCpoB1)
		cRegCSV +=	IIf((aCpoB1[nB1][1])="B1_COD","_"+&(QRD->(aCpoB1[nB1][1]))+";",&(QRD->(aCpoB1[nB1][1]))+";")
	Next
	cRegCSV += DTOC(QRD->B1_DATAC) + ";"
	cRegCSV += QRD->B1_POSIPI + ";"
	cRegCSV += Alltrim(QRD->B1_CONTA) + ";"
	cRegCSV += Alltrim(QRD->DESCP) + ";"  
	cRegCSV += Alltrim(USRFULLNAME(SUBSTR(EMBARALHA(QRD->B1_USERLGI,1),3,6)))
	
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	
	QRD->(DbSkip())	
EndDo

FClose(cArqCSV)                          

Return
