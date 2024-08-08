//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
 

/*

Descricao: Fonte para apresenta��o da legenda da rotina em MVC
Data: 02/08/2024
Autor: Eduardo Amaral

*/

User Function ZLEGZMEDDESPFRT()

    Local aLegenda := {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",      "Pedido n�o Gerado"})
    AADD(aLegenda,{"BR_AZUL",       "Pedido Gerado"})
    
     
    BrwLegenda(" Medicar - Lan�amento de Despesas Frotas", "Lancamento de Despesas Frotas", aLegenda)

Return
