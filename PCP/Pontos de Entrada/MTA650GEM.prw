#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} MTA650GEM
    Ponto de entrada para manipular geração de Ops Intermediarias
    @type  Function
    @author Fernando Corrêa (DS2U)
    @since 08/04/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/

User Function MTA650GEM(cTipo)
    
    
    Local aProdI    := {}
    Local nQtdPai   := 0
    Local nPosProd  := 0
    Local nx        := 0
    Local lFim      := .T.
    Local lGera     := .F.

    Private cSeq    := ''
    Default cTipo     := PARAMIXB[1]

    IF SUBSTR(cNumEmp,1,2) == "01" //Masipack
        Do Case 

        //Quando cTipo == '1'
        //É possível varrer a estrutura da OP principal para selecionar
        //quais Produtos deverão ser geradas as OPs intermediárias.
        //Poderá ser criada uma tela para selecionar esses produtos
        //Esses produtos poderão ser armazenados em uma tabela específica ou em um array, contendo os campos necessários.
        //O recomendável é que seja criada uma tabela específica

        //Neste exemplo passarei fixo para o array aArrayProd quais produtos intermediários
        //serão e não geradas as OPS.

        //Também estarei alimentando o array aArrayOps com as ordens que terão esse tratamento especial
        //Para que as demais OPs sejam criadas normalmente

        Case cTipo == '1'
            If !(AtIsRotina("XGERAOP"))
                If RecLock( "ZZZ", .T. )
                
                    ZZZ->ZZZ_FILIAL  := xFilial("ZZZ")
                    ZZZ->ZZZ_NUM     := PARAMIXB[3]
                    ZZZ->ZZZ_ITEM    := PARAMIXB[4]
                    ZZZ->ZZZ_SEQUEN  := PARAMIXB[5]
                    ZZZ->ZZZ_FLAG    := '3' //Não processada
                    ZZZ->(MsUnlock())

                EndIf 
            EndIf
            Return Nil

            //Quando cTipo == '2'
            //Retornará se a Ordem terá o tratamento especial ou não.
            //Se retornar .T é porque NÃO terá um tratamento especial e serão processadas normalmente,
            //Gerando todas OPs intermediárias automaticamente.

            //Se retornar .F. é porque possui um tratamento especial e as ordens não serão geradas neste momento.

        Case cTipo == '2'
            //Chamada via fun��o padr�o que gera OP atrav�s do pedido de venda s� passa por esse ponto, 
            //por isso deve gerar a ZZZ aqui.
            If FWIsInCallStack('A650GeraOp')
                Return .T.
            EndIf 

            Return .F. //Sempre bloqueio a criação da ordem de produção para criar tudo ao final com os dados da tabela ZZZ.

        //Quando cTipo == '3'
        //No final do processamento dos empenhos será chamado essa Opção 3 para criar as OPs intermediárias.
        //Através de um EXECAUTO
        Case cTipo == '3'

            DbSelectArea("ZZZ")
            ZZZ->(DbSetOrder(2))
            ZZZ->(MsSeek(xFilial("ZZZ")+'3'))

            DbSelectArea("SC2")
            SC2->(DbSetOrder(1))
            SC2->(DbGoTop())
                
            DbSelectArea("SG1")
            SG1->(DbSetOrder(1))
            SG1->(DbGoTop())

            DbSelectArea("SB1")
            SB1->(DbSetOrder(1))
            SB1->(DbGoTop())

            While ZZZ->(!Eof()) .and. ZZZ->ZZZ_FILIAL == xFilial("ZZZ") .and. ZZZ->ZZZ_FLAG = '3'
                If SC2->(MsSeek(xFilial("SC2")+ZZZ->ZZZ_NUM+ZZZ->ZZZ_ITEM+ZZZ->ZZZ_SEQUEN))
                    cSeq := SC2->C2_SEQUEN
                    nQtdPai := SC2->C2_QUANT
                    RECUR2(SC2->C2_NUM,SC2->C2_ITEM,SC2->C2_PRODUTO, SC2->C2_QUANT, SC2->C2_REVISAO,SC2->C2_SEQUEN,;
                           @aProdI,1,SC2->C2_DATPRI,SC2->C2_DATPRF,SC2->C2_EMISSAO,SC2->C2_MSREDUZ,SC2->C2_MSPED)
                    If Len(aProdI) > 0
                        lFim := .F.
                    EndIf 
                Else 
                    lFim := .T.
                EndIf
                While !lFim
                    nPosProd := aScan(aProdI,{ |x| Upper(AllTrim(x[7])) == "N"})
                    If nPosProd > 0
                        //RECUR2(cOp,cItem,cProd, nQuant, cRev,cSeq,cSeqPai,aProdI,nOpc)
                        RECUR2(aProdI[nPosProd][1]/*1 - OP*/,aProdI[nPosProd][2]/*2 - ITEM*/,aProdI[nPosProd][4]/*3 - PRODUTO*/,;
                               aProdI[nPosProd][6] /*4 - QTD*/,SC2->C2_REVISAO /*5 - REV*/,aProdI[nPosProd][8] /* 7 - SEQPAI*/,;
                               @aProdI/*8 - ARRAY*/,2 /*9 - NOPC*/,SC2->C2_DATPRI,SC2->C2_DATPRF,SC2->C2_EMISSAO,SC2->C2_MSREDUZ,SC2->C2_MSPED)
                        aProdI[nPosProd][7] := "S"
                    Else 
                        lFim := .T.
                    EndIf 
                    nPosProd := 0
                EndDo 
                If RecLock("ZZZ",.F.)
                    ZZZ->ZZZ_FLAG := '1'
                    ZZZ->(MsUnLock())
                EndIf 
                If Len(aProdI) > 0
                    For nx := 1 to Len(aProdI)
                        xGeraOp(aProdI[nx])
                    Next nx
                EndIf 
                nPosProd := 0
                aProdI   := {}
                ZZZ->(DbSkip())
            EndDo

            ZZZ->(dbCloseArea())

            Return Nil
                
        End Case
    
    EndIf 

Return 

/*/{Protheus.doc} RECUR2
    Função recursiva para varrer a estrutura do produto
    @type  Static
    @author DS2U (FC)
    @since 24/05/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
        

Static Function RECUR2(cOp,cItem,cProd, nQuant, cRev,cSeqPai,aProdI,nOpc,dC2_DATPRI,dC2_DATPRF,dC2_EMISSAO,cC2_MSREDUZ,cC2_MSPED)

Local clSQL     := " "
Local nQtdProd  := 0
Local cAlias    := GetNextAlias()


clSQL := " SELECT G1_COD, G1_COMP AS G1_COMP, G1_QUANT AS G1_QUANT, G1_REVINI AS REVISAO, G1_REVFIM "
clSQL += " FROM "
clSQL += "		" + retSQLName("SG1") + " SG1 "
clSQL += " WHERE  G1_COD =  "
clSQL += "'" + cProd + "'"	
clSQL += "	AND SG1.G1_FILIAL = '" + xFilial("SG1") + "' "
If nOpc == 1
    clSQL += "	AND SG1.G1_REVINI <= '"  + cRev  + "' "
    clSQL += "	AND SG1.G1_REVFIM >= '"  + cRev  + "' "
EndIf 
clSQL += " AND SG1.D_E_L_E_T_ = '' "

	
//--Cria uma tabela temporária com as informações da query				
dbUseArea(.T.,"TOPCONN",TcGenQry(,,clSQL),(cAlias),.F.,.T.)

(cAlias)->(DbGotop())
DbSelectArea("SG1")
SG1->(DbSetOrder(1))
While (cAlias)->(!EOF())
	If !Empty((cAlias)->G1_COD)
        //Valido se o produto tem estrutura para que seja gerada a ordem intermediária dele.
        If SG1->(MsSeek(xFilial("SG1")+(cAlias)->G1_COMP))
    		nQtdProd := valprod((cAlias)->G1_COD,(cAlias)->G1_COMP,nQuant,(cAlias)->G1_QUANT)
            If nQtdProd > 0
                cSeq := Soma1(cSeq)
                AADD(aProdI,{cOp,cItem,(cAlias)->G1_COD,(cAlias)->G1_COMP,(cAlias)->REVISAO,nQtdProd,"N",cSeq,cSeqPai,dC2_DATPRI,dC2_DATPRF,dC2_EMISSAO,cC2_MSREDUZ,cC2_MSPED})
            EndIf 
        EndIf 
	EndIf
	(cAlias)->(DbSkip())
EndDo

(cAlias)->(DbCloseArea())	

Return 


/*/{Protheus.doc} valprod
    Função para validar quantidade que deve ser produzida
    @type  StaticlRet    
    @author DS2U (FC)
    @since 24/05/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/

Static Function valprod(cCodPai, cCodComp,nQtdPai,nQtdFilho)

    Local nQtdComp  := 0
    Local nQtdProd  := 0
    Local nSaldoB2  := 0
    Local cUMPai    := ""
    Local lContinua := .T.
    

        cUMPai := Posicione("SB1",1,xFilial("SB1")+cCodPai,"B1_UM")
        If SB1->(MsSeek(xFilial("SB1") + cCodComp))
            If Alltrim(SB1->B1_UM) == "CJ" .and. Alltrim(cUMPai) == "CJ"
                lContinua := .T.
            ElseIf Alltrim(SB1->B1_UM) == "CJ" .and. Alltrim(cUMPai) != "CJ" //Elton pediu para retirar o CJ até que o calculo de MRP seja desenvolvido.
                lContinua := .F.
            ElseIf Alltrim(cUMPai) == "CJ" .and. Alltrim(SB1->B1_UM) != "CJ"
                lContinua := .F.
            EndIf    

            If lContinua
                nQtdComp := nQtdPai * nQtdFilho
                //Conforme solicitado no e-mail do Elton em 18/07/2023, o conjunto não deve entrar na regra do MRP, gerando sempre
                //a quantidade total da estrutura, pois para esses produtos não é feito controle correto de estoque
                If Alltrim(SB1->B1_UM) == "CJ"
                    nQtdProd := nQtdComp
                Else 
                    //Encontro saldo disponivel do componente.
                    nSaldoB2 := MostrarSaldo(cCodComp)
                    //Encontro posição da quantidade no Acols.
                    If nSaldoB2 <= 0
                        nQtdProd := nQtdComp
                    Else 
                        If nSaldoB2 - nQtdComp >= 0
                            nQtdProd := 0
                        Else 
                            nQtdProd := (nSaldoB2 - nQtdComp) *-1
                        EndIf 
                    EndIf 
                EndIf 

            EndIf 

        EndIf
     
Return nQtdProd

/*/{Protheus.doc} geraop
    Função responsável pela geração das OPs Intermediarias
    @type  Static Function
    @author DS2U (FC)
    @since 25/04/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/

Static Function xgeraop(aProdI)

    Local aVetor := {}
    PRIVATE lMsErroAuto := .f.

    lMsErroAuto := .F.

     //AADD(aProdI,{cOp/*1*/,cItem/*2*/,cAlias->G1_COD/*3*/,cAlias->G1_COMP/*4*/,cAlias->REVISAO/*5*/,nQtdProd/*6*/,"N"/*7*/,cSeq/*8*/,cSeqPai/*9*/, C2_DATPRI /*10*/,C2_DATPRF/*11*/,C2_EMISSAO/*12*/,C2_MSREDUZ/*13*/,cC2_MSPED/*14*/})
    
    aVetor := {{"C2_NUM",     aProdI[1]                                              , NIL},;
               {"C2_ITEM",    aProdI[2]                                              , NIL},;
               {"C2_SEQUEN",  aProdI[8]                                              , NIL},;
               {"C2_PRODUTO", aProdI[4]                                              , NIL},;
               {"C2_QUANT",   aProdI[6]                                              , NIL},;
               {"C2_DATPRI",  Iif(aProdI[10]  < date(), date(), aProdI[10] )         , NIL},;
               {"C2_DATPRF",  Iif(aProdI[11]  < date(), date(), aProdI[11] )         , NIL},;
               {"C2_EMISSAO", Iif(aProdI[12]  < date(), date(), aProdI[12])          , NIL},;
               {"C2_MSREDUZ", aProdI[13]                                             , NIL},;
               {"C2_MSPED",   aProdI[14]                                             , NIL},;
               {"C2_TPOP", "F"                                                       , NIL},;
               {"C2_SEQPAI",  aProdI[9]                                              , NIL},;
               {"AUTEXPLODE", "S"                                                    , NIL}}

            msExecAuto({|x,y| MATA650(x,y)},aVetor,3)

            If lMsErroAuto
                Mostraerro()
            else
                CONOUT ("Inclusão OK")
            Endif
    
Return 

/*/{Protheus.doc} MostrarSaldo
	Função para retornar saldo do produto SB2
	@type  Static Function
	@author Fernando Corrêa (DS2U)
	@since 09/04/2023\
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/

Static Function MostrarSaldo(cProduto)

	Local nSaldo := 0 //Saldo em Estoque
	Local aArea := GetArea() //Area
	Local aAreaSB2 := SB2->(GetArea())
	Local nSaldoAtu := 0

	
	SB2->( dbSetOrder(1) )
	SB2->( dbSeek(xFilial("SB2") + cProduto ) )

	While !SB2->( Eof() ) .And. SB2->B2_FILIAL + SB2->B2_COD == xFilial("SB2") + cProduto

		nSaldoAtu := SaldoSB2() + SB2->B2_SALPEDI
		nSaldo += nSaldoAtu
		
		SB2->( dbSkip() )
	EndDO

	IF nSaldo < 0
		nSaldo := 0
	EndIf

	RestArea(aAreaSB2)
	RestArea(aArea)

Return nSaldo
