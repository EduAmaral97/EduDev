//Bibliotecas
#Include 'TOTVS.ch'
  
/*/{Protheus.doc} User Function zTstTGet
Funcao com tela customizada usando a classe TDialog que foi gerado pelo PDialogMaker
@type  Function
@author Atilio
@since 07/10/2022 
@see https://atiliosistemas.com/portfolio/pdialogmaker/
@obs Obrigado por usar um aplicativo da Atilio Sistemas
/*/
  
User Function zTstTGet()
    Local aArea         := FWGetArea()
    Local nCorFundo     := RGB(204, 255, 204)
    Local nJanAltura    := 96
    Local nJanLargur    := 298 
    Local cJanTitulo    := 'Teste KeyPress'
    Local lDimPixels    := .T. 
    Local lCentraliz    := .T. 
    Local nObjLinha     := 0
    Local nObjColun     := 0
    Local nObjLargu     := 0
    Local nObjAltur     := 0
    Private cFontNome   := 'Tahoma'
    Private oFontPadrao := TFont():New(cFontNome, , -12)
    Private oDialogPvt 
    Private bBlocoIni   := {|| /*fSuaFuncao()*/ } //Aqui voce pode acionar funcoes customizadas que irao ser acionadas ao abrir a dialog 
    //objeto0 
    Private oGetTest 
    Private cGetTest    := Space(40) //Se o get for data para inicilizar use dToS(''), se for numerico inicie com 0  
    //objeto1 
    Private oSayInfo 
    Private cSayInfo    := '...'
      
    //Cria a dialog
    oDialogPvt := TDialog():New(0, 0, nJanAltura, nJanLargur, cJanTitulo, , , , , , nCorFundo, , , lDimPixels)
      
        //objeto0 - usando a classe TGet
        nObjLinha := 8
        nObjColun := 5
        nObjLargu := 140
        nObjAltur := 15
        oGetTest  := TGet():New(nObjLinha, nObjColun, {|u| Iif(PCount() > 0 , cGetTest := u, cGetTest)}, oDialogPvt, nObjLargu, nObjAltur, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels)
        oGetTest:bGetKey      := {|self, cText, nKey| fKeyPress(self, cText, nKey)}
  
        //objeto1 - usando a classe TSay
        nObjLinha := 28
        nObjColun := 5
        nObjLargu := 140
        nObjAltur := 7
        oSayInfo  := TSay():New(nObjLinha, nObjColun, {|| cSayInfo}, oDialogPvt, /*cPicture*/, oFontPadrao, , , , lDimPixels, /*nClrText*/, /*nClrBack*/, nObjLargu, nObjAltur, , , , , , /*lHTML*/)
  
      
    //Ativa e exibe a janela
    oDialogPvt:Activate(, , , lCentraliz, , , bBlocoIni)
      
    FWRestArea(aArea)
Return
  
  
Static Function fKeyPress(oObjeto, cTextoComp, nKey)
    Local nTamCompl := Len(cGetTest)
    Local nTamDigit := Len(Alltrim(cTextoComp))
  
    //Se for algum caractere válido da tabela ASCII (até 255)
    //  Ou for o Backspace (16777219)
    //  Ou for o Delete (16777223)
    If nKey < 255 .Or. nKey == 16777219 .Or. nKey == 16777223
  
        //Vai mostrar uma mensagem no label abaixo, começando com o caractere digitado
        cSayInfo := "'" + Chr(nKey) + "'"
  
        //Agora complementa com o tamanho disponível
        cSayInfo += " - Falta " + cValToChar(nTamCompl - nTamDigit) + " caracter(es)"
  
        //Atualiza o label
        oSayInfo:Refresh()
    EndIf
  
Return
