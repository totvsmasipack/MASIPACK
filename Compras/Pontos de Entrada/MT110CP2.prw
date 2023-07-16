#INCLUDE 'Protheus.ch'

/*------------------------------------------------------------------------------------------------------*
 | P.E.:  {Protheus.doc} MT110CP2                                                                       |
 | Desc:  Adiciona campos na grid de Aprovação de Solicitação de Compras                                |
 | Links: https://tdn.totvs.com.br/pages/releaseview.action?pageId=6085438 								|
 |                                                                                                      |
 | @author  DS2U (THOMAS MORAES)																		|
 | @since   Mai.2023																					|
 | @version 1.0																							|
 | @type    function                                  													|
 *------------------------------------------------------------------------------------------------------*/

User Function MT110CP2()
Local aAreaSC1 := SC1->(GetArea())
Local aItens := PARAMIXB[1]
Local oQual  := PARAMIXB[2]
Local nX  := 0
PARAMIXB[2]:AHEADERS := {} //Redefinindo as colunas

// Adiciona as colunas em ordem
aAdd(PARAMIXB[2]:AHEADERS,RetTitle("C1_PRODUTO"))
aAdd(PARAMIXB[2]:AHEADERS,RetTitle("C1_DESCRI"))
aAdd(PARAMIXB[2]:AHEADERS,RetTitle("C1_QUANT"))
aAdd(PARAMIXB[2]:AHEADERS,RetTitle("C1_UM"))
AADD(PARAMIXB[2]:AHEADERS,RetTitle("C1_ITEM"))
AADD(PARAMIXB[2]:AHEADERS,RetTitle("C1_MSAPROP"))
AADD(PARAMIXB[2]:AHEADERS,RetTitle("C1_SOLICIT"))
AADD(PARAMIXB[2]:AHEADERS,RetTitle("C1_EMISSAO"))
AADD(PARAMIXB[2]:AHEADERS,RetTitle("C1_OBS"))
AADD(PARAMIXB[2]:AHEADERS,RetTitle("C1_FILENT"))

//Redefinindo os conteudos
For nX := 1 To Len (PARAMIXB[2]:AARRAY)
    PARAMIXB[2]:AARRAY[nX] := {} 
Next nX

nX  := 0

// Adiciona campo da coluna que esta sendo incluída
cNumSC  := SC1->C1_NUM
cItemSC := SC1->C1_ITEM

SC1->(dbSetOrder(1))
SC1->(dbSeek(xFilial("SC1") + cNumSc + cItemSC))

While !Eof() .And. SC1->C1_FILIAL == xFilial("SC1") .And. SC1->C1_NUM == cNumSC

    For nX := 1 To Len(PARAMIXB[2]:AARRAY)

        AADD(PARAMIXB[2]:AARRAY[nX],SC1->C1_PRODUTO)
        AADD(PARAMIXB[2]:AARRAY[nX],SC1->C1_DESCRI)
        AADD(PARAMIXB[2]:AARRAY[nX],SC1->C1_QUANT)
        AADD(PARAMIXB[2]:AARRAY[nX],SC1->C1_UM)
        AADD(PARAMIXB[2]:AARRAY[nX],SC1->C1_ITEM)
        AADD(PARAMIXB[2]:AARRAY[nX],SC1->C1_MSAPROP)
        AADD(PARAMIXB[2]:AARRAY[nX],SC1->C1_SOLICIT)
        AADD(PARAMIXB[2]:AARRAY[nX],SC1->C1_EMISSAO)
        AADD(PARAMIXB[2]:AARRAY[nX],SC1->C1_OBS)
        AADD(PARAMIXB[2]:AARRAY[nX],SC1->C1_FILENT)
        
        SC1->(DBSKIP())

    Next nX

EndDo


// Redefine bLine do objeto oQual inlcuindo a coluna nova
aItens := PARAMIXB[2]:AARRAY
PARAMIXB[2]:bLine := { || {aItens[oQual:nAT][1],aItens[oQual:nAT][2],aItens[oQual:nAT][3],aItens[oQual:nAT][4],aItens[oQual:nAT][5],aItens[oQual:nAT][6],aItens[oQual:nAT][7],aItens[oQual:nAT][8],aItens[oQual:nAT][9],aItens[oQual:nAT][10]}}
// Produto / Descrição / Quantidade / Unid.Medida / Item / Apropriação /Solicitante/ Dt. Emissão  / OBS / Filial entrega 

// Evento de duplo click na celula
oQual:bLDblClick := {|| lEditCell (@aItens, oQual, "@!", 6)}
oQual:bValid := {|| U_RCOMG018(@aItens, oQual)}

RestArea(aAreaSC1)

Return
