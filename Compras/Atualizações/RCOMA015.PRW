#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³RCOMA015  ºAutor  ³Aparecida de F.Stevanatoº Data  23/09/10 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Visualizacao da tabela SZR - Avaliação dos Fornecedores     º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RCOMA015()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro := "Avaliação dos Fornecedores" 

Private aRotina := { {"Pesquisar"	   	,"AxPesqui",0,1} ,;     // Pesquisa na tabela SZR
                     {"Visualizar"		,"AxVisual",0,2} ,;		// Visualiza 
                     {"Alterar"	    	,"AxAltera",0,3} ,;		// Altera
                     {"Gera Planilha"   ,"U_GeraPlan()",0,4}}   // Gera Planilha  
                       
Private cString := "SZR"
PRIVATE cArqCSV := ""
PRIVATE cRegCSV := "" 
PRIVATE cPerg   := "COMA15" + Space(4)

dbSelectArea("SZR")

mBrowse( 6,1,22,75,"SZR")

Return

/***************************/
User Function GeraPlan()
/***************************/
   If !Pergunte(cPerg,.T.)
      Return
   EndIf   
   If (cArqCSV := FCreate("C:\Relato_Microsiga\IQF_Fornecedor.csv")) == -1
      apmsgStop("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
      Return
   Else 
      cRegCSV := ";" + "Analise de Fornecedores "  
      FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)) 
      cRegCSV := ""
      FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)) 
      cRegCSV := "PERIODO;FORNECEDOR;NOME FANTASIA;NATUREZA;IQF Entrega;IQF Conformidade;IQF Pontuação;IQF TOTAL;Observações"
      FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
      cRegCSV := ""
      FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
   EndIf
   
   SA2->(DbSetOrder(1))
   
   If Select("QR1") > 0 
      DbSelectArea("QR1")                                                                         
      DbCloseArea()
   EndIf 
       
   _cQuery := " SELECT * FROM " + RetSqlName("SZR") + " SZR "
   _cQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 ON  ZR_FORNEC = A2_COD AND A2_FILIAL = '" + xFilial("SA2") + "' "
   _cQuery += " WHERE ZR_FILIAL = '" + xFilial("SZR") + "' AND ZR_PERIODO >= '"+ mv_par01 +"' AND ZR_PERIODO <= '"+ mv_par02 +"'"
   _cQuery += " AND A2_RISCO = 'A'      "
	_cQuery += " AND SZR.D_E_L_E_T_ = '' "
	_cQuery += " AND SA2.D_E_L_E_T_ = '' "
   _cQuery += " ORDER BY ZR_FORNEC, ZR_PERIODO, ZR_LOJA "
      
   DbUseArea( .T., 'TOPCONN', TCGENQRY(NIL, NIL, _cQuery), "QR1", .T., .T.)   // esta funcao executa a query no sql e armazena o resultado na tabela virtual QR2
     
   Do While !QR1->(Eof())
      SA2->(DbSeek(xFilial("SA2")+QR1->ZR_FORNEC+QR1->ZR_LOJA))
      cRegCSV := "_"+SubStr(QR1->ZR_PERIODO,5,2)+"/"+SubStr(QR1->ZR_PERIODO,1,4)+";_"+QR1->ZR_FORNEC+"/"+QR1->ZR_LOJA+";"+SA2->A2_NREDUZ+";"+SA2->A2_NATUREZ+";"+TRANSFORM(QR1->ZR_IQFENT,"@E 999.9999")+";"+TRANSFORM(QR1->ZR_IQFCONF,"@E 999.999")+";"+TRANSFORM(QR1->ZR_IQFPONT,"@E 999.999")+";"+TRANSFORM(QR1->ZR_IQFTOT,"@E 999.999")  
      If QR1->ZR_IQFENT == 0
         cRegCSV += ";Periodo sem Entrada de Material"
      EndIf
      FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))   
      QR1->(DbSkip())
   EndDo
   FClose(cArqCSV) 
   QR1->(dbCloseArea())
   apmsgInfo( "OK - Planilha gerada em: C:\relato_microsiga\IQF_Fornecedores.csv")   

Return
