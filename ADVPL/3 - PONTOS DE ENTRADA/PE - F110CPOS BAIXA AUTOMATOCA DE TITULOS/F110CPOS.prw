#Include "Totvs.ch"

User Function F110CPOS()
	
	Local aCmp := ParamIxb
	Local cExibe := "E1_OK|E1_FILIAL|E1_PREFIXO|E1_NUM|E1_TIPO|E1_CLIENTE|E1_NOMCLI|E1_EMISSAO|E1_VENCTO|E1_VENCREA|E1_ZZFORPG|E1_VALOR|E1_SALDO"
	Local aRet := {}
	Local nI := 0
	
	//Ordena o Array por Nome (Array multidimensional) - Crescente usa < e Decrescente usa >
    //aSort(aCmp, , , {|x, y| x[1] < y[1]})
	
	//Alert("Chamou PE")
	
	For ni := 1 to Len(aCmp)
		If Alltrim(aCmp[nI][1]) $ cExibe
			Aadd(aRet, aCmp[nI])
		EndIf
	Next ni

Return aRet
