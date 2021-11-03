//-------------------------------------------------------------------
/*/{Protheus.doc} NSADDSA2
Ponto de entrada do NFSync para complementar os campos do cadastro de fornecedor que é feito pela ferramenta de forma automatica, para que o XML
seja importado corretamente.
Os campos obrigatórios por padrão já estão sendo contemplados pela ferramenta
@author  DS2U (SDA)
@since   22/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
User Function NSADDSA2()

Local aDadosSA2 := PARAMIXB

AADD( aDadosSA2, {"A2_BAIRRO"  , "AUTO NFE", nil } )
AADD( aDadosSA2, {"A2_INSCR"   , "ISENTO", nil } )
AADD( aDadosSA2, {"A2_PAIS"    , "105", nil } )
AADD( aDadosSA2, {"A2_NATUREZ" , allTrim( getMv( "NS_A2NATUR",, "A01" ) ), nil } )
AADD( aDadosSA2, {"A2_COND"    , allTrim( getMv( "NS_A2COND",, "C03" ) ), nil } )
AADD( aDadosSA2, {"A2_CODPAIS" , "01058", nil } )
AADD( aDadosSA2, {"A2_CONTATO" , "AUTO NFE", nil } )
AADD( aDadosSA2, {"A2_RISCO"   , "B", nil } )
AADD( aDadosSA2, {"A2_EMAIL2"  , "autonfe@nfsync.com", nil } )

Return aClone( aDadosSA2 )
