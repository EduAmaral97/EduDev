#INCLUDE 'protheus.ch'

User Function F620QRY()

    Local aArea    := GetArea()
    //Local cQueryOri := cQuery
    //Local cQueryPerso := ""
    Local cFilRet  := ""

    If MsgYesNo("Deseja listar apenas conciliado?")
        //Montando o filtro de retorno para exibi��o dos titulos que ser�o baixados
         
         cFilRet := " E5_RECONC = 'x' "
         //cQueryPerso := cQueryOri + cFilRet

    EndIf

    //MsgAlert("Filtro realizado!")
    RestArea(aArea)

Return cFilRet




