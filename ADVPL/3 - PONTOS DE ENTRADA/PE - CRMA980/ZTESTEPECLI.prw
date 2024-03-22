#INCLUDE "TOTVS.CH"

User Function ZTESTEPECLI()

    msgalert('TESTANDO PONTO DE ENTRADA - CRM980')

Return()


User Function ChkExec()
    Local aArea     := FWGetArea()
    Local lContinua := .T.
    Local cFuncao    := Upper(ParamIXB)
     
    //Se vier da rotina Pedido de Ve�culos, habilita o uso de atalhos, devido a tela n�o ter ponto de entrada para manipular o menu
    If ("VEIXA050" $ cFuncao)
        SetKey(VK_F7, {|| u_zSuaFuncao()})
    EndIf
     
    //Se vier da Rotina de Turnos, habilita o uso de atalhos, devido a tela n�o ter ponto de entrada para manipular o menu
    If ("GPEA080" $ cFuncao)
        SetKey(VK_F5, {|| u_zSuaFuncao()})
    EndIf
     
    FWRestArea(aArea)
Return lContinua
