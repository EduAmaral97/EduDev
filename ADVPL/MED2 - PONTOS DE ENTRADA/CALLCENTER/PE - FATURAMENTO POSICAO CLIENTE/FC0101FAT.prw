#include "protheus.ch"


User Function FC0101FAT()

	Local aCpos := aClone(ParamIxb[1])
	
	AAdd(aCpos,"E1_PLNUCOB")
	AAdd(aCpos,"E1_PEDIDO")
	AAdd(aCpos,"E1_SUBCON")
	AAdd(aCpos,"BQC_ANTCON")
	AAdd(aCpos,"BT5_NOME")
	
Return aCpos
