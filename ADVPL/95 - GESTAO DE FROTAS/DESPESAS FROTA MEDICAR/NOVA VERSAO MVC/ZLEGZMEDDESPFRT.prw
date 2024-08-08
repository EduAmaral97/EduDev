//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
 

/*

Descricao: Fonte para apresentação da legenda da rotina em MVC
Data: 02/08/2024
Autor: Eduardo Amaral

*/

User Function ZLEGZMEDDESPFRT()

    Local aLegenda := {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",      "Pedido não Gerado"})
    AADD(aLegenda,{"BR_AZUL",       "Pedido Gerado"})
    
     
    BrwLegenda(" Medicar - Lançamento de Despesas Frotas", "Lancamento de Despesas Frotas", aLegenda)

Return
