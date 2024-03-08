User Function zTeste()
    Local aArea   := GetArea()
    Local cFunBkp := FunName()
    Local oBrowse
     
    //Setando o nome da fun��o, para a fun��o customizada
    SetFunName("zTeste")
     
    //Inst�nciando FWMBrowse, setando a tabela, a descri��o
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("Z42")
    oBrowse:SetDescription(cTitulo)
     
    //Filtrando os dados
    oBrowse:SetFilterDefault("Z42->Z42_TIPO != '1'")
     
    //Ativando a navega��o
    oBrowse:Activate()
     
    //Voltando o nome da fun��o
    SetFunName(cFunBkp)
     
    RestArea(aArea)
Return Nil
