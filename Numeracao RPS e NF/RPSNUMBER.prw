//-------------------------------------------------------------------
/*/{Protheus.doc} PL627BOK
description Ponto de entrada para verificacoes especificas do usuario no lote de cobrança
@version P12
/*/
//-------------------------------------------------------------------

User Function PL627BOK()
    Local lRet      := .T.
    Local cQuery    := ""
    Local cConteOld := ""
    Local cConteNew := ""
    Local cMsgLog   := ""
    Local nTamSx5   := 0
    Local nContAuxi := 0
    Local cFilSF2   := xFilial("SF2")
    Local cAliasQry := GetNextAlias()
    Local cPrefixo  := SuperGetMV("MV_PLPFE11",,"")
    Local aParamBox := {}
    Local oContAuxi := Nil
    Local oDlg      := Nil
    Local oTFont1   := TFont():New("Calibri",,-16,.T.,.T.)
    Local oTFont2   := TFont():New("Calibri",,-15,.T.,.T.)
    Local oTFont3   := TFont():New("Calibri",,-13,.T.,.F.)
 
    If ParamIXB[2] == 3
        cPrefixo := &cPrefixo
 
        cQuery += " SELECT X5_FILIAL AS FILIAL,X5_CHAVE AS CHAVE,X5_DESCRI AS DESCRI"
        cQuery += " FROM " + RetSqlName("SX5")+" SX5 "
        cQuery += " WHERE  SX5.X5_FILIAL = '" + cFilSF2  + "'"    
        cQuery += "    AND SX5.X5_TABELA = '01'"
        cQuery += "    AND SX5.X5_CHAVE  = '" + cPrefixo + "'"
        cQuery += "    AND SX5.D_E_L_E_T_ = ' ' "
 
        DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.F.,.F.)
 
        DbSelectArea(cAliasQry)
 
        If !(cAliasQry)->(Eof())
            cConteOld := AllTrim((cAliasQry)->DESCRI)
        EndIf
        (cAliasQry)->(DbCloseArea())
 
        If !Empty(cConteOld)
            nTamSx5     := Len(cConteOld)
            nContAuxi   := Val(cConteOld)
 
            Define MSDialog oDlg Title "MEDICAR" From 0,0 TO 170,350 PIXEL    
            @ 025,020   SAY "Numero Proxima Fatura:"    FONT oTFont3 COLOR CLR_GRAY Of oDlg Pixel
            @ 022,090   MSGET oContAuxi VAR nContAuxi SIZE 70,010 OF oDlg PIXEL PICTURE "999999999"
 
            TButton():New( 050, 055, "Confirmar", oDlg,{|| lRet := .T., cConteNew := StrZero(nContAuxi,nTamSx5), oDlg:End() },50,12,,oTFont1,.F.,.T.,.F.,,.F.,,,.F. )
            TButton():New( 050, 110, "Cancelar" , oDlg,{|| lRet := .F., oDlg:End() },50,12,,oTFont1,.F.,.T.,.F.,,.F.,,,.F.)
 
            Activate MSDialog oDlg Centered
 
            If lRet .AND. cConteNew <> cConteOld
                If MsgYesNo("Confirma a substituição do numero da nota de: ["+cConteOld+"] para ["+cConteNew+"] ?", "Atenção")
                    cQuery := "UPDATE "+ RetSqlName("SX5")+ " "
                    cQuery += " SET     X5_DESCRI   = '"+cConteNew+"', "
                    cQuery += "         X5_DESCSPA  = '"+cConteNew+"', "
                    cQuery += "         X5_DESCENG  = '"+cConteNew+"'  "
                    cQuery += " FROM "+ RetSqlName("SX5")+ " SX5 "
                    cQuery += " WHERE  SX5.X5_FILIAL = '" + cFilSF2  + "'"    
                    cQuery += "    AND SX5.X5_TABELA = '01' "
                    cQuery += "    AND SX5.X5_CHAVE  = '" + cPrefixo + "'"
                    cQuery += "    AND SX5.D_E_L_E_T_ = ' ' "
                    If (TCSqlExec(cQuery) < 0)
                        cMsgLog := "Erro ao alterar o numero da nota: " +  CHR(13)+CHR(10) + TCSQLError()
                        TcSQLExec( "ROLLBACK" )
                        MsgAlert(cMsgLog,"Atenção")
                        lRet := .F.
                    Else
                        TcSQLExec( "COMMIT" )
                        MsgAlert("Numeração da nota alterado com sucesso !!!","Atenção")
                    EndIf
                else
                    lRet := .F.
                EndIf
            EndIf
        EndIf
 
    EndIf
 
Return(lRet)
