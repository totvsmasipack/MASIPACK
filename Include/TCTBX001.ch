#IFDEF SPANISH
   #define STR0001 "Los datos referidos del centro de coste x partida contable x clase de valor no permitido según el grupo "+ cGrupo +" en el registro de entidades de contabilidad x solicitantes (DBK)."
#ELSE
   #IFDEF ENGLISH
      #define STR0001 "Reported data for cost center x accounting item x value class not allowed according to the group "+ cGrupo +" in the register of accounting entities x requesters (DBK)."
   #ELSE
      #define STR0001 "Dados informados para centro de custo x item contabil x classe de valor não permitida de acordo com o grupo " + cGrupo + " no cadastro de solicitantes (DBK)." 
   #ENDIF
#ENDIF

