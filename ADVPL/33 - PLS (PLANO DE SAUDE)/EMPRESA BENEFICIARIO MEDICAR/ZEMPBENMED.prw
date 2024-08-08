//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'


/*

Descricao: Rotina personalizada desenvolvida nos novos molds padrão de MVC
Data: 02/08/2024
Autor: Eduardo Amaral

*/


User function ZEMPBENMED()

    local oBrowse as object

    oBrowse := FWLoadBrw("ZEMPBENMED")
    oBrowse:Activate()
    oBrowse:DeActivate()
    oBrowse:Destroy()
    FreeObj(oBrowse)
    oBrowse := nil

return nil


static function BrowseDef()

    local oBrowse as object

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("BBZ")
    oBrowse:SetDescription("Medicar - Empresa Beneficiarios")

    //oBrowse:AddLegend( "ZC1->ZC1_TIPODP == '1'", "GREEN",    "Tipo de despesa - Combustivel" )
    //oBrowse:AddLegend( "ZC1->ZC1_TIPODP == '2'", "RED",      "Tipo de despesa - Guincho" )
    //oBrowse:AddLegend( "ZC1->ZC1_TIPODP == '3'", "BLUE",     "Tipo de despesa - Rastreador" )
    //oBrowse:AddLegend( "ZC1->ZC1_TIPODP == '4'", "WHITE",    "Tipo de despesa - Outros" )
    

return oBrowse


static function MenuDef()

    local aRotina as array

    aRotina := {}       

    Add Option aRotina Title "Pesquisar"    Action "PesqBrw"              Operation OP_PESQUISAR Access 0
    Add Option aRotina Title "Visualizar"   Action "ViewDef.ZEMPBENMED"   Operation OP_VISUALIZAR Access 0
    Add Option aRotina Title "Incluir"      Action "ViewDef.ZEMPBENMED"   Operation OP_INCLUIR Access 0
    Add Option aRotina Title "Alterar"      Action "ViewDef.ZEMPBENMED"   Operation OP_ALTERAR Access 0
    Add Option aRotina Title "Excluir"      Action "ViewDef.ZEMPBENMED"   Operation OP_EXCLUIR Access 0
    Add Option aRotina Title "Imprimir"     Action "ViewDef.ZEMPBENMED"   Operation OP_IMPRIMIR Access 0
    Add Option aRotina Title "Copiar"       Action "ViewDef.ZEMPBENMED"   Operation OP_COPIA Access 0
    //ADD OPTION aRotina Title 'Legenda'      Action 'u_ZLEGZEMPBENMED'      OPERATION 6        ACCESS 0 //OPERATION X
    

return aRotina


static function ModelDef()

    local oModel as object
    local oStruct as object
    

    oModel := MPFormModel():New( "MODEL_BBZ", /*bPre*/ , /*bPos*/, /*bCommit*/, /*bCancel*/ )
    oStruct := FwFormStruct( 1, "BBZ", /*bFiltro*/ )
    
    oModel:AddFields( "FIELDS_BBZ", /*Owner*/ , oStruct, /*bPre*/ , /*bPos*/ , /*bLoad*/ )

    //Setando as descrições
    oModel:SetDescription("Medicar - Empresa Beneficiario")
    oModel:GetModel('FIELDS_BBZ'):SetDescription('Modelo Cabecario')
    oModel:SetPrimaryKey({'BBZ_FILIAL','BBZ_CODORG'})

return oModel


static function ViewDef()

    local oView as object
    local oStruct as object
    local oModel as object
    
    oView := FwFormView():New()
    oModel := FwLoadModel("ZEMPBENMED")
    oStruct := FwFormStruct( 2, "BBZ", /*bFiltro*/ )

    oView:SetModel(oModel)
    oView:AddField( "VIEW_BBZ", oStruct, "FIELDS_BBZ" )
    
    //Setando o dimensionamento de tamanho
    oView:CreateHorizontalBox('CABEC',100)

    //Amarrando a view com as box
    oView:SetOwnerView('VIEW_BBZ','CABEC')
    
    //Habilitando título
    oView:EnableTitleView('VIEW_BBZ','Empresa Beneficiario')
    
return oView

