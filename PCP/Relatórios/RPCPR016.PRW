#include "Rwmake.ch"
#include "Topconn.ch"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±³Funcao	   ³ RPCPR016³ Autor ³ José Roberto Funari      ³Data ³  21.04.10 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descricao ³ Indicadores para ISO 9001                   	              ³±± 
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//Revisão e alteração: 30/04/2014 - Eduardo Mantoan - Refeita a lógica de códido e de query / ajustes na impressão  

User Function RPCPR016()                                                                                    

PRIVATE Titulo      := "Indicadores para ISO"
PRIVATE cString     := "SC2"
PRIVATE wnrel       := "RPCPR016"
PRIVATE aReturn     := { "Zebrado",1,"Administracao",1,2,1,"",1 }      
PRIVATE nomeprog    := "RPCPR016"
PRIVATE cPerg	     := "PCPR16" + Space(4)
PRIVATE nLastKey    := 0
PRIVATE Li          := 99
Private Co          := 0
PRIVATE cabec1      := ""
PRIVATE cabec2      := ""
PRIVATE tamanho     := "M"
PRIVATE limite      := 80
PRIVATE CbCont      := 0
PRIVATE nIR 		  := 0
PRIVATE nIT		     := 0
PRIVATE nILaiser    := 0
PRIVATE nIMovim     := 0
PRIVATE nAjustes    := 0
PRIVATE nItensDev   := 0 
PRIVATE nOPs        := 0
PRIVATE nOPemDia    := 0
PRIVATE nOPAtrasada := 0

If !Pergunte(cPerg,.T.)
   Return
EndIf   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros		    			 ³
//³ mv_par01	 -  Data De                                      ³
//³ mv_par02	 -  Data Ate                                     ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nLastKey==27
	Set Filter to
	Return
EndIf

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,,,,.F.,,,Tamanho) 
 
If nLastKey = 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)    

MsgRun("Aguarde, Gerando Indicadores !!!!",, {|| GeraIndicadores()})

dbCloseArea()

Return

*********************************
Static Function GeraIndicadores()
*********************************

m_pag   := 1
Li 	    := 80 
Titulo  := "Indicadores para ISO"
cabec1  := "                                           Qtde.            Setor         Indicador"
cabec2  := "  Periodo: " + DTOC(mv_par01) + " à " + DTOC(mv_par02)
cabec3  := "  Nota  Dt.Emissao  Fornecedor                  Produto         Descricao                                 Qtde   Un.  Ped.Compra"
SB1->(DBSETORDER(1))
sd1->(DBSETORDER(6))
sd2->(DBSETORDER(5))

nIR := 0
nILaiser := 0
nIMovim := 0
nAjustes := 0
nItensDev := 0

If Select("TMP") > 0 
	DbSelectArea("TMP")                                  
	DbCloseArea()
EndIf
            //B1 Retirada pois baixa a performace 
cQry := " SELECT D3_DOC AS DOCUM,D3_TM AS TM,D3_COD AS PROD,D3_MSOBS AS OBS  "
cQry += " FROM "+RetSqlName("SD3")+" SD3                "
cQry += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_COD = D3_COD AND SB1.D_E_L_E_T_=' ' AND (B1_LOCAL LIKE '1%' OR B1_LOCAL LIKE '4%' OR B1_LOCAL LIKE 'G% ') AND B1_FILIAL ='"+xFilial("SB1")+"' " 
cQry += " WHERE  SD3.D_E_L_E_T_=' '  "   
cQry += " AND D3_FILIAL ='"+xFilial("SD3")+"'"
cQry += " AND D3_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' " //AND D3_USUARIO <> 'Lizandra       '   "

cQry += " UNION ALL "

cQry += " SELECT D1_DOC AS DOCUM,D1_MSOBS AS TM,D1_COD AS PROD,D1_MSOBS AS OBS  "
cQry += " FROM "+RetSqlName("SD1")+" SD1      "
cQry += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_COD = D1_COD AND SB1.D_E_L_E_T_=' ' AND (B1_LOCAL LIKE '1%' OR B1_LOCAL LIKE '4%' OR B1_LOCAL LIKE 'G% ')AND B1_FILIAL ='"+xFilial("SB1")+"' "
cQry += " WHERE  SD1.D_E_L_E_T_=' ' " 
cQry += " AND D1_FILIAL ='"+xFilial("SD1")+"'"
cQry += " AND D1_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' "

cQry += " UNION ALL  "

cQry += " SELECT D2_DOC AS DOCUM,D2_MSOBS AS TM,D2_COD AS PROD,D2_MSOBS AS OBS"
cQry += " FROM "+RetSqlName("SD2")+" SD2
cQry += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_COD = D2_COD AND SB1.D_E_L_E_T_=' ' AND (B1_LOCAL LIKE '1%' OR B1_LOCAL LIKE '4%' OR B1_LOCAL LIKE 'G% ') AND B1_FILIAL ='"+xFilial("SB1")+"' "
cQry += " WHERE  SD2.D_E_L_E_T_=' '  "
cQry += " AND D2_FILIAL ='"+xFilial("SD2")+"'"
cQry += " AND D2_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"'"
 
cQry += " ORDER BY  D3_DOC "


//Executa query
cQry := ChangeQuery(cQry)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMP",.T.,.T.)

dbSelectArea("TMP")
dbGoTop()

Do While !TMP->(Eof())

/*	If TMP->MSTIPOR + SUBSTR(TMP->MSCODIG,1,2) + SUBSTR(TMP->MSCFISC,1,2) = 'MCLPR' // Retirado por não ser utilizado mais (Claudio Qualidade)
	   nILaiser = nILaiser + 1
	EndIf  
*/	

	  	If !(AllTrim(TMP->TM) == "499" .OR. AllTrim(TMP->TM) == "999")
	  	
	      nIMovim++
	  	Else       
	  		
			nAjustes++
		EndIf

	TMP->(dbSkip())
	
EndDo	

TMP->(dbCloseArea())

Cabec(titulo,Cabec2,Cabec1,nomeprog,tamanho,18)

Li:=10
/*
@Li,000 Psay "                  Itens do Corte Laser: " // Retirado por não ser utilizado mais (Claudio Qualidade)
@Li,041 Psay nILaiser  Picture "@E 999,999"
@Li,060 Psay "Corte Laser"
Li+=4 */
@Li,000 Psay "Itens movimentados nos locais 1, 4 e G: "
@Li,041 Psay nIMovim Picture "@E 999,999"
@Li,062 Psay "Almoxarifado"
Li+=2
@Li,000 Psay "                       Itens ajustados: "
@Li,041 Psay nAjustes Picture "@E 999,999"
@Li,062 Psay"Almoxarifado"
If nIMovim > 0 
   @Li,080 Psay "   Acerto: " + STR(100 - ((nAjustes/nIMovim) * 100),6,2) + "%"
EndIf 
Li +=3
//If MV_PAR03 == 1
	@ Li,000 Psay "Entradas por Unidade
	Li ++
	@Li,000 PSAY __PrtFatLine()  
	Li ++
//EndIF
/*
IF sd1->(DBSEEK(xFilial("SD1") + SUBSTR(DTOS(mv_par01),1,6)))
   Do WHILE sd1->d1_dtdigit <= mv_par02 .AND. !sd1->(EOF())
      IF ALLTRIM(sd1->d1_cf) $ "1925_2925_3925_1101_2101_3101"
         nIR++
      ENDIF
      //@ nLinha,01 PSAY "                        Itens Recebidos: " + STR(nIR,6,0) + " [Recebimento]"
      sd1->(DBSKIP())
   ENDDO
ENDIF

IF sd2->(DBSEEK(xFilial("SD2") + SUBSTR(DTOS(mv_par01),1,6)))
   WHILE sd2->d2_emissao <= mv_par02 .AND. !sd2->(EOF())
      IF ALLTRIM(sd2->d2_cf) $ "5201_6201_7201"
         nItensDev++
      ENDIF
      sd2->(DBSKIP())
   ENDDO
ENDIF
*/

/// Notas Fiscais de Entrada

IF Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
ENDIF  
_cQuery := " SELECT 'E' AS TIPO, SD1.D1_DOC AS NOTAS, SD1.D1_PEDIDO AS PEDIDO, D1_DTDIGIT AS EMISSAO, SD1.D1_FORNECE AS CODFOR,B1_DESC, "
_cQuery += " SA2.A2_NREDUZ AS NOMFOR, SD1.D1_COD AS PROD,SD1.D1_QUANT AS QTDE , SD1.D1_UM AS UNID,SD1.D1_LOJA AS LOJA,"
_cQuery += " D1_ITEM AS ITEM, D1_ITEMPC AS ITEMP,A2_NATUREZ,A2_RISCO,A2_MSPONTI"
_cQuery += " FROM "+RetSqlName("SD1")+" SD1"
_cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_COD = SD1.D1_FORNECE AND SA2.D_E_L_E_T_ = '' AND (A2_NATUREZ = 'A01' OR A2_NATUREZ = 'A05' OR A2_NATUREZ = 'A06' OR A2_NATUREZ = 'A07') AND A2_FILIAL = '"+xFilial("SA2")+"'" 
_cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_COD = D1_COD AND B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_=''  "
_cQuery += " WHERE SD1.D1_DTDIGIT BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"'"
_cQuery += "  AND SD1.D1_TIPO = 'N' AND D1_FILIAL = '"+xFilial("SD1")+"'"
_cQuery += " AND SD1.D_E_L_E_T_ = ''" 

_cQuery += "  UNION  ALL"

_cQuery += " SELECT 'S' AS TIPO, SD2.D2_DOC AS NOTAS, SD2.D2_PEDIDO AS PEDIDO, SD2.D2_EMISSAO AS EMISSAO, SD2.D2_CLIENTE AS CODFOR,B1_DESC, "
_cQuery += " SA2.A2_NREDUZ AS NOMFOR, SD2.D2_COD AS PROD, SD2.D2_QUANT AS QTDE , SD2.D2_UM AS UNID,SD2.D2_LOJA AS LOJA,"
_cQuery += " D2_ITEM AS ITEM, D2_ITEMPV AS ITEMP,A2_NATUREZ,A2_RISCO,A2_MSPONTI"
_cQuery += " FROM "+RetSqlName("SD2")+" SD2"
_cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_COD = SD2.D2_CLIENTE AND (A2_NATUREZ = 'A01' OR A2_NATUREZ = 'A05' OR A2_NATUREZ = 'A06' OR A2_NATUREZ = 'A07') AND SA2.D_E_L_E_T_ = '' AND A2_FILIAL = '"+xFilial("SA2")+"'"
_cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_COD = D2_COD AND B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_='' "
_cQuery += " WHERE SD2.D2_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"'"
_cQuery += " AND (SD2.D2_TIPO = 'D' OR SUBSTRING(SD2.D2_CF,2,1) = '2') AND D2_FILIAL = '"+xFilial("SD2")+"'	" 																									

_cQuery += " AND SD2.D_E_L_E_T_ = ''"
 

_cQuery += " ORDER BY UNID"
//Else
//	_cQuery += " ORDER BY NOTAS"                                                            
//EndIF
//Executa query
TcQuery _cQuery New Alias "QR1"

nIDC 	:= 0
nIRC := 0
nUn    		 	:= ""
Co		 	  	 	:= 0
dbSelectArea("QR1")
dbGoTop()
//If MV_PAR03 == 1
	Do While !QR1->(Eof())
   	nUn   := QR1->UNID
   	nIR := 0
   	Do While nUn == QR1->UNID
			If QR1->TIPO == 'E'
				nIRC ++
		  		nIR += QR1->QTDE
		  		nIT += QR1->QTDE
			EndIf
			If QR1->TIPO == 'S'
				nIDC ++
	   		nItensDev += QR1->QTDE
	   	EndIf
			QR1->(dbSkip())
		EndDo
		If Co > 105
			Li ++
			Co := 0
		EndIf
		IF Li > 60
			Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
			Li++
		ENDIF
		Co += 2
		@ Li,Co Psay " | "
		Co +=3
		@ Li,Co Psay nUn +": "
		Co += 5
		@ Li,Co Psay nIR Picture "@E 99999,999"
		Co += 8
	EndDo
Co += 2
@ Li,Co Psay " | "
/*Else
	Do While !QR1->(Eof())
			If QR1->TIPO == 'E'
				nIRC ++
	   		nIR += QR1->QTDE
	   		nIT += QR1->QTDE
			EndIf	
			If QR1->TIPO == 'S'
				nIDC ++
	   		nItensDev   += QR1->QTDE
			EndIf
			QR1->(dbSkip())
	EndDo			
EndIF*/
Li +=2
@Li,000 PSAY __PrtFatLine()
Li++
@ Li,015 Psay "Total itens (Qtd): "
@ Li,041 Psay nIT Picture "@E 999999,999"
@ Li,060 Psay "Recebimento"
Li ++
@ Li,015 Psay "Total itens (Cod): "
@ Li,041 Psay nIRC Picture "@E 999999,999"
@ Li,060 Psay "Recebimento"
Li += 4
/*If MV_PAR03 <> 1
	@ Li,000 Psay "                       Itens Recebidos: "
	@ Li,041 Psay nIR Picture "@E 999,999"
	@ Li,055 Psay "Recebimento"
	Li += 4
EndIf*/
//Devolução de itens recebimento      
@ Li,000 Psay "Devolução de Itens"
Li++ 
@Li,000 PSAY __PrtFatLine()
Li++
@ Li,015 Psay "Itens devolvidos (Qtd): "
@ Li,041 Psay nItensDev Picture "@E 999,999"
@ Li,060 Psay "Recebimento"
@ Li,071 Psay "   Ind.Dev: " + STR((nItensDev/nIT) * 100,5,2) + "%"
Li ++
@ Li,015 Psay "Itens devolvidos (Cod): "
@ Li,041 Psay nIDC Picture "@E 999,999"
@ Li,060 Psay "Recebimento"
@ Li,071 Psay "   Ind.Dev: " + STR((nIDC/nIRC) * 100,5,2) + "%"
Li +=2
@Li,000 PSAY __PrtFatLine()
Li += 4
	If Li > 60
		Cabec(titulo,Cabec2,Cabec3,nomeprog,tamanho,18)
		Li++
	Else
		@ Li,000 Psay "  Nota  Dt.Emissao  Fornecedor                  Produto         Descricao                                 Qtde   Un.  Ped.Compra"
		Li++
		@Li,000 PSAY __PrtFatLine()
		Li++
	EndIF
	QR1->(DbGotop())
	Do While !QR1->(Eof())
		If QR1->TIPO == 'S'
			dDtEmissao := Stod(QR1->EMISSAO)
			Li++
			IF Li > 60
				Cabec(titulo,Cabec2,Cabec3,nomeprog,tamanho,18)
				Li++
			EndIf
			@ Li,000 Psay QR1->NOTAS         Picture "XXXXXX"
			@ Li,010 Psay dDtEmissao         Picture '99/99/99'
			@ Li,020 Psay QR1->CODFOR        Picture "XXXXXX"
			@ Li,026 Psay "-"
			@ Li,027 Psay QR1->NOMFOR        Picture "@!"
			@ Li,048 Psay QR1->PROD          Picture "@!"
			@ Li,064 Psay QR1->B1_DESC       Picture "@!" 
			@ Li,103 Psay QR1->QTDE          Picture "9999.99"
			@ Li,113 Psay QR1->UNID          Picture "@!"
			@ Li,118 Psay QR1->PEDIDO        Picture "XXXXXX"
		EndIf
		QR1->(dbSkip())
	EndDo
/*
nOPs := 0
nOPemDia := 0
nOPAtrasada := 0
SC2->(DbSetOrder(1))
SC2->(DBGOTOP())
Do WHILE !SC2->(EOF())

   IF sc2->c2_mslista # "S"
      SC2->(DBSKIP())
      LOOP
   ENDIF
   IF DTOS(sc2->c2_datrf) >= DTOS(mv_par01) .AND. DTOS(sc2->c2_datrf) <= DTOS(mv_par02)
      nOps++
      IF sc2->c2_datrf - IF(EMPTY(sc2->c2_dataji),sc2->c2_datpri,sc2->c2_dataji) <= 21
         ++nOPemDia
      ELSE
         ++nOPAtrasada
      ENDIF
   ENDIF
   SC2->(DBSKIP())
ENDDO 

Li+=4
@Li,000 Psay "         Listas de Separacao no periodo: "
@Li,041 Psay nOPs  Picture "@E 999,999"
@Li,050 Psay "Montagem/Eletrica"
Li+=2
@Li,000 Psay "           Em dia (21 dias em montagem): "
@Li,041 Psay nOPemDia Picture "@E 999,999"
@li,050 PSay "Listas em dia: " + STR(nOPemDia/nOPs*100,6,2) + "%"
Li+=2
@Li,000 Psay "Atrasadas (mais de 21 dias em montagem): "
@Li,041 Psay nOPAtrasada Picture "@E 999,999"
*/

Li += 2
@Li,000 PSAY __PrtFatLine()
Set Device To Screen
If aReturn[5] == 1
   Set Printer To
   dbCommitAll()
   OurSpool(wnrel)
EndIf

QR1->(dbCloseArea())

MS_FLUSH()

RETURN NIL