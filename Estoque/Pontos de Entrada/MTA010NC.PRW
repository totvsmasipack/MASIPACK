#Include "rwmake.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} MTA010NC
//TODO Descrição auto-gerada. Marcos
@author alison.goncalves
@since 14/08/2018
@version 1.0
@return array, contendo os campos que não devem ser copiados.

@type function
/*/
User Function MTA010NC()

Local aCpoNC := {}

    AAdd( aCpoNC, 'B1_MSNCM'  )
    AAdd( aCpoNC, 'B1_MSDTPE' )
    AAdd( aCpoNC, 'B1_CONINI' )
    AAdd( aCpoNC, 'B1_UCALSTD')
    AAdd( aCpoNC, 'B1_MSDESEN')
    AAdd( aCpoNC, 'B1_USERLGI')
    AAdd( aCpoNC, 'B1_USERLGA')
    AAdd( aCpoNC, 'B1_PICM'   )
    AAdd( aCpoNC, 'B1_IPI'    )
    AAdd( aCpoNC, 'B1_TS'     )
    AAdd( aCpoNC, 'B1_UCOM'   ) 
    AAdd( aCpoNC, 'B1_UPRC'   ) 
    AAdd( aCpoNC, 'B1_CUSTD'  )
    AAdd( aCpoNC, 'B1_PE'     )
    AAdd( aCpoNC, 'B1_DATREF' )
    AAdd( aCpoNC, 'B1_POSIPI' ) 
    AAdd( aCpoNC, 'B1_DESC' )
    AAdd( aCpoNC, 'B1_EMIN' )
    AAdd( aCpoNC, 'B1_ESTSEG' )
    AAdd( aCpoNC, 'B1_LE' )
    AAdd( aCpoNC, 'B1_LM' )

Return aCpoNC
