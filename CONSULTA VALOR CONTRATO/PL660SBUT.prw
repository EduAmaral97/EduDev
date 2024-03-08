#include 'protheus.ch'

User Function PL660SBUT()

Local aRet := {} 
aadd(aRet,{"POSCLI"  ,{||U_RESUMOCONTATO() }, "CLIQUE PARA VERIFICAR O RESUMO DO CONTRATO","RESUMO CONTRATO"})


Return (aRet)
