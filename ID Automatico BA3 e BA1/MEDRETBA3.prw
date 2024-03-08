/*
SX3 VALID CAMPO BA3_MATEMP = ExistChav("BA3",M->BA3_CODEMP+M->BA3_MATEMP,1)
*/

User Function MEDRETBA3()
 
    Local aArea     := GetArea()
    Local cQuery    := ""
    Local cAliasQry := ""
    Local cRet      := ""

    cQuery := " SELECT TOP 1 BA3.BA3_MATEMP  "
    cQuery += " FROM "+RetSqlName("BA3")+" BA3 "
    cQuery += " WHERE BA3.BA3_FILIAL = '"+xFilial("BA3")+ "' "
    cQuery += " AND BA3.D_E_L_E_T_ = ' '  "
    cQuery += " ORDER BY BA3.BA3_MATEMP DESC "

    //cQuery := ChangeQuery(cQuery)
    cAliasQry := GetNextAlias()
    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.F.,.F.)
   
    If (cAliasQry)->(!Eof())
        cRet := Soma1(ALLTRIM((cAliasQry)->BA3_MATEMP))
    else
        cRet := "10000000"
    EndIf
 
    (cAliasQry)->(DbCloseArea())
 
    RestArea(aArea)
 
Return(cRet)
