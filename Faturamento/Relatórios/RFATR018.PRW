#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR018  ºAutor  ³Aparecida de F.Stevanato º Data ³ 27/02/07                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de impressão do Orcamento de Venda de Maquina                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK.                                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAutor     ³ Alteracao                                                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAna Paula ³ Acrescentada QUERY E ORDER BY NA EMPRESA MASIPACK SEGUE CAMPO CUSTOMIZADO CK_MSITEM         º±±
±±ºAna Paula ³ Acrescentado CJ_MSCOR - (SPT)-Sem Pintura                                                   º±±
±±ºAna Paula ³ Garantia estava imprimindo 12 meses fixo, agora imprime o campo CJ_MSGARAN (DET0066/DET0069)º±±
±±ºAna Paula ³ Padronizacao na impressao do relatorio                                                      º±±
±±ºAna Paula ³ O cliente Santa Helena (000039) possui particularidades acrescentados nesta impressão       º±± 
±±ºFelipe F. ³ Retirada cobranca de frete por conta de comprador em Expedicao / Entrega                    º±± 
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß      
*/

User Function RFATR018()

Private aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 } 
Private cString   := "SCJ"
Private tamanho   := "G"
Private titulo    := ""
Private wnrel     := "RFATR018"
Private nomeprog  := "RFATR018"
Private cPerg     := "XRFATR018"
Private lEnd      := .F.
Private nLastKey  := 0
Private Li        := 9000
Private _nCont    := 0
Private cEnd      := ""
Private cTrif     := ""
Private cDesc     := ""
Private cDesc2    := ""
Private cValor    := ""
Private nTotLin   := 0
Private nPag      := 0
Private cVendedor := ""
Private nTotal    := 0
Private nTotMaq   := 0      
Private cProjeto  := ""
Private cNotas    := ""
Private cNotasIn  := ""
Private cSinal    := ""
Private Idioma    := 1    // 1-Portugues   2-Espanhol   3-Ingles
Private IdiomaTC  := 1
Private nMes      := 0
Private nItem     := 0
Private nLen      := 0
Private nLenCli   := 0
Private nCol      := 0
Private nVezes    := 0
Private Opcionais := .F.
Private cCNPJ     := ""
Private aProdutos := {}
Private nCampo    := 0
Private nQtdReg   := 0
Private nReg      := 0
Private I         := 0
Private J         := 0
Private _cCusto   := 0
Private cQuery1   := {}
Private cQuery2   := {}
Private aCores    := {{"TITANIO","BRANCO","PRETO","AMARELO","AZUL","VERDE","SEM PINTURA"},{"TITANIUM","BLANCO","NEGRO","AMARILLO","AZUL","VERDE","SEM PINTURA"},{"TITANIUM","WHITE","BLACK","YELLOW","BLUE","GREEN","SEM PINTURA"}}
Private aIdiomaTC := {{"PORTUGUES","PORTUGUÉS","PORTUGUESE"},{"ESPANHOL","ESPAÑOL","SPANISH"},{"INGLÊS","INGLÉS","ENGLISH"}}
Private aEmpacota := {{"PRIMÁRIO","PRIMARIO","PRIMARY"},{"SECUNDÁRIO","SECUNDARIO","SECONDARY"},{"MULTIPACK","MULTIPACK","MULTIPACK"},{"FARDO","FARDO","BALE"},{"ENCARTUCHAMENTO","ENCARTUCHAMENTO"," CARTONING"},{"ENCAIXOTAMENTO","ENCAJONAMIENTO","CASE PACKING"},{"NÃO APLICÁVEL","NÃO APLICÁVEL","NOT APLICABLE"},{"OUTROS","OUTROS","OUTROS"},{"PALETIZAÇÃO","PALETIZADO","PALLETIZING"}}
Private aDescProd := {"PRODUTO","PRODUCTO","PRODUCT"}
Private aDescPact := {"PACOTE","PAQUETE","PACKET",}
Private aDescAlim := {"ALIMENTAÇÃO","ALIMENTACIÓN","FEEDING",}

Private aDesCampos:= {{"PRODUTO","FORMA DO PRODUTO","DIMENSÃO DO PRODUTO","EMPACOTAMENTO","PESO/VOLUME","TIPO EMBALAGEM","FORMATO EMBALAGEM","PASSO EMBALAGEM","MATERIAL EMBALAGEM","FORMA","DIMENSÃO","QTDE.FILEIRAR/LARG.","FILEIRAS P/MIN.","RENDIMENTO ESPERADO"},;
						{"PRODUCTO","FORMA DEL PRODUCTO","DIMENSIÓN DEL PRODUTO","EMPAQUE","PESO/VOLUMEN","TIPO DE EMBALAJE","DIMENSIÓN DE EMBALAJE","PASO EMBALAJE","MATERIAL EMBALAJE","FORMA","DIMENSIÓN","QTE HILERA/ANJO","HILERA POR MINUTO","RENDIMIENTO ESPERADO"},;
						{"TO WRAP","PRODUCT SHAPE","PRODUCT DIMENSION","PACKAGING","WEIGHT/VOLUM","PACKAGE TYPE","PACKAGE DIMENSION","PACKAGE PACE","PACKAGE MATERIAL","FORM","DIMENSION","ROW QTY/WIDTH","ROW PER MINUTE","EFFICIENCY EXPECTED"}}

Private aDesCampo1:= {{"PRODUTO","FORMA DO PRODUTO","DIMENSÃO DO PRODUTO","EMPACOTAMENTO","PESO/VOLUME","TIPO EMBALAGEM","FORMATO EMBALAGEM","PASSO EMBALAGEM","MATERIAL EMBALAGEM","FORMA","DIMENSÃO","QTDE.FILEIRAR/LARG.","FILEIRAS P/MIN.","RENDIMENTO "},;
						{"PRODUCTO","FORMA DEL PRODUCTO","DIMENSIÓN DEL PRODUTO","EMPAQUE","PESO/VOLUMEN","TIPO DE EMBALAJE","DIMENSIÓN DE EMBALAJE","PASO EMBALAJE","MATERIAL EMBALAJE","FORMA","DIMENSIÓN","QTE HILERA/ANJO","HILERA POR MINUTO","RENDIMIENTO "},;
						{"TO WRAP","PRODUCT SHAPE","PRODUCT DIMENSION","PACKAGING","WEIGHT/VOLUM","PACKAGE TYPE","PACKAGE DIMENSION","PACKAGE PACE","PACKAGE MATERIAL","FORM","DIMENSION","ROW QTY/WIDTH","ROW PER MINUTE","EFFICIENCY "}}

Private aMeses    := {{"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"},;
						{"Enero","Febrero","Marzo","Abril","Mayo","Junio", "Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"},;
						{"January","February","March","April","May","June","July","August","September","October","November","Dezember"}}

Private _nEmp     := Val(Substr(cNumEmp,1,2))

If SubStr(cNumEmp,1,2) == "10"   //Fabrima
	_nEmp := 2
ElseIf SubStr(cNumEmp,1,2) == "15"  //Masipack Africa
	_nEmp := 3
EndIf

DET0001   := {"ORÇAMENTO DE VENDA Nº ","PROPUESTA VENTA Nº ","QUOTATION # "}
DET0002   := {"A.C.: ","Atencion.: Señor/es.","Attention.: "}
DET0002A  := {"Contato: ","Contato: ","Contact: "}
DET0006   := {"ORÇAMENTO Nº ","PROPUESTA Nº ","QUOTATION # "}
DET0007   := {"OPCIONAIS E ACESSÓRIOS","OPCIONALES Y ACCESORIOS","OPTIONALS AND ACCESSORIES"}
DET0008   := {"VALORES DOS OPCIONAIS E ACESSÓRIOS","VALORES DE LOS OPCIONALES Y ACESSÓRIOS","OPTIONALS AND ACCESSORIES VALUES"}
DET0009   := {"Observação: ","Observación: ","Observation: "}
DET0010   := {"O Rendimento esperado dependerá da qualidade do material de embalagem, das condições do produto e da alimentação.","El rendimiento esperado depende de la calidad del material de empaque, de las condiciones del producto y su alimentación.","The expected efficiency depends on the quality of the packaging material, the product conditions and feeding."}
DET0011   := {"Alimentação Elétrica: ","Fuente de Alimentación: ","Power Supply: "}
DET0011A  := {"Alimentação Pneumática","Alimentación Pneumatica","Pneumatic Feeding",}
DET0012   := {"Validade do orçamento:","Validez de la Propuesta:","Quotation Validity"}
DET0013   := {"Nota: ","Nota: ","Notes "}
DET0014   := {"DESCRITIVO TÉCNICO DOS EQUIPAMENTOS","DETALHES TÉCNICOS DE LOS EQUIPOS","TECHNICAL DESCRIPTION OF THE EQUIPMENT"}
DET0015   := {"Item","Íten","Ítem"}
DET0016   := {"CONDIÇÕES COMERCIAIS E ESCOPO DE FORNECIMENTO","CONDICIONES COMERCIALES Y SUMINISTRO","COMMERCIAL CONDITIONS CONCERNING EQUIPMENTS"}
DET0017   := {"VALORES DOS EQUIPAMENTOS","VALORES DE LOS EQUIPOS","EQUIPMENTS VALUES"}
DET0018   := {"ITEM    DESCRIÇÃO                                                                                                   QUANT    VALOR TOTAL ","ÍTEN    DESCRIPCIÓN                                                                                                   QUANT    VALOR TOTAL $","ÍTEM    DESCRIPTION                                                                                                   QUANT    TOTAL VALUE "}
DET0019   := {"                                     TOTAL"}
DET0020   := {"                                 EMBALAGEM","                                  EMBALAJE","                                   PACKAGE"}
DET0021   := {"                               TOTAL GERAL ","                            TOTAL EX-WORKS ","                            TOTAL EX-WORKS "}
DET0022   := {"CONDIÇÕES DE PAGAMENTO","CONDICIONES DE PAGO","PAYMENT CONDITIONS"}
DET0025   := {,"Beneficiario","Beneficiary Name"}
DET0026   := {"Masipack","Fabrima"}
DET0027   := {"São Bernardo do Campo","Guarulhos"}
DET0028   := {"3246-3666","2465-2500" }
DET0029   := {"121, 129, 130","340, 341, 342"}
DET0030   := {"rodolfo.almeida@masipack.com.br","at@fabrima.com.br"}
DET0031   := {"O pagamento a ser efetuado através de Finame deverá ocorrer no prazo máximo de 30 dias  após o faturamento,","Conta nº - Espacio 59 (favor mercionar): ","Account nº - Field 59 (mention):"}
DET0032   := {"independente de agentes financeiros, onde serão adotados os seguintes critérios de acompanhamento:","0013357X0000100986","0013357X0000100986"}
DET0033   := {"Após 10(dez) dias da data da entrega do equipamento, o processo  deverá  estar no agente  financeiro  em  fase","Banco Intermerdiário: ","Intermediary Bank: "}
DET0034   := {"solicitação ao Finame dos  recursos, ou seja:  cópia da  Nota  Fiscal  com  declaração do  recebimento, certidões"," BANCO DO BRASIL S/A - São Paulo - Brazil","BANCO DO BRASIL S/A - São Paulo - Brazil"}
DET0035   := {"negativas  em  ordem,  contrato  assinado e  garantias  firmadas  com  o  banco  (quando  for o  caso), e  demais","Banco de Destino: ","Bank Details: "}
DET0036   := {"documentos exigidos pelo banco para este processo.","New York - USA","New York - USA"}
DET0037   := {"No caso  de, após o 11º dia da  entrega o processo de  Finame  não  estiver  neste  estágio, será  emitido  uma","",""}
DET0038   := {"duplicata no valor da liberação do Finame, para pagamento com recursos próprios, com prazo de 20 dias.","SWIFT: BRASUS33","SWIFT: BRASUS33"}
DET0039   := {"Quando a liquidação deste título em seu vencimento será fornecida uma Carta de Cessão de Direitos  Creditórios","SWIFT: BRASBRRJOCO","SWIFT: BRASBRRJOCO"}
DET0040   := {"ao cliente que dará total autorização  para que o mesmo  receba o  valor a ser  liberado  Finame  diretamente  do","ABA: 026003557","ABA: 026003557"}
DET0041   := {"agente financeiro, uma vez que o mesmo já terá liquidado a fatura com recursos próprios.","CHIPS UID: CH023960","CHIPS UID: CH023960"}
DET0042   := {"Sem mais para o momento, permanecemos ao inteiro  dispor de  V.S.as.  para  quaisquer  esclarecimentos que","Sín más para el momento, quedamos a disposición para aclaraciones adicionales necesarias.","Please, if you have any question do not hesitate to contact us"}
DET0043   := {"se façam necessários."}
DET0044   := {"Atenciosamente,","Atentamente,","Faithfully yours,"}
DET0045   := {"Masipack Indª e Comº de Máquinas Automáticas S/A.","Fabrima Maquinas Automáticas Ltda."}
DET0046   := {"Atende este projeto na ","Atende a este proyecto en ","Suport of this project: ",}
DET0047   := "______________________________________________________________________________________________________________________"
DET0048   := {"Montagem e Testes serão efetuados na " + DET0026[_nEmp] + ", colocação e/ou funcionamento será a cargo do Cliente.","Montaje  y prueba serán efectuados en " + DET0026[_nEmp] + ", colocación en funcionamiento sera de responsabilidad del cliente.","Testing and assembly will be made at " + DET0026[_nEmp] + ", start up and any other arrangements will be on your own."}
DET0049   := {"NÃO APLICÁVEL","NO APLICABLE","NOT APPLICABLE"}
DET0050   := {"  FRETE INTERNO E CUSTO DE AEROPORTO/PORTO","FLETE INTERNO Y COSTO DE AEROPUERTO/PUERTO","     INLAND FREIGHT AND PORT HANDLING COSTS"}
DET0051   := {"                       FRETE INTERNACIONAL","                       FLETE INTERNATIONAL","                     OCEAN FREIGHT"}
DET0052   := {"                      SEGURO INTERNACIONAL","                      SEGURO INTERNATIONAL","                   INTERNATIONAL INSURANCE"}
DET0053   := {"                                  MONTAGEM","                                   MONTAJE","                                  ASSEMBLY"}
DET0054   := {"CONFIRMAÇÃO DE COMPRA","CONFIRMACIÓN DE COMPRA","PURCHASE CONFIRMATION"}
DET0055   := {"Declaramos estar de acordo com os dados e condições desta oferta.","Declaramos estar de acuerdo con los datos y condiciones de esta oferta.","We declare we fully understand and agree with the information and conditions of this commercial offer."}
DET0056   := {"De acordo,","De acuerdo;","In acceptance;"}
DET0057   := {"Cor Predominante:","Color Predominante:","Prevailing Color:"}
DET0058   := {"Notas Interna: ","Notas internas: " ,"Internal notes "}
DET0060   := {"sendo, embalagem",,"LEAD TIME"}
DET0061   := {", frete e seguro por conta do comprador.",," after all technical and commercial details are cleared, and with the first installment payment, except "} 
DET00611  := {"de seguro.",," after all technical and commercial details are cleared, and with the first installment payment, except "}
DET0062   := {"PRAZO DE ENTREGA","PLAZO DE ENTREGA","cash in acvance. The equipment will just start to be manufactured after first payment purchase order." }
DET0063   := {"- Recibimento da Confirmação do Pedido, bem como, das Condições gerais de venda e Fornecimento "," después de aclarados detalles técnicos Y comerciales, asi como pago del anticipo, respectada","* The transportation time is not a " + DET0026[_nEmp] + " responsibility and depend on transportation company contracted by"}
DET0064   := {"assinadas em sinal de concordância.","venta previa del producto.","customer."}
DET0064B  := {"- Pagamento do sinal no prazo determinado (vide em condições de pagamento) - Recebimento de amostras de","venta previa del producto.","customer."}
DET0064C  := {"produto e material de embalagem para análise, no máximo 15 dias após o pedido.","venta previa del producto.","customer."}
DET0064D  := {" - Esclarecimento de todos os detalhes técnicos e comerciais.","venta previa del producto.","customer."}
DET0065   := {"GARANTIA","DATOS COMPLEMENTARES Y OBSERVACIONES","COMPLEMENTARY INFO"}
DET0066   := {"Será de "," 1)  Precio " + '"' + "Ex Works - " + DET0027[_nEmp] + " - SP - Brazil, valores de flete,  seguro Y embalaje (por cuenta"," 1)  Price " + '"' + "Ex Works - " + DET0027[_nEmp] + " - SP - Brazil.  Balance  due  prior  shipment  and  upon  machine"}
DET00661  := {" meses a partir da data do faturamento contra defeitos de fabricação.", "", "" }
DET00662  := {" meses tera seu inicio imediatamente após o start do equipamento ou 10 dias após o faturamento do mesmo,","",""}
DET00663  := {"a qual vencer primeiro.","",""}
DET0067   := {"MONTAGEM E START UP DO EQUIPAMENTO","   del cliente) no están contidos en el precio de este presupuesto, serán determinados en el momento del","   acceptance at " + DET0026[_nEmp] + " Brazil. (Crating, shipping, and insurance are not  included on  the  price of this quote,"}
DET0068   := {"Despesas de locomoção, estadias e refeições, serão a cargo do cliente. As horas extras  bem  como,  sábados,","   embarque.","   crate and shipping charges will be determied at time of shipping."}
DET0069   := {"domingos e feriados serão cobrados do cliente. Serão oferecidos ","Sera de ","Warranty  Certify and  Service  Installment, specifying the guarantee conditions of our equipment will be sent out with"}
DET00691  := {""," meses de la fecha de la factura contra defectos de fabricacíon",""}
DET0070   := {" dias úteis ","MONTAJE Y FUNCIONAMIENTO - START UP","MACHINE ASSEMBLY AND START UP"}
DET0071   := {"","","the invoice."}
DET0072   := {"período de 8 horas diárias somente para a colocação em funcionamento do equipamento.","2)  Muestras: El cliente deberá enviar muestras del producto a ser envasado así como material de embalaje","   customer will be responsible for transportation, lodging, meals, and anu extra hours. The extra working"}
DET0073   := {"Deverá ser programado técnico com no mínimo 15 dias de antecedência para dar Start-Up.","   a ser utilizado. (Contactar nuestro depto de Comércio Exterior, e-mail:","   hours over five (05) days will be charged to the customer to pay."}
DET0074   := {"TESTES ","   comex@"+DET0026[_nEmp]+".com.br, teléfono: (+55 11) " + DET0028[_nEmp]+".","2) Sample: Customer must provide samples of products to be packed and also of the packed material to be used."}
DET0075   := {"deverá fornecer  amostra(s) do(s)  produto(s) a  ser(em)  embalado(s),  bem","3)  El pago de tasa de banquero intermediario es por cuenta del COMPRADOR, " + DET0026[_nEmp] + " no tiene","   Please contact our Import/Export dept., e-mail:"}
DET0076   := {"como do(s) material(is) de embalagem a ser(em) utilizado(s). Sendo, custo de transporte"," responsabilidade por esta despesa","   comex@" + DET0026[_nEmp] + ".com.br, phone: (+55 11) " + DET0028[_nEmp] + " for further info"}
DET0076B  := {"à cargo do Comprador","",""}
DET0077   := {"5)  Idioma dos documentos técnicos e Informações operacionais: ","4)  Idioma del documentos técnicos e informacionés operacionales: ","3) Doc´s technical and operation information Language: "}
DET0078   := {,"5)  ORIGEN: Brasil","4) ORIGIN: Brazil"}
DET0079   := {" - Variação de tensão permitida +/- 10%, variação da ciclagem permitida +/- 2%.","",""}
DET0080   := {" - A malha de terra deverá ser independente para o equipamento(Terra de instrumentação).","",""}
DET0081   := {"Pressão mínima de 6Kg para CM² .","presión mínima de 6 kg para CM* .","minimum pressure of 6 kg for CM* ."}
DET0082   := {"N/A .","",""}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros        						³
//³ mv_par01	// Numero do Orçamento                  				³
//³ mv_par02    // Idioma  1- Port. 2-Esp. 3-Ingles     				³
//³ mv_par03	// Qtde. de tecnicos             	  					³
//³ mv_par04    // Imp Todas as condicoes Sim,Nao       				³
//³ mv_par05	// Imp. Valores 1-Sim ou 2-Nao    	    				³
//³ mv_par06	// Montagem Inclusa ? 1-Sim ou 2-Nao   			   		³
//³ mv_par07	// Imp.Notas Interna? 1-Sim ou 2-Nao    		   		³
//³ mv_par08	// Alimentação Pneumática? Aplicavel - não aplicavel	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)

If mv_par01 == ""
	Alert("**** Atenção, entre com Número do Orçamento","Escape")
	Return
EndIf

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,,,,.F.,,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif   

//MsgRun("Aguarde, Imprimindo !!!!",, { || EmiteRelat() })
RptStatus({|lEnd| EmiteRelat() })

If apmsgyesno("Deseja imprimir outro orçamento?")
	U_RFATR018()
ENDIF
Return


//******************************
	Static Function EmiteRelat()
//******************************

Local nCampo, i, j, X

oFont1  := TFont():New("Arial Black",,12,,.F.,,,,,.F.)
oFont2  := TFont():New("Arial Black",,11,,.F.,,,,,.F.)
oFont3  := TFont():New("Arial",,12,,.F.,,,,,.F.)
oFont4  := TFont():New("Times New Roman",,12,,.T.,,,,,.F.)
oFont5  := TFont():New("Courier New",,11,,.T.,,,,,.F.)
oFont6  := TFont():New("Monotype Corsiva",,15,,.F.,,,,,.F.)
oFont7  := TFont():New("Arial",,8,,.F.,,,,,.F.)
oFont9  := TFont():New("Arial Black",,9,,.F.,,,,,.F.)
oFont10 := TFont():New("Arial",,10,,.F.,,,,,.F.)
oFont11 := TFont():New("Arial",,12,,.F.,,,,,.T.)
oFont12 := TFont():New("Arial Black",,15,,.F.,,,,,.F.)
oFont13 := TFont():New("Arial",,11,,.F.,,,,,.F.)

oPrn := TMSPrinter():New("RFATR018")

oPrn:StartPage()                           

oPrn:Say(0, 0, " ",oFont1,010)     // startando a impressora

Li      := 50
_cPaisA := .F.
_nCont  := 0 

Idioma := mv_par02  // Idioma a ser impresso

SM0->(dbSetOrder(1))
nRegistro := Recno()
SM0->(dbSeek(SubStr(cNumEmp,1,2)))
_cNomeEmp := SM0->M0_NOMECOM
_cEndEmp  := Alltrim(SM0->M0_ENDENT) + " - " + Alltrim(SM0->M0_BAIRENT)
_cCepEmp  := "CEP.: " + SubStr(SM0->M0_CEPENT,1,5) + "-" + SubStr(SM0->M0_CEPENT,6,3)
_cEstEmp  := SM0->M0_ESTENT
_cCNPJEmp := SM0->M0_CGC

SCJ->(DbSetOrder(1))
If SCJ->(DbSeek(xFilial("SCJ")+Alltrim(mv_par01)))
	cMSNotas  := SCJ->CJ_MSNOTAS
	cProjeto  := SCJ->CJ_MSPROJE
	cMSNotin  := SCJ->CJ_MSNOTIN
	cMSSaldo  := SCJ->CJ_MSSALDO
	cMSSinal  := SCJ->CJ_MSSINAL
EndIf

If Select("TMP1") > 0 
   DbSelectArea("TMP1")
   DbCloseArea()
EndIf

/// Array do CABECALHO DO ORCAMENTO DE MAQUINAS
cQuery1 := "SELECT SCJ.CJ_NUM,    SCJ.CJ_CLIENTE,SCJ.CJ_LOJA,   SCJ.CJ_MOEDA,  SCJ.CJ_MSINCOT,SCJ.CJ_EMISSAO,SCJ.CJ_ORCAM, SCJ.CJ_MSGARAN, "
cQuery1 += "       SCJ.CJ_MSEMAIL,SCJ.CJ_MSCTATO,SCJ.CJ_MSVEND, SCJ.CJ_MSTRIF, SCJ.CJ_MSCOR,  SCJ.CJ_MSVOLTG,SCJ.CJ_MSHZ, "
cQuery1 += "       SCJ.CJ_VALIDA, SCJ.CJ_MSVLORC,SCJ.CJ_MSVLMON,SCJ.CJ_MSVLEMB,SCJ.CJ_FRETE,  SCJ.CJ_DESPESA,SCJ.CJ_FRETAUT, "
cQuery1 += "       SCJ.CJ_SEGURO, SCJ.CJ_MSPRZEN,SCJ.CJ_MSDIAS, SCJ.CJ_MSINCOL,SCJ.CJ_MSINIGA,	"
If  SubStr(cNumEmp,1,2) $ "01"
	cQuery1 += "       SCJ.CJ_XMSDTRE,SCJ.CJ_XMSNURE, " 
Endif
cQuery1 += "       SA1.A1_EST,    SA1.A1_NOME,   SA1.A1_END, SA1.A1_BAIRRO, SA1.A1_CEP,    SA1.A1_MUN, "
cQuery1 += "       SA1.A1_PAIS,   SA1.A1_DDD,    SA1.A1_DDI,    SA1.A1_TEL,    SA1.A1_FAX,    SA1.A1_CGC, "
//Ivandro Santos - 21/11/16 - Início da alteração
//Ticket#2016111737000082 — Tabela | Atualização (cadastro) de Vendedores
//Ticket#2016112137000234 — Problemas ´para gerar Relatorios Microsiga
//cQuery1 += "       SA1.A1_INSCR,  SA1.A1_PESSOA, SA3.A3_NOME,   SA3.A3_TEL,    SA3.A3_EMAIL,  SA3.A3_MSAREA, SYA.YA_DESCR, " 
cQuery1 += "       SA1.A1_INSCR,  SA1.A1_PESSOA, SA3.A3_NOME,   SA3.A3_TEL,    SA3.A3_EMAIL,  SYA.YA_DESCR, " 
//Ticket#2016112137000234 — Fim da alteração                                                                    
cQuery1 += "       SYA.YA_MSDESCE,SYA.YA_MSDESCI,SA3.A3_DDDTEL,SA3.A3_DDI"
cQuery1 += "FROM "+RetSqlName("SCJ")+" SCJ " 
cQuery1 += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON  SA1.A1_FILIAL = '" + xFilial("SA1")+"' AND SA1.A1_COD    = SCJ.CJ_CLIENTE AND SA1.A1_LOJA = SCJ.CJ_LOJA  "
cQuery1 += "INNER JOIN "+RetSqlName("SA3")+" SA3 ON  SA3.A3_FILIAL = '" + xFilial("SA3")+"' AND SA3.A3_COD    = SCJ.CJ_MSVEND  "
cQuery1 += "INNER JOIN "+RetSqlName("SE4")+" SE4 ON  SE4.E4_FILIAL = '" + xFilial("SE4")+"' AND SE4.E4_CODIGO = SCJ.CJ_CONDPAG "
cQuery1 += "INNER JOIN "+RetSqlName("SYA")+" SYA ON  SYA.YA_FILIAL = '" + xFilial("SYA")+"' AND SYA.YA_CODGI  = SA1.A1_PAIS "
cQuery1 += "WHERE SCJ.CJ_FILIAL = '"+xFilial("SCJ")+"' AND SCJ.CJ_NUM = '"+MV_PAR01+"'  "  
cQuery1 += "AND SCJ.D_E_L_E_T_ = ' '  " 
cQuery1 += "AND SA1.D_E_L_E_T_ = ' '  " 
cQuery1 += "AND SA3.D_E_L_E_T_ = ' '  " 
cQuery1 += "AND SE4.D_E_L_E_T_ = ' '  "
cQuery1 += "AND SYA.D_E_L_E_T_ = ' '  "
cQuery1 += "ORDER BY SCJ.CJ_NUM "

//Executa Query
cQuery1 := ChangeQuery(cQuery1)

DbUseArea(.T.,"TOPCONN", TcGenQry(,,cQuery1),"TMP1",.T.,.T.)      

If Select("TMP2") > 0 
   DbSelectArea("TMP2")
   DbCloseArea()
EndIf
                                               
/// Array do ITENS DO ORCAMENTO DE MAQUINAS
cQuery2 := "SELECT  SCJ.CJ_NUM,    SCJ.CJ_CLIENTE,SCJ.CJ_LOJA,   SCJ.CJ_MOEDA,  SCJ.CJ_MSINCOT,SCJ.CJ_EMISSAO,SCJ.CJ_ORCAM, "
cQuery2 += "        SCJ.CJ_MSEMAIL,SCJ.CJ_MSCTATO,SCJ.CJ_MSVEND, SCJ.CJ_MSTRIF, SCJ.CJ_MSCOR,  SCJ.CJ_MSVOLTG,SCJ.CJ_MSHZ,   SCJ.CJ_VALIDA, "
cQuery2 += "        SCJ.CJ_MSVLORC,SCJ.CJ_MSVLMON,SCJ.CJ_MSVLEMB,SCJ.CJ_FRETE,  SCJ.CJ_DESPESA,SCJ.CJ_FRETAUT,SCJ.CJ_SEGURO, SCK.CK_ITEM, "
If  SubStr(cNumEmp,1,2) $ "01"
	cQuery2 += "        CK_MSITEM,                                                                                                             "
EndIf
cQuery2 += "        SCJ.CJ_MSPRZEN,SCJ.CJ_MSDIAS, SCJ.CJ_MSINCOL,SCK.CK_PRODUTO,SCK.CK_OBS,    SCK.CK_MSITOPC, "
cQuery2 += "        SCK.CK_QTDVEN, SCK.CK_PRCVEN, SCK.CK_VALOR,  SCK.CK_NUM,    SB1.B1_DESC
cQuery2 += "FROM "+RetSqlName("SCJ")+" SCJ " 
cQuery2 += "INNER JOIN "+RetSqlName("SCK")+" SCK ON  SCK.CK_FILIAL = '" + xFilial("SCK")+"' AND SCK.CK_NUM = SCJ.CJ_NUM  "
cQuery2 += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON  SB1.B1_FILIAL = '" + xFilial("SB1")+"' AND SB1.B1_COD = SCK.CK_PRODUTO  "
cQuery2 += "WHERE SCJ.CJ_FILIAL = '"+xFilial("SCJ")+"' AND SCJ.CJ_NUM = '"+MV_PAR01+"'  "  
cQuery2 += "AND SCJ.D_E_L_E_T_ = ' '  " 
cQuery2 += "AND SCK.D_E_L_E_T_ = ' '  " 
cQuery2 += "AND SB1.D_E_L_E_T_ = ' '  "
If  SubStr(cNumEmp,1,2) $ "01"
	cQuery2 += "ORDER BY SCJ.CJ_NUM, CK_MSITEM  "         
Else
	cQuery2 += "ORDER BY SCJ.CJ_NUM, SCK.CK_ITEM  "         
EndIf

//Executa Query
cQuery2 := ChangeQuery(cQuery2)

DbUseArea(.T.,"TOPCONN", TcGenQry(,,cQuery2),"TMP2",.T.,.T.)      

dbSelectArea("TMP1") 
TMP1->(DbGoTop())
If !TMP1->(EOF())   

	If Empty(cProjeto)
		apmsgStop("A descrição do projeto está em Branco, Altere-a antes de imprimir o Orçamento")
		Return
	Else
		nLen   := Len(cProjeto)
		If nLen > 100
			apmsgStop("A descrição do projeto está muito extensa reduza-a antes de imprimir o Orçamento (máximo 100 caracters")
			Return
		EndIf
	EndIf

	SX5->(DbSetOrder(1))
	If SX5->(DbSeek(xFilial("SX5")+"75"+TMP1->A1_PAIS))
		_cPaisA	:= .T.
	ENDIF
	
	If TMP1->CJ_MOEDA == 1
		cMoeda    := "R$"
	ElseIf TMP1->CJ_MOEDA == 2
		cMoeda    := "US$"
	ElseIf TMP1->CJ_MOEDA == 4
		cMoeda    := "Euro"
	EndIf
	
	If TMP1->A1_EST == "EX" .And. Empty(TMP1->CJ_MSINCOT)
		apmsgStop("Orçamento de exportação - Informe o INCOTERM antes da emissão")
		Return
	EndIf
	
	IdiomaTC := Idioma// foi Excluido o campo SCJ->CJ_MSIDITC, pois o comercial solicitou para inibí-lo.
	
	If Idioma == 1
		oPrn:SayBitmap (050,110,"Cab_Orca_Port_" + Str(_nEmp,1) + ".jpg",2200,250)
	ElseIf Idioma == 2
		oPrn:SayBitmap (050,110,"Cab_Orca_Esp_" + Str(_nEmp,1) + ".jpg",2200,250)
	ElseIf Idioma == 3
		oPrn:SayBitmap (050,110,"Cab_Orca_Ing_" + Str(_nEmp,1) + ".jpg",2200,250)
	EndIf
	Li+=300
	oPrn:Say (Li,100, DET0047,oFont2)
	Li+=55
	oPrn:Say (Li,110, DET0001[Idioma] + TMP1->CJ_ORCAM, oFont1)
	nMes := Month(STOD(TMP1->CJ_EMISSAO))
	If Idioma == 3
		If Day(STOD(TMP1->CJ_EMISSAO)) == 1
			oPrn:Say (Li,1450,DET0027[_nEmp] + ", " + aMeses[Idioma][nMes] + " " + SubStr(DTOC(STOD(TMP1->CJ_EMISSAO)),1,2) + "st, " + cValToChar(Year(STOD(TMP1->CJ_EMISSAO))),oFont10)
		ElseIf Day(STOD(TMP1->CJ_EMISSAO)) == 2
			oPrn:Say (Li,1450,DET0027[_nEmp] + ", " + aMeses[Idioma][nMes] + " " + SubStr(DTOC(STOD(TMP1->CJ_EMISSAO)),1,2) + "nd, " + cValToChar(Year(STOD(TMP1->CJ_EMISSAO))),oFont10)
		ElseIf Day(STOD(TMP1->CJ_EMISSAO)) == 3
			oPrn:Say (Li,1450,DET0027[_nEmp] + ", " + aMeses[Idioma][nMes] + " " + SubStr(DTOC(STOD(TMP1->CJ_EMISSAO)),1,2) + "rd, " + cValToChar(Year(STOD(TMP1->CJ_EMISSAO))),oFont10)
		Else
			oPrn:Say (Li,1450,DET0027[_nEmp] + ", " + aMeses[Idioma][nMes] + " " + SubStr(DTOC(STOD(TMP1->CJ_EMISSAO)),1,2) + "th, " + cValToChar(Year(STOD(TMP1->CJ_EMISSAO))),oFont10)
		EndIf
	Else
		oPrn:Say (Li,1450,DET0027[_nEmp] + ", " + SubStr(DTOC(STOD(TMP1->CJ_EMISSAO)),1,2) + " de " + aMeses[Idioma][nMes] + " de " + cValToChar(Year(STOD(TMP1->CJ_EMISSAO))),oFont10)
	EndIf
	Li+=15
	oPrn:Say (Li,100, DET0047,oFont2)
	
	cEnd  := ""
	If  SubStr(cNumEmp,1,2) $ "01" .And. !Empty(ALLTRIM(TMP1->CJ_XMSDTRE))
		Li+=50
		oPrn:Say (Li,110, "Revisão: " +TMP1->CJ_XMSNURE + " - " + DTOC(STOD(TMP1->CJ_XMSDTRE)), oFont1)
		Li+=50
	Endif
	
	Li+=70
	IF Len(ALLTRIM(TMP1->A1_NOME)) > 55
		nLenCli := Len(ALLTRIM(TMP1->A1_NOME))
		If Substr(ALLTRIM(TMP1->A1_NOME),55,1) == " "   
			oPrn:Say (Li,110, Substr(TMP1->A1_NOME,1,55), oFont2)
			Li+=55
			oPrn:Say (Li,110, Substr(TMP1->A1_NOME,55 + 1,nLenCli - 55), oFont2)
		Else
			For i := nLenCli to 1 step -1
					If Substr(TMP1->A1_NOME,i,1) == " " .And. i < 55
						oPrn:Say (Li,110, Substr(TMP1->A1_NOME,1,i), oFont2)
						Li+=55
						oPrn:Say (Li,110, Substr(TMP1->A1_NOME,i + 1,nLenCli - i), oFont2)
						Exit
					EndIf
			Next i
	   Endif
	Else
		oPrn:Say (Li,110, ALLTRIM(TMP1->A1_NOME), oFont2)
	Endif
	Li+=70
	oPrn:Say (Li,1450,DET0002A[Idioma]+TMP1->A3_NOME, oFont10)
	Li+=50
	cEnd := Alltrim(TMP1->A1_END)
	If !Empty(TMP1->A1_BAIRRO)
		cEnd += " - " + Alltrim(TMP1->A1_BAIRRO)
	EndIf
	oPrn:Say (Li,110, cEnd, oFont10)
	oPrn:Say (Li,1450, "("+ALLTRIM(TMP1->A3_DDI)+")("+ALLTRIM(TMP1->A3_DDDTEL)+")"+TMP1->A3_TEL, oFont10)
	If !Empty(TMP1->A1_CEP)
		cEnd := SubStr(TMP1->A1_CEP,1,5) + "-" + SubStr(TMP1->A1_CEP,6,3) + " - "
	Else
		cEnd := ""
	EndIf
	cEnd += Alltrim(TMP1->A1_MUN)
	If TMP1->A1_EST <> "EX"
		cEnd += " - " + Alltrim(TMP1->A1_EST)
	Else
		If Idioma == 1
			cEnd := cEnd + " - " + TMP1->YA_DESCR
		ElseIf Idioma == 2
			cEnd := cEnd + " - " + TMP1->YA_MSDESCE
		ElseIf Idioma == 3
			cEnd := cEnd + " - " + TMP1->YA_MSDESCI
		EndIf
	EndIf                                                      
	Li+=50
	oPrn:Say (Li,110, cEnd, oFont10) 
	oPrn:Say (Li,1450,TMP1->A3_EMAIL, oFont10)
	Li+=50
	oPrn:Say (Li,110, "DDI.: " + TMP1->A1_DDI + "   DDD.: " + TMP1->A1_DDD + "    Tel.: "+ TMP1->A1_TEL  , oFont10)
	If !Empty(TMP1->A1_FAX)
		oPrn:Say (Li,750, " / "+ Alltrim(TMP1->A1_FAX), oFont10)
	EndIf
	Li+=50
	If TMP1->A1_EST <> "EX"
		cCNPJ := TMP1->A1_CGC
		If Alltrim(TMP1->A1_PESSOA) == "J"
			oPrn:Say (Li,110, "CNPJ: " + SubStr(cCNPJ,1,8) + "/" + SubStr(cCNPJ,9,4) + "-" + SubStr(cCNPJ,13,2), oFont10)
		Else
			cCNPJ := Alltrim(TMP1->A1_CGC)
			oPrn:Say (Li,110, "CPF: " + SubStr(cCNPJ,1,Len(cCNPJ)-2) + "-" + SubStr(cCNPJ,Len(cCNPJ)-1,2), oFont10)
			Li+=50
			oPrn:Say (Li,110, "I.E.: " + Alltrim(TMP1->A1_INSCR), oFont10)
		EndIf
		Li+=50
	EndIf
	If !Empty(TMP1->CJ_MSEMAIL)
		oPrn:Say (Li,110, "e-mail: " + TMP1->CJ_MSEMAIL, oFont10)
		Li+=50
	EndIf

	Li+=30
	oPrn:Say (Li,110, DET0002[Idioma] + TMP1->CJ_MSCTATO, oFont10)
	
	SA3->(DbSetOrder(1))
	If SA3->(DBSeek(xFilial("SA3")+TMP1->CJ_MSVEND))
		cVendedor := TMP1->A3_NOME
	EndIf
	
	Li+=100
	oPrn:Say (Li,100, DET0047,oFont2)
	Li+=55
	If nLen <= 80
		nCol := 110 + ((80 - nLen) / 2) * 35       // utilizado para centralizar a descriçao do Projeto
		oPrn:Say (Li,nCol, cProjeto, oFont1)
	Else
		If Substr(cProjeto,80,1) == " "
			nCol := 110 + (1 / 2) * 35       // utilizado para centralizar a descriçao do Projeto
			oPrn:Say (Li,nCol, Substr(cProjeto,1,79), oFont1)
			Li+=55
			nCol := 110 + ((nLen - 80) / 2) * 35       // utilizado para centralizar a descriçao do Projeto
			oPrn:Say (Li,nCol, Substr(cProjeto,81,nLen - 80), oFont1)			
		Else
			For i := nLen to 1 step -1
				If Substr(cProjeto,i,1) == " " .And. i < 80
					nCol := 110 + ( (80 - i) / 2) * 35       // utilizado para centralizar a descriçao do Projeto
					oPrn:Say (Li,nCol, Substr(cProjeto,1,i), oFont1)
					Li+=55
					nCol := 110 + ((80 - (100 - i)) / 2) * 35       // utilizado para centralizar a descriçao do Projeto
					oPrn:Say (Li,nCol, Substr(cProjeto,i + 1,nLen - i), oFont1)
					Exit
				EndIf
			Next i	
		Endif
	Endif
	Li+=20
	oPrn:Say (Li,100, DET0047,oFont2)
	Li+=50
	SZJ->(DbSetOrder(1))
	SZJ->(DbGoTop())
	If SZJ->(DbSeek(xFilial("SCJ")+Alltrim(mv_par01)))
		nQtdReg := 0
		Do While !SZJ->(Eof()) .And. SZJ->ZJ_NUM == Alltrim(mv_par01)
			nQtdReg++
			SZJ->(DbSkip())
			Loop
		EndDo
		aProdutos := Array(14,nQtdReg)
		SZJ->(DbSeek(xFilial("SCJ")+Alltrim(mv_par01)))
		Do While !SZJ->(Eof()) .And. SZJ->ZJ_NUM == Alltrim(mv_par01)
			nReg++
			aProdutos[1,nReg]  := SZJ->ZJ_PRODUTO
			aProdutos[2,nReg]  := SZJ->ZJ_FPROD
			aProdutos[3,nReg]  := SZJ->ZJ_DIMENSA
			If SZJ->ZJ_EMPACOT == "P"
				aProdutos[4,nReg]  := aEmpacota[1,Idioma]
			ElseIf SZJ->ZJ_EMPACOT == "S"
				aProdutos[4,nReg]  := aEmpacota[2,Idioma]
			ElseIf SZJ->ZJ_EMPACOT == "M"
				aProdutos[4,nReg]  := aEmpacota[3,Idioma]
			ElseIf SZJ->ZJ_EMPACOT == "F"
				aProdutos[4,nReg]  := aEmpacota[4,Idioma]
			ElseIf SZJ->ZJ_EMPACOT == "C"
				aProdutos[4,nReg]  := aEmpacota[5,Idioma]
			ElseIf SZJ->ZJ_EMPACOT == "X"
				aProdutos[4,nReg]  := aEmpacota[6,Idioma]
			ElseIf SZJ->ZJ_EMPACOT == "N"
				aProdutos[4,nReg]  := aEmpacota[7,Idioma]
			ElseIf SZJ->ZJ_EMPACOT == "O"
				aProdutos[4,nReg]  := aEmpacota[8,Idioma]
			ElseIf SZJ->ZJ_EMPACOT == "A"
				aProdutos[4,nReg]  := aEmpacota[9,Idioma]
			Else
				aProdutos[4,nReg]  := ""
			EndIf
			aProdutos[5,nReg]  := SZJ->ZJ_PESOVOL
			SX5->(DbGotop())
			SX5->(DbSeek(xFilial("SX5")+"Z2"+SZJ->ZJ_MODEMB))
			cDesc := SubStr(X5DESCRI(),1,33)
			aProdutos[6,nReg]  := cDesc
			aProdutos[7,nReg]  := SZJ->ZJ_DIMEMB
			aProdutos[8,nReg]  := SZJ->ZJ_PASSO
			SX5->(DbGotop())
			SX5->(DbSeek(xFilial("SX5")+"Z6"+SZJ->ZJ_MATEMB))
			cDesc2 := ""
			cDesc := SubStr(X5DESCRI(),1,33)
			aProdutos[09,nReg] := cDesc
			aProdutos[10,nReg] := IIF(SUBSTR(SZJ->ZJ_FALIM,1,1)=="A","AUTOMATICA",IIF(SUBSTR(SZJ->ZJ_FALIM,1,1)=="M","MANUAL",IIF(SUBSTR(SZJ->ZJ_FALIM,1,1)=="P","POR CONTA DO CLIENTE","NAO APLICAVEL")))
			aProdutos[11,nReg] := SZJ->ZJ_DIMALIM
			aProdutos[12,nReg] := SZJ->ZJ_FILLARG
			aProdutos[13,nReg] := SZJ->ZJ_FILMIN
			aProdutos[14,nReg] := SZJ->ZJ_RENDESP
			SZJ->(DbSkip())
		EndDo
		nVezes := Int(nQtdReg / 3)
		If nVezes * 3 < nQtdReg
			nVezes++
		EndIf
		nTotLin = 2300
		For I := 1 To nVezes
			ChecaLinha()
			For nCampo := 1 To 14
				If nCampo == 1
					oPrn:Say (Li,0160, aDescProd[Idioma], oFont9)
					oPrn:Say (Li,0500, "|",oFont4)
					oPrn:Say (Li,0820, StrZero(3 * (I-1) + 1,2),oFont4)
					oPrn:Say (Li,1150, "|",oFont4)
					oPrn:Say (Li,1460, StrZero(3 * (I-1) + 2,2),oFont4)
					oPrn:Say (Li,1800, "|",oFont4)
					oPrn:Say (Li,2090, StrZero(3 * (I-1) + 3,2),oFont4)
					/*oPrn:Say (Li,1800, "|",oFont4)
					oPrn:Say (Li,1810, StrZero(5 * (I-1) + 4,2),oFont4)
					oPrn:Say (Li,2020, "|",oFont4)
					oPrn:Say (Li,2190, StrZero(5 * (I-1) + 5,2),oFont4)*/
				ElseIf nCampo == 4
					Li+=7
					oPrn:Say (Li,0100, DET0047,oFont2)
					Li+=50
					oPrn:Say (Li,0160, aDescPact[Idioma], oFont9)
					oPrn:Say (Li,0500, "|",oFont4)
					oPrn:Say (Li,1150, "|",oFont4)
					oPrn:Say (Li,1800, "|",oFont4)
					//oPrn:Say (Li,1870, "|",oFont4)
					//oPrn:Say (Li,2020, "|",oFont4)
				ElseIf nCampo == 10
					Li+=7
					oPrn:Say (Li,0100, DET0047,oFont2)
					Li+=50
					oPrn:Say (Li,0160, aDescAlim[Idioma], oFont9)
					oPrn:Say (Li,0500, "|",oFont4)
					//oPrn:Say (Li,0510, "|",oFont4)
					oPrn:Say (Li,1150, "|",oFont4)
					oPrn:Say (Li,1800, "|",oFont4)
					//oPrn:Say (Li,2020, "|",oFont4)
				ElseIf nCampo == 14
					Li+=7
					oPrn:Say (Li,0100, DET0047,oFont2)
					Li+=10
				EndIf
				Li+=40
				If TMP1->CJ_CLIENTE == '000039'   // SANTA HELENA
					oPrn:Say (Li,0110, aDesCampo1[Idioma,nCampo], oFont7)
				Else
					oPrn:Say (Li,0110, aDesCampos[Idioma,nCampo], oFont7)
				EndIf
				nCol := 500
				For J := 1 To 3
					nReg := 3 * (I -1) + J
					If nReg <= nQtdReg
						oPrn:Say (Li,nCol, "|",oFont4)
						nCol+=10
						oPrn:Say (Li,nCol, aProdutos[nCampo,nReg], oFont7)
					Else
						oPrn:Say (Li,nCol, "|",oFont4)
						nCol+=10
					EndIf
					nCol += 640
				Next J
			Next nCampo
			Li+=5
			oPrn:Say (Li,0100, DET0047,oFont2)
			Li+=50
		Next I
		nVezes := 0
		Li+=60
		IF MV_PAR04 == 1  // ATUALIZAÇÃO DO ORÇAMENTO 24/10/14 - LIZANDRA
			oPrn:Say (Li,110, DET0009[Idioma], oFont4)
			Li+=5
		ENDIF
		If MV_PAR09 == 1	
			oPrn:Say (Li,380, DET0010[Idioma], oFont10)
	    EndIf
	EndIf
	
	Li+=080
	If TMP1->CJ_MSTRIF == "1"
		cTrif := "Trifásico "
	Else
		cTrif := " "
	EndIf
	oPrn:Say (Li,110, DET0057[Idioma], oFont4)
	Li+=5
	_nCor := 0  
	If Alltrim(TMP1->CJ_MSCOR) == "TIT"
		_nCor := 1
	ElseIf Alltrim(TMP1->CJ_MSCOR) == "BCO"
		_nCor := 2
	ElseIf Alltrim(TMP1->CJ_MSCOR) == "PRE"
		_nCor := 3
	ElseIf Alltrim(TMP1->CJ_MSCOR) == "AMA"
		_nCor := 4
	ElseIf Alltrim(TMP1->CJ_MSCOR) == "AZU"
		_nCor := 5
	ElseIf Alltrim(TMP1->CJ_MSCOR) == "VER"
		_nCor := 6
	ElseIf Alltrim(TMP1->CJ_MSCOR) == "SPT"
		_nCor := 7
	EndIf
	If _nCor <> 0
		oPrn:Say (Li,640,aCores[Idioma][_nCor],oFont10)
	EndIf
	Li+=45
	oPrn:Say (Li,110, DET0011[Idioma], oFont4)
	Li+=5
	If MV_PAR10 == 1
		If TMP1->CJ_MSVOLTG == 0
			oPrn:Say (Li,640,DET0049[Idioma], oFont10)
		Else
			oPrn:Say (Li,640, Alltrim(Str(TMP1->CJ_MSVOLTG)) + " V. " + AllTrim(cTrif) + " - " + Alltrim(Str(TMP1->CJ_MSHZ)) + " HZ", oFont10)
		EndIf 
		Li+=45
  		oPrn:Say (Li,640,DET0079[Idioma], oFont10)
		Li+=45
		oPrn:Say (Li,640,DET0080[Idioma], oFont10) 
	Elseif MV_PAR10 == 2    
		oPrn:Say (Li,640,DET0082[Idioma], oFont10)
	EndIf

	Li+=45
	oPrn:Say (Li,110, DET0011A[Idioma], oFont4)
	Li+=5
	If MV_PAR08 == 1
		oPrn:Say (Li,640,DET0081[Idioma], oFont10) 
	ElseIf MV_PAR08 == 2
		oPrn:Say (Li,640,DET0082[Idioma], oFont10) 
    EndIf
	Li+=45
	oPrn:Say (Li,110, DET0012[Idioma], oFont4)
	Li+=5
	oPrn:Say (Li,640, DTOC(STOD(TMP1->CJ_VALIDA)), oFont10)
	Li+=50
	cNotas := cMSNotas
	If !Empty(cNotas)
		nTotLin = 2800
		ChecaLinha()
		oPrn:Say (Li,110, DET0013[Idioma], oFont4)
		For X := 1 TO MLCOUNT(cNotas,80)
			oPrn:Say (Li,640, MEMOLINE(cNotas,80,X), oFont10)
			Li+=50
			nTotLin = 3000
			ChecaLinha()
		Next
	EndIf
	Li+=50
	If mv_par07 == 1 .And. !Empty(Alltrim(cMSNotin))	// Imprime notas interna ?
		cNotasIn := Alltrim(cMSNotin)
		nTotLin = 2800
		ChecaLinha()
		oPrn:Say (Li,110, DET0058[Idioma], oFont4)
		For X := 1 TO MLCOUNT(cNotasIn,80)
			oPrn:Say (Li,640, MEMOLINE(cNotasIn,80,X), oFont10)
			Li+=50
			nTotLin = 3000
			ChecaLinha()
		Next
	Endif
	Li+=50
	oPrn:Say (Li,100, DET0047,oFont2)
	Li+=55
	oPrn:Say (Li,690, DET0014[Idioma], oFont1)
	Li+=15
	oPrn:Say (Li,100, DET0047,oFont2)
	Li+=70
	nTotLin := 3000
	ChecaLinha()
	Opcionais := .F.
	nItem     := 0
     
	dbSelectArea("TMP2") 
	TMP2->(DbGoTop())
	Do While !TMP2->(EOF()) 
		If TMP2->CK_MSITOPC == "S"
			Opcionais := .T.
		Else
			SZG->(DbSetOrder(1))
			SZG->(DbGotop())
			SZG->(DbSeek(xFilial("SZG")+TMP2->CK_PRODUTO))
			nItem++
			If SubStr(cNumEmp,1,2) $ "01"
				oPrn:Say (Li,110, DET0015[Idioma] +" "+ TMP2->CK_MSITEM,oFont13) 
			Else
				oPrn:Say (Li,110, DET0015[Idioma] + StrZero(nItem,2),oFont13)	
			EndIf
			If Idioma == 1
				cDesc := Alltrim(SZG->ZG_DESCPOR)
			ElseIf Idioma == 2
				cDesc := Alltrim(SZG->ZG_DESCESP)
			ElseIf Idioma == 3
				cDesc := Alltrim(SZG->ZG_DESCING)
			EndIf
			If Empty(cDesc)
				oPrn:Say (Li,300,Alltrim(SZG->ZG_CODIGO) + " => Maquina sem Descritivo", oFont2)
				Li+=50
			Else
				cDesc += Lower(Alltrim(TMP2->CK_OBS))
				For X := 1 TO MLCOUNT(cDesc,80)
					If X == 1
						oPrn:Say (Li,300, Alltrim(SZG->ZG_CODIGO) + " => " + MEMOLINE(cDesc,80,X), oFont9)
					Else
						oPrn:Say (Li,300, MEMOLINE(cDesc,80,X), oFont3)
					EndIf
					ChecaLinha()
					Li+=50
				Next
			EndIf
			ChecaLinha()
			Li+=50
		EndIf
		TMP2->(DBSkip())
	EndDo
	
	nItem := 0
	If Opcionais
		nTotLin := 2600
		ChecaLinha()
		Li+=50
		oPrn:Say (Li,100, DET0047,oFont2)
		Li+=55
		oPrn:Say (Li,850, DET0007[Idioma], oFont1)
		Li+=15
		oPrn:Say (Li,100, DET0047,oFont2)
		Li+=70
		nTotLin := 3150

		dbSelectArea("TMP2") 
		TMP2->(DbGoTop())
		Do While !TMP2->(Eof()) 
			If TMP2->CK_MSITOPC == "S"
				SZG->(DbSetOrder(1))
				SZG->(DbGotop())
				SZG->(DbSeek(xFilial("SZG")+TMP2->CK_PRODUTO))
				nItem++
				If SubStr(cNumEmp,1,2) $ "01"
					oPrn:Say (Li,110, DET0015[Idioma] +" "+ TMP2->CK_MSITEM  ,oFont13)    
				Else
					oPrn:Say (Li,110, DET0015[Idioma] + StrZero(nItem,2) ,oFont13)
				EndIf
				If Idioma == 1
					cDesc := Alltrim(SZG->ZG_DESCPOR)
				Else
					If Idioma == 2
						cDesc := Alltrim(SZG->ZG_DESCESP)
					Else
						cDesc := Alltrim(SZG->ZG_DESCING)
					Endif
				EndIf
				If Empty(cDesc)
					oPrn:Say (Li,300,"Acessório sem Descritivo", oFont2)
					Li+=50
				Else
					cDesc += Lower(Alltrim(TMP2->CK_OBS))
					For X := 1 TO MLCOUNT(cDesc,80)
						If X == 1
							oPrn:Say (Li,300, MEMOLINE(cDesc,80,X), oFont2)
						Else
							oPrn:Say (Li,300, MEMOLINE(cDesc,80,X), oFont3)
						EndIf
						ChecaLinha()
						Li+=50
					Next
				EndIf
				ChecaLinha()
				Li+=50
			EndIf
			TMP2->(DBSkip())
		EndDo
	EndIf
	Li+=50
	nTotLin := 2600
	ChecaLinha()
	oPrn:Say (Li,100, DET0047,oFont2)
	Li+=55
	oPrn:Say (Li,500, DET0016[Idioma], oFont1)
	Li+=15
	oPrn:Say (Li,100, DET0047,oFont2)
	Li+=80
	oPrn:Say (Li,230, DET0017[Idioma], oFont4)
	Li+=30
	oPrn:Say (Li,100, DET0047,oFont2)
	Li+=50
	oPrn:Say (Li,110, DET0018[Idioma]+cMoeda, oFont4)
	Li+=15
	oPrn:Say (Li,100, DET0047,oFont2)

	TMP1->(DbGotop())
	If TMP1->CJ_MSVLORC > 0
		nTotMaq := TMP1->CJ_MSVLORC
	Else
		nTotMaq := 0
	EndIf
	
	nItem := 1
	dbSelectArea("TMP2") 
	TMP2->(DbGoTop())
	Do While !TMP2->(Eof()) .And. TMP2->CK_NUM == Alltrim(mv_par01)
		If TMP2->CK_MSITOPC == "N"
			cDesc := ""
			SB1->(DbSetOrder(1))
			SB1->(DbGotop())
			If SB1->(DbSeek(xFilial("SB1")+TMP2->CK_PRODUTO))
				cDesc := Alltrim(SB1->B1_DESC)
			EndIf
			If Idioma > 1
				SZG->(DbSetOrder(1))
				SZG->(DbGotop())
				If SZG->(DbSeek(xFilial("SZG")+TMP2->CK_PRODUTO))
					If Idioma == 2 .And. !Empty(SZG->ZG_DESCRE)
						cDesc := Alltrim(SZG->ZG_DESCRE)
					EndIf
					If Idioma == 3 .And. !Empty(SZG->ZG_DESCRI)
						cDesc := Alltrim(SZG->ZG_DESCRI)
					EndIf
				EndIf
			EndIf
			Li+=50
			nTotLin := 3100
			ChecaLinha()
			oPrn:Say (Li,130, StrZero(nItem,2) ,oFont5)
			oPrn:Say (Li,260, cDesc, oFont5)
			oPrn:Say (Li,1670, Transform(TMP2->CK_QTDVEN, "999") ,oFont5)
			If TMP2->CK_PRCVEN > 1 .Or. TMP2->CK_PRCVEN < 0
				cValor := Transform(TMP2->CK_VALOR,"999,999,999.99")
				If Idioma == 1
					cValor := Replace(cValor,",","*")
					cValor := Replace(cValor,".",",")
					cValor := Replace(cValor,"*",".")
				EndIf
				If  mv_par05 == 1
					oPrn:Say (Li,1820, cValor,oFont5)
				EndIf
				nTotMaq += TMP2->CK_VALOR
			EndIf
			nItem++
		EndIf
		TMP2->(DBSkip())
	EndDo
	Li+=50
	
	Li+=30
	nTotLin := 2800
	ChecaLinha()
	oPrn:Say (Li,110, DET0047, oFont2)
	Li+=60

	dbSelectArea("TMP1")
	TMP1->(DbGotop())
	If Idioma == 1 .OR. TMP1->CJ_MSVLEMB > 0 .OR. TMP1->CJ_MSVLMON > 0
		oPrn:Say (Li,700,DET0019[1],oFont5)
	Else
		/*If TMP1->CJ_MSINCOT ==  "EXW" */
		oPrn:Say (Li,1200, Space(10) + "TOTAL EX-WORKS " ,oFont5)
		/*Else - Solicitado alteração por Grazieli - Comercial
			oPrn:Say (Li,1200, Space(15) + "TOTAL " + TMP1->CJ_MSINCOT ,oFont5)
		EndIf*/
	EndIf
	If mv_par05 == 1
		cValor := Transform(nTotMaq,"999,999,999.99")
	EndIf
	If Idioma == 1
		cValor := Replace(cValor,",","*")
		cValor := Replace(cValor,".",",")
		cValor := Replace(cValor,"*",".")
	EndIf
	If mv_par05 == 1
		oPrn:Say (Li,1820, cValor ,oFont5)
	EndIf
	
	If TMP1->CJ_MSVLEMB > 0 .Or. TMP1->CJ_MSVLMON > 0
		nTotal := nTotMaq + TMP1->CJ_MSVLEMB + TMP1->CJ_MSVLMON
		If TMP1->CJ_MSVLEMB > 0
			Li+=50
			oPrn:Say (Li,700, DET0020[Idioma] ,oFont5)
			cValor := Transform(TMP1->CJ_MSVLEMB,"999,999,999.99")
			If Idioma == 1
				cValor := Replace(cValor,",","*")
				cValor := Replace(cValor,".",",")
				cValor := Replace(cValor,"*",".")
			EndIf
			If mv_par05 == 1
				oPrn:Say (Li,1820, cValor ,oFont5)
			EndIf
		EndIf
		If TMP1->CJ_MSVLMON > 0
			Li+=50
			oPrn:Say (Li,700, DET0053[Idioma] ,oFont5)
			cValor := Transform(TMP1->CJ_MSVLMON,"999,999,999.99")
			If mv_par05 == 1
				oPrn:Say (Li,1820, cValor ,oFont5)
			EndIf
		EndIf
		Li+=15
		oPrn:Say (Li,1820, Replicate("_",15),oFont5)
		Li+=50
		If TMP1->CJ_MSINCOT == "EXW"
			oPrn:Say (Li,1200, Space(10) + "TOTAL EX-WORKS " ,oFont5)
		Else
			oPrn:Say (Li,700, Space(15) + "TOTAL " + TMP1->CJ_MSINCOT ,oFont5)
		EndIf
		cValor := Transform(nTotal,"999,999,999.99")
		If Idioma == 1
			cValor := Replace(cValor,",","*")
			cValor := Replace(cValor,".",",")
			cValor := Replace(cValor,"*",".")
		EndIf
		If mv_par05 == 1
			oPrn:Say (Li,1820, cValor ,oFont5)
		EndIf
	Else
		nTotal := nTotMaq
	EndIf
	
	If (TMP1->CJ_FRETE + TMP1->CJ_DESPESA) > 0
		nTotal += TMP1->CJ_FRETE
		nTotal += TMP1->CJ_DESPESA
		Li+=50
		oPrn:Say (Li,700, DET0050[Idioma] ,oFont5)
		cValor := Transform(TMP1->CJ_FRETE + TMP1->CJ_DESPESA,"999,999,999.99")
		If mv_par05 == 1
			oPrn:Say (Li,1820, cValor ,oFont5)
		EndIf
	EndIf
	
	If (TMP1->CJ_FRETAUT) > 0
		nTotal += TMP1->CJ_FRETAUT
		Li+=50
		oPrn:Say (Li,700, DET0051[Idioma] ,oFont5)
		cValor := Transform(TMP1->CJ_FRETAUT,"999,999,999.99")
		If mv_par05 == 1
			oPrn:Say (Li,1820, cValor ,oFont5)
		EndIf
	EndIf
	
	If (TMP1->CJ_SEGURO) > 0
		nTotal += TMP1->CJ_SEGURO
		Li+=50
		oPrn:Say (Li,700, DET0052[Idioma] ,oFont5)
		cValor := Transform(TMP1->CJ_SEGURO,"999,999,999.99")
		If mv_par05 == 1
			oPrn:Say (Li,1820, cValor ,oFont5)
		EndIf
	EndIf
	
	If (TMP1->CJ_FRETE + TMP1->CJ_DESPESA + TMP1->CJ_FRETAUT + TMP1->CJ_SEGURO) > 0
		Li+=15
		oPrn:Say (Li,1820, Replicate("_",15),oFont5)
		Li+=50
		nLen := 42 - (Len(Alltrim(DET0019[1])) + Len(Alltrim(TMP1->CJ_MSINCOT)) + Len(Alltrim(TMP1->CJ_MSINCOL)) + 4)
		oPrn:Say (Li,700, Space(nLen) + Alltrim(DET0019[1]) + " " + Alltrim(TMP1->CJ_MSINCOT) + " - " + Alltrim(TMP1->CJ_MSINCOL),oFont5)
		cValor := Transform(nTotal,"999,999,999.99")
		If mv_par05 == 1
			oPrn:Say (Li,1820, cValor ,oFont5)
		EndIf
	EndIf
	Li+=30
	oPrn:Say (Li,110, DET0047, oFont2)
	
	If Opcionais                    // Imprime valores dos opcionais
		nTotLin := 2600
		ChecaLinha()
		Li+=100
		oPrn:Say (Li,1000, DET0007[Idioma], oFont4)
		Li+=50
		oPrn:Say (Li,100, DET0047,oFont2)
		Li+=55
		oPrn:Say (Li,230, DET0008[Idioma], oFont4)
		Li+=15
		oPrn:Say (Li,100, DET0047,oFont2)
		Li+=50
		oPrn:Say (Li,110, DET0018[Idioma]+cMoeda, oFont4)
		Li+=15
		oPrn:Say (Li,100, DET0047,oFont2)
		Li+=15
		nTotLin := 3000
		nItem  := 0
		nTotal := 0

		dbSelectArea("TMP2") 
		TMP2->(DbGoTop())
		Do While !TMP2->(Eof()) 
			If TMP2->CK_MSITOPC == "S"
				cDesc := ""
				SB1->(DbSetOrder(1))
				SB1->(DbGotop())
				If SB1->(DbSeek(xFilial("SB1")+TMP2->CK_PRODUTO))
					cDesc := Alltrim(SB1->B1_DESC)
				EndIf
				If Idioma > 1
					SZG->(DbSetOrder(1))
					SZG->(DbGotop())
					If SZG->(DbSeek(xFilial("SZG")+TMP2->CK_PRODUTO))
						If Idioma == 2 .And. !Empty(SZG->ZG_DESCRE)
							cDesc := Alltrim(SZG->ZG_DESCRE)
						EndIf
						If Idioma == 3 .And. !Empty(SZG->ZG_DESCRI)
							cDesc := Alltrim(SZG->ZG_DESCRI)
						EndIf
					EndIf
				EndIf
				SB1->(DbSetOrder(1))
				SB1->(DbGotop())
				SB1->(DbSeek(xFilial("SB1")+TMP2->CK_PRODUTO))
				nTotLin := 3000
				ChecaLinha()
				nItem++
				If Li == 100 .And. nItem > 1
					oPrn:Say (Li,230, DET0008[Idioma], oFont4)
					Li+=30
					oPrn:Say (Li,100, DET0047,oFont2)
					Li+=50
					oPrn:Say (Li,110, DET0018[Idioma]+cMoeda, oFont4)
					Li+=15
					oPrn:Say (Li,100, DET0047,oFont2)
				EndIf
				Li+=50
				oPrn:Say (Li,130, StrZero(nItem,2) ,oFont5)
				oPrn:Say (Li,260, cDesc, oFont5)
				oPrn:Say (Li,1670, Transform(TMP2->CK_QTDVEN, "999") ,oFont5)
				If TMP2->CK_PRCVEN > 1
					cValor := Transform(TMP2->CK_VALOR,"999,999,999.99")
					If Idioma == 1
						cValor := Replace(cValor,",","*")
						cValor := Replace(cValor,".",",")
						cValor := Replace(cValor,"*",".")
					EndIf
					If mv_par05 == 1
						oPrn:Say (Li,1820, cValor ,oFont5)
					EndIf
					nTotal += TMP2->CK_VALOR
				EndIf
				If !Empty(Alltrim(TMP2->CK_OBS))
					Li+=50
					oPrn:Say (Li,780, Alltrim(TMP2->CK_OBS), oFont3)
				EndIf
			EndIf
			TMP2->(DBSkip())
		EndDo
		Li+=15
		oPrn:Say (Li,110, DET0047, oFont2)
	EndIf
	
	Li+=120
	nTotLin := 2600
	ChecaLinha()
	oPrn:Say (Li,250, DET0022[Idioma], oFont1)
	Li+=70
	
	If mv_par05 == 1
		If !Empty(Alltrim(cMSSINAL))
			For X := 1 TO MLCOUNT(Alltrim(cMSSINAL),80)
				oPrn:Say (Li,110, MEMOLINE(Alltrim(cMSSINAL),80,X), oFont3)
				Li+=50
				nTotLin := 2800
				ChecaLinha()
			Next
		EndIf
		If !Empty(Alltrim(cMSSaldo))
			For X := 1 TO MLCOUNT(Alltrim(cMSSaldo),80)
				oPrn:Say (Li,110, MEMOLINE(Alltrim(cMSSaldo),80,X), oFont3)
				Li+=50
				nTotLin := 2800
				ChecaLinha()
			Next
		ENDIF
		/*   alterado 23/05/14 a pedido do depto comercial - se necessario digitar saldo
			If Idioma == 1
				oPrn:Say (Li,110, "SINAL", oFont2)
				oPrn:Say (Li,260, "de 20% no ato da confirmação do pedido para inicio do processo de fabricação", oFont3)
				Li+=50
				oPrn:Say (Li,110, "SALDO", oFont2)
				oPrn:Say (Li,280, "de 80% a combinar, sendo as parcelas cobradas através de boleto bancário", oFont3)
			ElseIf Idioma == 2
				oPrn:Say (Li,110, "ANTICIPO", oFont2)
				oPrn:Say (Li,360, "de 30% con el pedido", oFont3)
				Li+=50
				oPrn:Say (Li,110, "SALDO", oFont2)
				oPrn:Say (Li,300, "de 70% contra aviso de embarque de los equipos", oFont3)
			ElseIf Idioma == 3
				oPrn:Say (Li,110, "30% down purchase order.", oFont3)
				Li+=50
				oPrn:Say (Li,110, "70% against shipping advice", oFont3)
			EndIf
		EndIf  
		*/
	EndIf
	nTotLin := 3100
	ChecaLinha()
	Do Case
		Case Idioma == 1
			ImpPortugues()
		Case Idioma == 2
			ImpEspanhol()
		Case Idioma == 3
			ImpIngles()
	EndCase

	dbSelectArea("TMP1")
	//TMP1->(DbGotop())
	
	Li+=120
	nTotLin := 2400
	ChecaLinha()
	oPrn:Say (Li,110, DET0042[Idioma], oFont3)
	If Idioma == 1
		Li+=50
		oPrn:Say (Li,110, DET0043[Idioma], oFont3)
	Endif
	Li+=120
	oPrn:Say (Li,110, DET0044[Idioma], oFont3)
	Li+=120
	oPrn:Say (Li,1060, DET0045[_nEmp], oFont6)
	Li+=70
	If Idioma <> 3
		oPrn:Say (Li,1060, DET0046[Idioma] + DET0026[_nEmp] + ": " + SubStr(cVendedor,1,25), oFont10)
	Else
		oPrn:Say (Li,1060, DET0046[Idioma] + SubStr(cVendedor,1,25), oFont10)
	EndIf
	Li+=120
	oPrn:Say (Li,110, Replicate("_",98), oFont3)
	Li+=100
	nTotLin := 2400
	ChecaLinha()
	oPrn:Say (Li,150, DET0054[Idioma], oFont2)
	Li+=100
	oPrn:Say (Li,110, DET0055[Idioma], oFont3)
	Li+=80
	oPrn:Say (Li,110, DET0056[Idioma], oFont3)
	Li+=150
	oPrn:Say (Li,860, "_____________________________________________", oFont3)
	Li+=70
	nCol := 860 + (46 - Len(Alltrim(TMP1->A1_NOME))) / 2 * 13
	oPrn:Say (Li,nCol, Alltrim(TMP1->A1_NOME), oFont6)
	Li+=70
	nCol := 860 + (46 - Len(Alltrim(TMP1->CJ_MSCTATO))) / 2 * 13
	oPrn:Say (Li,nCol, Alltrim(TMP1->CJ_MSCTATO), oFont10)
	Li:=3000
	oPrn:Say (Li,110, DET0047, oFont2)
	Li+=55
	nPag++
	oPrn:Say (Li,110, DET0006[Idioma] + TMP1->CJ_ORCAM + " - " + TMP1->A1_NOME, oFont2)
	oPrn:Say (Li,2100, STR(nPag), oFont3)
	Li+=50
	oPrn:Say (Li,110, DET0045[_nEmp], oFont3)
	_nCont++
EndIf
//EndDo

If _nCont == 0
	apmsgStop("Erro no Processamento ***")
	oPrn:End()
	MS_FLUSH()
	Return
EndIf

oPrn:EndPage()   // Finaliza a pagina

oPrn:Preview()   // Video

oPrn:End()

TMP1->(DbCloseArea())
TMP2->(DbCloseArea())

MS_FLUSH()

Return (.T.)

/******************************/
Static Function ImpPortugues()
/******************************/     

/* tirado em 24/10/14 - Lizandra - atualização do orçamento pelo depto comercial (Erica/Sidnei)

If TMP1->CJ_MSDIAS > 0 .And. mv_par04 == 1 .And. TMP1->A1_EST <> "EX"
	Li+=100
	oPrn:Say (Li,250, "OPÇÃO FINANCIAMENTO SISTEMA VENDOR/LEASING/FINAME", oFont1)
	Li+=70
	oPrn:Say (Li,110, "SINAL ", oFont2)
	oPrn:Say (Li,260, "de 10% no ato da confirmação do pedido para inicio do processo de fabricação", oFont3)
	Li+=50
	oPrn:Say (Li,110, "SALDO ", oFont2)
	oPrn:Say (Li,280, "de 90% em 36 parcelas.", oFont3)
	nTotLin := 2500
	ChecaLinha()
	Li+=100
	oPrn:Say (Li,250, "OUTRAS CONDIÇÕES PARA PAGAMENTO - FINAME/LEASING/OUTROS", oFont1)
	nTotLin := 3100
	ChecaLinha()
	Li+=70
	oPrn:Say (Li,110, DET0031[Idioma], oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, DET0032[Idioma], oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, DET0033[Idioma], oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, DET0034[Idioma], oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, DET0035[Idioma], oFont3)
	ChecaLinha()
	Li+=50                
	
	oPrn:Say (Li,110, DET0036[Idioma], oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, DET0037[Idioma], oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, DET0038[Idioma], oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, DET0039[Idioma], oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, DET0040[Idioma], oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, DET0041[Idioma], oFont3)
EndIf
nTotLin := 2600
*/
ChecaLinha()
Li+=100
If TMP1->A1_EST <> "EX"
	oPrn:Say (Li,250, "IMPOSTOS", oFont1)
	Li+=70
//	oPrn:Say (Li,110, "IPI: isento", oFont2) 
//	oPrn:Say (Li,110, "Os preços de nossos  equipamentos já  contém  todos os encargos tributários da legislação em vigor, ", oFont3)
//	Li+=50
//	oPrn:Say (Li,110, "ICMS: 8,80% incluso no valor acima. ", oFont2)
//	oPrn:Say (Li,2090, "mas não", oFont2)
//	Li+=50
	oPrn:Say (Li,110, "Eventuais alterações nos impostos acarretarão acréscimos ou exclusões no preço.", oFont3)
//	oPrn:Say (Li,110, "incluem o IPI.", oFont2)
	Li+=50
/*
	oPrn:Say (Li,110, "Os preços em questão não incluem eventuais aumentos  decorrentes de  alteração na  legislação  tributária  que", oFont3)
	Li+=50
	oPrn:Say (Li,110, "venham onerá-los.", oFont3)
*/	
	nTotLin := 2800
	ChecaLinha()
	Li+=100
	/*oPrn:Say (Li,250, "PRAZO DE ENTREGA", oFont1)
	Li+=70
	oPrn:Say (Li,110, "Entende-se ", oFont3)
	Li-=5
	If TMP1->CJ_CLIENTE == '000039'   // SANTA HELENA
		//oPrn:Say (Li,345, "posto na fábrica Santa Helena Indústria de Alimentos S.A. em Ribeirão Preto, com as ", oFont2)
		oPrn:Say (Li,345, "posto na fábrica Santa Helena Indústria de Alimentos S.A. em Ribeirão Preto, com as ", oFont3)
		Li+=50
		oPrn:Say (Li,110, " despesas de frete, seguro e embalagem já inclusas no preço final deste contrato. ", oFont3)
	Else	
		oPrn:Say (Li,345, "posto nossa fábrica em " + DET0027[_nEmp] + ",", oFont2)
	EndIf
	Li+=5
	If _nEmp == 1
		If TMP1->CJ_CLIENTE == '000039'   // SANTA HELENA
			//oPrn:Say (Li,1440, "seguro e embalagem já inclusas no preço final deste contrato ", oFont3)
			oPrn:Say (Li,1440, " ", oFont3)
		Else
			oPrn:Say (Li,1440, DET0060[Idioma], oFont3)
		EndIf
	Else
		oPrn:Say (Li,1230, DET0060[Idioma], oFont3)
	EndIf
	Li+=50 
	If TMP1->CJ_CLIENTE == '000039' //SANTA HELENA
		oPrn:Say (Li,110, "", oFont3)
	Else
		oPrn:Say (Li,110, DET0061[Idioma], oFont3)
	EndIf
	*/
	nTotLin := 2800
	ChecaLinha()
	Li+=100
	oPrn:Say (Li,250, DET0062[Idioma]+"     - ", oFont1)
	Li+=5
	oPrn:Say (Li,900, Alltrim(TMP1->CJ_MSPRZEN)+", condicionado a:", oFont3)
	Li+=70
	oPrn:Say (Li,110, DET0063[Idioma], oFont3)
	Li+=50
	oPrn:Say (Li,110, DET0064[Idioma], oFont3)
	Li+=50
	oPrn:Say (Li,110, DET0064B[Idioma], oFont3)
	Li+=50
	oPrn:Say (Li,110, DET0064C[Idioma], oFont3)
	Li+=50
	oPrn:Say (Li,110, DET0064D[Idioma], oFont3)
	Li+=100
	ChecaLinha()
	oPrn:Say (Li,250, "ENTREGA/EXPEDIÇÃO", oFont1)
	Li+=70
	//oPrn:Say (Li,110, "Entende-se ", oFont3)
	Li-=5
	// tirado em 11/12/15 (Lizandra) - a pedido do comercial - Rose
//	If TMP1->CJ_CLIENTE == '000039'   // SANTA HELENA
		//oPrn:Say (Li,345, "posto na fábrica Santa Helena Indústria de Alimentos S.A. em Ribeirão Preto, com as ", oFont2)
//		oPrn:Say (Li,110, "Posto na fábrica Santa Helena Indústria de Alimentos S.A. em Ribeirão Preto, com as ", oFont3)
//		Li+=50
//		oPrn:Say (Li,110, " despesas de frete, seguro e embalagem já inclusas no preço final deste contrato. ", oFont3)
//	Else	
	
	
	//VICTOR DESSUNTE - 09/08/2016
	//INICIO - TICKET: 2016080937000059
	If TMP1->CJ_MSINCOT == "CIF"
		//oPrn:Say (Li,110, "Entende-se " + AllTrim(TMP1->CJ_MSINCOL) + ", correndo por conta do cliente a descarga e movimentação do equipamento nas dependências da COMPRADORA.", oFont3)
		//Ivandro Santos - 06/09/2016
		//Inicio - Ticket#2016090637000081 — Alterar informação
		//oPrn:Say (Li,110, "Entende-se " + AllTrim(TMP1->CJ_MSINCOL) + ", correndo por conta da Masipack a descarga e movimentação do equipamento ", oFont3)
		//Li+=50
		//oPrn:Say (Li,110, "nas dependências da COMPRADORA.", oFont3)
		//Fim - Ticket#2016090637000081
		//Ivandro Santos - 28/11/17 - início da alteração: Ticket#2017112837000158 — Alteração de TEXTO para entrega CIF
		oPrn:Say (Li,110, "Posto fábrica da " + AllTrim(TMP1->A1_NOME) + ", " + Alltrim(TMP1->A1_MUN) + " - " +Alltrim(GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5")+"12"+TMP1->A1_EST,1,""))+ ".", oFont3)
		Li+=50
		oPrn:Say (Li,110, "8.1 - O descarregamento e o transporte interno na planta da " + AllTrim(TMP1->A1_NOME) + " ficarão por conta ", oFont3)
		Li+=50
		oPrn:Say (Li,110, "da empresa " + AllTrim(TMP1->A1_NOME) + ".", oFont3)
		Li+=50
		oPrn:Say (Li,110, "8.2 - O seguro e o transporte, feito pela Masipack não cobrirá o descarregamento e o transporte interno.", oFont3)
		//Ticket#2017112837000158 — Fim da alteração
	Else 
	//FELIPE FREITAS - 24/10/2018
	//INICIO - TICKET: 2018102437000049
		//oPrn:Say (Li,110, "Posto nossa fábrica em " + DET0027[_nEmp]+", "+DET0060[Idioma], oFont3)
		oPrn:Say (Li,110, "Posto nossa fábrica em " + DET0027[_nEmp] + DET0061[Idioma], oFont3)
	EndIf
	
	Li+=5
	Li+=50 
		
	//If TMP1->CJ_MSINCOT <> "CIF"
		//oPrn:Say (Li,110, DET0061[Idioma], oFont3)
   	//EndIf
	
	//FIM - TICKET: 2016080937000059

	
//	EndIf
	/*
	If _nEmp == 1                     
	/// tirado em 11/12/15 (Lizandra) - a pedido do comercial -Rose
//		If TMP1->CJ_CLIENTE == '000039'   // SANTA HELENA
			//oPrn:Say (Li,1440, "seguro e embalagem já inclusas no preço final deste contrato ", oFont3)
//			oPrn:Say (Li,1440, " ", oFont3)
//		Else
		 //	oPrn:Say (Li,1440, DET0060[Idioma], oFont3)
//		EndIf
//	Else
		oPrn:Say (Li,1230, DET0060[Idioma], oFont3)
	EndIf
	*/
	// Tirado em 11/12/15 (Lizandra) - a pedido do comercial - Rose
	//If TMP1->CJ_CLIENTE == '000039' //SANTA HELENA
	//	oPrn:Say (Li,110, "", oFont3)
	//Else
	//EndIf 
	///


	ChecaLinha()
	Li+=100
	///////////////////////////////////////////////////////////////////////////////////////////////////
	If TMP1->A1_EST <> "EX"
		oPrn:Say (Li,250, DET0074[Idioma], oFont1)
		Li+=70
		oPrn:Say (Li,110, " A COMPRADORA, ", oFont2)
		Li+=5
		oPrn:Say (Li,520, DET0075[Idioma], oFont3)
		Li+=50
		oPrn:Say (Li,110, DET0076[Idioma], oFont3) 
		Li+=50
		oPrn:Say (Li,110, DET0076B[Idioma], oFont3)
	EndIf
Else
	If TMP1->A1_PAIS $ 'ZA '
		oPrn:Say (Li,110,"Beneficiario" , oFont1)
		ChecaLinha()
		Li+=70
		oPrn:Say (Li,110, "MASIPACK IND. COM. MÁQUINAS AUTOMÁTICAS S/A", oFont3)
		ChecaLinha()
		Li+=50
		oPrn:Say (Li,110, "Rua Miragaia, No. 13 - Vila Paulicéia", oFont3)
		ChecaLinha()
		Li+=50
		oPrn:Say (Li,110,"CEP: 09689-000 - São Bernardo do Campo - SP", oFont3)
		ChecaLinha()
		Li+=50
		oPrn:Say (Li,110, "Phone.:  0055 11 3246-3666", oFont3)
		Li+=70
		ChecaLinha()
		Li+=50
		oPrn:Say (Li,110, "Bank Details: ", oFont1)
		Li+=10
		oPrn:Say (Li,670, "BANCO DO BRASIL S/A - São Paulo - Brazil", oFont3)
		Li+=50
		ChecaLinha()
		oPrn:Say (Li,670, "Account nº - Field 59 (mention): 0013357X0000100986 - SWIFT: BRASBRRJOCO - LEAD TIME ", oFont3)
		Li+=50
		ChecaLinha()
		oPrn:Say (Li,110, " ", oFont1)
		Li+=10
		oPrn:Say (Li,1150, " ", oFont3)
		nTotLin := 2800
    Else
		oPrn:Say (Li,110,"Beneficiario" , oFont1)
		ChecaLinha()
		Li+=70
		oPrn:Say (Li,110, DET0045[_nEmp], oFont3)
		ChecaLinha()
		Li+=50
		oPrn:Say (Li,110, _cEndEmp, oFont3)
		ChecaLinha()
		Li+=50
		oPrn:Say (Li,110, _cCepEmp + " - " + DET0027[_nEmp] + " - " + _cEstEmp + " - Brasil", oFont3)
		ChecaLinha()
		Li+=50
		oPrn:Say (Li,110, "Fone.: "+ DET0028[_nEmp] + ".", oFont3)
		Li+=70
		oPrn:Say (Li,110, "Banco de Destino: ", oFont1)
		Li+=10
		oPrn:Say (Li,670, "BANCO SANTANDER S/A - São Paulo - Brazil", oFont3)
		Li+=50
		oPrn:Say (Li,670, "SWIFT: BSCHBRSP", oFont3)
		Li+=50
		ChecaLinha()
		oPrn:Say (Li,110, "Conta nº - Campo 59 (Favor Mencionar):", oFont1)
		Li+=10
		oPrn:Say (Li,1150, "3544034644001", oFont3)
		nTotLin := 2800
		ChecaLinha()
		Li+=100
		oPrn:Say (Li,250, DET0062[Idioma], oFont1)
		Li+=70
		oPrn:Say (Li,110, Alltrim(TMP1->CJ_MSPRZEN) + " após pagamento do sinal, bem como, todos os detalhes e comerciais esclarecidos. A fabricação", oFont3)
		Li+=50
		oPrn:Say (Li,110, "do equipamento somente se iniciará após o primeiro pagamento da ordem de compra.", oFont3)
	EndIf
EndIf
nTotLin := 2800
ChecaLinha()
Li+=100
oPrn:Say (Li,250, DET0065[Idioma], oFont1)
Li+=70

oPrn:Say (Li,110, DET0066[Idioma], oFont3)
oPrn:Say (Li,270,Alltrim(STR(TMP1->CJ_MSGARAN)), oFont3)
IF TMP1->CJ_MSINIGA = "N"
	oPrn:Say (Li,310, DET00661[idioma], oFont3)
Elseif TMP1->CJ_MSINIGA = "S"
	oPrn:Say (Li,310, DET00662[idioma], oFont3)
	Li+=70
	oPrn:Say (Li,110, DET00663[idioma], oFont3)
endif

Li+=100 
ChecaLinha()

//oPrn:Say (Li,250, DET0067[Idioma], oFont1)
Li+=70
If TMP1->CJ_MSDIAS > 0   // texto apenas para orçamento nacionais
	IF ! _cPaisA
		oPrn:Say (Li,110, "PERÍODO  MONTAGEM  E  START UP:  Será  necessário ", oFont3)
		Li-=5                                
		/* tirado em 111/12/15 (Lizandra) a pedido do comercial - Rose
		If TMP1->CJ_CLIENTE == '000039'
			oPrn:Say (Li,1240, Str(mv_par03,2)+" técnicos, os quais ficarão a cargo da  " + DET0026[_nEmp]  , oFont2)
			Li+=50
			ChecaLinha()
			oPrn:Say (Li,110, "num período de ", oFont3)
			Li+=5
			ChecaLinha()
			oPrn:Say (Li,400, Alltrim(STR(TMP1->CJ_MSDIAS)) + " dias úteis", oFont2)
			Li+=5
			oPrn:Say (Li,900, "para montagem, start up, testes e treinamento.", oFont3)
			Li+=50
			ChecaLinha()
			//oPrn:Say (Li,110, "Será necessário que a Compradora providencie técnicos mecânicos e elétricos para a montagem.", oFont3)
			//Li+=50
		Else
		*/
			oPrn:Say (Li,1240, Str(mv_par03,2)+" técnico  da  " + DET0026[_nEmp]  , oFont2)
			Li+=5
			oPrn:Say (Li,1800, "num período de ", oFont3)
			Li+=45
			oPrn:Say (Li,110, Alltrim(STR(TMP1->CJ_MSDIAS)) + " dias úteis", oFont2)
			Li+=5
			oPrn:Say (Li,400, "para montagem, start up, testes e treinamento de operação. Será necessário que a Compradora ", oFont3)
			Li+=50
			ChecaLinha()
			//////////
			oPrn:Say (Li,110,"providencie técnicos mecânicos e elétricos para auxiliar a montagem.",oFont3)
			Li+=50
		//////////
//		EndIf
		Checalinha()
		oPrn:Say (Li,110, "·", oFont12)
		If mv_par06 == 1  // Montagem inclusa no orçamento

			/* tirado em 111/12/15 (Lizandra) a pedido do comercial - Rose
			If TMP1->CJ_CLIENTE == '000039'
				oPrn:Say (Li,140,"Para Montagem e start up de equipamentos durante o período acima as despesas já estão inclusas no preço. Serão", oFont3)
				Li+=50
				oPrn:Say (Li,140,"cobradas somente as despesas extras e horas extras (se solicitado pelo cliente), isto é, não serão cobradas as horas normais.", oFont3)
		   Else
		   */
				//Ivandro Santos - 14/12/16
				//Ticket#2016121437000139 — Texto Orçamento
				oPrn:Say (Li,140,"Para Montagem e start up de equipamentos durante o período acima as horas normais trabalhadas e horas viajadas", oFont3)
				//oPrn:Say (Li,140,"Para Montagem e start up de equipamentos durante o período acima as despesas já estão inclusas no preço. Serão", oFont3)
				Li+=50
				//Ivandro Santos - 20/09/17 - início da alteração - Ticket#2017092037000033 — ACRÉSCIMO DE INFORMAÇÃO
				oPrn:Say (Li,140,"estão inclusas no preço, transporte e estadia do técnico sob responsabilidade da COMPRADORA", oFont3)
				//oPrn:Say (Li,140,"estão inclusas no preço. ", oFont3)
				//Ticket#2017092037000033 — fim da alteração
				//oPrn:Say (Li,140,"cobradas somente as despesas extras e horas extras (quando ocorrer), isto é, não serão cobradas as horas normais.", oFont3)
				//Ticket#2016121437000139 — Fim da alteração
//			EndIf
		Else

		/* tirado em 111/12/15 (Lizandra) a pedido do comercial - Rose
			If TMP1->CJ_CLIENTE == '000039'
				oPrn:Say (Li,140,"Para Montagem e start up de equipamentos durante o período acima as despesas já estão inclusas no preço. Serão", oFont3)
				Li+=50
				oPrn:Say (Li,140,"cobradas somente as despesas extras e horas extras (se solicitado pelo cliente), isto é, não serão cobradas as horas normais.", oFont3)
			Else
//				oPrn:Say (Li,140,"Para Montagem e start up de equipamentos serão cobradas somente as despesas extras e horas extras ", oFont3)
*/
				oPrn:Say (Li,140,"Para Montagem e start up de equipamentos serão cobradas todas as horas e despesas.  ", oFont3)
//				Li+=50
//				oPrn:Say (Li,140,"(quando ocorrer), isto é, não serão cobradas as horas normais.", oFont3)
//			EndIf
		EndIf
		Li+=70
		nTotLin := 2900
		ChecaLinha()
		oPrn:Say (Li,110, "CONDIÇÕES DE SERVIÇOS DE ASSISTÊNCIA TÉCNICA PARA MONTAGEM E START UP:  ", oFont3)
		Li+=50
		oPrn:Say (Li,110, "Informamos  abaixo  condições  para  prestação  de  serviços de  Assistência  Técnica em  equipamentos " + DET0026[_nEmp] + ",", oFont3)
		Li+=50
		oPrn:Say (Li,110, "como segue:", oFont3)
		Li+=50
		ChecaLinha()
		oPrn:Say (Li,110, "·", oFont12)
		If TMP1->A1_EST <> "EX"
			//Ivandro Santos - Início da alteração
			//Ticket#2017050237000128 — Horas técnicas
			oPrn:Say (Li,140, "DIA TÉCNICO – R$ 1.500,00/DIA", oFont3)	//oPrn:Say (Li,140, "HORA TÉCNICO - R$ 160,00/HORA.", oFont3)
			Li+=50
			oPrn:Say (Li,140, "HORA VIAGEM - R$ 150,00/HORA.", oFont3)	//oPrn:Say (Li,140, "HORA VIAGEM - R$ 160,00/HORA.", oFont3)
			Li+=50
			oPrn:Say (Li,140, "Nossos técnicos estão liberados somente para trabalho em horário comercial e em dias úteis,", oFont3)
			Li+=50
			oPrn:Say (Li,140, "ou seja, das 07:00 as 17:00 horas, de segunda a sexta feira.", oFont3)
			Li+=50
			ChecaLinha()
			oPrn:Say (Li,110, "·", oFont12)
			oPrn:Say (Li,140, "HORA TÉCNICO EXTRA - aplicada (Dias Úteis entre 17:00 e 19:00) - R$200,00 / Hora", oFont3)
			Li+=50
			oPrn:Say (Li,110, "·", oFont12)
			oPrn:Say (Li,140, "HORA TÉCNICO EXTRA - aplicada (Dias Úteis após as 19:00) - R$200,00 / Hora", oFont3)
			//oPrn:Say (Li,140, "HORA TÉCNICO EXTRA - aplicada (Dias Úteis após as 19:00) - R$240,00 / Hora", oFont3)
			Li+=50
			oPrn:Say (Li,110, "·", oFont12)
			oPrn:Say (Li,140, "HORA TÉCNICO - aplicada (Sábados/Domingos e Feriados) - R$200,00 / Hora", oFont3)
			//oPrn:Say (Li,140, "HORA TÉCNICO - aplicada (Sábados/Domingos e Feriados) - R$240,00 / Hora", oFont3)
			//Ticket#2017050237000128 — Fim da alteração
			//Ticket#2017092037000033 — ACRÉSCIMO DE INFORMAÇÃO
			//If mv_par06 == 2
			Li+=50
			ChecaLinha()
			oPrn:Say (Li,110, "·", oFont12)
			oPrn:Say (Li,140, "DIÁRIAS - Alimentação (2 refeições), Telefonemas e Lavandeira R$80,00 / Dia - Contra apresentação de recibos;", oFont3)
			Li+=50
			oPrn:Say (Li,110, "·", oFont12)
			oPrn:Say (Li,140, "TRANSPORTE AEREO/TERRESTRE, passagem aérea, taxi, ônibus etc) - Contra apresentação de recibos Custo", oFont3)
			Li+=50
			oPrn:Say (Li,140, "real + 10%;", oFont3)
			Li+=50
			ChecaLinha()
			oPrn:Say (Li,110, "·", oFont12)
			oPrn:Say (Li,140, "HOSPEDAGEM - Contra apresentação de recibos Custo Real + 10%;", oFont3)
			Li+=50
			ChecaLinha()
			oPrn:Say (Li,110, "·", oFont12)
			oPrn:Say (Li,140, "Quilometragem (KM rodado) Tabela a consutar (" + DET0026[_nEmp] + "/Cliente/" + DET0026[_nEmp] + "; Traslados no local - ex. Hotel/", oFont3)
			Li+=50
			oPrn:Say (Li,140, "Cliente/Hotel) - Contra apresentação R$0,90 / KM;", oFont3)
			Li+=50
			ChecaLinha()
			oPrn:Say (Li,110, "·", oFont12)
			oPrn:Say (Li,140, "OUTRAS TAXAS - estacionamento, pedágios, e outros serão faturados conforme o valor gasto + 10%.", oFont3)
			//EndIf
			//Ticket#2017092037000033 — Fim da alteração
			Li+=50
			oPrn:Say (Li,110, "·", oFont12)
			oPrn:Say (Li,140, "Não incluso impostos", oFont2)
		Else
			oPrn:Say (Li,110, "·", oFont12)
			oPrn:Say (Li,140, "Hora de Serviço - Dias úteis (de segunda à sexta-feira - horário comercial):  USD 90,00 / Hora", oFont3)
			Li+=50
			oPrn:Say (Li,110, "·", oFont12)
			oPrn:Say (Li,140, "Hora de Serviço - Dias úteis (de segunda a sexta-feira - entre 17:00h[5pm] e 19:00h[7pm]: USD 110,00 / Hora", oFont3)
			Li+=50
			oPrn:Say (Li,110, "·", oFont12)
			oPrn:Say (Li,140, "Hora de Serviço - Dias úteis (de segunda a sexta-feira - após às 19:00h[7pm] - USD 130,00 / Hora", oFont3)
			Li+=50
			oPrn:Say (Li,110, "·", oFont12)
			oPrn:Say (Li,140, "Hora de Serviço - Sábados, domingos e feriados do Brasil - USD 130,00", oFont3)
			Li+=50
			oPrn:Say (Li,110, "·", oFont12)
			oPrn:Say (Li,140, "Hora de Viagem - USD 100,00", oFont3)
			Li+=50
			oPrn:Say (Li,110, "·", oFont12)
			oPrn:Say (Li,140, "Diarias (despesas) - USD 80,00", oFont3)
			Li+=50
			oPrn:Say (Li,110, "·", oFont12)
			oPrn:Say (Li,140, "Transportes (vôos, taxi, transporte local, etc.) - Custo real acrescido de 10%", oFont3)
			Li+=50
			oPrn:Say (Li,110, "·", oFont12)
			oPrn:Say (Li,140, "Hotel - Custo real acrescido de 10%", oFont3)
			Li+=85
			ChecaLinha()
			oPrn:Say (Li,110, "Nota 1: A condição de pagamento é de 21DDL após o retorno do nosso técnico às instalações da " + DET0026[_nEmp] + ".", oFont3)
			Li+=80
			oPrn:Say (Li,110, "Nota 2: Para autorização de despacho do técnico às vossas instalações, por gentileza preencha o formulário e", oFont3)
			Li+=50
			oPrn:Say (Li,110, "e retorne por email com vosso 'de acordo/aceitação' dos termos estipulados. ", oFont3)
			ChecaLinha()
		EndIf
	ELSE
		oPrn:Say (Li,110, "PERÍODO  MONTAGEM  E  START UP:  Será  necessário ", oFont3)
		Li-=5
		oPrn:Say (Li,1240, Str(mv_par03,2)+" técnico(s)  da  " + DET0026[_nEmp]  , oFont2)
		Li+=5
		oPrn:Say (Li,1800, "     num período de ", oFont3)
		Li+=45
		oPrn:Say (Li,110, Alltrim(STR(TMP1->CJ_MSDIAS)) + " dias úteis", oFont2)
		Li+=5
		oPrn:Say (Li,400, "para montagem, start up, testes e treinamento de operação.", oFont3)
		Li+=50
		nTotLin := 2900
		ChecaLinha()
		oPrn:Say (Li,110, "HORÁRIO DE TRABALHO: De segunada a sexta-feira das 07:30 as 16:30h, com intervalo de uma hora para ", oFont3)
		Li+=50
		oPrn:Say (Li,110, "as refeições. Os custos referentes a feriados, finais de semanas e trabalhos realizados fora deste períodos ", oFont3)
		Li+=50
		oPrn:Say (Li,110, "serão cobrados adicionais mediante aprovação da ", oFont3)
		oPrn:Say (Li,1100, "COMPRADORA. ", oFont2)
		Li+=80
		oPrn:Say (Li,110, "CUSTOS PARA EQUIPAMENTOS EM GARANTIA, STAR UP E MANUTENÇÃO: Este serviço tera um custo para a ",oFont3)
		Li+=50
		oPrn:Say (Li,110, "COMPRADORA ", oFont2)
		oPrn:Say (Li,450, "de US$ 500,00 (quinhentos dólares) por dia e por técnico que incluem despesas como refeições,",oFont3)
		Li+=50
		oPrn:Say (Li,110, "durante o período citado acima. " , oFont3)
		Li+=50
		oPrn:Say (Li,110, "Os custos com translado ", oFont3)
		oPrn:Say (Li,600, "VENDEDORA X COMPRADORA ", oFont2)
		oPrn:Say (Li,1300,"sendo terrestre ou aéreo serão a cargo da  " , oFont3)
		Li+=50
		oPrn:Say (Li,110,"COMPRADORA. ", oFont2)
		Li+=50
		oPrn:Say (Li,140, "Não incluso impostos", oFont2)
		ChecaLinha()
		oPrn:Say (Li,110, "·", oFont12)
	endif
	Li+=85
	nTotLin := 2900
	ChecaLinha()
	oPrn:Say (Li,110, "PROGRAMAÇÃO:  A ", oFont3)
	Li-=5
	oPrn:Say (Li,550, "COMPRADORA ", oFont2)
	Li+=5
	oPrn:Say (Li,900, "deverá programar técnico com no mínimo de 15 dias de antecedencia", oFont3)
	Li+=50
	oPrn:Say (Li,110, "para  o " + '"' + "start up" + '"' + "  dos  equipamentos,  enviando  um  email  para ", oFont3)
	IF !_cPaisA
		oPrn:Say (Li,1380, DET0030[_nEmp], oFont11)
		oPrn:Say (Li,1900, "     ou  via  fone/fax:", oFont3)
		Li+=50
		oPrn:Say (Li,110, "(+55 11) "+ DET0028[_nEmp] + ". ", oFont3)
		Li+=85
	ELSE
		oPrn:Say (Li,1380, " rodolfo.almeida@masipack.com.br ", oFont11)
		oPrn:Say (Li,1890, "        ou  via  ", oFont3)
		Li+=50
		oPrn:Say (Li,110, "fone/fax: +27 11 524 0275. ", oFont3)
		Li+=85
	ENDIF
	nTotLin := 2800
	ChecaLinha()
	oPrn:Say (Li,110, "CONDIÇÃO:  No momento que for  programado técnico  para a  montagem, a ", oFont3)
	Li-=5
	oPrn:Say (Li,1640, "COMPRADORA ", oFont2)
	Li+=5
	oPrn:Say (Li,2010, "deverá  ter", oFont3)
	Li+=50
	oPrn:Say (Li,110, "todos os periféricos necessários  prontos para a instalação. São  eles:  alimentação  elétrica e  ar  comprimido", oFont3)
	Li+=50
	oPrn:Say (Li,110, "no ponto do equipamento, sistema de  exaustão (em casos de necessidades),  produto a  embalar  em  escala", oFont3)
	Li+=50
	oPrn:Say (Li,110, "continua de  produção e material de  embalagem  impresso (no caso da empacotadora),  caso haja  atraso ou", oFont3)
	Li+=50
	oPrn:Say (Li,110, "cancelamento  do  serviço  por  parte  da ", oFont3)
	Li-=5
	oPrn:Say (Li,940, "COMPRADORA, ", oFont2)
	Li+=5
	oPrn:Say (Li,1330, "  esta  deverá  entrar  em   contato   com   a", oFont3)
	Li+=50
	oPrn:Say (Li,110, "Assistência Técnica " + DET0026[_nEmp] + " para negociar uma nova montagem. ", oFont3)
	Li+=50
	nTotLin := 3000
	ChecaLinha()
	If TMP1->A1_EST <> "EX"
		/*
		oPrn:Say (Li,110, "Para cada equipamento a ", oFont3)
		Li-=5
		oPrn:Say (Li,630, "COMPRADORA, ", oFont2)
		Li+=5
		oPrn:Say (Li,990, "terá  direito a  primeira  instalação e caso não seja  completa por", oFont3)
		Li+=50
		oPrn:Say (Li,110, "motivos alheios a ", oFont3)
		Li-=5
		oPrn:Say (Li,480, "VENDEDORA, ", oFont2)
		Li+=5
		oPrn:Say (Li,810, "a próxima visita será cobrada.", oFont3)
		Li+=85
		ChecaLinha()
		*/
		oPrn:Say (Li,110, "CONDIÇÕES DE PAGAMENTO: 21DDL após a execução do serviço.", oFont3)
//		Li+=50
//		oPrn:Say (Li,110, "Em conformidade com a legislação previdenciária a assistência técnica se equivale a Cessão de Mão de Obra e", oFont3)
//		Li+=50
//		oPrn:Say (Li,110, "consequentemente há necessidade da retenção por parte do Tomador do Serviço de 11% de INSS, que deve ser", oFont3)

        // Acrescentado este IF, pois na impressão da YOKI não deve conter a frase "cópia autenticada da GPS enviada ao Prestador do Serviço"
        // TOCADO CODIGO DO CLIENTE POR DESCRIÇÃO - LIZANDRA - 08/11/13
		IF TMP1->A1_NOME $ "YOKI"
			Li+=50
			oPrn:Say (Li,110, "Em conformidade com a legislação previdenciária a assistência técnica se equivale a Cessão de Mão de Obra e", oFont3)
			Li+=50
			oPrn:Say (Li,110, "consequentemente há necessidade da retenção por parte do Tomador do Serviço de 11% de INSS, que deve ser", oFont3)
			Li+=50
			oPrn:Say (Li,110, "recolhido dentro dos prazos legais.", oFont3) 
//		ELSE	
//			Li+=50
//			oPrn:Say (Li,110, "recolhido dentro dos prazos legais e a cópia autenticada da GPS enviada ao Prestador do Serviço.", oFont3) 
		EndIf
		//Ivandro Santos - 19/09/17 - Ticket#2017091937000036 — ACRÉSCIMO DE INFORMAÇÃO
			Li+=85
			oPrn:Say (Li,110, REPLICATE("_",98), oFont3)
			Li+=05
			oPrn:Say (Li,110, REPLICATE("_",98), oFont3)
			Li+=50
			oPrn:Say (Li,110, "NOTAS - ASSISTÊNCIA TÉCNICA:",oFont12 )
			ChecaLinha()
			Li+=85
			oPrn:Say (Li,110, "1)	É NECESSÁRIA A APROVAÇÃO OFICIAL RELATIVA À OFERTA PARA POSTERIOR DESLOCAMENTO DO TÉCNICO.", oFont3 )
			ChecaLinha()
			Li+=85
			oPrn:Say (Li,110, "2)	Os serviços técnicos deverão ser realizados no local de instalação, conforme estipulado no contrato de venda,", oFont3) 
			ChecaLinha()
			Li+=50
			oPrn:Say (Li,110, " sendo que, para qualquer alteração de roteiro haverá incidência de custos. ", oFont3) 
			ChecaLinha()
			Li+=50
			oPrn:Say (Li,110, "3)	Caso o cliente opte por realizar as reservas dos bilhetes aéreos, é obrigatório que os mesmos sejam emitidos em ", oFont3) 
			ChecaLinha()
			Li+=50
			oPrn:Say (Li,110, "dias úteis e horários comerciais (07:00 às 17:10h), no entanto, se por algum motivo não for possível, a Masipack ", oFont3) 
			ChecaLinha()
			Li+=50
			ChecaLinha()
			oPrn:Say (Li,110, "deverá ser  imediatamente informada, ficando assim, sujeito a aprovação.", oFont3) 
			ChecaLinha()
			Li+=50
			oPrn:Say (Li,110, "Para a reserva  da hospedagem, é importante que sejam consideradas as questões de Segurança, Conforto, Limpeza e ", oFont3) 
			ChecaLinha()
			Li+=50
			oPrn:Say (Li,110, "Privacidade, caso contrário, o técnico poderá buscar outra alternativa que, no mínimo,  atenda a esses quesitos de forma ", oFont3)
			ChecaLinha()
			Li+=50
			oPrn:Say (Li,110, "satisfatória. ", oFont3) 
			ChecaLinha()
			Li+=15
			oPrn:Say (Li,110, REPLICATE("_",98), oFont3)
			Li+=05
			oPrn:Say (Li,110, REPLICATE("_",98), oFont3)
		
		//Ticket#2017091937000036 — Fim da alteração
		ChecaLinha()		
		Li+=85
		oPrn:Say (Li,110, "NOTA: É necessária a aprovação oficial relativo à oferta para posterior deslocamento do técnico.", oFont3)
	Else
		oPrn:Say (Li,250, "INFORMAÇÕES COMPLEMENTARES", oFont1)
		Li+=100
		If TMP1->CJ_MSINCOT == "EXW"
			oPrn:Say (Li,110, "1) Preço EXWORKS - " + DET0027[_nEmp] + " - SP - Brazil. Embalagem, embarque  e  seguro  não estão", oFont3)
			ChecaLinha()
			Li+=50
			oPrn:Say (Li,130, "inclusos no preço dessa cotação. Despesas de transporte, serão determinadas no momento do embarque.", oFont3)
			ChecaLinha()
		EndIf
		Li+=80
		ChecaLinha()
		oPrn:Say (Li,110, "2) Amostras: A ", oFont3)
		Li-=5
		oPrn:Say (Li,430, "COMPRADORA, ", oFont2)
		Li+=5
		oPrn:Say (Li,830, "deverá  fornecer  amostras dos  produtos à serem embalados e do", oFont3)
		ChecaLinha()
		Li+=50
		oPrn:Say (Li,110, "material de embalagem à ser utilizado. Gentileza contatar nosso Depto. de Exportação/Importação através", oFont3)
		ChecaLinha()
		Li+=50
		oPrn:Say (Li,110, "do email " + DET0030[_nEmp] + ", fone (+55 11) " + DET0028[_nEmp] + " para maiores informações.", oFont3)
		Li+=80
		oPrn:Say (Li,110, "3) Idioma de informação operacional e documentação técnica: " + aIdiomaTC[IdiomaTC,Idioma], oFont3)
		Li+=80
		oPrn:Say (Li,110, "4) Origem: Brasil", oFont3)
		ChecaLinha()
		Li+=80
	EndIf
Else
	oPrn:Say (Li,110, DET0048[Idioma], oFont3)
EndIf
nTotLin := 2800
ChecaLinha()
Li+=100  
/*
If TMP1->A1_EST <> "EX"
	oPrn:Say (Li,110, DET0074[Idioma] + "  A", oFont3)
	Li-=5
	oPrn:Say (Li,380, "COMPRADORA, ", oFont2)
	Li+=5
	oPrn:Say (Li,750, DET0075[Idioma], oFont3)
	Li+=50
	oPrn:Say (Li,110, DET0076[Idioma], oFont3)
EndIf  */
Return

/***********************************/
Static Function ImpEspanhol()
/***********************************/
/*If TMP1->A1_PAIS $ 'ZA '
	ChecaLinha()
	Li+=70
	oPrn:Say (Li,110, "Beneficiary", oFont1)
	ChecaLinha()
	Li+=70
	oPrn:Say (Li,110, "MASIPACK IND. COM. MÁQUINAS AUTOMÁTICAS S/A", oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, "Rua Miragaia, No. 13 - Vila Paulicéia", oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110,"CEP: 09689-000 - São Bernardo do Campo - SP", oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, "Phone.:  0055 11 3246-3666", oFont3)
	Li+=70
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, "Bank Details: ", oFont1)
	Li+=10
	oPrn:Say (Li,670, "BANCO DO BRASIL S/A - São Paulo - Brazil", oFont3)
	Li+=50
	ChecaLinha()
	oPrn:Say (Li,670, "Account nº - Field 59 (mention): 0013357X0000100986 - SWIFT: BRASBRRJOCO - LEAD TIME ", oFont3)
	Li+=50
	ChecaLinha()
	oPrn:Say (Li,110, " ", oFont1)
	Li+=10
	oPrn:Say (Li,1150, " ", oFont3)
Else     */
	ChecaLinha()
	Li+=70
	oPrn:Say (Li,110, DET0025[Idioma], oFont1)
	ChecaLinha()
	Li+=70
	oPrn:Say (Li,110, DET0045[_nEmp], oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, _cEndEmp+" - CNPJ: "+_cCNPJEmp, oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, _cCepEmp + " - " + DET0027[_nEmp] + " - " + _cEstEmp + " - Brasil", oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, "Fone.: "+ DET0028[_nEmp] + ".", oFont3)
	Li+=70
	ChecaLinha()
	Li+=70
//Ivandro Santos - 27/01/17
//Ticket#2017012737000151 — Alterar Informação Relatorio Orçamentos
/*
	oPrn:Say (Li,110, DET0035[Idioma], oFont1)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, DET0034A[Idioma], oFont1)
	oPrn:Say (Li,670, DET0034B[Idioma], oFont3)
	Li+=50
	ChecaLinha()
	oPrn:Say (Li,110, DET0034C[Idioma], oFont1)
	oPrn:Say (Li,670, DET0034D[Idioma], oFont3)
	Li+=50
	ChecaLinha()
	oPrn:Say (Li,110, DET0034E[Idioma], oFont1)
	oPrn:Say (Li,670, DET0034F[Idioma], oFont3)
	Li+=50
	ChecaLinha()
	oPrn:Say (Li,110, DET0034G[Idioma], oFont1)
	oPrn:Say (Li,670, DET0034H[Idioma], oFont3)
	Li+=50
	ChecaLinha()
	oPrn:Say (Li,110, DET0034I[Idioma], oFont1)
	oPrn:Say (Li,670, DET0034J[Idioma], oFont3)
	Li+=50
	ChecaLinha()
	oPrn:Say (Li,110, DET0034K[Idioma], oFont1)
	oPrn:Say (Li,670, DET0034L[Idioma], oFont3)*/
//Ticket#2017012737000151 — Fim da alteração
	Li-=15
//EndIf
	
nTotLin := 2800
ChecaLinha()
Li+=100
oPrn:Say (Li,250, DET0062[Idioma], oFont1)
Li+=70
oPrn:Say (Li,110, Alltrim(TMP1->CJ_MSPRZEN) + DET0063[Idioma], oFont3)
Li+=50
oPrn:Say (Li,110, DET0064[Idioma], oFont3)
nTotLin := 3000
ChecaLinha()
Li+=100
oPrn:Say (Li,250, "GARANTIA", oFont1)
Li+=80

/*
oPrn:Say (Li,110, DET0069[Idioma], oFont3)
oPrn:Say (Li,250,Alltrim(STR(TMP1->CJ_MSGARAN)), oFont3)
oPrn:Say (Li,300, DET00691[idioma], oFont3)
*/
oPrn:Say (Li,110, DET0069[Idioma] + Alltrim(STR(TMP1->CJ_MSGARAN)) + DET00691[idioma], oFont3)

ChecaLinha()
Li+=100
nTotlin := 2750
ChecaLinha()
If TMP1->CJ_MSDIAS > 0   // texto apenas para orçamento espanhol
	oPrn:Say (Li,250, DET0070[Idioma], oFont1)
	Li+=70
	oPrn:Say (Li,110, "PERIODO: Será necesario ", oFont3)
	Li-=5
	oPrn:Say (Li,640, Str(mv_par03,2) + " técnico ", oFont2)
	Li+=5
	oPrn:Say (Li,880, "da " + DET0026[_nEmp] + " en un período de ", oFont3)
	Li-=5
	oPrn:Say (Li,1480, Alltrim(STR(TMP1->CJ_MSDIAS)) + " dias útiles", oFont2)
	Li+=5
	oPrn:Say (Li,1790, " para el montaje, start up,", oFont3)
	Li+=50
	oPrn:Say (Li,110, "testes y entrenamiento. Será requerido a el comprador proveer el personal técnico mecánico y eléctrico para ayudar el montaje.", oFont3)
	Li+=50
	//////////
	//oPrn:Say (Li,110,"Será requerido a el comprador proveer el personal técnico mecánico y eléctrico para montaje.",oFont3)
	//Li+=50
	//////////
	oPrn:Say (Li,110, "·", oFont12)
	If mv_par06 == 1  // Montagem inclusa no orçamento
		oPrn:Say (Li,140,"Para Montaje y Startup de los equipos durante el periodo citado arriba los costos ya están inclusos en el precio.", oFont3)
		Li+=50
  //		oPrn:Say (Li,140,"Serán cobradas solamente los custos extras y las horas extras (cuando ocurrir), es decir, no serán cobradas las", oFont3)
	//	Li+=50
	//	oPrn:Say (Li,140, "horas normales.", oFont3)
	Else
		oPrn:Say (Li,140,"Para el montaje y start up de los equipos serán cobrados todas las horas y todos los costos.", oFont3)
//		Li+=50
//		oPrn:Say (Li,140,"es decir, no serán cobradas las horas normales.", oFont3)
	EndIf
	Li+=70
	nTotLin := 2800
	ChecaLinha()
	oPrn:Say (Li,110, "CONDICIONES DE SERVICIO DE ASISTÊNCIA TÉCNICA PARA MONTAJE Y START UP:", oFont3)
	Li+=50
	oPrn:Say (Li,110, "Informamos abajo las condiciones para servicio de Asistência Técnica en el equipo " + DET0026[_nEmp] + ":", oFont3)
	Li+=50
	oPrn:Say (Li,110, "·", oFont12)
	oPrn:Say (Li,140, "Hora trabajada en días hábiles (lune hasta viermes) 08:00am hasta 05:00pm - $90,00 por hora", oFont3)
	Li+=50
//	ChecaLinha()
	oPrn:Say (Li,110, "·", oFont12)
	oPrn:Say (Li,140, "Hora Extra trabajada em dias hábiles entre las 5:00pm hasta 7:00pm - $110,00", oFont3)
	Li+=50
	oPrn:Say (Li,110, "·", oFont12)
	oPrn:Say (Li,140, "Hora Extra trabajada em dias hábiles después de las 7:00pm - $130,00", oFont3)
	Li+=50
	oPrn:Say (Li,110, "·", oFont12)
	oPrn:Say (Li,140, "Hora Extra trabajada en los dias festivos de Brasil, sábados y domingos - $130,00", oFont3)
	If mv_par06 == 2
		Li+=50
		oPrn:Say (Li,110, "·", oFont12)
		oPrn:Say (Li,140, "Hora viajada - $90,00", oFont3)
		Li+=50
		oPrn:Say (Li,110, "·", oFont12)
		oPrn:Say (Li,140, "Gastos diarios - $80,00", oFont3)
		Li+=50
		oPrn:Say (Li,110, "·", oFont12)
		oPrn:Say (Li,140, "Transportes (avión, taxi, transportes internos, etc.) - Costo real ", oFont3)
		Li+=50
		oPrn:Say (Li,110, "·", oFont12)
		oPrn:Say (Li,140, "Hotel - Costo real ", oFont3)
	EndIf
	Li+=85
	ChecaLinha()
	oPrn:Say (Li,110, "COBRANZA: La cobranza de los servicios acorrerá a 21DDL cuando del regreso de nuestro técnico a la planta de",oFont3)
	Li+=50
	oPrn:Say (Li,110, DET0026[_nEmp] + ".", oFont3)
	Li+=85
	nTotLin := 2900
	ChecaLinha()
	oPrn:Say (Li,110, "PROGRAMACIÓN:  La ", oFont3)
	Li-=5
	oPrn:Say (Li,560, "COMPRADORA ", oFont2)
	Li+=5
	oPrn:Say (Li,930, "deberá programar técnico con en el mínimo de 15 días antes para el", oFont3)
	Li+=50
	oPrn:Say (Li,110, "start up de  los  equipos,  enviando  un  email  para ", oFont3)
	oPrn:Say (Li,1140, DET0030[_nEmp], oFont11)
	oPrn:Say (Li,1700, " o  por telefóno, llamar a (55 11) 3246-3666", oFont3)
//	Li+=50
//	oPrn:Say (Li,110, DET0028[_nEmp] + " Extensión " + DET0029[_nEmp] + ".", oFont3)
	Li+=80
	nTotLin := 2800
	ChecaLinha()
	oPrn:Say (Li,110, "CONDICIÓN: En el  momento  que el  técnico  es  programado  para  el  montaje, la ", oFont3)
	Li-=5
	oPrn:Say (Li,1730, "COMPRADORA ", oFont2)
	Li+=5
	oPrn:Say (Li,2070, "deberá tener", oFont3)
	Li+=50
	oPrn:Say (Li,110, "todos  los  periféricos  necesarios  listos  para  la  instalación.  Ellos son:  alimentación  eléctrica  y  aire comprimido ", oFont3)
	Li+=50
	oPrn:Say (Li,110, "en el punto del  equipo, sistema  de  salida  de  aire (en caso de necesidad),  producto  a  ser  embalado  en  escala", oFont3)
	Li+=50
	oPrn:Say (Li,110, "continua de produción y material  de  embalaje   impreso (si la máquina es una empaquetadora). Si  hay  retraso o", oFont3)
	Li+=50
	oPrn:Say (Li,110, "cancelación  del  servicio  por  parte  de la ", oFont3)
	Li-=5
	oPrn:Say (Li,960, "COMPRADORA, ", oFont2)
	Li+=5
	oPrn:Say (Li,1340, "ella  deberá   contactar  a  la  Asistencia  Técnica", oFont3)
	Li+=50
	oPrn:Say (Li,110, DET0026[_nEmp] + " hacer la negociación de un nuevo montaje.", oFont3)
	Li+=60
	nTotLin := 2900
	ChecaLinha()
Else
	oPrn:Say (Li,110, DET0048[Idioma], oFont3)
EndIf
Li+=100
nTotLin := 2800
ChecaLinha()
oPrn:Say (Li,250, DET0065[Idioma], oFont1)
Li+=100
If TMP1->CJ_MSINCOT == "EXW"
	oPrn:Say (Li,110, DET0066[Idioma], oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,130, DET0067[Idioma], oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,130, DET0068[Idioma], oFont3)
	Li+=100
	oPrn:Say (Li,150, "Es de responsabilidad de la ", oFont3)
	Li-=5
	oPrn:Say (Li,710, "COMPRADORA ", oFont2)
	Li+=5
	oPrn:Say (Li,1050, " indicar a la ", oFont3)
	Li-=5
	oPrn:Say (Li,1300, "VENDEDORA, ", oFont2)
	Li+=5
	oPrn:Say (Li,1630, "con 30 dias de anticipo, el agente", oFont3)
	Li+=50
	oPrn:Say (Li,150, "transportista.", oFont3)
ElseIf TMP1->CJ_MSINCOT == "FOB"
	Li+=80
	oPrn:Say (Li,110, "1)  Precio " + '"' + "FOB - Puerto de Santos - SP - Brazil" + '"' + ", valores de flete internacional, seguro internacional Y embalaje", oFont3)
	Li+=50
	oPrn:Say (Li,130, "(por cuenta del cliente) no están contidos en el precio de este presupesto, serán determinados en el momento", oFont3)
	Li+=50
	oPrn:Say (Li,130, "del embarque.", oFont3)
	Li+=100
	oPrn:Say (Li,150, "Es de responsabilidad de la ", oFont3)
	Li-=5
	oPrn:Say (Li,710, "COMPRADORA ", oFont2)
	Li+=5
	oPrn:Say (Li,1050, " indicar a la ", oFont3)
	Li-=5
	oPrn:Say (Li,1300, "VENDEDORA, ", oFont2)
	Li+=5
	oPrn:Say (Li,1630, "con 30 dias de anticipo, el agente", oFont3)
	Li+=50
	oPrn:Say (Li,150, "transportista.", oFont3)
ElseIf TMP1->CJ_MSINCOT == "CFR"
	Li+=80
	oPrn:Say (Li,110, "1)  Precio " + '"' + "CFR - " + Alltrim(TMP1->CJ_MSINCOL) + '"' + ", seguro y embalaje (por cuenta del cliente) no están", oFont3)
	Li+=50
	oPrn:Say (Li,130, "contidos en el precio de este presupuesto.", oFont3)
ElseIf TMP1->CJ_MSINCOT == "CIF"
	Li+=80
	oPrn:Say (Li,110, "1)  Precio " + '"' +  "CIF - " + Alltrim(TMP1->CJ_MSINCOL) + '"' + ", valores de flete, seguro y embalaje por cuenta del " + DET0026[_nEmp],oFont3)
	Li+=50
	oPrn:Say (Li,130, "están contidos en el precio de este presupuesto.", oFont3)
ElseIf TMP1->CJ_MSINCOT == "CIP"
	Li+=80
	oPrn:Say (Li,110, "1)  Precio " + '"' + "CIP - " + Alltrim(TMP1->CJ_MSINCOL) + '"' + ", valores de flete, seguro y embalaje por cuenta del " + DET0026[_nEmp], oFont3)
	Li+=50
	oPrn:Say (Li,130, "están contidos en el precio de este presupuesto.", oFont3)
ElseIf TMP1->CJ_MSINCOT == "FCA"
	Li+=80
	oPrn:Say (Li,110, "1)  Precio " + '"' + "FCA - " + DET0026[_nEmp] + " - SP - Brazil, valores de flete, seguro Y embalaje (por cuenta del cliente) no", oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,130, "    están contidos en el precio de este presupuesto, serán determinados en el momento del embarque", oFont3)
ElseIf TMP1->CJ_MSINCOT == "DDU"
	Li+=80
	oPrn:Say (Li,110, "1)  Precio " + '"' + "DDU - " + Alltrim(TMP1->CJ_MSINCOL) + '"' + ", todos los costos incluyedos hasta la fabrica del cliente", oFont3)
	Li+=50
	oPrn:Say (Li,130, "excepto los impuestos. El embalaje (por cuenta del cliente) no están contidos en el precio de este presupuesto.", oFont3)
ElseIf TMP1->CJ_MSINCOT == "DDP"
	Li+=80
	oPrn:Say (Li,110, "1)  Precio " + '"' + "DDP - " + Alltrim(TMP1->CJ_MSINCOL) + '"' + ", todos los costos incluyedos hasta la fabrica del cliente", oFont3)
	Li+=50
	oPrn:Say (Li,130, "El embalaje (por cuenta del cliente) no están contidos en el precio de este presupuesto.", oFont3)
EndIf

ChecaLinha()
Li+=80
oPrn:Say (Li,110, DET0072[Idioma], oFont3)
ChecaLinha()
Li+=50
oPrn:Say (Li,130, DET0073[Idioma], oFont3)
ChecaLinha()
Li+=50
oPrn:Say (Li,130, DET0074[Idioma], oFont3)
ChecaLinha()
Li+=80
oPrn:Say (Li,110, DET0075[Idioma], oFont3)
ChecaLinha()
Li+=50
oPrn:Say (Li,130, DET0076[Idioma], oFont3)
ChecaLinha()
Li+=80
oPrn:Say (Li,110, DET0077[Idioma] + aIdiomaTC[IdiomaTC,Idioma], oFont3)
ChecaLinha()
Li+=80
oPrn:Say (Li,110, DET0078[Idioma], oFont3)

If TMP1->A1_PAIS == "AR"
	ChecaLinha()
	Li+=100
	oPrn:Say (Li,110, "ITEM PARA ARGENTINA:", oFont3)
	Li+=50
	oPrn:Say (Li,250, "8)  Arancel de importación: 0,00 % (Mercosul), I.V.A.: 10,50 % (declarado como bien de uso)", oFont3)
EndIf
Return

/********************************/
Static Function ImpIngles()
/********************************/

/*If TMP1->A1_PAIS $ 'ZA '
	ChecaLinha()
	Li+=70
	oPrn:Say (Li,110, "Beneficiary", oFont1)
	ChecaLinha()
	Li+=70
	oPrn:Say (Li,110, "MASIPACK IND. COM. MÁQUINAS AUTOMÁTICAS S/A", oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, "Rua Miragaia, No. 13 - Vila Paulicéia", oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110,"CEP: 09689-000 - São Bernardo do Campo - SP", oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, "Phone.:  0055 11 3246-3666", oFont3)
	Li+=70
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, "Bank Details: ", oFont1)
	Li+=10
	oPrn:Say (Li,670, "BANCO DO BRASIL S/A - São Paulo - Brazil", oFont3)
	Li+=50
	ChecaLinha()
	oPrn:Say (Li,670, "Account nº - Field 59 (mention): 0013357X0000100986 - SWIFT: BRASBRRJOCO - LEAD TIME ", oFont3)
	Li+=50
	ChecaLinha()
	oPrn:Say (Li,110, " ", oFont1)
	Li+=10
	oPrn:Say (Li,1150, " ", oFont3)
	Li-=15
Else */
	ChecaLinha()
	Li+=70
	oPrn:Say (Li,110, DET0025[Idioma], oFont1)
	ChecaLinha()
	Li+=70
	oPrn:Say (Li,110, DET0045[_nEmp], oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, _cEndEmp+" - CNPJ: "+_cCNPJEmp, oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, _cCepEmp + " - " + DET0027[_nEmp] + " - " + _cEstEmp + " - Brasil", oFont3)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, "Fone.: "+ DET0028[_nEmp] + ".", oFont3)
	Li+=70
	ChecaLinha()
//Ivandro Santos - 27/01/2017
//Ticket#2017012737000151 — Alterar Informação Relatorio Orçamentos
/*
	Li+=10
	oPrn:Say (Li,110, DET0035[Idioma], oFont1)
	ChecaLinha()
	Li+=50
	oPrn:Say (Li,110, DET0034A[Idioma], oFont1)
	oPrn:Say (Li,670, DET0034B[Idioma], oFont3)
	Li+=50
	ChecaLinha()
	oPrn:Say (Li,110, DET0034C[Idioma], oFont1)
	oPrn:Say (Li,670, DET0034D[Idioma], oFont3)
	Li+=50
	ChecaLinha()
	oPrn:Say (Li,110, DET0034E[Idioma], oFont1)
	oPrn:Say (Li,670, DET0034F[Idioma], oFont3)
	Li+=50
	ChecaLinha()
	oPrn:Say (Li,110, DET0034G[Idioma], oFont1)
	oPrn:Say (Li,670, DET0034H[Idioma], oFont3)
	Li+=50
	ChecaLinha()
	oPrn:Say (Li,110, DET0034I[Idioma], oFont1)
	oPrn:Say (Li,670, DET0034J[Idioma], oFont3)
	Li+=50
	ChecaLinha()
	oPrn:Say (Li,110, DET0034K[Idioma], oFont1)
	oPrn:Say (Li,670, DET0034L[Idioma], oFont3)    */
//Ticket#2017012737000151 — Fim da alteração
	Li-=15
//EndIf

ChecaLinha()
Li+=100
oPrn:Say (Li,250, DET0060[Idioma], oFont1)
ChecaLinha()
Li+=70
/* tirado em 111/12/15 (Lizandra) a pedido do comercial - Rose
If TMP1->CJ_CLIENTE == '000039'
	oPrn:Say (Li,110, Alltrim(TMP1->CJ_MSPRZEN) + DET00611[Idioma], oFont3)
Else
*/
	oPrn:Say (Li,110, Alltrim(TMP1->CJ_MSPRZEN) + DET0061[Idioma], oFont3)
//EndIf
nTotLin := 2800
ChecaLinha()
Li+=50
oPrn:Say (Li,110, DET0062[Idioma], oFont3)
Li+=50
oPrn:Say (Li,110, DET0063[Idioma], oFont3)
Li+=50
oPrn:Say (Li,110, DET0064[Idioma], oFont3)
nTotLin := 2800
ChecaLinha()
Li+=100
oPrn:Say (Li,250, "WARRANTY", oFont1)
Li+=80
oPrn:Say (Li,110, DET0069[Idioma], oFont3)
Li+=50
oPrn:Say (Li,110, DET0071[Idioma], oFont3)
Li+=100
nTotlin := 2800
ChecaLinha()
ChecaLinha()
If TMP1->CJ_MSDIAS > 0   // texto apenas para orçamento ingles
	IF _cPaisA .And. MV_PAR11 == 1
		oPrn:Say (Li,250, DET0070[Idioma], oFont1)
		Li+=80
		oPrn:Say (Li,110, "ASSEMBLY AND START UP: It will be necessary ", oFont3)
		oPrn:Say (Li,1035, Str(mv_par03,2) + " " + DET0026[_nEmp] + " technician", oFont2)
		oPrn:Say (Li,1550,"for a period of ", oFont3)
		oPrn:Say (Li,1830, Alltrim(STR(TMP1->CJ_MSDIAS)) + " working days", oFont2)
		Li+=50
		oPrn:Say (Li,110, "for the  assembly, start-up and training. Its under responsibility of Purchaser to provide mechanical and electrical  ", oFont3)
		Li+=50
		//////////
		oPrn:Say (Li,110," technicians to aid for machine assembly.",oFont3)
		Li+=50
		//////////
		nTotLin := 2750
		ChecaLinha()
		oPrn:Say (Li,110, "WORKING TIME: Monday to Friday, from 07:30am to 16:30pm with 1 hour break for a meal. ", oFont3)
		Li+=50
		oPrn:Say (Li,110, "The costs with holidays, weekends and extra working hours out of this period will be charged under the aproval of the",oFont3)
		Li+=50
 		oPrn:Say (Li,110, "PURCHASER.", oFont2)
		Li+=50
		nTotLin := 2750
		ChecaLinha()
		oPrn:Say (Li,110, "COSTS FOR EQUIPMENT WITHIN THE WARRANTY PERIOD, START UP AND MAINTENANCE: This service ", oFont3)
		Li+=50
		oPrn:Say (Li,110, "will have a cost to the ",oFont3) 
		oPrn:Say (Li,580, "PURCHASER", oFont2)
		oPrn:Say (Li,840, "  of US$ 500.00 (five hundred dollars) per days per technician.", oFont3)
		Li+=50
		oPrn:Say (Li,110, "This value includes expenditures such as meals, during the period above considered.", oFont3)
		Li+=50
		nTotLin := 2900
		ChecaLinha()
		oPrn:Say (Li,110, "The costs with the transpostation ", oFont3)
		oPrn:Say (Li,780, "SELLER X PURCHASER ",oFont2) 
		oPrn:Say (Li,1300, ", may that be ground or air, will be in charge of the ", oFont3)
		Li+=50
		oPrn:Say (Li,110, "PURCHASER", oFont2)
		Li+=50
		oPrn:Say (Li,110, ". VAT not included.", oFont2)
		Li+=80
		oPrn:Say (Li,110, "PROGRAMMING:  The ", oFont3)
		oPrn:Say (Li,570, "PURCHASER", oFont2)
		oPrn:Say (Li,880, "should program a technician with at least 15 (Fifteen) days in advance for the ", oFont3)
		Li+=50
		oPrn:Say (Li,110, "equipaments start up, sending an email for rodolfo.almeida@masipack.com.br or calling (55 11) 3246-3666 Extension 121, 129 or 130.", oFont3)
		nTotLin := 2900
		ChecaLinha()
		Li+=50
		oPrn:Say (Li,110, "CONDITION: At the moment a technician is programmed for the assembly, the",oFont3)
		oPrn:Say (Li,1600," PURCHASER ",oFont2)
		oPrn:Say (Li,1900," must have all the ", oFont3)
		Li+=50
		oPrn:Say (Li,110, "necessary peripherals ready for intallation. ", oFont3)
		Li+=50
		oPrn:Say (Li,110, "They are: electrical in feed and compressed air on the equipment point, suction device (if necessary), product to be", oFont3)
		Li+=50
		oPrn:Say (Li,110, "packed in a continuous scale of production and material of packaging printed (in case of a packer machine). ",oFont3)
		Li+=50
		oPrn:Say (Li,110, "In case of delay or cancellation on ",oFont3)
		oPrn:Say (Li,780, "PURCHASER ",oFont2)
		oPrn:Say (Li,1050, " part, it should contact Masipack to negotiate a new assembly.", oFont3)
		Li+=50
	ELSE
		oPrn:Say (Li,250, DET0070[Idioma], oFont1)
		Li+=80
		oPrn:Say (Li,110, "ASSEMBLY AND START UP: It will be necessary " + Str(mv_par03,2) + " " + DET0026[_nEmp] + " technician for a period of " + Alltrim(STR(TMP1->CJ_MSDIAS)) + " working days for the  assembly,", oFont3)
		Li+=50
		oPrn:Say (Li,110, "start-up and training. Its under responsibility of Purchaser to provide mechanical and electrical technicians  for machine ", oFont3)
		Li+=50
		//////////
		oPrn:Say (Li,110," assembly.",oFont3)
		Li+=50
		//////////
		oPrn:Say (Li,110, "·", oFont12)
		If mv_par06 == 1  // Montagem inclusa no orçamento
			oPrn:Say (Li,140,"Expenses concerning assembly and start up of equipments during the period mentioned above are include in the price.", oFont3)
			Li+=50
			oPrn:Say (Li,140,"It will only be charged extra expenses and overtime (when occur), that is, office hours (07:00am to 05:00pm), won't be", oFont3)
			Li+=50
			oPrn:Say (Li,140,"charged.", oFont3)
		Else
			oPrn:Say (Li,140,"It will de charged all hours and all expenses.", oFont3)
//			Li+=50
//			oPrn:Say (Li,140,"charged.", oFont3)
		EndIf
		Li+=70
		nTotLin := 2750
		ChecaLinha()
		oPrn:Say (Li,110, "TECHNICAL SUPPORT SERVICE CONDITIONS FOR ASSEMBLY AND START UP:", oFont3)
		Li+=50
		oPrn:Say (Li,110, "We inform bellow the conditions to offer technical support in "+ DET0026[_nEmp] + "'s machines:", oFont3)
		Li+=50
		ChecaLinha()
		oPrn:Say (Li,110, "·", oFont12)
		oPrn:Say (Li,140, "Worked hours on Weekdays (Monday to Friday - 8:00 am until 5:00pm) - $90,00", oFont3)
		Li+=50
		ChecaLinha()
		oPrn:Say (Li,110, "·", oFont12)
		oPrn:Say (Li,140, "Overtime - Weekdays (Monday to Friday between 5:00pm until 7:00pm) - $110,00", oFont3)
		Li+=50
		oPrn:Say (Li,110, "·", oFont12)
		oPrn:Say (Li,140, "Overtime - Weekdays (Monday to Friday after 7:00pm) - $130,00", oFont3)
		Li+=50
		oPrn:Say (Li,110, "·", oFont12)
		oPrn:Say (Li,140, "Overtime Saturdays, Sundays and Holidays - $130,00", oFont3)
		If mv_par06 == 2
			Li+=50
			oPrn:Say (Li,110, "·", oFont12)
			oPrn:Say (Li,140, "Traveled hour - $80,00", oFont3)
			Li+=50
			oPrn:Say (Li,110, "·", oFont12)
			oPrn:Say (Li,140, "Daily (expenses) - $80,00", oFont3)
			Li+=50
			oPrn:Say (Li,110, "·", oFont12)
			oPrn:Say (Li,140, "Transportation (plane, taxi, internal transport, etc.) - Real Cost ", oFont3)
			Li+=50
			oPrn:Say (Li,110, "·", oFont12)
			oPrn:Say (Li,140, "Hotel - Real Cost ", oFont3)
		EndIf
		Li+=70
		oPrn:Say (Li,110, "Note 1: The payment term is 21DDL when our technician returns to " + DET0026[_nEmp] + "'s plants.", oFont3)
		Li+=70
		oPrn:Say (Li,110, "Note 2: For permission of the departure of the technician to your company, please fill out the form and return by", oFont3)
		Li+=50
		oPrn:Say (Li,110, "e-mail your agreement.", oFont3)
		Li+=85
		nTotLin := 2900
		ChecaLinha()
		oPrn:Say (Li,110, "PROGRAMMING:  The ", oFont3)
		Li-=5
		oPrn:Say (Li,570, "PURCHASER", oFont2)
		Li+=5
		oPrn:Say (Li,880, "must shedule a techinician 15 days prior to the equipment start up date,", oFont3)
		Li+=50
		oPrn:Say (Li,110, "sending an email to ", oFont3)
		oPrn:Say (Li,610, DET0030[_nEmp], oFont11)
		oPrn:Say (Li,1130, "or calling (55 11) 3246-3666. ", oFont3)
		Li+=80
		nTotLin := 2800
		ChecaLinha()
		oPrn:Say (Li,110, "CONDITION: When the technician is scheduled for the assembly, the ", oFont3)
		Li-=5
		oPrn:Say (Li,1460, "PURCHASER ", oFont2)
		Li+=5
		oPrn:Say (Li,1770, "must have all the acessories", oFont3)
		Li+=50
		oPrn:Say (Li,110, "and devices ready  for the instalattion. They are: electrical and  compressed air  feeding in the equipment location,",oFont3)
		Li+=50
		oPrn:Say (Li,110, "exhaustion system (when necessary), product  to be  packed in a continuous production line and printed packaging", oFont3)
		Li+=50
		oPrn:Say (Li,110, "material (for the packaging machines). If there is any kind of delay or cancelling  by the", oFont3)
		Li-=5
		oPrn:Say (Li,1800, "PURCHASER,", oFont2)
		Li+=5
		oPrn:Say (Li,2110, "the person", oFont3)
		Li+=55
		oPrn:Say (Li,110, "responsible must contat " + DET0026[_nEmp] + " Technical Assistance for a new negotation of the assembly.", oFont3)
		Li+=60
	ENDIF
Else
	oPrn:Say (Li,110, DET0048[Idioma], oFont3)
EndIf
ChecaLinha()
Li+=80
oPrn:Say (Li,250, DET0065[Idioma], oFont1)
If TMP1->CJ_MSINCOT == "EXW"
	Li+=80
	oPrn:Say (Li,110, DET0066[Idioma], oFont3)
	Li+=50
	oPrn:Say (Li,130, DET0067[Idioma], oFont3)
	Li+=50
	oPrn:Say (Li,130, DET0068[Idioma], oFont3)
ElseIf TMP1->CJ_MSINCOT == "FOB"
	Li+=80
	oPrn:Say (Li,110, "1)  Price " + '"' + "FOB - Santos Port - SP - Brazil" + '"' + ", International freight, International Insurance and packaging is under", oFont3)
	Li+=50
	oPrn:Say (Li,130, "customer responsibility and are not included in this price.", oFont3)
	Li+=100
	oPrn:Say (Li,130, "Buyer should inform seller within 30 days before the equipment get ready and the appropriate freitht forwarder.", oFont3)
ElseIf TMP1->CJ_MSINCOT == "CFR"
	Li+=80
	oPrn:Say (Li,110, "1)  Price " + '"' + "CFR - " + Alltrim(TMP1->CJ_MSINCOL) + '"' + ", insurance is under customer", oFont3)
	//oPrn:Say (Li,110, "1)  Price " + '"' + "CFR - " + Alltrim(TMP1->CJ_MSINCOL) + '"' + ", insurance and packaging is under customer", oFont3) //-Alterado a pedido da Graziei_Comercial - 20/05/16
	Li+=50
	oPrn:Say (Li,130, "responsibility and are not included in this price.", oFont3)
ElseIf TMP1->CJ_MSINCOT == "CIF"
	Li+=80
	oPrn:Say (Li,110, "1)  Price " + '"' + "CIF - " + Alltrim(TMP1->CJ_MSINCOL) + '"' + ", all costs included and under " + DET0026[_nEmp] + " responsibility.", oFont3)
ElseIf TMP1->CJ_MSINCOT == "CIP"
	Li+=80
	oPrn:Say (Li,110, "1)  Price " + '"' + "CIP - " + Alltrim(TMP1->CJ_MSINCOL) + '"' + ", all costs included and under "+ DET0026[_nEmp] + " responsibility.", oFont3)
ElseIf TMP1->CJ_MSINCOT == "DDU"
	Li+=80
	oPrn:Say (Li,110, "1)  Price " + '"' + "DDU - " + Alltrim(TMP1->CJ_MSINCOL) + '"' + ", all costs included except duties. Packaging is under", oFont3)
	Li+=50
	oPrn:Say (Li,130, "customer responsibility and are not included in this price.", oFont3)
ElseIf TMP1->CJ_MSINCOT == "DDP"
	Li+=80
	oPrn:Say (Li,110, "1)  Price " + '"' + "DDP - " + Alltrim(TMP1->CJ_MSINCOL) + '"' + ", all costs included. Packaging is under customer", oFont3)
	Li+=50
	oPrn:Say (Li,130, "responsibility and are not included in this price.", oFont3)
EndIf
ChecaLinha()
Li+=80
oPrn:Say (Li,110, DET0074[Idioma], oFont3)
ChecaLinha()
Li+=50
oPrn:Say (Li,130, DET0075[Idioma], oFont3)
ChecaLinha()
Li+=50
oPrn:Say (Li,130, DET0076[Idioma], oFont3)
ChecaLinha()
Li+=80
oPrn:Say (Li,110, DET0077[Idioma] + aIdiomaTC[IdiomaTC,Idioma], oFont3)
ChecaLinha()
Li+=80
oPrn:Say (Li,110, DET0078[Idioma], oFont3)
Return

/******************************/
Static Function ChecaLinha()
/******************************/
If Li > nTotLin
	nPag++
	If nPag > 1
		Li:=3200
		oPrn:Say (Li,110, DET0047, oFont2)
		Li+=55
		oPrn:Say (Li,110, DET0006[Idioma] + TMP1->CJ_ORCAM + " - " + TMP1->A1_NOME, oFont2)
		oPrn:Say (Li,2100, STR(nPag), oFont3)
		Li+=50
		oPrn:Say (Li,110, DET0045[_nEmp], oFont3)
	EndIf
	oPrn:EndPage()
	oPrn:StartPage()
	Li:=100
	If nVezes > 0
		oPrn:Say (Li,0100, DET0047,oFont2)
		Li+=50
	EndIf
Endif

Return