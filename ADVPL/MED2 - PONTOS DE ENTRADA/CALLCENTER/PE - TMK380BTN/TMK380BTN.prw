#Include 'Protheus.ch'

User Function TMK380BTN()

    Local aButtons := {}

    Alert("Ponto de Entrada TMK380BTN")

    AAdd(aButtons ,{ "EDITABLE" , {|| Alert('a��o do bot�o Teste 1')}, 'ToolTip','Teste 1'})
    AAdd(aButtons ,{ "VERNOTA" , {|| Alert('a��o do bot�o Teste 2')}, 'TolTip','Teste 2'})


Return(aButtons)
