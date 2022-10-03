/*------------------------------------------------------------------------------------------------------*
 | Programa:  RECIMP                                                                                    |
 | Desc:  Este programa tem como objetivo calcular abatimentos de impostos no contas a receber          |
 |        para corrreta geração do valor no CNAB                                                        |
 |                                                                      								|
 | @author  DS2U (THOMAS MORAES)																		|
 | @since   Out.2022																					|
 | @version 1.0																							|
 | @type    function                                  													|
 *------------------------------------------------------------------------------------------------------*/

User Function RECIMP()

Local _cRet

_cRet:= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,dDataBase,SE1->E1_CLIENTE,SE1->E1_LOJA)
                                   
RETURN(_cRet)
