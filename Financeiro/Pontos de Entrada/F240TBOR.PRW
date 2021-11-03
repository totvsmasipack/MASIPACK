#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออออออหออออออออออออออออหอออออออหอออออออออออออออออออออออหออออออหออออออออออออออปฑฑ
ฑฑบ PROGRAMA     บ   F240TBOR      บ AUTOR บ FABIO MARCELO DIAS    บ DATA บ  05/01/11   บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออสอออออออสอออออออออออออออออออออออสออออออสออออออออออออออนฑฑ
ฑฑบ DESCRICAO    บ CALCULO DO VALOR QUANDO E2_MOEDA <> 1 NA GERACAO DO BORDERO A PAGAR  บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ TABS.UTILIZ  บ DESCRICAO                                                   บ ACESSO บฑฑ
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออฮอฮออออออออออนฑฑ
ฑฑบ    SE2       บ CONTAS A PAGAR                                              บ READ   บฑฑ
ฑฑบ    SM2       บ CADASTRO DE MOEDAS                                          บ READ   บฑฑ
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฮออออออนฑฑ
ฑฑบ HISTORICO    บ 05/01/2011 CRIAวรO.                                                  บฑฑ
ฑฑบ              บ                                                                      บฑฑ
ฑฑบ  		     บ                                                                      บฑฑ
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฮออออออออออนฑฑ
ฑฑบ USO          บ MODULO FINANCEIRO                                                    บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ PROPRIETARIO บ CUSTOMIZADO PARA MASIPACK                                            บฑฑ
ฑฑศออออออออออออออสออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

USER FUNCTION F240TBOR()

	LOCAL AAREASE2	:= {}
	LOCAL AAREASEA	:= {}  
	LOCAL NVALATU	:= 0

	AAREASE2 := SE2->(GETAREA())
	AAREASEA := SEA->(GETAREA())

	DO WHILE SEA->(!EOF()) .AND. SEA->EA_PREFIXO == SE2->E2_PREFIXO .AND. SEA->EA_NUM == SE2->E2_NUM .AND. SEA->EA_PARCELA == SE2->E2_PARCELA .AND. SEA->EA_NUMBOR == SE2->E2_NUMBOR
		IF SE2->E2_MOEDA > 1
			RECLOCK("SE2",.F.)
			DO CASE
				CASE SE2->E2_MOEDA == 2
					SE2->E2_MOEDA	:= 1
					SE2->E2_MSMOEFI := 2
				
				CASE SE2->E2_MOEDA == 3
					SE2->E2_MOEDA	:= 1
					SE2->E2_MSMOEFI := 3
					
				CASE SE2->E2_MOEDA == 4
					SE2->E2_MOEDA	:= 1
					SE2->E2_MSMOEFI := 4
					
				CASE SE2->E2_MOEDA == 5
					SE2->E2_MOEDA	:= 1
					SE2->E2_MSMOEFI := 5
			END CASE

			NVALATU := ROUND(NOROUND(XMOEDA(SE2->E2_VALOR,SE2->E2_MSMOEFI,1,SE2->E2_VENCREA,3,SE2->E2_TXMOEDA),3),2)
			SE2->E2_ACRESC	+= ROUND(NOROUND(NVALATU - SE2->E2_VALOR,3),2)
			SE2->E2_SALDO	:= NVALATU
			SE2->E2_VLCRUZ	:= NVALATU
			SE2->(MSUNLOCK())
	    ENDIF
		SE2->(DBSKIP())
	    SEA->(DBSKIP())
	    NVALATU := 0
	
	END DO

	RESTAREA(AAREASE2)
	RESTAREA(AAREASEA)

RETURN()