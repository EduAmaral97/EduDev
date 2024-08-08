//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
 

/*

Descricao: Fonte para apresentação da legenda da rotina em MVC
Data: 02/08/2024
Autor: Eduardo Amaral

*/

User Function ZLEGMEDTELA()

    Local aLegenda := {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",      "Tipo de despesa - Combustivel"})
    AADD(aLegenda,{"BR_VERMELHO",   "Tipo de despesa - Guincho"})
    AADD(aLegenda,{"BR_AZUL",       "Tipo de despesa - Rastreador"})
    AADD(aLegenda,{"BR_BRANCO",     "Tipo de despesa - Outros"})
     
    BrwLegenda(" Medicar - Lançamento de Despesas Frotas", "Lancamento de Despesas Frotas", aLegenda)

Return
