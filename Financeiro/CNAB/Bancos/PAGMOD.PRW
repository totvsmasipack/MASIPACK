/////  PROGRAMA PARA INDICAR A MODALIDADE DO PAGAMENTO POS.264-265

///// 01 - Depositos em Conta Corrente
///// 03 - DOCs para outros Bancos
///// 30 - Titulos do Banco Bradesco - Rastreamento
/////      O Bradesco ira procurar todos os titulos do proprio banco contra o
/////      seu CGC e enviara para sua confirmacao de pagamento
///// 31 - Titulos de Outros Bancos
                              
user function pagmod(_aModel)

IF SEA->EA_MODELO $ "01,03"   

   If SE2->E2_PORTADO == "237"
      _aModel := "01"
   Else
      _aModel := "03"
   Endif
   //ElseIf SEA->EA_MODELO $ "30/31"
   //	_cBanco := iif(Empty(SE2->E2_CODBAR),LEFT(SE2->E2_LINDIG,3),LEFT(SE2->E2_CODBAR,3))
Else
   _aModel := SEA->EA_MODELO	
   //_aModel := iif(_cBanco == SE2->E2_PORTADO,"30","31")
EndIf
Return(_aModel)