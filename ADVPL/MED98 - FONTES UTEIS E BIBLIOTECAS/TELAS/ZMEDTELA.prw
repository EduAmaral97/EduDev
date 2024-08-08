//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'


/*

Descricao: Rotina personalizada desenvolvida nos novos molds padrão de MVC
Data: 02/08/2024
Autor: Eduardo Amaral

*/


User function ZMEDTELA()

    local oBrowse as object

    oBrowse := FWLoadBrw("ZMEDTELA")
    oBrowse:Activate()
    oBrowse:DeActivate()
    oBrowse:Destroy()
    FreeObj(oBrowse)
    oBrowse := nil

return nil


static function BrowseDef()

    local oBrowse as object

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZC1")
    oBrowse:SetDescription("Medicar - Lançamento de Despesas Frotas")

    oBrowse:AddLegend( "ZC1->ZC1_TIPODP == 'Combustivel         '", "GREEN",    "Tipo de despesa - Combustivel" )
    oBrowse:AddLegend( "ZC1->ZC1_TIPODP == 'Guincho             '", "RED",      "Tipo de despesa - Guincho" )
    oBrowse:AddLegend( "ZC1->ZC1_TIPODP == 'Rastreador          '", "BLUE",      "Tipo de despesa - Rastreador" )
    oBrowse:AddLegend( "ZC1->ZC1_TIPODP == 'Outros              '", "WHITE",      "Tipo de despesa - Outros" )
    

return oBrowse


static function MenuDef()

    local aRotina as array

    aRotina := {}       

    Add Option aRotina Title "Pesquisar"    Action "PesqBrw"            Operation OP_PESQUISAR Access 0
    Add Option aRotina Title "Visualizar"   Action "ViewDef.ZMEDTELA"   Operation OP_VISUALIZAR Access 0
    Add Option aRotina Title "Incluir"      Action "ViewDef.ZMEDTELA"   Operation OP_INCLUIR Access 0
    Add Option aRotina Title "Alterar"      Action "ViewDef.ZMEDTELA"   Operation OP_ALTERAR Access 0
    Add Option aRotina Title "Excluir"      Action "ViewDef.ZMEDTELA"   Operation OP_EXCLUIR Access 0
    Add Option aRotina Title "Imprimir"     Action "ViewDef.ZMEDTELA"   Operation OP_IMPRIMIR Access 0
    Add Option aRotina Title "Copiar"       Action "ViewDef.ZMEDTELA"   Operation OP_COPIA Access 0
    ADD OPTION aRotina Title 'Legenda'      Action 'u_ZLEGMEDTELA'      OPERATION 6        ACCESS 0 //OPERATION X
    

return aRotina


static function ModelDef()

    local oModel as object
    local oStruct as object
    local oStFilho as object
    Local aSB1Rel := {}

    oModel := MPFormModel():New( "MODEL_ZC1", /*bPre*/ , /*bPos*/, /*bCommit*/, /*bCancel*/ )
    oStruct := FwFormStruct( 1, "ZC1", /*bFiltro*/ )
    oStFilho := FwFormStruct( 1, "ZC2", /*bFiltro*/ )

    oModel:AddFields( "FIELDS_ZC1", /*Owner*/ , oStruct, /*bPre*/ , /*bPos*/ , /*bLoad*/ )

    oModel:AddGrid('ZC2DETAIL','FIELDS_ZC1',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
     
    //Fazendo o relacionamento entre o Pai e Filho
    aAdd(aSB1Rel, {'ZC2_FILIAL',    'ZC1_FILIAL'} )
    aAdd(aSB1Rel, {'ZC2_SERIE',     'ZC1_SERIE'} )
    aAdd(aSB1Rel, {'ZC2_DOC',       'ZC1_DOC'} )
    aAdd(aSB1Rel, {'ZC2_FORNEC',    'ZC1_FORNEC'} )
    aAdd(aSB1Rel, {'ZC2_LOJA',      'ZC1_LOJA'} )
    
     
    oModel:SetRelation('ZC2DETAIL', aSB1Rel, ZC2->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('ZC2DETAIL'):SetUniqueLine({"ZC2_FILIAL","ZC2_SERIE","ZC2_DOC","ZC2_FORNEC","ZC2_LOJA","ZC2_QUANT","ZC2_VALOR","ZC2_CC","ZC2_CLVL"})    //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
    

    //Setando as descrições
    oModel:SetDescription("Medicar - Lancamento de despesa Frotas.")
    oModel:GetModel('FIELDS_ZC1'):SetDescription('Modelo Cabecario')
    oModel:GetModel('ZC2DETAIL'):SetDescription('Modelo Placa')

    oModel:SetPrimaryKey({'ZC1_FILIAL','ZC1_SERIE','ZC1_DOC','ZC1_FORNEC','ZC1_LOJA'})

    //VALIDACOES DA ROTINA
    //oModel:MPFormModel():SetPre(PREMEDTELA())
    //oModel:MPFormModel():SetPost(POSMEDTELA())

return oModel


static function ViewDef()

    local oView as object
    local oStruct as object
    Local oStFilho as object
    local oModel as object
    
    oView := FwFormView():New()
    oModel := FwLoadModel("ZMEDTELA")
    oStruct := FwFormStruct( 2, "ZC1", /*bFiltro*/ )
    oStFilho := FwFormStruct( 2, "ZC2", /*bFiltro*/ )

    oView:SetModel(oModel)
    oView:AddField( "VIEW_ZC1", oStruct, "FIELDS_ZC1" )
    oView:AddGrid('VIEW_ZC2',oStFilho,'ZC2DETAIL')

    //Setando o dimensionamento de tamanho
    oView:CreateHorizontalBox('CABEC',30)
    oView:CreateHorizontalBox('GRID',70)
     
    //Amarrando a view com as box
    oView:SetOwnerView('VIEW_ZC1','CABEC')
    oView:SetOwnerView('VIEW_ZC2','GRID')


    //Habilitando título
    oView:EnableTitleView('VIEW_ZC1','Dados da Nota')
    oView:EnableTitleView('VIEW_ZC2','Rateio - Placas')

return oView

