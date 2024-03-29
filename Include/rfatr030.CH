#IFDEF SPANISH
	#define STR0001  "Relacion de los Pedidos no entregados"
	#define STR0002  "Este programa emitira la relacion de los Pedidos Pendientes,"
	#define STR0003  "imprimiendo el numero del Pedido, Cliente, Fecha de la Entrega, "
	#define STR0004  "Ctd. pedida, Ctd ya entregada, Saldo del Producto y atraso."
	#define STR0005  "A Rayas"
	#define STR0006  "Administracion" 
	#define STR0007  "Por pedido"
	#define STR0008  "Por producto"
	#define STR0009  "Por cliente"
	#define STR0010  "Por fch.entrega" 
	#define STR0011  "PEDIDO LIB.DE   C L I E N T E          PAIS         VENDEDOR      GARANT. VISITA MULTA  PED. DO   CONF. ENCOMENDA  DATA     PRAZO    PREVISAO IT PRODUTO         DESCRICAO                           QTDE.   "
	#define STR0012  "       VENDAS                                                     (meses)               CLIENTE   NUMERO     DATA  CONCL.            ENTREGA                                                                 "
	#define STR0013  "PRODUTO         DESCRICAO                          QTDE.  PRAZO    PREVISAO  PEDIDO     LIB.DE   C L I E N T E           PAIS         VENDEDOR     GARANT. VISITA MULTA  PED. DO   CONF. ENCOMENDA  DATA DE  "
	#define STR0014  "                                                                   ENTREGA              VENDAS                                                     (meses)               CLIENTE   NUMERO     DATA  CONCL.   "
	#define STR0015  "Selecionando Registros..."
	#define STR0016  "C L I E N T E          PAIS         VENDEDOR     PEDIDO  LIB.DE   GARANT. VISITA MULTA  PED. DO   CONF. ENCOMENDA  DATA     PRAZO    PREVISAO IT PRODUTO         DESCRICAO                           QTDE.   "
	#define STR0017  "                                                         VENDAS   (meses)               CLIENTE   NUMERO     DATA  CONCL.            ENTREGA                                                                 "
	#define STR0018  "Por Data de Entrega"
	#define STR0019  "PRAZO    PREVISAO  PEDIDO  LIB.DE    C L I E N T E          PAIS         VENDEDOR    GARANT. VISITA MULTA PED. DO   CONF. ENCOMENDA  DATA     IT PRODUTO         DESCRICAO                           QTDE.   "
	#define STR0020  "         ENTREGA           VENDAS                                                    (meses)              CLIENTE   NUMERO     DATA  CONCL.                                                                  "
	#define STR0021  "CANCELADO PELO OPERADOR"
	#define STR0022  "Por Vendedor"
	#define STR0023  "VENDEDOR    C L I E N T E           PAIS         PEDIDO  LIB.DE  GARANT. VISITA MULTA  PED. DO    CONF. ENCOMENDA  DATA     PRAZO    PREVISAO IT PRODUTO         DESCRICAO                           QTDE.   "
	#define STR0024  "                                                         VENDAS  (meses)               CLIENTE    NUMERO     DATA  CONCL.            ENTREGA                                                                 "
#ELSE
	#IFDEF ENGLISH
	    #define STR0001  "List of Undelivered Products  "
	    #define STR0002  "This program will print the Pending Orders list, showing "
		#define STR0003  "the number of the Order, Customer, Delivery Date, Quantity"
		#define STR0004  "Ordered, Quantity Delivered, Product Balance and Delay.  "
		#define STR0005  "Z.Form "
		#define STR0006  "Management   "
		#define STR0007  "By Order "
		#define STR0008  "By Product"
		#define STR0009  "By Client "
		#define STR0010  "By Delivery Dt"
		#define STR0011  "PEDIDO LIB.DE   C L I E N T E          PAIS         VENDEDOR      GARANT. VISITA MULTA  PED. DO   CONF. ENCOMENDA  DATA     PRAZO    PREVISAO IT PRODUTO         DESCRICAO                           QTDE.   "
		#define STR0012  "       VENDAS                                                     (meses)               CLIENTE   NUMERO     DATA  CONCL.            ENTREGA                                                                 "
		#define STR0013  "PRODUTO         DESCRICAO                          QTDE.  PRAZO    PREVISAO  PEDIDO     LIB.DE   C L I E N T E           PAIS         VENDEDOR     GARANT. VISITA MULTA  PED. DO   CONF. ENCOMENDA  DATA DE  "
		#define STR0014  "                                                                   ENTREGA              VENDAS                                                     (meses)               CLIENTE   NUMERO     DATA  CONCL.   "
		#define STR0015  "Selecionando Registros..."
		#define STR0016  "C L I E N T E          PAIS         VENDEDOR     PEDIDO  LIB.DE   GARANT. VISITA MULTA  PED. DO   CONF. ENCOMENDA  DATA     PRAZO    PREVISAO IT PRODUTO         DESCRICAO                           QTDE.   "
		#define STR0017  "                                                         VENDAS   (meses)               CLIENTE   NUMERO     DATA  CONCL.            ENTREGA                                                                 "
		#define STR0018  "Por Data de Entrega"
		#define STR0019  "PRAZO    PREVISAO  PEDIDO  LIB.DE    C L I E N T E          PAIS         VENDEDOR    GARANT. VISITA MULTA PED. DO   CONF. ENCOMENDA  DATA     IT PRODUTO         DESCRICAO                           QTDE.   "
		#define STR0020  "         ENTREGA           VENDAS                                                    (meses)              CLIENTE   NUMERO     DATA  CONCL.                                                                  "
		#define STR0021  "CANCELADO PELO OPERADOR"
		#define STR0022  "Por Vendedor"
		#define STR0023  "VENDEDOR    C L I E N T E           PAIS         PEDIDO  LIB.DE  GARANT. VISITA MULTA  PED. DO    CONF. ENCOMENDA  DATA     PRAZO    PREVISAO IT PRODUTO         DESCRICAO                           QTDE.   "
		#define STR0024  "                                                         VENDAS  (meses)               CLIENTE    NUMERO     DATA  CONCL.            ENTREGA                                                                 "
 #ELSE
		#define STR0001  "Relacao de Pedidos nao entregues"
		#define STR0002  "Este programa ira emitir a relacao dos Pedidos Pendentes,"
		#define STR0003  ""
		#define STR0004  ""
		#define STR0005  "Zebrado"
		#define STR0006  "Administracao"
		#define STR0007  "Por Pedido"
		#define STR0008  "Por Produto"
		#define STR0009  "Por Cliente"
		#define STR0010  "Por Dt.Entrega"
        #define STR0011  "PEDIDO LIB.DE   C L I E N T E          PAIS         VENDEDOR      GARANT. VISITA MULTA  PED. DO   CONF. ENCOMENDA  DATA     PRAZO    PREVISAO IT PRODUTO         DESCRICAO                           QTDE.   "
        #define STR0012  "       VENDAS                                                     (meses)               CLIENTE   NUMERO     DATA  CONCL.            ENTREGA                                                                 "
        #define STR0013  "PRODUTO         DESCRICAO                          QTDE.  PRAZO    PREVISAO  PEDIDO     LIB.DE   C L I E N T E           PAIS         VENDEDOR     GARANT. VISITA MULTA  PED. DO   CONF. ENCOMENDA  DATA DE  "
        #define STR0014  "                                                                   ENTREGA              VENDAS                                                     (meses)               CLIENTE   NUMERO     DATA  CONCL.   "
        #define STR0015  "Selecionando Registros..."
        #define STR0016  "C L I E N T E          PAIS         VENDEDOR     PEDIDO  LIB.DE   GARANT. VISITA MULTA  PED. DO   CONF. ENCOMENDA  DATA     PRAZO    PREVISAO IT PRODUTO         DESCRICAO                           QTDE.   "
        #define STR0017  "                                                         VENDAS   (meses)               CLIENTE   NUMERO     DATA  CONCL.            ENTREGA                                                                 "
        #define STR0018  "Por Data de Entrega"
        #define STR0019  "PRAZO    PREVISAO  PEDIDO  LIB.DE    C L I E N T E          PAIS         VENDEDOR    GARANT. VISITA MULTA PED. DO   CONF. ENCOMENDA  DATA     IT PRODUTO         DESCRICAO                           QTDE.   "
        #define STR0020  "         ENTREGA           VENDAS                                                    (meses)              CLIENTE   NUMERO     DATA  CONCL.                                                                  "
        #define STR0021  "CANCELADO PELO OPERADOR"
        #define STR0022  "Por Vendedor"
        #define STR0023  "VENDEDOR    C L I E N T E           PAIS         PEDIDO  LIB.DE  GARANT. VISITA MULTA  PED. DO    CONF. ENCOMENDA  DATA     PRAZO    PREVISAO IT PRODUTO         DESCRICAO                           QTDE.   "
        #define STR0024  "                                                         VENDAS  (meses)               CLIENTE    NUMERO     DATA  CONCL.            ENTREGA                                                                 "
	#ENDIF
#ENDIF
