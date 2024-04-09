#Include "TOTVS.ch"
#Include "PROTHEUS.ch"
#Include "TopConn.ch"
  
//Posições do Array
Static nPosFilial       := 1 
Static nPosCodbem       := 2 
Static nPosPlaca        := 3 
Static nPosDocto        := 4 
Static nPosValor        := 5 
Static nPosDtEmis       := 6 
Static nPosDtVenc       := 7 
Static nPosTipo         := 8 
Static nPosNatureza     := 9 
Static nPosPrefixo      := 10 
Static nPosNumTit       := 11 
Static nPosFornecedor   := 12
Static nPosCondPag      := 13 
Static nPosParcela      := 14 
Static nPosCentroCusto  := 15 
Static nPosClasseVlr    := 16 


User Function ZIMPDOCFRT()

    Local aArea     := GetArea()
    Private cArqOri := ""
  
    //Mostra o Prompt para selecionar arquivos
    cArqOri := tFileDialog( "CSV files (*.csv) ", 'Seleção de Arquivos', , , .F., )
      
    //Se tiver o arquivo de origem
    If ! Empty(cArqOri)
          
        //Somente se existir o arquivo e for com a extensão CSV
        If File(cArqOri) .And. Upper(SubStr(cArqOri, RAt('.', cArqOri) + 1, 3)) == 'CSV'
            Processa({|| fImporta() }, "Importando...")
            //msginfo("Teste Importador Contrato")
        Else
            MsgStop("Arquivo e/ou extensão inválida!", "Atenção")
        EndIf
    EndIf
      
    RestArea(aArea)
Return
  
  
Static Function fImporta()
    Local aArea      := GetArea()
    Local cArqLog    := "zImpCSV_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-') + ".log"
    Local nTotLinhas := 0
    Local cLinAtu    := ""
    Local nLinhaAtu  := 0
    Local aLinha     := {}
    Local oArquivo
    Local aLinhas
    Local cFilialArq := ""
    Local cCodbem := ""
    Local cPlaca := ""
    Local cDocto := ""
    Local cValor := ""
    Local cDtEmis := ""
    Local cTipo := ""
    Local cNatureza := ""
    Local cPrefixo := ""
    Local cNumTit := ""
    Local cFornecedor := ""
    Local cCondPag := ""
    Local cParcela := ""
    Local cCentroCusto := ""
    Local cClaseVlr := ""
    


    Private cDirLog    := GetTempPath() + "x_importacao\"
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

                        cFilialArq   := aLinha[nPosFilial]
                        cCodbem      := aLinha[nPosCodbem]
                        cPlaca       := aLinha[nPosPlaca]
                        cDocto       := aLinha[nPosDocto]
                        cValor       := aLinha[nPosValor]
                        cDtEmis      := aLinha[nPosDtEmis]
                        cDtVenc      := aLinha[nPosDtVenc]
                        cTipo        := aLinha[nPosTipo]
                        cNatureza    := aLinha[nPosNatureza]
                        cPrefixo     := aLinha[nPosPrefixo]
                        cNumTit      := aLinha[nPosNumTit]
                        cFornecedor  := aLinha[nPosFornecedor]
                        cCondPag     := aLinha[nPosCondPag]
                        cParcela     := aLinha[nPosParcela]
                        cCentroCusto := aLinha[nPosCentroCusto]
                        cClaseVlr    := aLinha[nPosClasseVlr]
            
                        RecLock("TS1", .T.)
                            TS1->TS1_FILIAL     := StrZero(val(cFilialArq) ,6)
                            TS1->TS1_CODBEM     := cCodbem
                            TS1->TS1_PLACA      := cPlaca
                            TS1->TS1_DOCTO      := cDocto
                            TS1->TS1_VALOR      := Val(cValor)
                            TS1->TS1_DTEMIS     := CToD(cDtEmis)
                            TS1->TS1_DTVENC     := CToD(cDtVenc)
                            TS1->TS1_QTDPAR     := 1
                            TS1->TS1_IDDOCT     := ""
                            TS1->TS1_TIPO       := cTipo
                            TS1->TS1_NATURE     := cNatureza
                            TS1->TS1_PREFIX     := cPrefixo
                            TS1->TS1_NUMSE2     := StrZero(val(cNumTit) ,9)
                            TS1->TS1_FORNEC     := StrZero(val(cFornecedor),6)
                            TS1->TS1_LOJA       := "01"
                            TS1->TS1_CONPAG     := StrZero(val(cCondPag),3)
                            TS1->TS1_VALPAG     := 0
                        TS1->(MsUnlock())
                        //ConfirmSX8()
                
                        DbSelectArea('SA2')
                        SA2->(DbSetOrder(1))
                        SA2->(DbSeek(FWxFilial('SA2') + StrZero(val(cFornecedor),6) + '01'))

                        RecLock("SE2", .T.)
                            SE2->E2_FILIAL    := StrZero(val(cFilialArq) ,6)
                            SE2->E2_PREFIXO   := cPrefixo
                            SE2->E2_NUM       := StrZero(val(cNumTit) ,9)
                            SE2->E2_PARCELA   := StrZero(val(cParcela) ,2)
                            SE2->E2_TIPO      := cTipo
                            SE2->E2_NATUREZ   := cNatureza
                            SE2->E2_FORNECE   := StrZero(val(cFornecedor),6)
                            SE2->E2_LOJA      := "01"
                            SE2->E2_NOMFOR    := SA2->A2_NREDUZ
                            SE2->E2_EMISSAO   := CToD(cDtEmis)
                            SE2->E2_VENCTO    := CToD(cDtVenc)
                            SE2->E2_VENCREA   := CToD(cDtVenc)
                            SE2->E2_VALOR     := Val(cValor)
                            SE2->E2_HIST      := ""
                            SE2->E2_MOEDA     := 1
                            SE2->E2_VLCRUZ    := Val(cValor)
                            SE2->E2_SALDO     := Val(cValor)
                            SE2->E2_ORIGEM    := "MNTA805"
                            SE2->E2_DECRESC   := 0
                            SE2->E2_CCD       := ""
                            SE2->E2_ITEMD     := ""
                            SE2->E2_CCUSTO    := cCentroCusto
                            SE2->E2_CLVL      := cClaseVlr
                        SE2->(MsUnlock())

                        SA2->(DbCloseArea())
       
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
