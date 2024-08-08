//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'


/*

Descricao: Rotina personalizada desenvolvida nos novos molds padrão de MVC
Data: 02/08/2024
Autor: Eduardo Amaral

*/


User function ZMEDDESPFRT()

    local oBrowse as object

    oBrowse := FWLoadBrw("ZMEDDESPFRT")
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

    oBrowse:AddLegend( "ZC1->ZC1_PEDIDO == '      '", "GREEN",    "Pedido não Gerado" )
    oBrowse:AddLegend( "ZC1->ZC1_TIPODP != '      '", "BLUE",     "Pedido Gerado" )

return oBrowse


static function MenuDef()

    local aRotina as array

    aRotina := {}       

    Add Option aRotina Title "Pesquisar"        Action "PesqBrw"                OPERATION OP_PESQUISAR   Access 0
    Add Option aRotina Title "Visualizar"       Action "ViewDef.ZMEDDESPFRT"    OPERATION OP_VISUALIZAR  Access 0
    Add Option aRotina Title "Incluir"          Action "ViewDef.ZMEDDESPFRT"    OPERATION OP_INCLUIR     Access 0
    Add Option aRotina Title "Alterar"          Action "ViewDef.ZMEDDESPFRT"    OPERATION OP_ALTERAR     Access 0
    Add Option aRotina Title "Excluir"          Action "ViewDef.ZMEDDESPFRT"    OPERATION OP_EXCLUIR     Access 0
    Add Option aRotina Title "Imprimir"         Action "ViewDef.ZMEDDESPFRT"    OPERATION OP_IMPRIMIR    Access 0
    Add Option aRotina Title "Copiar"           Action "ViewDef.ZMEDDESPFRT"    OPERATION OP_COPIA       Access 0
    ADD OPTION aRotina Title 'Legenda'          Action 'u_ZLEGZMEDDESPFRT'      OPERATION 6              ACCESS 0 //OPERATION X
    ADD OPTION aRotina Title 'Importar Placas'  Action 'u_ZIMPPLACA(ZC1_FILIAL,ZC1_SERIE,ZC1_DOC,ZC1_FORNEC,ZC1_LOJA,ZC1_PEDIDO)'            OPERATION 6              ACCESS 0 //OPERATION X
    ADD OPTION aRotina Title 'Excluir Placas'   Action 'u_ZDELPLACA(ZC1_FILIAL,ZC1_SERIE,ZC1_DOC,ZC1_FORNEC,ZC1_LOJA,ZC1_PEDIDO)'            OPERATION 7              ACCESS 0 //OPERATION X
    ADD OPTION aRotina Title 'Gerar Pedido'     Action 'u_ZGERAPC(ZC1_FILIAL,ZC1_SERIE,ZC1_DOC,ZC1_FORNEC,ZC1_LOJA,ZC1_PEDIDO,ZC1_CODPRD,ZC1_COND)'              OPERATION 9              ACCESS 0 //OPERATION X
    
return aRotina


static function ModelDef()

    local oModel as object
    local oStruct as object
    local oStFilho as object
    Local aZC2Rel := {}
    

    oModel := MPFormModel():New( "MODEL_ZC1", /*bPre*/ , /*bPos*/, /*bCommit*/, /*bCancel*/ )
    oStruct := FwFormStruct( 1, "ZC1", /*bFiltro*/ )
    oModel:AddFields( "FIELDS_ZC1", /*Owner*/ , oStruct, /*bPre*/ , /*bPos*/ , /*bLoad*/ )
    
    //Setando as descrições
    oModel:SetDescription("Medicar - Lancamento de despesa Frotas.")
    oModel:GetModel('FIELDS_ZC1'):SetDescription('Modelo Cabecario')

    oModel:SetPrimaryKey({'ZC1_FILIAL','ZC1_SERIE','ZC1_DOC','ZC1_FORNEC','ZC1_LOJA'})




    /* ------------------------- GRID ZC2 COM AS PLACAS ------------------------- */
    oStFilho := FwFormStruct( 1, "ZC2", /*bFiltro*/ )
    oModel:AddGrid('ZC2DETAIL','FIELDS_ZC1',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    
    oModel:GetModel('ZC2DETAIL'):SetDescription('Modelo Placa')
    oModel:GetModel('ZC2DETAIL'):SetOptional(.T.)

    //Fazendo o relacionamento entre o Pai e Filho
    aAdd(aZC2Rel, {'ZC2_FILIAL',    'ZC1_FILIAL'} )
    aAdd(aZC2Rel, {'ZC2_SERIE',     'ZC1_SERIE'} )
    aAdd(aZC2Rel, {'ZC2_DOC',       'ZC1_DOC'} )
    aAdd(aZC2Rel, {'ZC2_FORNEC',    'ZC1_FORNEC'} )
    aAdd(aZC2Rel, {'ZC2_LOJA',      'ZC1_LOJA'} )

    oModel:SetRelation('ZC2DETAIL', aZC2Rel, ZC2->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('ZC2DETAIL'):SetUniqueLine({"ZC2_FILIAL","ZC2_SERIE","ZC2_DOC","ZC2_FORNEC","ZC2_LOJA","ZC2_QUANT","ZC2_VALOR","ZC2_CC","ZC2_CLVL"})   
    //oModel:SetPrimaryKey({})
    
    oModel:GetModel('ZC2DETAIL'):SetDescription('Modelo Placa')


return oModel


static function ViewDef()

    local oView as object
    local oStruct as object
    Local oStFilho as object
    local oModel as object
    
    oView := FwFormView():New()
    oModel := FwLoadModel("ZMEDDESPFRT")
    oStruct := FwFormStruct( 2, "ZC1", /*bFiltro*/ )
    

    oView:SetModel(oModel)
    oView:AddField( "VIEW_ZC1", oStruct, "FIELDS_ZC1" )
    

    //Setando o dimensionamento de tamanho
    oView:CreateHorizontalBox('CABEC',30)
    
     
    //Amarrando a view com as box
    oView:SetOwnerView('VIEW_ZC1','CABEC')
    


    //Habilitando título
    oView:EnableTitleView('VIEW_ZC1','Dados da Nota')
    


     /* ------------------------- GRID ZC2 COM AS PLACAS ------------------------- */
    oStFilho := FwFormStruct( 2, "ZC2", /*bFiltro*/ )
    oView:AddGrid('VIEW_ZC2',oStFilho,'ZC2DETAIL')
    oView:CreateHorizontalBox('GRID',70)
    oView:SetOwnerView('VIEW_ZC2','GRID')
    oView:EnableTitleView('VIEW_ZC2','Rateio - Placas')

return oView

