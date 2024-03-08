#INCLUDE 'protheus.ch'


User Function PL660SBUT()

Local aRet := {} 

aadd(aRet,{"IMPBENEF"  ,{|| U_MEDADP() },"Importador Medicar","Importador Medicar"})
aadd(aRet,{""  ,{|| U_RESUMOCONTATO() }, "Resumo Contrato","Resumo Contrato"})

Return (aRet)

