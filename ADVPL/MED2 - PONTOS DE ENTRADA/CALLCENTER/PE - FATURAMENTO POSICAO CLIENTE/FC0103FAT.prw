#include "protheus.ch"

User Function FC0103FAT()

Local cAliasTmp := ParamIxb[1]
Local cAliasQry := ParamIxb[2]

	Reclock(cAliasTmp,.F.)
		
		(cAliasTmp)->E1_PLNUCOB 	:= (cAliasQry)->E1_PLNUCOB
		(cAliasTmp)->E1_PEDIDO		:= (cAliasQry)->E1_PEDIDO
		(cAliasTmp)->E1_SUBCON		:= (cAliasQry)->IDCONTRATO
		(cAliasTmp)->BQC_ANTCON		:= (cAliasQry)->NRCONTRATO
		(cAliasTmp)->BT5_NOME		:= (cAliasQry)->PERFIL
	
	(cAliasTmp)->(MsUnlock())


	//ORDENA POR EMISSAO
	IF DBOrderInfo(7) != "t1index1"

		//ORDERNA POR EMISSAO
		(cAliasTmp)->(DBCreateIndex("T1INDEX1", "F2_EMISSAO"            , {|| DTOS(F2_EMISSAO)            }))
		DBSetOrder(1)
	
	Endif



Return
