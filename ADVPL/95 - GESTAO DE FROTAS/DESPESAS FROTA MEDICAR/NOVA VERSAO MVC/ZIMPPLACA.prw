#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "FWMVCDEF.CH"

//Posições do Array para planilha de importacao
Static nPosPlaca        := 1
Static nPosVlrUni       := 2 
Static nPosQuantidade   := 3
Static nPosValor        := 4 
Static nPosCC           := 5 
Static nPosCLVL         := 6 
Static nPosInsumo       := 7
Static nPosCondutor     := 8
Static nPosPosto        := 9



User Function ZIMPPLACA(cFilialNF,cSerie,cDoc,cForn,cLoja,cPedido)

    Private cArqOri := ""
    
   
    IF !EMPTY(cPedido)

        MsgInfo("NF com pedido gerado nao é possivel importar as placas." + CHR(13)+CHR(10) + CHR(13)+CHR(10) + "- Pedido: " + cPedido, "Lancamento de despesas Frota Medicar")

    Else

        If ZC2->(DbSeek(ZC1->ZC1_FILIAL+ZC1->ZC1_SERIE+ZC1->ZC1_DOC+ZC1->ZC1_FORNEC+ZC1->ZC1_LOJA))
        
            MsgInfo("NF com placas vinculadas nao é possivel Importar." + CHR(13)+CHR(10) + CHR(13)+CHR(10) + "- Delete as placas para proseguir.", "Lancamento de despesas Frota Medicar")

        Else

            //Mostra o Prompt para selecionar arquivos
            cArqOri := tFileDialog( "CSV files (*.csv) ", 'Seleção de Arquivos', , , .F., )

            //Se tiver o arquivo de origem
            If ! Empty(cArqOri)
                
                //Somente se existir o arquivo e for com a extensão CSV
                If File(cArqOri) .And. Upper(SubStr(cArqOri, RAt('.', cArqOri) + 1, 3)) == 'CSV'
                    Processa({|| fImportaPlaca(cFilialNF,cSerie,cDoc,cForn,cLoja) }, "Importando...")
                    //msginfo("Teste Importador Contrato")
                Else
                    MsgStop("Arquivo e/ou extensão inválida!", "Atenção")
                EndIf
            EndIf

            MsgInfo("Placas importadas com Sucesso.", "Despesas Frota Medicar")

        Endif


    Endif


Return 



Static Function fImportaPlaca(cFilialNF,cSerie,cDoc,cForn,cLoja)

    Local aArea      := GetArea()
    Local cArqLog    := "zImpCSV_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-') + ".log"
    Local nTotLinhas := 0
    Local cLinAtu    := ""
    Local nLinhaAtu  := 0
    Local aLinha     := {}
    Local oArquivo
    Local aLinhas
    Local cPlaca        := ""
    Local cVlrUni       := ""
    Local cQuantidade   := ""
    Local cValor        := ""
    Local cCC           := ""
    Local cCLVL         := ""
    Local cInsumo       := ""
    Local cCondutor     := ""
    Local cPosto        := ""
    
    Private cDirLog    := GetTempPath() + "x_impcombfrt\"
    Private cLog       := ""


    //Se a pasta de log não existir, cria ela
    If ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIf

    //Definindo o arquivo a ser lido
    oArquivo := FWFileReader():New(cArqOri)
    
    //Se o arquivo pode ser aberto
    If (oArquivo:Open())

        //Se não for fim do arquivo
        If ! (oArquivo:EoF())

            //Definindo o tamanho da régua
            aLinhas := oArquivo:GetAllLines()
            nTotLinhas := Len(aLinhas)
            ProcRegua(nTotLinhas)
            
            //Método GoTop não funciona (dependendo da versão da LIB), deve fechar e abrir novamente o arquivo
            oArquivo:Close()
            oArquivo := FWFileReader():New(cArqOri)
            oArquivo:Open()

            //Enquanto tiver linhas
            While (oArquivo:HasLine())

                //Incrementa na tela a mensagem
                nLinhaAtu++
                IncProc("Analisando linha " + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")
                
                //Pegando a linha atual e transformando em array
                cLinAtu := oArquivo:GetLine()
                aLinha  := StrTokArr(cLinAtu, ";")

                if nLinhaAtu >= 2

                    if cLinAtu = ""

                        msginfo("Linha em branco.")

                    else 

                        cPlaca      := aLinha[nPosPlaca]
                        cVlrUni     := aLinha[nPosVlrUni]
                        cQuantidade := aLinha[nPosQuantidade]
                        cValor      := aLinha[nPosValor]
                        cCC         := aLinha[nPosCC]
                        cCLVL       := aLinha[nPosCLVL]
                        cInsumo     := aLinha[nPosInsumo]
                        cCondutor   := aLinha[nPosCondutor]
                        cPosto      := aLinha[nPosPosto]

                        RecLock("ZC2", .T.)
                                ZC2->ZC2_FILIAL  := cFilialNF
                                ZC2->ZC2_SERIE   := cSerie
                                ZC2->ZC2_DOC     := cDoc
                                ZC2->ZC2_FORNEC  := cForn
                                ZC2->ZC2_LOJA    := cLoja
                                ZC2->ZC2_PLACA   := cPlaca
                                ZC2->ZC2_QUANT   := Val(cQuantidade)
                                ZC2->ZC2_VALOR   := Val(cValor)
                                ZC2->ZC2_CC      := StrZero(val(cCC) ,5)
                                ZC2->ZC2_CLVL    := StrZero(val(cCLVL) ,6)
                                ZC2->ZC2_INSUMO  := cInsumo
                                ZC2->ZC2_CONDUT  := cCondutor
                                ZC2->ZC2_POSTO   := cPosto                                
                                ZC2->ZC2_VLRUNI  := Val(cVlrUni)                                
                        ZC2->(MsUnlock())
                        //ConfirmSX8()
    
                    EndIf

                EndIf

            EndDo


            //Se tiver log, mostra ele
            If ! Empty(cLog)
                cLog := "Processamento finalizado, abaixo as mensagens de log: " + CRLF + cLog
                MemoWrite(cDirLog + cArqLog, cLog)
                ShellExecute("OPEN", cArqLog, "", cDirLog, 1)
            EndIf

        Else
            MsgStop("Arquivo não tem conteúdo!", "Atenção")
        EndIf

        //Fecha o arquivo
        oArquivo:Close()
    Else
        MsgStop("Arquivo não pode ser aberto!", "Atenção")
    EndIf


    RestArea(aArea)

Return 






               