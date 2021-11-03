#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTR999  บ Autor ณ Victor Dessunte    บ Data ณ  26/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de movimentacao de estoque                       บฑฑ
ฑฑบ          ณ Obs.: Substituicao do RESTR010(Movimento de Estoque)       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Grupo Masipack                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RESTR999()

Local 	cDesc1		:= "Este programa tem como objetivo imprimir relatorio "
Local 	cDesc2		:= "de acordo com os parametros informados pelo usuario."
Local 	cDesc3		:= ""
Local 	cPict		:= ""
Local 	titulo		:= ""
Local 	nLin		:= 80
Local 	Cabec1		:= ""
Local 	Cabec2		:= ""
Local 	imprime		:= .T.
Local 	aOrd		:= {}
Private lEnd		:= .F.
Private lAbortPrint	:= .F.
Private CbTxt		:= ""
Private limite		:= 220
Private tamanho		:= "G"
Private nomeprog	:= "RESTR999"
Private nTipo		:= 15
Private aReturn		:= {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey	:= 0
Private cPerg		:= "RESTR010"
Private cbtxt		:= Space(10)
Private cbcont		:= 00
Private CONTFL		:= 01
Private m_pag		:= 01
Private wnrel		:= "RESTR999"
Private cString		:= ""
Private _cDtIni		:= ""
Private _cUltDia	:= "" 
Private _nSaldo		:= 0
/*Ticket#2018021237000149 — movimento de estoque*/

If SUBSTR(cNumEmp,1,2) == "15"
	ApMsgAlert("Esse relat๓rio nใo ้ utilizado na Helsimplast")
	Return
Endif

While .T.
	_cDtIni	:= ""
	_cUltDia	:= "" 
	_nSaldo	:= 0
 	
	If !Pergunte(cPerg,.T.)
		Return
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
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	
End

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  26/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local _cMsg		:= ""
Local _nSldIn	:= 0
Local _nEnt		:= 0
Local _nSai		:= 0
Local _nPeriod	:= 0
Local _lPrim	:= .T.
Local nOrdem
Local	_aDadB1	:= GetAdvFVal("SB1",{"B1_DESC","B1_UM","B1_LOCAL"},xFilial("SB1")+MV_PAR02,1,{"","",""})
Local	_aDadB2	:= GetAdvFVal("SB2",{"B2_DINVENT","B2_QATU","B2_RESERVA"},xFilial("SB2")+MV_PAR02+"01",1,{"","",""})
Local	_aSlB210:= GetAdvFVal("SB2",{"B2_QATU","B2_RESERVA"},xFilial("SB2")+MV_PAR02+"10",1,{0,0})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMensagem informando sobre a data correta para emissao do relatorio.           ณ
//ณAntes de 07/2016 os saldos em estoque na tabela SB2 estavam errados           ณ
//ณpois eram utilizadas as tabelas SZ8 e SZ9 para emitir o relatorio de movimentoณ
//ณde estoque.                                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู]

//VICTOR DESSUNTE - 30/01/2016
//INICIO - TICKET:2017013037000207
_nPeriod := VAL(STR(MV_PAR04) + MV_PAR03)
//If MV_PAR04 < 2017 .AND. VAL(MV_PAR03) < 7
If _nPeriod < 201607
//FIM - TICKET:2017013037000207

	If cUserName == "FPiffer"
		_cMsg := "Para melhor demonstrar os movimentos no relat๓rio, a data inicial, " + CRLF
		_cMsg += "serแ alterada para 01/07/2016."
		MV_PAR03 := "07"
		MV_PAR04 := "2017"
	Else
		_cMsg := "Voc๊ escolheu um perํodo antigo (anterior เ 06/2016)." + CRLF
		_cMsg += "As linhas apresentadas estarใo OK, por้m, o calculo do estoque "
		_cMsg += "que o sistema farแ ao final da listagem poderแ apresentar diverg๊ncias." + CRLF
		_cMsg += "NESSES CASOS, CONSIDERE COMO SALDO ATUAL O MOSTRADO NO CABEวALHO DO RELATำRIO."
	EndIf

	MsgAlert(_cMsg,'Aten็ใo')
EndIf

If MV_PAR01 == 1 //CODIGO
	LjMsgRun("Buscando dados do fechamento..."	,,{|| FechDados() })
EndIf

LjMsgRun("Efetuando leitura dos dados..."	,,{|| GeraDados() })

//VICTOR DESSUNTE - 16/03/2017
//INICIO - TICKET:2017030337000139

TRB->(dbGoTop())
/*If TRB->(EOF())
	MsgStop("Nใo hแ dados!")
	TRB->(dbCloseArea())
	Return
EndIf*/

SetRegua(RecCount())

_nSldIn := _nSaldo

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
If MV_PAR01 == 1 //CODIGO
	@ 006,000 PSAY "Produto......: " + UPPER(Alltrim(MV_PAR02)) + "-" + _aDadB1[1]
	@ 006,065 PSAY "UM : " + _aDadB1[2]
	@ 006,110 PSAY "Local: " + _aDadB1[3]
	@ 006,153 PSAY "Ultimo Inventario em: "
	@ 006,175 PSAY DTOC(_aDadB2[1])
	@ 007,000 PSAY "Movimento de.: " + DTOC(STOD(_cDtIni)) + " ate " + DTOC(MV_PAR05)//DTOC(STOD(_cUltDia))
	@ 007,065 PSAY "Saldo Inicial: "
	@ 007,080 Psay _nSldIn Picture "@E 9,999,999.999"
	@ 007,095 Psay " em " + DTOC(STOD(_cDtIni))
	@ 007,110 Psay "Saldo Atual: "
	@ 007,123 Psay _aDadB2[2]+_aSlB210[1] Picture "@E 9,999,999.999"
	@ 007,137 Psay " em " + DTOC(MV_PAR05)//DTOC(STOD(_cUltDia))
	@ 007,153 Psay "Reservado (Vendas): "
	@ 007,175 Psay _aDadB2[3]+_aSlB210[2] Picture "@E 9,999,999.999"
	
	//          1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
	//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	cabec2 := "Data       Hora    Documento    Forn/Cliente            Tipo   Qtde.           Saldo          Refer.     Lote do VS    Usuario       Pedido       Local    Observa็๕es"
	//99/99/9999 99:99                                               9,999,999.999   9,999,999.999
	cabec3 := ""
Else //REFERENCIA OU DOCUMENTO
	@ 006, 000 Psay IIF(MV_PAR01==2,"Documento: ","Referencia: ") + UPPER(ALLTRIM(MV_PAR02))
	
	//          1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
	//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	cabec2 := "Data       Hora    Documento    Forn/Cliente            Tipo   Qtde.           Saldo          Refer.     Lote do VS    Usuario       Pedido       Local    Produto         Descri็ใo"
	cabec3 := "                                                                               Atual"
	//99/99/9999 99:99                                               9,999,999.999   9,999,999.999                                                               XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXX
EndIf

@ 009,000 Psay Replicate("-",220)
@ 010,000 Psay cabec2
If !Empty(cabec3)
	@ 011,000 Psay cabec3
	@ 012,000 Psay Replicate("-",220)
Else
	@ 011,000 Psay Replicate("-",220)
EndIf

nLin := 14

@ nLin,000 Psay DTOC(STOD(_cDtIni))
@ nLin,011 Psay "*** Saldo Inicial ***
@ nLin,079 Psay _nSaldo Picture "@E 9,999,999.999"
nLin++
//FIM - TICKET:2017030337000139

While TRB->(!EOF())
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 62
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		
		If MV_PAR01 == 1 //CODIGO
			@ 006,000 PSAY "Produto......: " + UPPER(Alltrim(MV_PAR02)) + "-" + _aDadB1[1]
			@ 006,065 PSAY "UM : " + _aDadB1[2]
			@ 006,110 PSAY "Local: " + _aDadB1[3]
			@ 006,153 PSAY "Ultimo Inventario em: "
			@ 006,175 PSAY DTOC(_aDadB2[1])
			@ 007,000 PSAY "Movimento de.: " + DTOC(STOD(_cDtIni)) + " ate " + DTOC(MV_PAR05)//DTOC(STOD(_cUltDia))
			@ 007,065 PSAY "Saldo Inicial: "
			@ 007,080 Psay _nSldIn Picture "@E 9,999,999.999"
			@ 007,095 Psay " em " + DTOC(STOD(_cDtIni))
			@ 007,110 Psay "Saldo Atual: "
			@ 007,123 Psay _aDadB2[2] Picture "@E 9,999,999.999"
			@ 007,137 Psay " em " + DTOC(MV_PAR05)//DTOC(STOD(_cUltDia))
			@ 007,153 Psay "Reservado (Vendas): "
			@ 007,175 Psay _aDadB2[3] Picture "@E 9,999,999.999"
					
			         //          1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
			         //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
			cabec2 := "Data       Hora    Documento    Forn/Cliente            Tipo   Qtde.           Saldo          Refer.     Lote do VS    Usuario       Pedido       Local    Observa็๕es"
			         //99/99/9999 99:99                                               9,999,999.999   9,999,999.999 
			cabec3 := ""
	    Else //REFERENCIA OU DOCUMENTO
			@ 006, 000 Psay IIF(MV_PAR01==2,"Documento: ","Referencia: ") + UPPER(ALLTRIM(MV_PAR02))

			         //          1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
			         //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
			cabec2 := "Data       Hora    Documento    Forn/Cliente            Tipo   Qtde.           Saldo          Refer.     Lote do VS    Usuario       Pedido       Local    Produto         Descri็ใo"
			cabec3 := "                                                                               Atual"
			         //99/99/9999 99:99                                               9,999,999.999   9,999,999.999                                                               XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXX
		EndIf
		
		@ 009,000 Psay Replicate("-",220)
		@ 010,000 Psay cabec2
		If !Empty(cabec3)
			@ 011,000 Psay cabec3
			@ 012,000 Psay Replicate("-",220)
		Else
			@ 011,000 Psay Replicate("-",220)
		EndIf
		
		nLin := 14
	Endif
	
	If MV_PAR01 == 1 //CODIGO
		If TRB->EST == 'S'
			_nSaldo := _nSaldo - TRB->QUANT
			_nSai	:= _nSai + TRB->QUANT
		ElseIf TRB->EST == 'E'
			_nSaldo := _nSaldo + TRB->QUANT
			_nEnt	:= _nEnt + TRB->QUANT
		EndIf
	Else
		_nSaldo := _aDadB2[2]
	EndIf
	
	@ nLin,000 Psay DTOC(STOD(TRB->DATA))
	@ nLin,011 Psay SUBSTR(TRB->HORA,1,5)
	@ nLin,019 Psay TRB->DOC
	@ nLin,032 Psay SUBSTR(TRB->FORCLI,1,24)
	@ nLin,056 Psay TRB->TIPO
	@ nLin,063 Psay IIF(TRB->EST == 'S', TRB->QUANT*-1,TRB->QUANT) Picture "@E 9,999,999.999" + IIF(TRB->EST == 'N','*','')
	@ nLin,079 Psay _nSaldo Picture "@E 9,999,999.999"
	@ nLin,094 Psay TRB->REF
	@ nLin,106 PSAY TRB->LOTEVS
	@ nLin,120 PSAY TRB->USER
	@ nLin,134 PSAY TRB->PED
	@ nLin,147 PSAY TRB->LOC

    If MV_PAR01 == 1 //CODIGO
		@ nLin,156 PSAY TRB->OBS
	Else
		@ nLin,156 PSAY UPPER(Alltrim(TRB->COD))
		@ nLin,171 PSAY TRB->DESC
	EndIf
	
	nLin := nLin + 1
	TRB->(dbSkip())
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTOTALIZADORณ
//ภฤฤฤฤฤฤฤฤฤฤฤู
nLin := nLin + 2
@ nLin,000 Psay __PrtThinLine()
If MV_PAR01 == 1 //CODIGO
	nLin := nLin + 2
	@ nLin,080 Psay "Saldo Inicial.................: "
	@ nLin,111 Psay "(+)"
	@ nLin,115 Psay _nSldIn Picture "@E 9,999,999.999"
	nLin++
	@ nLin,080 Psay "Total de Entradas no periodo..: "
	@ nLin,111 Psay "(+)"
	@ nLin,115 Psay _nEnt Picture "@E 9,999,999.999"
	nLin++
	@ nLin,080 Psay "Total de Saidas no periodo....: "
	@ nLin,111 Psay "(-)"
	@ nLin,115 Psay _nSai Picture "@E 9,999,999.999"
	nLin++
	@ nLin,116 Psay "_____________"
	nLin++
	@ nLin,080 Psay "Saldo Final...................: "
	@ nLin,111 Psay "(=)"
	@ nLin,115 Psay _nSaldo Picture "@E 9,999,999.999"
EndIf

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraDados บAutor  ณVictor Dessunte     บ Data ณ  08/26/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera dados para leitura no relatorio                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Grupo Masipack                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraDados()

Local _cQry 	:= ""

_cUltDia := DTOS(LASTDAY(STOD(ALLTRIM(STR(MV_PAR04))+MV_PAR03+'01')))

If MV_PAR01 == 1 .OR. MV_PAR01 == 2 //CODIGO OU DOCUMENTO
	_cQry := " SELECT																				" + CRLF
	_cQry += "		*																				" + CRLF
	_cQry += " FROM																					" + CRLF
	_cQry += " (																					" + CRLF
	_cQry += " 		SELECT																			" + CRLF
	_cQry += "			D1_DTDIGIT				AS 'DATA'	,										" + CRLF
	_cQry += "			F1_HORA					AS 'HORA'	,										" + CRLF
	_cQry += " 			D1_DOC+'-'+D1_SERIE		AS 'DOC'	,										" + CRLF
	_cQry += "			CASE WHEN D1_TIPO IN('N','I','P','C') THEN									" + CRLF
	_cQry += "				ISNULL(RTRIM(LTRIM(A2_NREDUZ))+' c/c '+D1_CC,'')						" + CRLF
	_cQry += "			ELSE																		" + CRLF
	_cQry += "				ISNULL(RTRIM(LTRIM(A1_NREDUZ))+' c/c '+D1_CC,'')						" + CRLF
	_cQry += "			END						AS 'FORCLI'	,										" + CRLF
	_cQry += "			'E'						AS 'TIPO'	,										" + CRLF
	_cQry += "			D1_QUANT				AS 'QUANT'	,										" + CRLF
	_cQry += "			D1_X_LTVS				AS 'LOTEVS'	,										" + CRLF
	_cQry += "			D1_MSUSER				AS 'USER'	,										" + CRLF
	_cQry += "			ISNULL(D1_PEDIDO+'/'+D1_ITEMPC,'')	AS 'PED'	,							" + CRLF
	_cQry += "			D1_X_LOC				AS 'LOC'	,										" + CRLF
	_cQry += "			D1_MSOBS				AS 'OBS'	,										" + CRLF
	
	_cQry += "			CASE WHEN F4_ESTOQUE = 'S' THEN												" + CRLF
	_cQry += "				'E'																		" + CRLF
	_cQry += "			ELSE																		" + CRLF
	_cQry += "				'N'																		" + CRLF
	_cQry += "			END						AS 'EST'	,										" + CRLF
	
	_cQry += "			D1_NUMSEQ				AS 'SEQ'	,										" + CRLF
	_cQry += "			D1_COD					AS 'COD'	,										" + CRLF
	_cQry += "			B1_DESC					AS 'DESC'	,										" + CRLF
	_cQry += "			B1_UM					AS 'UM'		,										" + CRLF
	_cQry += "			B1_LOCAL				AS 'LOCAL'	,										" + CRLF
	_cQry += "			B2_DINVENT				AS 'DTINV'	,										" + CRLF
	_cQry += "			B2_RESERVA				AS 'RES'	,										" + CRLF
	_cQry += "			B2_QATU					AS 'SLD'	,										" + CRLF
	_cQry += "			' '						AS 'REF'											" + CRLF
	_cQry += "		FROM																			" + CRLF
	_cQry +=			RetSqlName("SD1") + " AS D1 INNER JOIN " + RetSqlName("SF1") + " AS F1		" + CRLF
	_cQry += "		ON	F1.D_E_L_E_T_	= ' '														" + CRLF
	_cQry += "		AND F1_FILIAL		= '" + xFilial("SF1") + "'									" + CRLF
	_cQry += "		AND F1_DOC			= D1_DOC													" + CRLF
	_cQry += "		AND F1_SERIE		= D1_SERIE													" + CRLF
	_cQry += "		AND F1_FORNECE		= D1_FORNECE												" + CRLF
	_cQry += "		AND F1_LOJA			= D1_LOJA													" + CRLF
	
	_cQry += "		INNER JOIN " + RetSqlName("SB1") + " AS B1										" + CRLF
	_cQry += "		ON	B1.D_E_L_E_T_	= ' '														" + CRLF
	_cQry += "		AND B1_FILIAL		= '" + xFilial("SB1") + "'									" + CRLF
	_cQry += "		AND B1_COD			= D1_COD													" + CRLF
	
	_cQry += "		LEFT JOIN " + RetSqlName("SA2") + " AS A2										" + CRLF
	_cQry += "		ON	A2.D_E_L_E_T_	= ' '														" + CRLF
	_cQry += "		AND A2_FILIAL		= '" + xFilial("SA2") + "'									" + CRLF
	_cQry += "		AND A2_COD			= D1_FORNECE												" + CRLF
	_cQry += "		AND A2_LOJA			= D1_LOJA													" + CRLF
		
	_cQry += "		LEFT JOIN " + RetSqlName("SA1") + " AS A1										" + CRLF
	_cQry += "		ON	A1.D_E_L_E_T_	= ' '														" + CRLF
	_cQry += "		AND A1_FILIAL		= '" + xFilial("SA1") + "'									" + CRLF
	_cQry += "		AND A1_COD			= D1_FORNECE												" + CRLF
	_cQry += "		AND A1_LOJA			= D1_LOJA													" + CRLF
	
	_cQry += "		INNER JOIN " + RetSqlName("SF4") + " AS F4										" + CRLF
	_cQry += "		ON	F4.D_E_L_E_T_	= ' '														" + CRLF
	_cQry += "		AND F4_FILIAL		= ' '														" + CRLF
	_cQry += "		AND F4_CODIGO		= D1_TES													" + CRLF
//	_cQry += "		AND F4_ESTOQUE		= 'S'														" + CRLF
	
	_cQry += "		LEFT JOIN " + RetSqlName("SB2") + " AS B2										" + CRLF
	_cQry += "		ON	B2.D_E_L_E_T_	= ' '														" + CRLF
	_cQry += "		AND B2_FILIAL		= '" + xFilial("SB2") + "'									" + CRLF
	_cQry += "		AND B2_COD			= D1_COD													" + CRLF
	_cQry += "		AND B2_LOCAL = CASE WHEN SUBSTRING(B1_PROCED,2,1) = 'N' THEN '10' ELSE '01' END	" + CRLF
	
	_cQry += "	WHERE 																				" + CRLF
	_cQry += "		D1.D_E_L_E_T_	= ' ' 															" + CRLF
	_cQry += "	AND D1_FILIAL		= '" + xFilial("SD1") + "'										" + CRLF
	
	If MV_PAR01 == 1 //CODIGO
		_cQry += "	AND D1_COD			= '" + ALLTRIM(MV_PAR02) + "'								" + CRLF
		_cQry += "	AND D1_DTDIGIT BETWEEN '" + _cDtIni + "' AND '" + DTOS(MV_PAR05) + "'			" + CRLF
	Else //DOCUMENTO
		_cQry += "	AND D1_DOC LIKE '%" + ALLTRIM(MV_PAR02) + "%'									" + CRLF
	EndIf
	
	_cQry += "	UNION ALL																			" + CRLF
	
	_cQry += "	SELECT																				" + CRLF
	_cQry += "		D2_EMISSAO				AS 'DATA'	,											" + CRLF
	_cQry += "		F2_HORA					AS 'HORA'	,											" + CRLF
	_cQry += "		D2_DOC+'-'+D2_SERIE		AS 'DOC'	,											" + CRLF
	_cQry += "		CASE WHEN D2_TIPO IN('N','C','I','P') THEN										" + CRLF
	_cQry += "			ISNULL(RTRIM(LTRIM(A1_NREDUZ))+' c/c '+D2_CCUSTO,'')						" + CRLF
	_cQry += "		ELSE																			" + CRLF
	_cQry += "			ISNULL(RTRIM(LTRIM(A2_NREDUZ))+' c/c '+D2_CCUSTO,'')						" + CRLF
	_cQry += "		END						AS 'FORCLI'	,											" + CRLF
	_cQry += "		'V'						AS 'TIPO'	,											" + CRLF
	_cQry += "		D2_QUANT				AS 'QUANT'	,											" + CRLF
	_cQry += "		D2_X_LTVS				AS 'LOTEVS'	,											" + CRLF
	_cQry += "		D2_MSUSER				AS 'USER'	,											" + CRLF
	_cQry += "		ISNULL(D2_PEDIDO+'/'+D2_ITEMPV,'')	AS 'PED'	,								" + CRLF
	_cQry += "		D2_X_LOC				AS 'LOC'	,											" + CRLF
	_cQry += "		D2_MSOBS				AS 'OBS'	,											" + CRLF
	_cQry += "		CASE WHEN F4_ESTOQUE = 'S' THEN													" + CRLF
	_cQry += "			'S'																			" + CRLF
	_cQry += "		ELSE																			" + CRLF
	_cQry += "			'N'																			" + CRLF
	_cQry += "		END						AS 'EST'	,											" + CRLF
	_cQry += "		D2_NUMSEQ				AS 'SEQ'	,											" + CRLF
	_cQry += "		D2_COD					AS 'COD'	,											" + CRLF
	_cQry += "		B1_DESC					AS 'DESC'	,											" + CRLF
	_cQry += "		B1_UM					AS 'UM'		,											" + CRLF
	_cQry += "		B1_LOCAL				AS 'LOCAL'	,											" + CRLF
	_cQry += "		B2_DINVENT				AS 'DTINV'	,											" + CRLF
	_cQry += "		B2_RESERVA				AS 'RES'	,											" + CRLF
	_cQry += "		B2_QATU					AS 'SLD'	,							   				" + CRLF
	_cQry += "		' '						AS 'REF'	  											" + CRLF
	_cQry += "	FROM																				" + CRLF
	_cQry += 			RetSqlName("SD2") + " AS D2 INNER JOIN " + RetSqlName("SF2") + " AS F2		" + CRLF
	_cQry += "		ON	F2.D_E_L_E_T_	= ' '														" + CRLF
	_cQry += "		AND F2_FILIAL		= '" + xFilial("SF2") + "'									" + CRLF
	_cQry += "		AND F2_DOC			= D2_DOC													" + CRLF
	_cQry += "		AND F2_SERIE		= D2_SERIE													" + CRLF
	_cQry += "		AND F2_CLIENTE		= D2_CLIENTE												" + CRLF
	_cQry += "		AND F2_LOJA			= D2_LOJA													" + CRLF
	
	_cQry += "		INNER JOIN " + RetSqlName("SB1") + " AS B1										" + CRLF
	_cQry += "		ON	B1.D_E_L_E_T_	= ' '														" + CRLF
	_cQry += "		AND B1_FILIAL		= '" + xFilial("SB1") + "'									" + CRLF
	_cQry += "		AND B1_COD			= D2_COD													" + CRLF
	
	_cQry += "		LEFT JOIN " + RetSqlName("SA2") + " AS A2										" + CRLF
	_cQry += "		ON	A2.D_E_L_E_T_	= ' '														" + CRLF
	_cQry += "		AND A2_FILIAL		= '" + xFilial("SA2") + "'									" + CRLF
	_cQry += "		AND A2_COD			= D2_CLIENTE												" + CRLF
	_cQry += "		AND A2_LOJA			= D2_LOJA													" + CRLF
		
	_cQry += "		LEFT JOIN " + RetSqlName("SA1") + " AS A1										" + CRLF
	_cQry += "		ON	A1.D_E_L_E_T_	= ' '														" + CRLF
	_cQry += "		AND A1_FILIAL		= '" + xFilial("SA1") + "'									" + CRLF
	_cQry += "		AND A1_COD			= D2_CLIENTE												" + CRLF
	_cQry += "		AND A1_LOJA			= D2_LOJA													" + CRLF
	
	_cQry += "		INNER JOIN " + RetSqlName("SF4") + " AS F4										" + CRLF
	_cQry += "		ON	F4.D_E_L_E_T_	= ' '														" + CRLF
	_cQry += "		AND F4_FILIAL		= '" + xFilial("SF4") + "'									" + CRLF
	_cQry += "		AND F4_CODIGO		= D2_TES													" + CRLF
	
	_cQry += "		LEFT JOIN " + RetSqlName("SB2") + " AS B2										" + CRLF
	_cQry += "		ON	B2.D_E_L_E_T_	= ' '														" + CRLF
	_cQry += "		AND B2_FILIAL		= '" + xFilial("SB2") + "'									" + CRLF
	_cQry += "		AND B2_COD			= D2_COD													" + CRLF
	_cQry += "		AND B2_LOCAL = CASE WHEN SUBSTRING(B1_PROCED,2,1) = 'N' THEN '10' ELSE '01' END " + CRLF
	
	_cQry += "	WHERE																				" + CRLF
	_cQry += "		D2.D_E_L_E_T_	= ' '															" + CRLF
	_cQry += "	AND D2_FILIAL		= '" + xFilial("SD2") + "'										" + CRLF
	
	If MV_PAR01 == 1 //CODIGO
		_cQry += "	AND	D2_COD			= '" + ALLTRIM(MV_PAR02) + "'								" + CRLF
		_cQry += "	AND D2_EMISSAO BETWEEN '" + _cDtIni + "' AND '" + DTOS(MV_PAR05) + "'			" + CRLF
	Else
		_cQry += "	AND D2_DOC LIKE '%" + ALLTRIM(MV_PAR02) + "%'									" + CRLF
	EndIf
	
	_cQry += "	UNION ALL																			" + CRLF
	
	_cQry += "	SELECT 																				" + CRLF
	_cQry += "		D3_EMISSAO				AS 'DATA'	,											" + CRLF
	_cQry += "		D3_HORAS				AS 'HORA'	,											" + CRLF
	_cQry += "		CASE WHEN D3_OP <> '' THEN														" + CRLF
	_cQry += "			D3_OP																		" + CRLF
	_cQry += "		ELSE																			" + CRLF
	_cQry += "			D3_DOC																		" + CRLF
	_cQry += "		END						AS 'DOC'	,											" + CRLF
	_cQry += "		ISNULL(RTRIM(LTRIM(C2_MSREDUZ))+' c/c '+D3_CC,'')	AS 'FORCLI'	,				" + CRLF
	_cQry += "		'M'						AS 'TIPO'	,											" + CRLF
	_cQry += "		D3_QUANT				AS 'QUANT'	,											" + CRLF
	_cQry += "		D3_MSVLOTE				AS 'LOTEVS'	,											" + CRLF
	_cQry += "		D3_USUARIO				AS 'USER'	,											" + CRLF
	_cQry += "		ISNULL(C2_MSPED,'')		AS 'PED'	,											" + CRLF
	_cQry += "		D3_MSLOCAL				AS 'LOC'	,											" + CRLF
	_cQry += "		D3_MSOBS				AS 'OBS'	,											" + CRLF
	
	//VICTOR DESSUNTE - 14/03/2017
	//INICIO - TICKET:2017031437000109
	_cQry += "		CASE WHEN D3_CF NOT LIKE '%4' THEN " + CRLF //TRANSFERENCIA 
	_cQry += "			CASE WHEN D3_TM > 499 THEN " + CRLF
	_cQry += "				'S' " + CRLF
	_cQry += "			ELSE " + CRLF
	_cQry += "				'E' " + CRLF
	_cQry += "			END " + CRLF
	_cQry += "		ELSE " + CRLF
	_cQry += "			'N' " + CRLF
	_cQry += "		END 					AS 'EST'	, " + CRLF
	//FIM - TICKET:2017031437000109
	
	_cQry += "		D3_NUMSEQ				AS 'SEQ'	,											" + CRLF
	_cQry += "		D3_COD					AS 'COD'	,											" + CRLF
	_cQry += "		B1_DESC					AS 'DESC'	,											" + CRLF
	_cQry += "		B1_UM					AS 'UM'		,											" + CRLF
	_cQry += "		B1_LOCAL				AS 'LOCAL'	,											" + CRLF
	_cQry += "		B2_DINVENT				AS 'DTINV'	,											" + CRLF
	_cQry += "		B2_RESERVA				AS 'RES'	,											" + CRLF
	_cQry += "		B2_QATU					AS 'SLD',										 		" + CRLF
	_cQry += "		C2_MSREFER				AS 'REF'										 		" + CRLF
	_cQry += "	FROM																				" + CRLF
	_cQry += 		RetSqlName("SD3") + " AS D3 LEFT JOIN " + RetSqlName("SC2") + " AS C2			" + CRLF
	_cQry += "		ON	C2.D_E_L_E_T_	= ' '														" + CRLF
	_cQry += "		AND C2_FILIAL		= '" + xFilial("SC2") + "'									" + CRLF
	_cQry += "		AND C2_NUM			= SUBSTRING(D3_OP,1,6)										" + CRLF
	_cQry += "		AND C2_ITEM			= SUBSTRING(D3_OP,7,2)										" + CRLF
	_cQry += "		AND C2_SEQUEN		= SUBSTRING(D3_OP,9,3)										" + CRLF
	
	_cQry += "		INNER JOIN " + RetSqlName("SB1") + " AS B1										" + CRLF
	_cQry += "		ON	B1.D_E_L_E_T_	= ' '														" + CRLF
	_cQry += "		AND B1_FILIAL		= '" + xFilial("SB1") + "'									" + CRLF
	_cQry += "		AND B1_COD			= D3_COD													" + CRLF
	
	_cQry += "		LEFT JOIN " + RetSqlName("SB2") + " AS B2										" + CRLF
	_cQry += "		ON	B2.D_E_L_E_T_	= ' '														" + CRLF
	_cQry += "		AND B2_FILIAL		= '" + xFilial("SB2") + "'									" + CRLF
	_cQry += "		AND B2_COD			= D3_COD													" + CRLF
	_cQry += "		AND B2_LOCAL = CASE WHEN SUBSTRING(B1_PROCED,2,1) = 'N' THEN '10' ELSE '01' END " + CRLF
	
	_cQry += "	WHERE																				" + CRLF
	_cQry += "		D3.D_E_L_E_T_	= ' ' 															" + CRLF
	_cQry += "	AND D3_FILIAL		= '" + xFilial("SD3") + "'										" + CRLF
	_cQry += "	AND D3_LOCAL		IN ('01','10')													" + CRLF
	
	If MV_PAR01 == 1 //CODIGO
		_cQry += "	AND D3_COD			= '" + ALLTRIM(MV_PAR02) + "'								" + CRLF
		_cQry += "	AND D3_EMISSAO BETWEEN '" + _cDtIni + "' AND '" + DTOS(MV_PAR05) + "'			" + CRLF
	Else //DOCUMENTO
		_cQry += "	AND D3_DOC LIKE '%" + ALLTRIM(MV_PAR02) + "%'									" + CRLF
	EndIf
	
	_cQry += "	) A																					" + CRLF
	_cQry += "	ORDER BY A.SEQ																		"
ElseIf MV_PAR01 == 3 //REFERENCIA
	_cQry += "	SELECT 																				" + CRLF
	_cQry += "		D3_EMISSAO				AS 'DATA'	,											" + CRLF
	_cQry += "		D3_HORAS				AS 'HORA'	,											" + CRLF
	_cQry += "		CASE WHEN D3_OP <> '' THEN														" + CRLF
	_cQry += "			D3_OP																		" + CRLF
	_cQry += "		ELSE																			" + CRLF
	_cQry += "			D3_DOC																		" + CRLF
	_cQry += "		END						AS 'DOC'	,											" + CRLF
	_cQry += "		ISNULL(RTRIM(LTRIM(C2_MSREDUZ))+' c/c '+D3_CC,'')	AS 'FORCLI'	,				" + CRLF
	_cQry += "		'M'						AS 'TIPO'	,											" + CRLF
	_cQry += "		D3_QUANT				AS 'QUANT'	,											" + CRLF
	_cQry += "		D3_MSVLOTE				AS 'LOTEVS'	,											" + CRLF
	_cQry += "		D3_USUARIO				AS 'USER'	,											" + CRLF
	_cQry += "		ISNULL(C2_MSPED,'')		AS 'PED'	,											" + CRLF
	_cQry += "		D3_MSLOCAL				AS 'LOC'	,											" + CRLF
	_cQry += "		D3_MSOBS				AS 'OBS'	,											" + CRLF
	
	//VICTOR DESSUNTE - 14/03/2017
	//INICIO - TICKET:2017031437000109
	_cQry += "		CASE WHEN D3_CF NOT LIKE '%4' THEN " + CRLF //TRANSFERENCIA 
	_cQry += "			CASE WHEN D3_TM > 499 THEN " + CRLF
	_cQry += "				'S' " + CRLF
	_cQry += "			ELSE " + CRLF
	_cQry += "				'E' " + CRLF
	_cQry += "			END " + CRLF
	_cQry += "		ELSE " + CRLF
	_cQry += "			'N' " + CRLF
	_cQry += "		END 					AS 'EST'	, " + CRLF
	//FIM - TICKET:2017031437000109
	
	_cQry += "		D3_NUMSEQ				AS 'SEQ'	,											" + CRLF
	_cQry += "		D3_COD					AS 'COD'	,											" + CRLF
	_cQry += "		B1_DESC					AS 'DESC'	,											" + CRLF
	_cQry += "		B1_UM					AS 'UM'		,											" + CRLF
	_cQry += "		B1_LOCAL				AS 'LOCAL'	,											" + CRLF
	_cQry += "		B2_DINVENT				AS 'DTINV'	,											" + CRLF
	_cQry += "		B2_RESERVA				AS 'RES'	,											" + CRLF
	_cQry += "		B2_QATU					AS 'SLD',										 		" + CRLF
	_cQry += "		C2_MSREFER				AS 'REF'										 		" + CRLF
	_cQry += "	FROM																				" + CRLF
	_cQry += 		RetSqlName("SD3") + " AS D3 LEFT JOIN " + RetSqlName("SC2") + " AS C2			" + CRLF
	_cQry += "		ON	C2.D_E_L_E_T_	= ' '														" + CRLF
	_cQry += "		AND C2_FILIAL		= '" + xFilial("SC2") + "'									" + CRLF
	_cQry += "		AND C2_NUM			= SUBSTRING(D3_OP,1,6)										" + CRLF
	_cQry += "		AND C2_ITEM			= SUBSTRING(D3_OP,7,2)										" + CRLF
	_cQry += "		AND C2_SEQUEN		= SUBSTRING(D3_OP,9,3)										" + CRLF
	
	_cQry += "		INNER JOIN " + RetSqlName("SB1") + " AS B1										" + CRLF
	_cQry += "		ON	B1.D_E_L_E_T_	= ' '														" + CRLF
	_cQry += "		AND B1_FILIAL		= '" + xFilial("SB1") + "'									" + CRLF
	_cQry += "		AND B1_COD			= D3_COD													" + CRLF
	
	_cQry += "		LEFT JOIN " + RetSqlName("SB2") + " AS B2										" + CRLF
	_cQry += "		ON	B2.D_E_L_E_T_	= ' '														" + CRLF
	_cQry += "		AND B2_FILIAL		= '" + xFilial("SB2") + "'									" + CRLF
	_cQry += "		AND B2_COD			= D3_COD													" + CRLF
	_cQry += "		AND B2_LOCAL = CASE WHEN SUBSTRING(B1_PROCED,2,1) = 'N' THEN '10' ELSE '01' END " + CRLF
	
	_cQry += "	WHERE																				" + CRLF
	_cQry += "		D3.D_E_L_E_T_	= ' ' 															" + CRLF
	_cQry += "	AND D3_FILIAL		= '" + xFilial("SD3") + "'										" + CRLF
	_cQry += "	AND D3_LOCAL		IN ('01','10')													" + CRLF
	_cQry += "	AND D3_MSREFER		= '" + ALLTRIM(MV_PAR02) + "'									"
EndIf

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TCQUERY _cQry NEW ALIAS "TRB"

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFECHDADOS บAutor  ณVictor Dessunte     บ Data ณ  08/31/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ - Localiza informacoes do ultimo fechamento                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FechDados()

Local _cQry := ""

_cQry := " SELECT 																	" + CRLF
_cQry += "		TOP 1 B9_DATA, B9_QINI 												" + CRLF
_cQry += " FROM 																	" + CRLF
_cQry += "		"+RetSqlName("SB9")+" B9											" + CRLF
_cQry += " INNER JOIN 																" + CRLF
_cQry += "		"+RetSQLName("SB1")+" B1 ON  										" + CRLF
_cQry += "			B1_FILIAL = '"+xFilial("SB1")+"' 								" + CRLF 
_cQry += "		AND B1_COD = B9_COD													" + CRLF
_cQry += "		AND B1_MSBLQL <> '1'												" + CRLF
_cQry += "		AND B1.D_E_L_E_T_ = ''												" + CRLF
_cQry += " WHERE 																	" + CRLF
_cQry += " 		B9.D_E_L_E_T_ 	= ' ' 												" + CRLF
_cQry += " AND B9_FILIAL 	= '" + xFilial("SB9") + "' 								" + CRLF
_cQry += " AND SUBSTRING(B9_DATA,1,6) < '" + ALLTRIM(STR(MV_PAR04))+MV_PAR03 + "' 	" + CRLF
_cQry += " AND B9_COD = '" + MV_PAR02 + "' 											" + CRLF

//VICTOR DESSUNTE - 24/01/2017
//INICIO - TICKET: 2017012437000077
IF ALLTRIM(STR(MV_PAR04))+MV_PAR03 > '201803'
	_cQry += "	AND	B9_LOCAL = CASE WHEN ISNULL(B9_DATA,'') = '' AND SUBSTRING(B9_DATA,1,6) > '201803' THEN '10' ELSE '01' END " + CRLF
ELSE
	_cQry += "	AND	B9_LOCAL = '01' " + CRLF
ENDIF 
//FIM - TICKET: 2017012437000077

_cQry += " ORDER BY B9_DATA DESC 													"

If Select("TRBB9") > 0
	TRBB9->(dbCloseArea())
EndIf

TCQUERY _cQry NEW ALIAS "TRBB9"

TRBB9->(dbGoTop())

If TRBB9->(!EOF())
	_cDtIni := IIF(EMPTY(ALLTRIM(TRBB9->B9_DATA)),"20180401",DTOS(STOD(TRBB9->B9_DATA)+1))
	_nSaldo	:= TRBB9->B9_QINI
Else
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCaso nao encontre o saldo inicial anterior ao selecionado, pega o proximo fechamentoณ
	//ณapos a data selecionada.                                                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Select("TRBB9") > 0
		TRBB9->(dbCloseArea())
	EndIf
	
	_cQry := " SELECT	" + CRLF
	_cQry += " 		TOP 1 B9_DATA, B9_QINI " + CRLF
	_cQry += " FROM " + CRLF
	_cQry += "		"+RetSqlName("SB9")+" B9											" + CRLF
	_cQry += " INNER JOIN 																" + CRLF
	_cQry += "		"+RetSQLName("SB1")+" B1 ON  										" + CRLF
	_cQry += "			B1_FILIAL = '"+xFilial("SB1")+"' 								" + CRLF 
	_cQry += "		AND B1_COD = B9_COD													" + CRLF
	_cQry += "		AND B1_MSBLQL <> '1'												" + CRLF
	_cQry += "		AND B1.D_E_L_E_T_ = ''												" + CRLF
	_cQry += " WHERE " + CRLF
	_cQry += " 			B9.D_E_L_E_T_ 	= ' ' " + CRLF
	_cQry += "	AND 	B9_FILIAL 	= '" + xFilial("SB9") + "' " + CRLF
	_cQry += "	AND 	B9_COD 		= '" + MV_PAR02  + "' " + CRLF

	//VICTOR DESSUNTE - 24/01/2017
	//INICIO - TICKET: 2017012437000077
	IF ALLTRIM(STR(MV_PAR04))+MV_PAR03 > '201803'
		_cQry += "	AND	B9_LOCAL = CASE WHEN ISNULL(B9_DATA,'') = '' AND SUBSTRING(B9_DATA,1,6) > '201803' THEN '10' ELSE '01' END " + CRLF
	ELSE
		_cQry += "	AND	B9_LOCAL = '01' " + CRLF
	ENDIF 
	//FIM - TICKET: 2017012437000077
	
	_cQry += "	ORDER BY B9_DATA "
	
	TCQUERY _cQry NEW ALIAS "TRBB9"

	TRBB9->(dbGoTop())
	
	If TRBB9->(!EOF())
		_cDtIni := IIF(EMPTY(ALLTRIM(TRBB9->B9_DATA)),"20180401",DTOS(STOD(TRBB9->B9_DATA)+1))
		_nSaldo	:= TRBB9->B9_QINI
	EndIf
EndIf

If Select("TRBB9") > 0
	TRBB9->(dbCloseArea())
EndIf

Return
