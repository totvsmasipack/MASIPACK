#include 'totvs.ch'
#include 'protheus.ch'


/*/{Protheus.doc} User Function RESTA030
    Função para controle das referências de OP
    @type  Function
    @author Masipack
    @since 13/07/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function RESTA030()

Local aColumn := {}
Local aCoord  := {}
Local aSize   := FWGetDialogSize()
Local bChange := {|| A030ChgOpc(@nRadio) }
Local cNumero := SPACE(TamSX3('C2_NUM')[1]+TamSX3('C2_ITEM')[1]+TamSX3('C2_SEQUEN')[1])
Local cNumRef := SPACE(TamSX3('C2_MSREFER')[1])
Local lChange := .F.
Local nRadio  := 0
Local oArea	  := FWLayer():New()
Local oCol    := Nil
Local oDlg    := Nil
Local oChk    := Nil
Local oGet1   := Nil
Local oGet2   := Nil
Local oPnl1   := Nil
Local oPnl2   := Nil
Local oPnl3   := Nil
Local oRadio  := Nil

Private cRefer  := GetSX8Num('SC2','C2_MSREFER','C2_MSREFER' + cEmpAnt)
Private cAlsTmp := GetNextAlias()
Private oMark   := Nil
Private oTable  := Nil


    oDlg := TDialog():New(aSize[1], aSize[2],aSize[3], aSize[4],"",,,,,,,,,.T.)
    
    oArea:Init(oDlg,.F.)
	oArea:AddLine("L01",094,.T.)

	oArea:AddCollumn("L01BRW",85,.F.,"L01")
    oArea:AddCollumn("L01OPC",15,.F.,"L01")

    oArea:AddWindow("L01BRW","L01BRW","Ordens de Produção Selecionadas",100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
    oArea:AddWindow("L01OPC","L01OPC1","Opções",030,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
    oArea:AddWindow("L01OPC","L01OPC2","Próxima Ref.: " + cRefer,070,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	
    oPnl1 := oArea:GetWinPanel("L01OPC","L01OPC1","L01")
    oPnl2 := oArea:GetWinPanel("L01OPC","L01OPC2","L01")
    oPnl3 := oArea:GetWinPanel("L01BRW","L01BRW" ,"L01")        
    
    aCoord := FWGetDialogSize(oPnl1)
    oRadio := TRadMenu():New(aCoord[2], aCoord[2]+5,{'Nova','Trocar','Excluir','Imprimir'},,oPnl1,,bChange,,,,,,100,12,,,,.T.,.F.)
    oRadio:bSetGet := { |u| Iif(PCount()==0, nRadio, nRadio := u) }
    
    aCoord := FWGetDialogSize(oPnl2)
    oGet1 := TGet():New(aCoord[1]+01,aCoord[2]+01,{|u| If(PCount()>0,cNumero:=u,cNumero)},oPnl2,070,010,'@!',,,,,,,.T.,,,,,,{|| A030GetOP(@oGet1,@cNumero,nRadio,@oRadio) },.F.,,,'cNumero',,,,.T.,.F.,,'Número OP',1,,,,.T.)
    oGet1:cF3 := 'SC2_1'

    oChk := TCheckBox():New(aCoord[1]+35,aCoord[2]+01,'Utiliza referêcia abaixo?',{|u| IIF( PCount() > 0, lChange := u , lChange ) },oPnl2,70,10,,{|| .T. },,,,,,.T.)
    oGet2 := TGet():New(aCoord[1]+45,aCoord[2]+01,{|u| If(PCount()>0,cNumRef:=u,cNumRef)},oPnl2,050,010,'@!',,,,,,,.T.,,,,,,{|| /*A030GetOP(@oGet1,@cNumRef,nRadio,@oRadio)*/ },,,,'cNumRef',,,,.T.,.F.,,'Referência p/ Troca',1,,,,.T.)

    AADD(aColumn,{"C2_OK"       ,'C'                    ,2                      ,0                      })
    AADD(aColumn,{"C2_NUM"      ,TamSX3('C2_NUM')[3]    ,TamSX3('C2_NUM')[1]    ,TamSX3('C2_NUM')[2]    })
    AADD(aColumn,{"C2_ITEM"     ,TamSX3('C2_ITEM')[3]   ,TamSX3('C2_ITEM')[1]   ,TamSX3('C2_ITEM')[2]   })
    AADD(aColumn,{"C2_SEQUEN"   ,TamSX3('C2_SEQUEN')[3] ,TamSX3('C2_SEQUEN')[1] ,TamSX3('C2_SEQUEN')[2] })
    AADD(aColumn,{"C2_MSREFER"  ,TamSX3('C2_MSREFER')[3],TamSX3('C2_MSREFER')[1],TamSX3('C2_MSREFER')[2]})
    AADD(aColumn,{"C2_PRODUTO"  ,TamSX3('C2_PRODUTO')[3],TamSX3('C2_PRODUTO')[1],TamSX3('C2_PRODUTO')[2]})
    AADD(aColumn,{"B1_DESC"     ,TamSX3('B1_DESC')[3]   ,TamSX3('B1_DESC')[1]   ,TamSX3('B1_DESC')[2]   })
    AADD(aColumn,{"B1_GRUPO"    ,TamSX3('B1_GRUPO')[3]  ,TamSX3('B1_GRUPO')[1]  ,TamSX3('B1_GRUPO')[2]  })
    AADD(aColumn,{"BM_DESC"     ,TamSX3('B1_DESC')[3]   ,TamSX3('B1_DESC')[1]   ,TamSX3('B1_DESC')[2]   })
    
    oTable := FWTemporaryTable():New( cAlsTmp )
    oTable:SetFields( aColumn )
    oTable:Create()

    aColumn := {}

    oCol := FWBrwColumn():New()
	oCol:SetTitle('Número')
	oCol:SetData({|| C2_NUM })
    oCol:SetType( TamSX3('C2_NUM')[3] )
	oCol:SetSize(TamSX3('C2_NUM')[1])
    oCol:SetDecimal(TamSX3('C2_NUM')[2])
	aAdd(aColumn, oCol)

    oCol := FWBrwColumn():New()
	oCol:SetTitle('Item')
	oCol:SetData({|| C2_ITEM })
	oCol:SetType( TamSX3('C2_ITEM')[3] )
	oCol:SetSize(TamSX3('C2_ITEM')[1])
    oCol:SetDecimal(TamSX3('C2_ITEM')[2])
	aAdd(aColumn, oCol)

    oCol := FWBrwColumn():New()
	oCol:SetTitle('Sequencia')
	oCol:SetData({|| C2_SEQUEN })
	oCol:SetType( TamSX3('C2_SEQUEN')[3] )
	oCol:SetSize(TamSX3('C2_SEQUEN')[1])
    oCol:SetDecimal(TamSX3('C2_SEQUEN')[2])
	aAdd(aColumn, oCol)

    oCol := FWBrwColumn():New()
	oCol:SetTitle('Nº Referencia')
	oCol:SetData({|| C2_MSREFER })
	oCol:SetType( TamSX3('C2_MSREFER')[3] )
	oCol:SetSize(TamSX3('C2_MSREFER')[1])
    oCol:SetDecimal(TamSX3('C2_MSREFER')[2])
	aAdd(aColumn, oCol)
    
    oCol := FWBrwColumn():New()
	oCol:SetTitle('Cód. Produto')
	oCol:SetData({|| C2_PRODUTO })
	oCol:SetType( TamSX3('C2_PRODUTO')[3] )
	oCol:SetSize(TamSX3('C2_PRODUTO')[1])
    oCol:SetDecimal(TamSX3('C2_PRODUTO')[2])
	aAdd(aColumn, oCol)

    oCol := FWBrwColumn():New()
	oCol:SetTitle('Descrição')
	oCol:SetData({|| B1_DESC })
	oCol:SetType( TamSX3('B1_DESC')[3] )
	oCol:SetSize(TamSX3('B1_DESC')[1])
    oCol:SetDecimal(TamSX3('B1_DESC')[2])
	aAdd(aColumn, oCol)

    oCol := FWBrwColumn():New()
	oCol:SetTitle('Grupo')
	oCol:SetData({|| B1_GRUPO })
	oCol:SetType( TamSX3('B1_GRUPO')[3] )
	oCol:SetSize(TamSX3('B1_GRUPO')[1])
    oCol:SetDecimal(TamSX3('B1_GRUPO')[2])
	aAdd(aColumn, oCol)

    oCol := FWBrwColumn():New()
	oCol:SetTitle('Nome Grupo')
	oCol:SetData({|| BM_DESC })
	oCol:SetType( TamSX3('BM_DESC')[3] )
	oCol:SetSize(TamSX3('BM_DESC')[1])
    oCol:SetDecimal(TamSX3('BM_DESC')[2])
	aAdd(aColumn, oCol)

    oMark := FWMarkBrowse():New()
    oMark:SetOwner(oPnl3)
    oMark:SetAlias(oTable:GetAlias())
    oMark:SetTemporary(.T.)
    oMark:SetIgnoreARotina(.T.)
    oMark:SetMenuDef("") 
    oMark:SetColumns(aColumn)
    oMark:SetFieldMark('C2_OK')
    oMark:SetCustomMarkRec( {|| RecLock(oMark:Alias(),.F.), (oMark:Alias())->C2_OK := IIF(!oMark:IsMark(),oMark:Mark(),''), (oMark:Alias())->(MsUnLock()) } )
    oMark:DisableFilter()
    oMark:DisableReport()
    oMark:Activate()

    ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| If( A030TOK(nRadio,cNumRef), ( UPDSC2(nRadio,cNumRef), oDlg:End() ), Nil )},{|| oDlg:End(), RollBackSX8() }) CENTERED 

Return

/*/{Protheus.doc} A030ChgOpc
    Função para controle da Opção. Sera executada a função do relatório quando selecionado 'Imprimir'
    @type  Static Function
    @author Masipack
    @since 20/07/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function A030ChgOpc(nRadio)

    If nRadio == 4
        EST030RPT()
    Endif

Return


/*/{Protheus.doc} A030GetOP
    Função para validar e gravar a OP no arquivo temporário, utilizado na tela da rotina 
    @type  Static Function
    @author Masipack
    @since 20/07/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function A030GetOP(oGet1,cNumero,nRadio,oRadio)

Local aAreaSC2  := SC2->(GetArea())
Local aGrupo    := {}
Local nX        := 0
Local lRet      := .T.

    IF !Empty(cNumero)
    
        dbSelectArea('SC2')
        SC2->(dbSetOrder(1))
        SC2->(dbSeek(FWxFilial("SC2") + PadR(cNumero,TamSX3("C2_NUM")[1] + TamSX3("C2_ITEM")[1] + TamSX3("C2_SEQUEN")[1] + TamSX3("C2_ITEMGRD")[1] )))

        dbSelectArea('SD4')
        SD4->(dbSetOrder(2))
        SD4->(dbSeek(FWxFilial("SD4") + PadR(cNumero,TamSX3("D4_OP")[1])))

        If nRadio == 0
            FwAlertWarning('Opção não selecionada. Escolha uma opção para continuar')
            Return
        Endif
        
        If !(nRadio == 4)
            For nX := 1 to 4
                If !(nX == nRadio)
                    oRadio:Disable(nX)
                Endif
            Next nX
        Endif

        If !(SC2->(FOUND()))
            lRet := .F.
            cNumero := SPACE(TamSX3('C2_NUM')[1]+TamSX3('C2_ITEM')[1]+TamSX3('C2_SEQUEN')[1])
            oGet1:SetFocus()
            oGet1:CtrlRefresh()
            Help(NIL, NIL, "OPNOTFOUND", NIL, "Ordem de produção " + cNumero + " não encontrada!", 1, 0)

        ElseIf lRet .And. !(SD4->(FOUND()))
            lRet := .F.
            cNumero := SPACE(TamSX3('C2_NUM')[1]+TamSX3('C2_ITEM')[1]+TamSX3('C2_SEQUEN')[1])
            oGet1:SetFocus()
            oGet1:CtrlRefresh()
            Help(NIL, NIL, "NOEMPENHO", NIL, "Ordem de Produção " + cNumero + " sem empenhos!", 1, 0)

        ElseIf lRet .And. !Empty(SC2->C2_DATRF)
            
            cNumero := SPACE(TamSX3('C2_NUM')[1]+TamSX3('C2_ITEM')[1]+TamSX3('C2_SEQUEN')[1])
            oGet1:SetFocus()
            oGet1:CtrlRefresh()
            Help(NIL, NIL, "OPENCER", NIL, "Ordem de produção " + cNumero + " já encerrada", 1, 0)
/*
        ElseIf lRet .And. nRadio == 1 .And. !Empty(SC2->C2_MSREFER)
            lRet := .F.
            cNumero := SPACE(TamSX3('C2_NUM')[1]+TamSX3('C2_ITEM')[1]+TamSX3('C2_SEQUEN')[1])
            oGet1:SetFocus()
            oGet1:CtrlRefresh()
            Help(NIL, NIL, "OPREFER", NIL, 'Ação não permitida para a Ordem de Produção com Referência', 1, 0, NIL, NIL, NIL, NIL, NIL, {'OP: ' + cNumero + ' vinculada a ref.: ' + SC2->C2_MSREFER } )
*/
        ElseIf lRet .And. nRadio == 3 .And. Empty(SC2->C2_MSREFER)
            lRet := .F.
            cNumero := SPACE(TamSX3('C2_NUM')[1]+TamSX3('C2_ITEM')[1]+TamSX3('C2_SEQUEN')[1])
            oGet1:SetFocus()
            oGet1:CtrlRefresh()
            Help(NIL, NIL, "EXCBLOQ", NIL, 'Ordem de produção não possui vínculo com Referência', 1, 0)

        Endif
        
        If lRet
            aGrupo := GetGroupSB1(cNumero,nRadio)
            GrvSC2TMP(aGrupo)
            cNumero := SPACE(TamSX3('C2_NUM')[1]+TamSX3('C2_ITEM')[1]+TamSX3('C2_SEQUEN')[1])
            oGet1:SetFocus()
            oGet1:CtrlRefresh()
        Endif

    Endif

    RestArea(aAreaSC2)

Return lRet



/*/{Protheus.doc} GetGroupSB1
    (long_description)
    @type  Static Function
    @author user
    @since 07/08/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function GetGroupSB1(cNumero,nRadio)

Local _aColumn  := {}
Local _aRet     := {}
Local _aSize    := MsAdvSize()
Local _cTRB     := GetNextAlias()
Local _cWhere   := "%%"
Local _nOpc     := 0
Local _nCount   := 0
Local _oCol     := Nil
Local _oDialog  := Nil
Local _oMark    := Nil
Local _oTable   := Nil

    IF nRadio == 1
        _cWhere := "% D4_MSREFER = ' ' AND %"
    ENDIF

    BEGINSQL Alias _cTRB

        SELECT  C2_NUM + C2_ITEM + C2_SEQUEN    AS 'D4_OP', 
                D4_MSREFER, 
		        COALESCE(BM_GRUPO,'0010')       AS BM_GRUPO,
                COALESCE(BM_DESC,'MECANICO')    AS BM_DESC 
        
        FROM    %Table:SC2% C2,
                %Table:SD4% D4,
                %Table:SB1% B1

        LEFT JOIN   %Table:SBM% BM ON
                    BM_GRUPO = B1_GRUPO AND
                    BM.%NOTDEL%
        
        WHERE %Exp:_cWhere%
        C2_FILIAL                       = %Exp:xFilial('SC2')%          AND
        C2_NUM + C2_ITEM + C2_SEQUEN    = %Exp:cNumero%                 AND
        D4_FILIAL                       = %Exp:xFilial('SD4')%          AND
        D4_OP                           = C2_NUM + C2_ITEM + C2_SEQUEN  AND
        D4_QUANT                        > 0                             AND
        B1_COD                          = D4_COD                        AND
        D4.%NOTDEL%                                                     AND
        B1.%NOTDEL%

        GROUP BY C2_NUM,C2_ITEM,C2_SEQUEN,D4_MSREFER,BM_GRUPO,BM_DESC
        ORDER BY D4_OP, BM_GRUPO

    ENDSQL

    AADD(_aColumn,{"D4_OK"       ,'C'                       ,2                          ,0                         })
    AADD(_aColumn,{"D4_OP"       ,TamSX3('D4_OP')[3]        ,TamSX3('D4_OP')[1]         ,TamSX3('D4_OP')[2]        })
    AADD(_aColumn,{"D4_MSREFER"  ,TamSX3('D4_MSREFER')[3]   ,TamSX3('D4_MSREFER')[1]    ,TamSX3('D4_MSREFER')[2]   })
    AADD(_aColumn,{"BM_GRUPO"    ,TamSX3('BM_GRUPO')[3]     ,TamSX3('BM_GRUPO')[1]      ,TamSX3('BM_GRUPO')[2]     })
    AADD(_aColumn,{"BM_DESC"     ,TamSX3('BM_DESC')[3]      ,TamSX3('BM_DESC')[1]       ,TamSX3('BM_DESC')[2]      })
    
    _oTable := FWTemporaryTable():New()
    _oTable:SetFields( _aColumn )
    _oTable:Create()

    While (_cTRB)->(!EOF())
        (_oTable:GetAlias())->(DBAppend())
        (_oTable:GetAlias())->D4_OK         := ''
        (_oTable:GetAlias())->D4_OP         := (_cTRB)->D4_OP
        (_oTable:GetAlias())->D4_MSREFER    := (_cTRB)->D4_MSREFER
        (_oTable:GetAlias())->BM_GRUPO      := (_cTRB)->BM_GRUPO
        (_oTable:GetAlias())->BM_DESC       := (_cTRB)->BM_DESC
        (_oTable:GetAlias())->(DBCommit())
        _nCount++
        (_cTRB)->(dbSkip())
    Enddo

    If _nCount > 1

        _oDialog := TDialog():New(_aSize[1], _aSize[2],_aSize[6]/2, _aSize[5]/2,"",,,,,,,,,.T.)

        _aColumn := {}

        _oCol := FWBrwColumn():New()
        _oCol:SetTitle('Número OP')
        _oCol:SetData({|| (_oTable:GetAlias())->D4_OP })
        _oCol:SetType( TamSX3('D4_OP')[3] )
        _oCol:SetSize(TamSX3('D4_OP')[1])
        _oCol:SetDecimal(TamSX3('D4_OP')[2])
        aAdd(_aColumn, _oCol)

        _oCol := FWBrwColumn():New()
        _oCol:SetTitle('Nº Refer.')
        _oCol:SetData({|| (_oTable:GetAlias())->D4_MSREFER })
        _oCol:SetType( TamSX3('D4_MSREFER')[3] )
        _oCol:SetSize(TamSX3('D4_MSREFER')[1])
        aAdd(_aColumn, _oCol)
        
        _oCol := FWBrwColumn():New()
        _oCol:SetTitle('Grupo')
        _oCol:SetData({|| (_oTable:GetAlias())->BM_GRUPO })
        _oCol:SetType( TamSX3('BM_GRUPO')[3] )
        _oCol:SetSize(TamSX3('BM_GRUPO')[1])
        aAdd(_aColumn, _oCol)
        
        _oCol := FWBrwColumn():New()
        _oCol:SetTitle('Desc. Grupo')
        _oCol:SetData({|| (_oTable:GetAlias())->BM_DESC })
        _oCol:SetType( TamSX3('BM_DESC')[3] )
        _oCol:SetSize(TamSX3('BM_DESC')[1])
        aAdd(_aColumn, _oCol)

        _oMark := FWMarkBrowse():New()
        _oMark:SetOwner(_oDialog)
        _oMark:SetAlias(_oTable:GetAlias())
        _oMark:SetTemporary(.T.)
        _oMark:SetIgnoreARotina(.T.)
        _oMark:SetMenuDef("") 
        _oMark:SetColumns(_aColumn)
        _oMark:SetFieldMark('D4_OK')
        _oMark:SetCustomMarkRec( {|| RecLock(_oMark:Alias(),.F.), (_oMark:Alias())->D4_OK := IIF(!_oMark:IsMark(),_oMark:Mark(),''), (_oMark:Alias())->(MsUnLock()) } )
        _oMark:DisableFilter()
        _oMark:DisableReport()
        _oMark:Activate()

        ACTIVATE MSDIALOG _oDialog ON INIT EnchoiceBar(_oDialog,{|| _nOpc := 1, _oDialog:End() },{|| _oDialog:End() }) CENTERED

    Endif

    If _nOpc == 1 .And. _nCount > 1
        
        (_oMark:Alias())->(dbGoTop())
        While (_oMark:Alias())->(!EOF())
            If _oMark:IsMark()
                AADD(_aRet,{(_oMark:Alias())->D4_MSREFER, (_oMark:Alias())->BM_GRUPO, (_oMark:Alias())->BM_DESC})
            Endif
            (_oMark:Alias())->(dbSkip())
        Enddo
    
    ElseIf _nCount == 1
        
        (_oTable:GetAlias())->(dbGoTop())
        AADD(_aRet,{(_oTable:GetAlias())->D4_MSREFER, (_oTable:GetAlias())->BM_GRUPO, (_oTable:GetAlias())->BM_DESC})
    
    Endif

    _oTable:Delete()
    (_cTRB)->(dbCloseArea())

Return _aRet


/*/{Protheus.doc} GrvSC2TMP
    Grava/Troca/Remove o numero da referencia nas ordens de produção marcadas
    @type  Static Function
    @author Masipack
    @since 20/07/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function GrvSC2TMP(aGrupo)

Local nX := 0

    If Len(aGrupo) > 0
        For nX := 1 To Len(aGrupo)
            (oTable:GetAlias())->(DBAppend(.F.))
            (oTable:GetAlias())->C2_OK        := oMark:Mark()
            (oTable:GetAlias())->C2_NUM       := SC2->C2_NUM
            (oTable:GetAlias())->C2_ITEM      := SC2->C2_ITEM
            (oTable:GetAlias())->C2_SEQUEN    := SC2->C2_SEQUEN
            (oTable:GetAlias())->C2_MSREFER   := aGrupo[nX,1]
            (oTable:GetAlias())->C2_PRODUTO   := SC2->C2_PRODUTO
            (oTable:GetAlias())->B1_DESC      := POSICIONE('SB1',1,xFilial('SB1') + Padr(SC2->C2_PRODUTO,TamSx3('B1_DESC')[1]), 'B1_DESC')
            (oTable:GetAlias())->B1_GRUPO     := aGrupo[nX,2]
            (oTable:GetAlias())->BM_DESC      := aGrupo[nX,3]
            (oTable:GetAlias())->(DBCommit())
            oMark:Refresh(.T.)
        Next nX
    Else
        (oTable:GetAlias())->(DBAppend(.F.))
        (oTable:GetAlias())->C2_OK        := oMark:Mark()
        (oTable:GetAlias())->C2_NUM       := SC2->C2_NUM
        (oTable:GetAlias())->C2_ITEM      := SC2->C2_ITEM
        (oTable:GetAlias())->C2_SEQUEN    := SC2->C2_SEQUEN
        (oTable:GetAlias())->C2_MSREFER   := SC2->C2_MSREFER
        (oTable:GetAlias())->C2_PRODUTO   := SC2->C2_PRODUTO
        (oTable:GetAlias())->B1_DESC      := POSICIONE('SB1',1,xFilial('SB1') + Padr(SC2->C2_PRODUTO,TamSx3('B1_DESC')[1]), 'B1_DESC')
        (oTable:GetAlias())->(DBCommit())
        oMark:Refresh(.T.)
    Endif
        
Return

/*/{Protheus.doc} A030TOK
    Valida se as OP's estão marcadas para prosseguir
    @type  Static Function
    @author Masipack
    @since 20/07/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function A030TOK(nRadio,cNumRef)

Local lOk   := .F.

Default nRadio := 0

    If nRadio == 0
        FwAlertWarning('Selecione a opção para continuar')
        Return .F.
    Endif

    If nRadio == 2 .And. Empty(cNumRef)
        FwAlertWarning('Informe a referência para substituição no campo "Referência p/ Troca"')
        Return .F.
    Endif
    
    (oMark:Alias())->(DbGoTop())

    While (oMark:Alias())->(!Eof())
        If oMark:IsMark()
            lOk := .T.
            Exit
        Endif
        (oMark:Alias())->(DbSkip())
    Enddo

    If !lOk
        FwAlertWarning('Nenhuma Ordem de Produção selecionada para Continuar')
        Return .F.
    Endif

Return .T.


/*/{Protheus.doc} A030GetOP
    Função para efetuva o número de referencia na OP e Empenhos
    @author Masipack
    @since 20/07/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function UPDSC2(nRadio,cNumRef)

Local cMsgAlert := ''
Local lOk       := .F.

    If nRadio == 1 .OR. nRadio == 2 .OR. nRadio == 3

        dbSelectArea("SB1")
        SB1->(dbSetOrder(1))

        SC2->(dbSetOrder(1))
        SD4->(dbSetOrder(2))   // D4_FILIAL+D4_OP+D4_COD

        cRefer := IIF(nRadio == 3, SPACE(TamSx3('C2_MSREFER')[1]), IIF(nRadio == 2, cNumRef, cRefer ) )

        (oMark:Alias())->(DbGoTop())
        While (oMark:Alias())->(!Eof())
            IncProc()
            If oMark:IsMark()
                If SC2->(dbSeek(xFilial("SC2") + (oMark:Alias())->(C2_NUM+C2_ITEM+C2_SEQUEN)))
                    
                    If Empty(SC2->C2_MSREFER)
                        lOk := Reclock('SC2',.F.)
                        Replace SC2->C2_MSREFER With cRefer
                        SC2->(MsUnlock())
                    Endif

                    If SD4->(dbSeek(FWxFilial("SD4") + Padr((oMark:Alias())->(C2_NUM+C2_ITEM+C2_SEQUEN),TamSX3("D4_OP")[1])))
                        While SD4->(!EOF()) .And. SD4->D4_FILIAL == FWxFilial("SD4") .And. SD4->D4_OP == Padr((oMark:Alias())->(C2_NUM+C2_ITEM+C2_SEQUEN),TamSX3("D4_OP")[1])
                            
                            SB1->(dbSeek(FWxFilial("SB1") + SD4->D4_COD))

                            If  cEmpAnt == '01' .And. (Empty(SB1->B1_GRUPO) .Or. SB1->B1_GRUPO == (oMark:Alias())->B1_GRUPO)
                                
                                If lOk := Reclock('SD4',.F.)
                                    Replace SD4->D4_MSREFER With cRefer
                                    SD4->(MsUnlock())
                                Endif
                            
                            ElseIf cEmpAnt == '10'
                                
                                If lOk := Reclock('SD4',.F.)
                                    Replace SD4->D4_MSREFER With cRefer
                                    SD4->(MsUnlock())
                                Endif

                                If lOk := Reclock('SC2',.F.)
                                    Replace SC2->C2_MSREFER With cRefer
                                    SC2->(MsUnlock())
                                Endif

                            Endif
                            
                            SD4->(dbSkip())
                        Enddo
                    Endif
                Endif

            Endif
            (oMark:Alias())->(DbSkip())
        Enddo

        If lOk
            If nRadio == 1
                ConfirmSX8()
            Endif
            cMsgAlert := 'Referência ' + IIF(nRadio == 1,  cRefer + ' INCLUÍDA ', IIF(nRadio == 2, cRefer + ' ALTERADA ', 'EXCLUÍDA ' )) + 'com sucesso'
            FwAlertSuccess(cMsgAlert)
        Endif
    
    Endif

Return


/*/{Protheus.doc} EST030RPT
    Função para imprimir o relatório de Referencias
    @type  Static Function
    @author Masipack
    @since 20/07/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function EST030RPT()

Local cPerg := 'ESTA030A'

    If Pergunte(cPerg,.T.)

        oReport := ReportDef(cPerg)
        oReport:PrintDialog()

    Endif

Return

/*/{Protheus.doc} ReportDef()
(long_description)
@type  Static Function
@author Masipack
@since 22/06/2020
/*/
Static Function ReportDef(cPerg)

Local cDesc     := "Este relatório imprimirá as ordens de produção por Referência"
Local cTitulo   := "Resumo da OP | SEPARAÇÃO NO ALMOXARIFADO"
Local oReport
Local oSection
	
	oReport := TReport():New("RESTA030",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cDesc)
    oReport:DisableOrientation()
	oReport:SetPortrait() 
    oReport:SetPreview(.T.)

    oSection := TRSection():New(oReport,"CABEC",{"SD4"})
    TRCell():New(oSection,"C2_NUM","SD4",RetTitle("C2_NUM"),PesqPict("SD4","D4_OP"),TamSX3("D4_OP")[1]+15)
    TRCell():New(oSection,"A1_NREDUZ","SA1",'Cliente',PesqPict("SA1","A1_NREDUZ"),TamSX3("A1_NREDUZ")[1]+20)
    TRCell():New(oSection,"C2_PRODUTO","SC2",RetTitle("C2_PRODUTO"),PesqPict("SC2","C2_PRODUTO"),TamSX3("C2_PRODUTO")[1]+15)
    TRCell():New(oSection,"B1_DESC","SB1",RetTitle("B1_DESC"),PesqPict("SB1","B1_DESC"),TamSX3("B1_DESC")[1]+15)
    TRCell():New(oSection,"B1_LOCAL","SB1",RetTitle("B1_LOCAL"),PesqPict("SB1","B1_LOCAL"),TamSX3("B1_LOCAL")[1]+15)
    TRCell():New(oSection,"C5_COR","SC5",RetTitle("C5_COR"),PesqPict("SC5","C5_COR"),30)

Return oReport

/*/{Protheus.doc} PrintReport()
(long_description)
@type  Static Function
@author Masipack
@since 22/06/2020
/*/
Static Function PrintReport(oReport)

Local _cAlsQRY  := GetNextAlias()
Local oSection  := oReport:Section(1)
Local lRodape   := .F.

    If FwCodEmp() == '10'
        
        BEGINSQL ALIAS _cAlsQRY
            SELECT  C2_NUM, C2_ITEM, C2_SEQUEN, C2_MSREFER, ISNULL(A1_NREDUZ,'-') [A1_NREDUZ], 
                    C2_PRODUTO, B1_DESC, B1_LOCAL, ISNULL(C5_COR,'-') [C5_COR]
            FROM %Table:SC2% C2
                LEFT JOIN %Table:SB1% B1 ON B1_COD = C2_PRODUTO AND B1.%NOTDEL%
                LEFT JOIN %Table:SC5% C5 ON C5_FILIAL = C2_FILIAL AND ( C5_NUM = C2_NUM + C2_ITEM + C2_SEQUEN OR C5_NUM = C2_MSPED ) AND C5.%NOTDEL%
                LEFT JOIN %Table:SA1% A1 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND A1.%NOTDEL%
            WHERE C2_FILIAL = %Exp:xFilial('SC2')% AND
            C2_MSREFER = %Exp:MV_PAR01% AND
            C2.%NOTDEL%
            ORDER BY C2_NUM, C2_ITEM, C2_SEQUEN
        ENDSQL

    Else

        _cAlsQRY  := GetNextAlias()

        BEGINSQL ALIAS _cAlsQRY
            SELECT  C2_NUM, C2_ITEM, C2_SEQUEN, D4_MSREFER, ISNULL(A1_NREDUZ,'-') [A1_NREDUZ], 
                    C2_PRODUTO, B1_DESC, B1_LOCAL, ISNULL(C5_COR,'-') [C5_COR]
            FROM %Table:SD4% D4
                LEFT JOIN %Table:SC2% C2 ON C2_FILIAL = D4_FILIAL AND C2_NUM + C2_ITEM + C2_SEQUEN = D4_OP AND C2.%NOTDEL%
                LEFT JOIN %Table:SB1% B1 ON B1_COD = C2_PRODUTO AND B1.%NOTDEL%
                LEFT JOIN %Table:SC5% C5 ON C5_FILIAL = C2_FILIAL AND ( C5_NUM = C2_NUM + C2_ITEM + C2_SEQUEN OR C5_NUM = C2_MSPED ) AND C5.%NOTDEL%
                LEFT JOIN %Table:SA1% A1 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND A1.%NOTDEL%
            WHERE C2_FILIAL = %Exp:xFilial('SC2')% AND
            D4_MSREFER = %Exp:MV_PAR01% AND
            D4.%NOTDEL%
            GROUP BY C2_NUM, C2_ITEM, C2_SEQUEN, D4_MSREFER, A1_NREDUZ, C2_PRODUTO, B1_DESC, B1_LOCAL, C5_COR
            ORDER BY C2_NUM, C2_ITEM, C2_SEQUEN
        ENDSQL

    Endif

    If !(_cAlsQRY)->(EOF())

        oSection:Init()

        oReport:PrintText('>>> REFERÊNCIA: ' + MV_PAR01 + ' <<<', oReport:Row(), oReport:Col()+900)
        oReport:IncRow()

        Do While !(_cAlsQRY)->(EOF())

            If oReport:Cancel()
                Exit
            EndIf

                lRodape := .T.
                
                oReport:IncMeter()
                
                oSection:Cell( "C2_NUM"		):SetValue((_cAlsQRY)->(C2_NUM+C2_ITEM+C2_SEQUEN))
				oSection:Cell( "A1_NREDUZ"	):SetValue((_cAlsQRY)->A1_NREDUZ)
				oSection:Cell( "C2_PRODUTO"	):SetValue((_cAlsQRY)->C2_PRODUTO)
				oSection:Cell( "B1_DESC"	):SetValue((_cAlsQRY)->B1_DESC)
				oSection:Cell( "B1_LOCAL"	):SetValue((_cAlsQRY)->B1_LOCAL)
				oSection:Cell( "C5_COR"		):SetValue((_cAlsQRY)->C5_COR)

                oSection:Printline()

            (_cAlsQRY)->(dbSkip())
        
        Enddo

        oSection:Finish()

        If lRodape
            oReport:FatLine()
            oReport:SkipLine(2)
            oReport:PrintText('Data da Separação: _________/_________/_________' + SPACE(20) + 'Hora da Separação: _________:_________' + SPACE(20) + 'Responsável: _____________________________________'  , oReport:Row())
            oReport:SkipLine()

        Else

            oReport:FatLine()
            oReport:SkipLine(2)
            oReport:PrintText('ITENS JÁ SEPARADOS', oReport:Row())
            oReport:SkipLine()

        Endif
    
    Endif

    (_cAlsQRY)->(dbCloseArea())

Return
