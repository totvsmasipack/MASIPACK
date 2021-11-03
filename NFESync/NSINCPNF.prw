/*/{Protheus.doc} User Function NSINCPNF
Ponto de entrada do NfSync - Tratamento antes da transação (begin transaction)
da inclusao de prenota
@type  Function
@author DS2U (SDA)
@since 02/10/2019
@version 1.0
/*/
User Function NSINCPNF()

//  Tratamento especifico do NfSync devido ao ponto de entrada MT140TOK da Masipack,
// Que estava apresentando interface de motivo para a inclusao manual de pre-nota
if ( type( "l140Auto" ) == "U" )    
    _SetNamedPrvt( "l140Auto" , .T., "EXECNF" )
endif

l140Auto := .T.

Return