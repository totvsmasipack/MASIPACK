#Include "Rwmake.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} RFATC001
//TODO Descrição auto-gerada.
@author Lizandra Marques
@since 16/12/2013
@version 1.0
@return NIL
@type function
/*/
User Function RFATC001()

Local nP

Local oTable  := Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cPerg			:= "XRFATC001"
Private aCampos		:= {}        
Private aHeadMBrow	:= {}
Private _aPonV		:= {}
Private _nPerc		:= 0

aRotina   := {{"Visualizar","AxVisual"  ,0,1}}        // Visualiza

IF ! Pergunte(cPerg,.T.)
 	Return
ENDIF

cNome := UPPER(Alltrim(MV_PAR01))
_nPerc := AT("%",cNome)
_aPonV := StrToKArr2(cNome,";",.T.)

If Select("TRB") > 0 
   DbSelectArea("TRB")
   DbCloseArea()
EndIf

IF MV_PAR02 == 1 .OR. MV_PAR02 == 2 
	AADD(aCampos,{ "A1_COD"    ,"C", 06,0,"@!" } )
	AADD(aCampos,{ "A1_LOJA"   ,"C", 02,0,"@!" } )	
	AADD(aCampos,{ "A1_NOME"   ,"C", 45,0,"@!" } )
	AADD(aCampos,{ "A1_NREDUZ" ,"C", 20,0,"@!" } )
	AADD(aCampos,{ "A1_TEL"    ,"C", 15,0,"@!" } )
ELSEIF MV_PAR02 == 3 .OR. MV_PAR02 == 5 
	AADD(aCampos,{ "B1_COD"    ,"C", 15,0,"@!" } )
	AADD(aCampos,{ "B1_REVATU" ,"C", 03,0,"@!" } )	
	AADD(aCampos,{ "B1_DESC"   ,"C", 35,0,"@!" } )
	AADD(aCampos,{ "B5_CEME"   ,"C",200,0,"@!" } )	//AADD(aCampos,{ "B1_DESCP"  ,"C",105,0,"@!" } )
	AADD(aCampos,{ "B1_UM"     ,"C", 02,0,"@!" } )
	AADD(aCampos,{ "B1_PROCED" ,"C", 02,0,"@!" } )
	AADD(aCampos,{ "B1_LOCAL"  ,"C", 08,0,"@!" } )
	AADD(aCampos,{ "B2_QATU"   ,"N", 12,2,"@E 999,999,999.99"})
	AADD(aCampos,{ "SC"		   ,"N", 12,2,"@E 999,999,999.99"  } )
	AADD(aCampos,{ "PC"		   ,"N", 12,2,"@E 999,999,999.99"  } )
	AADD(aCampos,{ "OP"		   ,"N", 12,2,"@E 999,999,999.99"  } )
	AADD(aCampos,{ "DEV"	   ,"N", 12,2,"@E 999,999,999.99"  } )
	AADD(aCampos,{ "EMP"	   ,"N", 12,2,"@E 999,999,999.99"  } )
	AADD(aCampos,{ "PV"		   ,"N", 12,2,"@E 999,999,999.99"  } )
	AADD(aCampos,{ "REQ"	   ,"N", 12,2,"@E 999,999,999.99"  } )
ELSE
	AADD(aCampos,{ "ZG_COD"    ,"C", 15,0,"@!" } )
	AADD(aCampos,{ "ZG_DESCP"  ,"C", 35,0,"@!" } )	
	AADD(aCampos,{ "ZG_DESCE"  ,"C", 50,0,"@!" } )
	AADD(aCampos,{ "ZG_DESCI"  ,"C", 50,0,"@!" } )
ENDIF

oTable := FWTemporaryTable():New("TRB",aCampos)
oTable:Create()

IF Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
ENDIF

IF MV_PAR02 == 1
	cCadastro := "Cadastro de Clientes"
	_cQuery := " SELECT A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ, A1_TEL "
	_cQuery += " FROM " + RetSqlName("SA1") + " A1 "
	_cQuery += " WHERE A1_FILIAL = '" + xFilial("SA1") + "' AND A1.D_E_L_E_T_ = ' ' "
	_cQuery += "       AND A1_NOME LIKE "+IIF(_nPerc==0,"('%" + cNome + "%')","('" + cNome + "')")+" "
	_cQuery += " ORDER BY A1_NOME "

	TcQuery _cQuery New Alias "QR1"

	DO WHILE !QR1->(EOF())
		RecLock("TRB",.T.)
		TRB->A1_COD		:= QR1->A1_COD
		TRB->A1_LOJA	:= QR1->A1_LOJA
		TRB->A1_NOME	:= QR1->A1_NOME
		TRB->A1_NREDUZ	:= QR1->A1_NREDUZ
		TRB->A1_TEL		:= QR1->A1_TEL
		TRB->(MSUnlock())
	
		QR1->(dbSKIP())
	ENDDO
ELSEIF MV_PAR02 == 2
	cCadastro := "Cadastro de Fornecedores"
	_cQuery := " SELECT A2_COD, A2_LOJA, A2_NOME, A2_NREDUZ, A2_TEL "
	_cQuery += " FROM " + RetSqlName("SA2") + " A2 "
	_cQuery += " WHERE A2_FILIAL = '" + xFilial("SA2") + "' AND A2.D_E_L_E_T_ = ' ' "
	_cQuery += "       AND A2_NOME LIKE "+IIF(_nPerc==0,"('%" + cNome + "%')","('" + cNome + "')")+" "
	_cQuery += " ORDER BY A2_NOME "

	TcQuery _cQuery New Alias "QR1"

	DO WHILE !QR1->(EOF())
		RecLock("TRB",.T.)
		TRB->A1_COD		:= QR1->A2_COD
		TRB->A1_LOJA	:= QR1->A2_LOJA
		TRB->A1_NOME	:= QR1->A2_NOME
		TRB->A1_NREDUZ	:= QR1->A2_NREDUZ
		TRB->A1_TEL		:= QR1->A2_TEL
		TRB->(MSUnlock())
	
		QR1->(dbSKIP())
    
	ENDDO
ELSEIF MV_PAR02 == 4                              
	cCadastro := "Descritivo de Maquinas"
	_cQuery := " SELECT ZG_CODIGO, ZG_MSDESC, ZG_DESCRE, ZG_DESCRI "
	_cQuery += " FROM " + RetSqlName("SZG") + " ZG "
	_cQuery += " WHERE ZG_FILIAL = '" + xFilial("SZG") + "' AND ZG.D_E_L_E_T_ = ' ' " 
	_cQuery += "       AND ZG_MSDESC LIKE "+IIF(_nPerc==0,"('%" + cNome + "%')","('" + cNome + "')")+"  "
	_cQuery += " ORDER BY ZG_MSDESC "

	TcQuery _cQuery New Alias "QR1"

	DO WHILE !QR1->(EOF())
		RecLock("TRB",.T.)
		TRB->ZG_COD		:= QR1->ZG_CODIGO
		TRB->ZG_DESCP	:= QR1->ZG_MSDESC
		TRB->ZG_DESCE	:= QR1->ZG_DESCRE
		TRB->ZG_DESCI	:= QR1->ZG_DESCRI
		TRB->(MSUnlock())
	
		QR1->(dbSKIP())
    
	ENDDO
ELSEIF MV_PAR02 == 3 .OR. MV_PAR02 == 5
	cCadastro := "Cadastro de Produtos - Nome Científico"                                             
	_cQuery := " SELECT B1_COD, B1_REVATU, B1_DESC, ISNULL(B5_CEME,'') 'B5_CEME', B1_UM, B1_PROCED, ISNULL(B2_QATU,0) 'B2_QATU',B1_LOCAL, "
		/*SOMA DAS SCS*/
	_cQuery += "(SELECT ISNULL(SUM(C1_QUANT-C1_QUJE-C1_QUJE2),0)"
	_cQuery += "FROM "+RetSQLName("SC1")+" with (nolock) " 
	_cQuery += "WHERE C1_FILIAL = '"+xFilial("SC1")+"' AND" 
	_cQuery += "	D_E_L_E_T_ = '' AND" 
	_cQuery += " C1_QUANT-C1_QUJE-C1_QUJE2 > 0 AND " 
	_cQuery += " C1_PRODUTO = B1.B1_COD AND" 
	_cQuery += " C1_PEDIDO = '' AND" 
	_cQuery += " C1_EMISSAO BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' AND" 
	_cQuery += " C1_RESIDUO = '' AND" 
	_cQuery += " (C1_OBS NOT LIKE ('%SNF%') OR C1_OBS NOT LIKE ('%VALE%')) AND"  
	_cQuery += " C1_MSAPROP NOT LIKE ('%COTA%')) AS 'SOMA_SC', " 
	//*SOMA DOS PCS*/
	_cQuery += " (" 
	_cQuery += "  SELECT ISNULL(SUM(C7.C7_QUANT-C7.C7_QUJE),0)" 
	_cQuery += " FROM "+RetSQLName("SC7")+" C7 with (nolock) " 
	_cQuery += " WHERE C7.C7_PRODUTO = B1.B1_COD AND "  
	_cQuery += " 	C7.D_E_L_E_T_ = '' AND " 
	_cQuery += " 	C7_RESIDUO = '' AND " 
	_cQuery += " 	C7.C7_FILIAL = '"+xFilial("SC7")+"' AND " 
	_cQuery += " 	C7.D_E_L_E_T_ = '' AND " 
	_cQuery += " 	C7_QUANT-C7_QUJE > 0 AND " 
	_cQuery += " 	C7_MSNF = '' AND " 
	_cQuery += " 	C7_DATPRF BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' AND " 
	_cQuery += " 	(C7_OBS NOT LIKE ('%SNF%') OR C7_OBS NOT LIKE ('%VALE%'))) AS 'SOMA_PC', "
	/*SOMA DAS OPS*/
	_cQuery += " ( " 
	_cQuery += " SELECT ISNULL(SUM(C2.C2_QUANT-C2.C2_QUJE-C2_PERDA),0) " 
	_cQuery += " FROM "+RetSQLName("SC2")+" C2 with (nolock) " 
	_cQuery += " WHERE "  
	_cQuery += " 	C2.D_E_L_E_T_ = '' AND "  
	_cQuery += " 	C2.C2_FILIAL = '"+xFilial("SC2")+"' AND " 
	_cQuery += " 	(C2_QUANT-C2_QUJE-C2_PERDA) > 0 AND " 
	_cQuery += " 	C2_DATRF = '' AND  " 
	_cQuery += " 	C2_DATPRI BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' AND " 
	_cQuery += " 	C2_PRODUTO = B1.B1_COD) AS 'SOMA_OP', "
	/*SOMA DAS DEVOLUÇÕES ARMAZEM*/
	_cQuery += " ( " 
	_cQuery += " SELECT ISNULL(SUM(ZP.ZP_QUANT-ZP.ZP_QUJE),0) " 
	_cQuery += " FROM "+RetSQLName("SZP")+" ZP with (nolock) " 
	_cQuery += " WHERE  " 
	_cQuery += " 	ZP.ZP_PRODUTO = B1.B1_COD AND " 
	_cQuery += " 	ZP.D_E_L_E_T_ = '' AND  " 
	_cQuery += " 	ZP.ZP_FILIAL = '"+xFilial("SZP")+"' AND " 
	_cQuery += " 	(ZP_QUANT-ZP_QUJE) > 0) AS 'SOMA_DEV', "
	/*SOMA DOS EMPENHOS*/
	_cQuery += " ( " 
	_cQuery += " SELECT ISNULL(SUM(D4_QUANT),0) " 
	_cQuery += " FROM "+RetSQLName("SD4")+" with (nolock) " 
	_cQuery += " WHERE D4_QUANT > 0 AND " 
	_cQuery += " 	D4_FILIAL = '"+xFilial("SD4")+"' AND " 
	_cQuery += " 	D_E_L_E_T_ = '' AND " 
	_cQuery += "	D4_DATA BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' AND" 
	_cQuery += " 	D4_COD = B1.B1_COD) AS 'SOMA_EMP', "     
	/*SOMA DOS PVS*/
	_cQuery += " (SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT-C6_QTDENT2),0) " 
	_cQuery += " FROM "+RetSQLName("SC6")+" C6 with (nolock) " 
	_cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 with (nolock) ON C5_NUM = C6_NUM AND "  
	_cQuery += " 	C5.D_E_L_E_T_ = '' AND "  
	_cQuery += " 	C5.C5_FILIAL = '"+xFilial("SC5")+"' " 
	_cQuery += " WHERE C6_BLQ = '' AND  " 
	_cQuery += " 	C6_NOTA = '' AND  " 
	_cQuery += " 	C6_QTDVEN-C6_QTDENT-C6_QTDENT2>0 AND " 
	_cQuery += " 	C6.C6_PRODUTO = B1.B1_COD AND  " 
	_cQuery += " 	(C6.C6_MSPCP = '' OR C6.C6_MSPCP <> '20491231') AND " 
	_cQuery += " 	C6.D_E_L_E_T_ = '' AND  " 
	_cQuery += " 	(C5_MSDTPEN BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' OR " 	
	_cQuery += " 	C5_MSDTENT BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"') AND " 	
	_cQuery += " 	C6.C6_FILIAL = '"+xFilial("SC6")+"' AND " 
	_cQuery += " 	(C5.C5_NOTA <> 'XXXXXX' OR C5_NOTA = '') "
	_cQuery += " 	) AS 'SOMA_PV', "
	/*SOMA DAS REQUISIÇÕES AO ARMAZEM*/
	_cQuery += " (SELECT ISNULL(SUM(CP_QUANT-CP_QUJE),0) " 
	_cQuery += " FROM "+RetSQLName("SCP")+" CP with (nolock) " 
	_cQuery += " WHERE CP_STATUS = '' AND "  
	_cQuery += " 	CP.D_E_L_E_T_ = '' AND "  
	_cQuery += " 	CP.CP_FILIAL = '"+xFilial("SCP")+"' AND " 
	_cQuery += " 	CP_EMISSAO BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' AND " 
	_cQuery += " 	CP_PRODUTO = B1.B1_COD AND " 
	_cQuery += " 	CP_QUANT-CP_QUJE > 0 " 
	_cQuery += " ) AS 'SOMA_RE' "
	_cQuery += " FROM " + RetSqlName("SB1") + " B1 "
	_cQuery += " LEFT JOIN " + RetSQLName("SB2") + " B2 ON B2_COD = B1_COD AND B2.D_E_L_E_T_ = ' ' AND B2.B2_FILIAL = '" +xFilial("SB2")+ "' "
	_cQuery += " AND B2_LOCAL = B1_LOCPAD "                   
	_cQuery += " LEFT JOIN " + RetSQLName("SB5") + " B5 ON B5_COD = B1_COD AND B5.D_E_L_E_T_ = ' ' "
	_cQuery += " WHERE B1_FILIAL = '" + xFilial("SB1") + "' AND B1.D_E_L_E_T_ = ' ' " 
	If MV_PAR02 == 3
		_cQuery += " 	   AND B1_DESC LIKE "
	Else 
		_cQuery += "       AND B5_CEME LIKE "
	Endif
	For nP := 1 to Len(_aPonV)
		_nPerc := AT("%",_aPonV[nP])
		If _nPerc == 0
			_aPonV[nP] = "%"+_aPonV[nP]+"%"
		Endif
		 If nP == 1
			_cQuery += "('" + _aPonV[nP] + "')"
		 Else
		 	_cQuery += IIF(MV_PAR02==3,"AND B1_DESC LIKE ('" + _aPonV[nP] + "')","AND B5_CEME LIKE ('" + _aPonV[nP] + "')")
		 Endif
	Next
	_cQuery += " 	   AND B1_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	_cQuery += " ORDER BY B1_COD "

	TcQuery _cQuery New Alias "QR1"
	
	DO WHILE !QR1->(EOF())
		RecLock("TRB",.T.)
		TRB->B1_COD		:= QR1->B1_COD
		TRB->B1_REVATU	:= QR1->B1_REVATU
		TRB->B1_DESC	:= QR1->B1_DESC
		TRB->B5_CEME	:= QR1->B5_CEME		//TRB->B1_DESCP	:= QR1->B1_DESCP                           
		TRB->B1_UM		:= QR1->B1_UM
		TRB->B1_PROCED	:= QR1->B1_PROCED
		TRB->B1_LOCAL 	:= QR1->B1_LOCAL
		TRB->B2_QATU	:= QR1->B2_QATU
		TRB->SC			:= QR1->SOMA_SC
		TRB->PC			:= QR1->SOMA_PC
		TRB->OP			:= QR1->SOMA_OP
		TRB->DEV		:= QR1->SOMA_DEV
		TRB->EMP		:= QR1->SOMA_EMP
		TRB->PV			:= QR1->SOMA_PV
		TRB->REQ		:= QR1->SOMA_RE
		TRB->(MSUnlock())
	
		QR1->(dbSKIP())
    
	ENDDO
ENDIF


QR1->(dbCloseArea())      

MsgRun("Criando coluna para MBrowse...",,{|| aHeadMBrow := HeadBrow() } )


dbSelectArea("TRB")             
TRB->(dbGoTop())

mBrowse(6,1,22,75,"TRB",aHeadMBrow,,,,,,"","")    

//Fecha a área
TRB->(dbCloseArea())

oTable:Delete()

Return            

/*/{Protheus.doc} HeadBrow
//TODO Descrição auto-gerada.
@author ivandro.santos
@since 16/12/13
@version 1.0
@return aHead

@type function
/*/
Static Function HeadBrow()
Local aHead := {}         

//Campos que aparecerão na MBrowse, como não é baseado no SX3 deve ser criado.
//Sequência do vetor: Título, Campo, Tipo, Tamanho, Decimal, Picture

IF MV_PAR02 == 3 .OR. MV_PAR02 == 5
	AAdd( aHead, { "Codigo"        , {|| TRB->B1_COD }   ,"C", 15 , 0, "" } )
	AAdd( aHead, { "Revisao"       , {|| TRB->B1_REVATU },"C", 03 , 0, "" } )
	AAdd( aHead, { "Descrição"     , {|| TRB->B1_DESC }  ,"C", 35 , 0, "" } )
	AAdd( aHead, { "Nome.Cientifico", {|| TRB->B5_CEME }  ,"C", 200, 0, "" } )
	AAdd( aHead, { "UM"            , {|| TRB->B1_UM }    ,"C", 02 , 0, "" } )
	AAdd( aHead, { "Procedencia"   , {|| TRB->B1_PROCED },"C", 02 , 0, "" } )
	AAdd( aHead, { "Local"   	   , {|| TRB->B1_LOCAL  },"C", 05 , 0, "" } )
	AAdd( aHead, { "Estoque"	   , {|| TRB->B2_QATU 	},"N", 05 , 0, "@E 999,999,999.99" } )
	AAdd( aHead, { "Sol.Compra"	   , {|| TRB->SC	    },"N", 05 , 2, "@E 999,999,999.99" } )
	AAdd( aHead, { "Ped.Compra"	   , {|| TRB->PC	    },"N", 05 , 2, "@E 999,999,999.99" } )
	AAdd( aHead, { "O.P."		   , {|| TRB->OP		},"N", 05 , 2, "@E 999,999,999.99" } )
	AAdd( aHead, { "Devolução"	   , {|| TRB->DEV		},"N", 05 , 2, "@E 999,999,999.99" } )
	AAdd( aHead, { "Empenho"	   , {|| TRB->EMP		},"N", 05 , 2, "@E 999,999,999.99" } )
	AAdd( aHead, { "Ped.Venda"	   , {|| TRB->PV		},"N", 05 , 2, "@E 999,999,999.99" } )
	AAdd( aHead, { "Requisição"	   , {|| TRB->REQ		},"N", 05 , 2, "@E 999,999,999.99" } )
ELSEIF MV_PAR02 == 1 .OR. MV_PAR02 == 2
	AAdd( aHead, { "Codigo"        , {|| TRB->A1_COD }   ,"C", 06 , 0, "" } )
	AAdd( aHead, { "Loja"          , {|| TRB->A1_LOJA }  ,"C", 02 , 0, "" } )
	AAdd( aHead, { "Nome"          , {|| TRB->A1_NOME }  ,"C", 45 , 0, "" } )
	AAdd( aHead, { "Nome Fantasia" , {|| TRB->A1_NREDUZ },"C", 20 , 0, "" } )
	AAdd( aHead, { "Telefone"      , {|| TRB->A1_TEL }   ,"C", 15 , 0, "" } )
ELSE                                  
	AAdd( aHead, { "Codigo"        , {|| TRB->ZG_COD }   ,"C", 15 , 0, "" } )
	AAdd( aHead, { "Descrição"     , {|| TRB->ZG_DESCP } ,"C", 35 , 0, "" } )
	AAdd( aHead, { "Desc.Espanhol" , {|| TRB->ZG_DESCE } ,"C", 50 , 0, "" } )
	AAdd( aHead, { "Desc.Ingles"   , {|| TRB->ZG_DESCI } ,"C", 50 , 0, "" } )
ENDIF 	

Return( aHead )
