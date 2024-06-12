#Include 'Totvs.ch'
 
User Function ZMEDTELA()
    Local aStruct    As Array //Fields Struct
    Local aColumns   As Array //Browse Columns
    Local aFilter    As Array //Filter Array
    Local nX         As Numeric //Loop Control
    Local nOrder     As Numeric //Order
 
    aStruct := {}
    AAdd(aStruct, {"NUMREG"    , "N", 12                       , 00})
    AAdd(aStruct, {"CT1_CONTA" , "C", TamSX3("CT1_CONTA")[01]  , TamSX3("CT1_CONTA")[02]})
    AAdd(aStruct, {"CT1_DESC01", "C", TamSX3("CT1_DESC01")[01] , TamSX3("CT1_DESC01")[02]})
    AAdd(aStruct, {"CT1_CTASUP", "C", TamSX3("CT1_CTASUP")[01] , TamSX3("CT1_CTASUP")[02]})
 
    //Set Columns
    aColumns := {}
    aFilter  := {}
    For nX := 03 To Len(aStruct)
        //Columns
        AAdd(aColumns,FWBrwColumn():New())
        aColumns[Len(aColumns)]:SetData( &("{||"+aStruct[nX][1]+"}") )
        aColumns[Len(aColumns)]:SetTitle(RetTitle(aStruct[nX][1]))
        aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
        aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])
        aColumns[Len(aColumns)]:SetPicture(PesqPict("CT1",aStruct[nX][1]))
        //Filters
        aAdd(aFilter, {aStruct[nX][1], RetTitle(aStruct[nX][1]), TamSX3(aStruct[nX][1])[3], TamSX3(aStruct[nX][1])[1], TamSX3(aStruct[nX][1])[2], PesqPict("CT1", aStruct[nX][1])} )
    Next nX
 
    //Instance of Temporary Table
    oTempTable := FWTemporaryTable():New()
    //Set Fields
    oTempTable:SetFields(aStruct)
    //Set Indexes
    oTempTable:AddIndex("INDEX1", {"CT1_CTASUP", "CT1_CONTA"} )
    oTempTable:AddIndex("INDEX2", {"CT1_CONTA"} )
    //Create
    oTempTable:Create()
    cAliasTmp := oTemptable:GetAlias()
 
    aHeadCols := {}
    oBrowse    := NIL
    aAccounts := {}
    cQuery := ""
 
    cAliasQry := GetNextAlias()
 
    cQuery := "SELECT CT1.CT1_CONTA, CT1.CT1_DESC01, CT1_CTASUP "
    cQuery += "FROM " + RetSqlName("CT1") + " CT1 "
    cQuery += "WHERE CT1.CT1_FILIAL = '" + FWxFILIAL("CT1") + "' "
    cQuery += "  AND CT1.D_E_L_E_T_ = ' ' "
    cQuery += "ORDER BY CT1.CT1_CTASUP, CT1.CT1_CONTA "
 
    cQuery := ChangeQuery(cQuery)
 
    PlsQuery(cQuery, cAliasQry)
 
    nOrder := 01
 
    DBSelectArea(cAliasTMP)
    (cAliasQry)->(DbGoTop())
    While !(cAliasQry)->(Eof())
        //Add Temporary Table
        If (RecLock(cAliasTMP, .T.))
            (cAliasTMP)->NUMREG      := nOrder
            (cAliasTMP)->CT1_CONTA  := (cAliasQry)->CT1_CONTA
            (cAliasTMP)->CT1_DESC01 := (cAliasQry)->CT1_DESC01
            (cAliasTMP)->CT1_CTASUP := (cAliasQry)->CT1_CTASUP
            (cAliasTMP)->(MsUnlock())
        EndIf
        nOrder ++
        (cAliasQry)->(DBSkip())
    EndDo
 
    (cAliasTMP)->(DbGoTop())
 
    oBrowse:= FWMBrowse():New()
 
    oBrowse:SetAlias(cAliasTMP) //Temporary Table Alias
    oBrowse:SetTemporary(.T.) //Using Temporary Table
    oBrowse:SetUseFilter(.T.) //Using Filter
    oBrowse:OptionReport(.F.) //Disable Report Print
    oBrowse:SetColumns(aColumns)
    oBrowse:SetFieldFilter(aFilter) //Set Filters
 
    oBrowse:Activate(/*oDlg*/) //Caso deseje incluir em um componente de Tela (Dialog, Panel, etc), informar como parâmetro o objeto
 
    oFWFilter := oBrowse:FWFilter()
    oFWFilter:DisableSave(.T.) //Disable Save Button
 
    //Delete Temporary Table
    oTempTable:Delete()
Return
