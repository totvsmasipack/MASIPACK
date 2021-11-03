#Include "Protheus.ch"
#Include "Topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCOMR018  บ Autor ณ Ana Paula QFaustinoบ Data ณ  11/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera arquivo CSV para Solicitacao de Compras               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MASIPACK AP10                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function RCOMR018()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1        := "Este programa tem como objetivo gerar a planilha .csv "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := ""
Local cPict         := ""
Local imprime       := .T.
Local aOrd          := {}
Local titulo        := ""

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RCOMR018" 
Private cPerg	    := "XRCOMR018 "	
Private tamanho     := "G"
Private nomeprog    := "RCOMR018" 
Private cString     := "SC1"

Pergunte(cPerg,.F.)                            

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If (cArqCSV := FCreate("C:\Relato_Microsiga\Solicitacao_Compras.csv")) == -1
   Alert("Arquivo para o Excel nใo pode ser criado - Avise o Depto. de Informแtica")
Else
	cData := StrZero(day(dDataBase),2)+"/"+StrZero(month(dDataBase),2)+"/"+right(Str(year(dDataBase)),4)
    cRegCSV := ";;;;RCOMR018 - SOLICITACAO DE COMPRA EMITIDO EM " + cData
    FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
    cRegCSV := ""
    FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
    cRegCSV := "Nr.SC;Item SC;Produto;Un;Descricao;Procedencia;Quantidade;Quant.PC;Qtd. Entregue;CC;Solicitante;Dt.Emissao;Nr.Pedido;Item Ped.;Nr.Cotacao;Residuo;Dt.Necessidade;Qtde Estoque;Empenho;Qtd.Reserva;Apropriacao;Ult.Pre็o;Monitorado;Total (R$);Total Pendente (R$)"
 	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf   	       	  

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| ImpCom18()})
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  11/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ImpCom18()

Local titulo       := ""
Local Cabec1       := ""
Local Cabec2       := ""
Local Reuniao      := ""
Local nLin         := 80

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(RecCount())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posicionamento do primeiro registro e loop principal. Pode-se criar ณ
//ณ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ณ
//ณ cessa enquanto a filial do registro for a filial corrente. Por exem ณ
//ณ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ณ
//ณ                                                                     ณ
//ณ dbSeek(xFilial())                                                   ณ
//ณ While !EOF() .And. xFilial() == A1_FILIAL                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cQuery := "SELECT SC1.C1_NUM,    SC1.C1_ITEM,    SC1.C1_PRODUTO, SC1.C1_DESCRI,  SC1.C1_UM,     SC1.C1_QUANT,   SC1.C1_QUJE,    SC1.C1_OBS, "
cQuery += "       SC1.C1_CC,     SC1.C1_MSAPROP, SC1.C1_SOLICIT, SC1.C1_EMISSAO, SC1.C1_PEDIDO, SC1.C1_ITEMPED, SC1.C1_COTACAO, SC1.C1_RESIDUO, "
cQuery += "       SC1.C1_DATPRF, SC7.C7_QUJE,"
IF SUBSTR(cNumEmp,1,2) <> "15"
	cQuery += "       SC1.C1_MSREUNI, "
EndIf
cQuery += "       SB1.B1_UPRC,    SB2.B2_QATU,    SB2.B2_QEMP,  SB2.B2_RESERVA,  SB1.B1_PROCED "
cQuery += "FROM "+RetSqlName("SC1")+" SC1"+CRLF
cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL='" + xFilial("SB1")+"' AND SB1.B1_COD = SC1.C1_PRODUTO "+CRLF
cQuery += "INNER JOIN "+RetSqlName("SB2")+" SB2 ON SB2.B2_FILIAL='" + xFilial("SB2")+"' AND SB2.B2_COD = SC1.C1_PRODUTO "+CRLF
cQuery += "LEFT JOIN "+RetSqlName("SC7")+ " SC7 ON C7_FILIAL = C1_FILIAL AND C7_ITEM = C1_ITEMPED AND C7_NUM = C1_PEDIDO AND SC7.D_E_L_E_T_  = ' '"
cQuery += "WHERE SC1.C1_FILIAL = '"+xFilial("SC1")+"' AND SC1.C1_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+DtoS(mv_par02)+"' "
cQuery += "  AND SC1.C1_DATPRF  BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"' "
cQuery += "  AND SC1.D_E_L_E_T_ = '' "+CRLF
cQuery += "  AND SB1.D_E_L_E_T_ = '' "+CRLF
cQuery += "  AND SB2.D_E_L_E_T_ = '' "+CRLF

If MV_PAR05 == 1	//SC's Abertas
//	cQuery += " AND SC1.C1_QUJE <> SC1.C1_QUANT " + CRLF
	cQuery += " AND SC1.C1_QUJE = 0 " + CRLF
	cQuery += " AND SC1.C1_RESIDUO = ' ' " + CRLF

ElseIf MV_PAR05 == 2 //SC's Parcialmente Atendida
	cQuery += " AND SC1.C1_QUJE > 0 " + CRLF
	cQuery += " AND SC1.C1_QUJE < SC1.C1_QUANT " + CRLF
	cQuery += " AND SC1.C1_RESIDUO = ' ' " + CRLF

Else	//Atendidas
	cQuery += " AND SC1.C1_QUJE >= SC1.C1_QUANT " + CRLF
	cQuery += " AND SC1.C1_RESIDUO = ' ' " + CRLF

EndIf

cQuery += "GROUP BY SC1.C1_NUM,    SC1.C1_ITEM,    SC1.C1_PRODUTO, SC1.C1_DESCRI,  SC1.C1_UM,     SC1.C1_QUANT,   SC1.C1_QUJE,    SC1.C1_OBS, " + CRLF
cQuery += "       SC1.C1_CC,     SC1.C1_MSAPROP, SC1.C1_SOLICIT, SC1.C1_EMISSAO, SC1.C1_PEDIDO, SC1.C1_ITEMPED, SC1.C1_COTACAO, SC1.C1_RESIDUO, " + CRLF
cQuery += "       SC1.C1_DATPRF, SC7.C7_QUJE," + CRLF
IF FwCodEmp() <> "15"
	cQuery += " SC1.C1_MSREUNI," + CRLF
EndIf
cQuery += " SB1.B1_UPRC,    SB2.B2_QATU,    SB2.B2_QEMP,  SB2.B2_RESERVA,  SB1.B1_PROCED "

cQuery += "ORDER BY SC1.C1_NUM " + CRLF

//Executa Query
//cQuery := ChangeQuery(cQuery)

//DbUseArea(.T.,"TOPCONN", TcGenQry(,,cQuery),"TMP",.T.,.T.)

TcQuery cQuery New Alias "TMP"

TcSetField("TMP","C1_QUANT",  "N",12,02)
TcSetField("TMP","C1_QUJE",   "N",12,02)
TcSetField("TMP","C7_QUJE",   "N",12,02)
TcSetField("TMP","C1_EMISSAO","D",08,00)
TcSetField("TMP","C1_DATPRF", "D",08,00)
IF SUBSTR(cNumEmp,1,2) <> "15"
	TcSetField("TMP","C1_MSREUNI","D",08,00)
EndIf
TcSetField("TMP","B1_UPRC",   "N",12,02)
TcSetField("TMP","B2_QATU",   "N",12,02)
TcSetField("TMP","B2_QEMP",   "N",12,02)

TMP->(DbGoTop())
//nTreg := TMP->(RecCount())
//ProcRegua(nTReg)
//SetRegua(RecCount())

Do While !TMP->(EOF())
	
	Emissao     := Dtoc(TMP->C1_EMISSAO)
	Necessidade := Dtoc(TMP->C1_DATPRF)
	
	IF SUBSTR(cNumEmp,1,2) <> "15"
		If Dtoc(TMP->C1_MSREUNI) <> " "
			Reuniao := Dtoc(TMP->C1_MSREUNI)
	    EndIf
	Else
		Reuniao := " "
	EndIf
	nTotal    := (TMP->C1_QUANT * TMP->B1_UPRC)
	nPendente := ((TMP->C1_QUANT - TMP->C1_QUJE) * TMP->B1_UPRC)
	
	cRegCSV := "_"+TMP->C1_NUM+";"+;
	"_"+TMP->C1_ITEM+";"+;
	"_"+TMP->C1_PRODUTO+";"+;
	AllTrim(TMP->C1_UM)+";"+;
	AllTrim(TMP->C1_DESCRI)+";"+;
	AllTrim(TMP->B1_PROCED)+";"+;
	Transform(TMP->C1_QUANT,"@E 999,999,999.99")+";"+;
	Transform(TMP->C1_QUJE,"@E 999,999,999.99")+";"+;
	Transform(TMP->C7_QUJE,"@E 999,999,999.99")+";"+;
	AllTrim(TMP->C1_CC)+";"+;
	AllTrim(TMP->C1_SOLICIT)+";"+;
	Emissao+";"+;
	"_"+TMP->C1_PEDIDO+";"+;
	"_"+TMP->C1_ITEMPED+";"+;
	"_"+TMP->C1_COTACAO+";"+;
	AllTrim(TMP->C1_RESIDUO)+";"+;
	Necessidade+";"+;
	Transform(TMP->B2_QATU,"@E 999,999,999.99")+";"+;
	Transform(TMP->B2_QEMP,"@E 999,999,999.99")+";"+;
	Transform(TMP->B2_RESERVA,"@E 999,999,999.99")+";"+;
	AllTrim(TMP->C1_MSAPROP)+";"+;
	Transform(TMP->B1_UPRC,"@E 999,999.999")+";"+;
	Reuniao+";"+;
	Transform(nTotal,"@E 999,999.999")+";"+;
	Transform(nPendente,"@E 999,999.999")
	
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	TMP->(dbSkip())
EndDo

If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
   	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   	nLin := 8
Endif
@nLin,000 Psay "Planilha gerada em => C:\RELATO_MICROSIGA\Solicitacao_Compras.CSV"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

TMP->(DbCloseArea())                                           
FClose(cArqCSV)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
