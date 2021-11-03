#Include "Rwmake.ch"
#Include "Topconn.ch"
#include "shell.ch"

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | RPCPR036.prw    | AUTOR | Ivandro Santos   | DATA | 08/12/2015  |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Relatório de Estrutura com peças críticas. Relatório será usado |//
//|           | para informar aos clientes as peças de reposição de acordo com  |//
//|           | a criticidade do produto.                                       |//
//|           | Solicitado por Franco, setor Documentacao Tecnica/Eng           |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////


User Function RPCPR041()

//+-------------------------------------------------------------------------------
//| Declaracoes de variaveis
//+-------------------------------------------------------------------------------

Local cDesc1  := "Este relatorio ira imprimir de estrutura de produtos"         
Local cDesc2  := "com matéria prima em Inox que tenha Certificado"                      
Local cDesc3  := "Sera gerado um arquivo em C:\relato_microsiga\RPCPR041.CSV"

Private cString  := "SG1"
Private Tamanho  := "M"
Private aReturn  := { "Zebrado",1,"Administracao",2,2,1,"",1 }
Private wnrel    := "RPCPR041"
Private NomeProg := "RPCPR041"
Private nLastKey := 0
Private Limite   := 132
Private Titulo   := "Estrutura de Peças críticas"
Private cPerg    := "XRPCP036"
Private nTipo    := 0
Private cbCont   := 0
Private cbTxt    := "registro(s) lido(s)"
Private Li       := 80
Private m_pag    := 1

#IFNDEF TOP
   MsgInfo("Não é possível executar este programa, está base de dados não é TopConnect","Incompatibilidade")
   RETURN
#ENDIF

/*+----------------------
  | Parametros do aReturn 
  +----------------------
aReturn - Preenchido pelo SetPrint()
aReturn[1] - Reservado para formulario
aReturn[2] - Reservado para numero de vias
aReturn[3] - Destinatario
aReturn[4] - Formato 1=Comprimido 2=Normal
aReturn[5] - Midia 1-Disco 2=Impressora
aReturn[6] - Plota ou arquivo 1-Lpt1... 4-Com1...
CReturn[7] - Expressao do filtro
aReturn[8] - Ordem a ser selecionada
aReturn[9] [10] [n] - Campos a processar se houver
*/

//+-------------------------------------------------------------------------------
//| Solicita ao usuario a parametrizacao do relatorio.
//+-------------------------------------------------------------------------------
wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,.F.,.F.)

//+-------------------------------------------------------------------------------
//| Disponibiliza para usuario digitar os parametros
//+-------------------------------------------------------------------------------
Pergunte(cPerg,.F.)
//+-------------------------------------------------------------------------------
//| Se teclar ESC, sair
//+-------------------------------------------------------------------------------
If nLastKey == 27
   Return
Endif

//+-------------------------------------------------------------------------------
//| Estabelece os padroes para impressao, conforme escolha do usuario
//+-------------------------------------------------------------------------------
SetDefault(aReturn,cString)

//+-------------------------------------------------------------------------------
//| Verificar se sera reduzido ou normal
//+-------------------------------------------------------------------------------
nTipo := Iif(aReturn[4] == 1, 15, 18)

//+-------------------------------------------------------------------------------
//| Se teclar ESC, sair
//+-------------------------------------------------------------------------------
If nLastKey == 27
   Return
Endif

//+-------------------------------------------------------------------------------
//| Chama funcao que processa os dados
//+-------------------------------------------------------------------------------
RptStatus({|lEnd| RelSQLINOX(@lEnd, wnrel, cString) }, "Aguarde...", "Processando registros...", .T. )

Return


Static Function RelSQLINOX(lEnd,wnrel,cString)
Local cQuery   := ""
Local aCol     := {}
Local aCompAtu := {}
Local nX := 0

Private cArq   :="C:\Relato_Microsiga\Peca_Inox.CSV"
//+-------------------------------------------------------------------------------
//| Gera arquivo .CSV - INICIO
//+-------------------------------------------------------------------------------
If (cArqCSV := FCreate(cArq)) == -1 
	Alert("Arquivo para o Excel não pode ser criado - Verifique se o mesmo não está aberto - Avise o Depto. de Informática")
	Return
Else
	
	//+-------------------------------------------------------------------------------
	//| Gera arquivo .CSV - FIM
	//+-------------------------------------------------------------------------------
	cRegCSV := "CÓDIGO;DESCRIÇÃO CÓDIGO PAI;COMPONENTE;DESCRIÇÃO COMPONENTE;CERT. ATOX; CONF CE; CERT QUAL;GRUPO;TIPO;UM;GR VENDAS"
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)) 
EndIF

DbSelectArea("SG1")

DbSetOrder(2)
dBGoTop()
_lComp := SG1->(DbSeek(xFilial("SG1")+Alltrim(MV_PAR01)))

DbSetOrder(1)
dBGoTop()
SG1->(DbSeek(xFilial("SG1")+Alltrim(MV_PAR01)))
aadd(aCompAtu,{SG1->G1_COD})
Do While SG1->(!Eof()) .And. Alltrim(SG1->G1_COD) == Alltrim(MV_PAR01)
	aadd(aCompAtu,{SG1->G1_COMP,SG1->G1_COD})
	SG1->(dbSkip())
EndDo
SG1->(DbCloseArea())
For nX:= 1 to len(aCompAtu)
	//+-----------------------
	//| Cria filtro temporario
	//+-----------------------
	cQuery := " SELECT G1_COD,SB1.B1_DESC B1_DESC,G1_COMP,SB1C.B1_DESC AS COMPDESC,SB1C.B1_MSATOX B1_MSATOX,SB1C.B1_MSCONF B1_MSCONF, "
	cQuery += " SB1C.B1_MSCERT B1_MSCERT,SB1C.B1_GRUPO B1_GRUPO, SB1C.B1_TIPO, SB1C.B1_UM B1_UM, SB1.B1_MSGRVEN "
	cQuery += " FROM "+RetSqlName("SG1")+" SG1 "
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 "
	cQuery += "    ON G1_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1C "
	cQuery += "    ON G1_COMP = SB1C.B1_COD AND SB1C.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE SUBSTRING(SB1C.B1_GRUPO,4,1) = 'I' " //SB1C.B1_MSPCCRI <> '' "
	cQuery += " 	AND G1_COD IN
    If _lComp
		cQuery += " 	(SELECT G1_COMP FROM SG1010 SG1C WHERE SG1C.G1_COD = '"+Alltrim(aCompAtu[nX][1])+"') " //MV_PAR01
	Else
		cQuery += " 	(SELECT G1_COMP FROM SG1010 SG1C WHERE SG1C.G1_COD = '"+Alltrim(aCompAtu[nX][1])+"') " //
	Endif
	cQuery += " 	AND SG1.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY SB1.B1_COD "
	
	//-----------------------
	//| Cria uma view no banco
	//+-----------------------
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "QR1", .T., .F. )
	dbSelectArea("QR1")
	
	TcSetField("QR1","G1_COD"	,"C",15,00)
	TcSetField("QR1","G1_COMP"	,"C",15,00)
		
	//"CÓDIGO;DESCRIÇÃO CÓDIGO PAI;COMPONENTE;DESCRIÇÃO COMPONENTE;CERT. ATOX; CONF CE; CERT QUAL;GRUPO;TIPO;UM;GR VENDAS"
	While QR1->(!Eof())
		
		cRegCSV :=	QR1->G1_COD		+ ";"
		cRegCSV +=	QR1->B1_DESC	+ ";"
		cRegCSV +=	QR1->G1_COMP	+ ";"
		cRegCSV +=	QR1->COMPDESC	+ ";"
		cRegCSV +=	QR1->B1_MSATOX	+ ";"
		cRegCSV +=	QR1->B1_MSCONF	+ ";"
		cRegCSV +=	QR1->B1_MSCERT	+ ";"
		cRegCSV +=	QR1->B1_GRUPO	+ ";"
		cRegCSV +=	QR1->B1_TIPO	+ ";"
		cRegCSV +=	QR1->B1_UM		+ ";"						
		cRegCSV +=	QR1->B1_MSGRVEN
		
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))//Grava Linha
		
		QR1->(dbSkip()) 
		
		SetRegua( RecCount() )
	
	End
	If Select("QR1") > 0
		dbSelectArea("QR1")
		dbCloseArea()
	EndIf
Next

FClose(cArqCSV)

If lEnd
   @ Li, aCol[1] PSay cCancel
   Return
Endif
   
If Li <> 80
   Roda(cbCont,cbTxt,Tamanho)
Endif

Return