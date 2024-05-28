#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FWBROWSE.CH'
#INCLUDE "FWMVCDEF.CH"
  
/*

CLIENTE: 046569 ou 060395 


PASSO 1 

Listagem de contratos Medicar  - Contratos do Cliente

*/

/* -------------------------- BROWSER DA ROTINA -------------------------- */

User Function ZMEDCTR()

 Local aIndex := {}
 Local aSeek := {}

  Private cCadastro := "Contratos Medicar"
  Private oBrow
  
  //Private aRotina := {;
  //{ "Pesquisar"     ,'PesqBrw'        ,0,1 },;
  //{ "Visualizar"    ,'AxVisual'       ,0,2 },;
  //{ "Incluir"       ,'AxInclui'       ,0,3 },;
  //{ "AlTerar"       ,'AxAltera'       ,0,4 },;  
  //{ "Excluir"       ,'AxDeleta'       ,0,5 };
  // }

   aAdd(aIndex, {"BQC_SUBCON"})
   aAdd(aIndex, {"BQC_ANTCON"})

   aAdd(aSeek,  {"BQC_SUBCON"    , {{"LookUp", "C", 9, 0, "Id Contrato",,}} , 1, .T. }) // TIPO | TAMANHO | 0
   aAdd(aSeek,  {"BQC_ANTCON"    , {{"LookUp", "C", 20, 0, "Numero Contrato",,}} , 1, .T. }) // TIPO | TAMANHO | 0

  // Monta o mBrowse para exibição dos registros
  oBrowse := FWMBrowse():New() // Inicializa o objeto
  oBrowse:SetAlias("BQC") // Indica a tabela utilizada
  oBrowse:SetDescription(cCadastro) // Titulo
  oBrowse:DisableDetails() // Desabilita os detalhes
  oBrowse:SetSeek(.T.,aSeek)


  oBrowse:AddButton( "Beneficiarios"       , {|| ZVIS() } ,, 2 ) 
  oBrowse:AddButton( "Resumo Contrato"          , {|| ZINC() } ,, 3 ) 
  oBrowse:AddButton( "Titulos"          , {|| ZALT() } ,, 4 ) 
  
  //oBrowse:AddButton( "Excluir"          , {|| ZEXC() } ,, 5 ) 
  //oBrowse:AddButton( "Importar Placas"  , {|| MINHAFUNCAO() } ,, 6 ) 

  oBrowse:AddLegend( " BQC_DATBLO == '' "  , "GREEN"      ,  "Contrato Ativo" )
  oBrowse:AddLegend( " BQC_DATBLO <> '' "  , "BLUE"       ,  "Contrato Bloqueado" )        
     
  oBrowse:Activate() //Ativa

Return Nil
