User Function zTeste()
    Local aArea   := GetArea()
    Local cFunBkp := FunName()
    Local oBrowse
     
    //Setando o nome da função, para a função customizada
    SetFunName("zTeste")
     
    //Instânciando FWMBrowse, setando a tabela, a descrição
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("Z42")
    oBrowse:SetDescription(cTitulo)
     
    //Filtrando os dados
    oBrowse:SetFilterDefault("Z42->Z42_TIPO != '1'")
     
    //Ativando a navegação
    oBrowse:Activate()
     
    //Voltando o nome da função
    SetFunName(cFunBkp)
     
    RestArea(aArea)
Return Nil
