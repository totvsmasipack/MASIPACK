#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} User Function RCOMA024
	Função para excluir Solicitações de compras geradas pelo MRP
	@type  Function
	@author user
	@since 18/08/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/

User Function RCOMA024()

    Local aCabecalho := {}
	Local aItens     := {}
    Local cQuery     := ""
    Local cAlias     := GetNextAlias() 

    Private lMsErroAuto

    cQuery := " SELECT C1_NUM, C1_ITEM "
    cQuery += "       FROM " + RETSQLNAME("SC1") + " SC1 " 
    cQuery += " WHERE C1_FILIAL = '" + xFilial("SC1") + "' "
    cQuery += "       AND C1_SEQMRP <> '' "
	cQuery += "       AND C1_QUJE = 0 "
    cQuery += "       AND D_E_L_E_T_ = '' "

    //--Cria uma tabela temporária com as informações da query				
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)


    DbSelectArea((cAlias))

    While  .not. (cAlias)->(Eof())
        
        aCabecalho := {}
        aItens     := {}

        //	Montagem de aCabecalho e aItens					
        MsAguarde({|| MontaSC1((cAlias)->C1_NUM, (cAlias)->C1_ITEM, @aCabecalho, @aItens) },"Montando exclusão das SC...","Aguarde...")
        
        If len(aCabecalho) > 0
            MSExecAuto({|X,Y,Z| Mata110(X,Y,Z)}, aCabecalho, aItens, 5)//exclui as SC's selecionadas
            
            If lMsErroAuto
                MostraErro()
                DisarmTransaction()
            EndIf
        EndIf 

        (cAlias)->(DbSkip())

    EndDo 
		
	
Return()

Static Function MontaSC1(cC1_Num, cC1_Item, aCabecalho, aItens)
	
    Local aArea     := GetArea()
	Local aAreaSC1  := SC1->(GetArea())
	Local cDeletar	:= ""
	Local lRetorno  := .t.
	
	dbSelectArea("SC1")
	dbSetOrder(1)
	dbSeek(xFilial("SC1")+cC1_Num)
	
	MsProcTxt("Localizando pedido "+cC1_Num)
	
	If Found()
		aCabecalho	:=	{}
		aCabecalho	:={	{ "C1_FILIAL"	, SC1->C1_FILIAL	, NIL},;
						{ "C1_NUM"		, SC1->C1_NUM		, NIL},;
						{ "C1_SOLICIT"	, SC1->C1_SOLICIT	, NIL},;
						{ "C1_EMISSAO"	, SC1->C1_EMISSAO	, NIL},;
						{ "C1_UNIDREQ"	, "01"	, NIL},;
						{ "C1_CODCOMP"	, "1"	, NIL},;
						{ "C1_FILENT"	, SC1->C1_FILENT	, NIL}}
		
		aItens		:=	{}
		
		MsProcTxt("Montando Pedido "+cC1_Num)
		
		Do While !Eof() .And.	SC1->C1_FILIAL	==	xFilial("SC1") .And.;
								SC1->C1_NUM		==	cC1_Num
								
			cDeletar	:=	If(cC1_Item == SC1->C1_ITEM, "S", "N")
			
			MsProcTxt("Montando Pedido "+cC1_Num+" - Item: "+SC1->C1_ITEM)
			
			aAdd(aItens,{	{ "LINPOS"		, "C1_ITEM"			, SC1->C1_ITEM},;
							{ "C1_PRODUTO"	, SC1->C1_PRODUTO	, NIL},;
							{ "C1_DESCRI"	, SC1->C1_DESCRI	, NIL},;
							{ "C1_UM"		, SC1->C1_UM   		, NIL},;
							{ "C1_SEGUM"	, SC1->C1_SEGUM		, NIL},;
							{ "C1_QUANT"	, SC1->C1_QUANT		, NIL},;
							{ "C1_QTSEGUM"	, SC1->C1_QTSEGUM	, NIL},;
							{ "C1_DATPRF"	, SC1->C1_DATPRF	, NIL},;
							{ "C1_LOCAL"	, SC1->C1_LOCAL		, NIL},;
							{ "C1_OBS"		, SC1->C1_OBS		, NIL},;
							{ "C1_OP"		, SC1->C1_OP		, NIL},;
							{ "C1_CC"		, SC1->C1_CC		, NIL},;
							{ "C1_IMPORT"	, SC1->C1_IMPORT	, NIL},;
							{ "C1_CLASS"	, SC1->C1_CLASS		, NIL},;
							{ "C1_ORIGEM"	, SC1->C1_ORIGEM	, NIL},;
							{ "C1_CLVL"		, SC1->C1_CLVL		, NIL},;
							{ "AUTDELETA"	, cDeletar			, NIL}})	//	Deletar Item?
										
			dbSelectArea("SC1")
			dbSkip()
		EndDo
	EndIf
						
	RestArea(aAreaSC1)
	RestArea(aArea)
	
Return(lRetorno)
