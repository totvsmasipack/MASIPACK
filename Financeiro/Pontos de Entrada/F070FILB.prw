
#INCLUDE"PROTHEUS.CH"
/*/{Protheus.doc} F070FILB
  Ponto de entrada para incluir filtro de sistema na baixas contas a receber.
  @type  Function
  @author DS2U (Raphael)
  @since 16/11/2023
  @version version
  @param param_name, param_type, param_descr
  @return return_var, return_type, return_description
  @example
  (examples)
  @see (links_or_references)
/*/

User Function F070FILB()

    Local cPrefixo    := SUPERGETMV("ES_RFIN21P",, "LJ") //Prefixo do Titulo que será desconsiderado pelo filtro.
    Local cFiltro     := ""
    Local cUserNotFil := SUPERGETMV("ES_RFIN21U",, "") //Parametro para adicionar código de usuários que não terão o filtro ativo
    Local _cUserID    := RetCodUsr()
    Local lFiltro     :=  SUPERGETMV("ES_F070FIL",, .T.)  //Parametro para desligar filto para todos usuarios.
    

  //Filtro aplicado somente para empresa Masitubos
  If Alltrim(SubStr(cNumEmp,1,2)) == "15"
    If lFiltro
      IF!(_cUserID $ Alltrim(cUserNotFil))
        cFiltro := "E1_PREFIXO != '"+ cPrefixo +"'"
      ENDIF
    EndIF 
  EndIf 

Return cFiltro
